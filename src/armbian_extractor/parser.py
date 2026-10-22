import os
import re
from pathlib import Path


class NixbianConfigParser:
    """
    Parses Armbian bash configuration files to extract variables without executing bash.
    Handles 'source' directives and basic variable expansion.
    """

    VAR_REGEX = re.compile(
        r"^(?:export\s+|declare\s+(?:-[a-zA-Z]+\s+)*)?([A-Z0-9_]+)=(.*)$"
    )
    # Regex to capture source directives: source "path" or . "path"
    SOURCE_REGEX = re.compile(r"^(?:source|\.)\s+(.+)$")
    # Regex to capture case statements: case $VAR in
    CASE_REGEX = re.compile(r"^case\s+\$?([A-Z0-9_]+)\s+in$")
    # Regex for case patterns: pattern)
    CASE_PATTERN_REGEX = re.compile(r"^([^)]+)\)$")
    # Regex for case ending: esac
    ESAC_REGEX = re.compile(r"^esac$")

    def __init__(self, armbian_src_root, branch="current"):
        self.armbian_root = Path(armbian_src_root).resolve()
        self.context = {
            "SRC": str(self.armbian_root),
        }
        # Pre-define some common variables that might be used in paths
        self.context["BRANCH"] = branch

        self.current_case_var = None
        self.case_stack = []
        self.skip_until_pattern = None
        self.skip_until_esac = False

    def resolve_path(self, path_str, current_file):
        """Resolves a path string (which may verify regex) relative to current file or root."""
        # Clean quotes
        path_str = path_str.strip("\"'")

        # Expand variables in path (e.g. ${BASH_SOURCE%/*})
        expanded_path = self.expand_variables(path_str, current_file)

        # Handle cases like ${LINUXFAMILY} in paths
        path = Path(expanded_path)
        if not path.is_absolute():
            # If relative, it's usually relative to the current file's directory
            # UNLESS it starts with $SRC, handled by expansion above.
            path = current_file.parent / path

        return path

    def expand_variables(self, text, current_file=None):
        """Resolves ${VAR} placeholders in a string."""
        if not text:
            return ""

        # Handle BASH_SOURCE special case
        if current_file:
            # ${BASH_SOURCE%/*} -> directory of current file
            if "${BASH_SOURCE%/*}" in text:
                text = text.replace("${BASH_SOURCE%/*}", str(current_file.parent))

        def replacer(match):
            var_name = match.group(1)
            # Check if it's a known variable
            if var_name in self.context:
                return str(self.context[var_name])
            return f"${{{var_name}}}"

        # Replace ${VAR}
        text = re.sub(r"\$\{([A-Z0-9_]+)\}", replacer, text)
        # Replace $VAR
        text = re.sub(r"\$([A-Z0-9_]+)", replacer, text)

        return text

    def parse_file(self, file_path):
        """Parses a single file and recursively processes sourced files."""
        file_path = Path(file_path)
        if not file_path.exists():
            # Try some common locations relative to SRC
            candidates = [
                self.armbian_root / file_path,
                self.armbian_root / "config" / file_path,
                self.armbian_root / "config" / "sources" / file_path,
            ]
            for cand in candidates:
                if cand.exists():
                    file_path = cand
                    break
            else:
                # Still not found, skip
                return

        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()

        for line in lines:
            line = line.strip()
            # Skip comments
            if not line or line.startswith("#"):
                continue

            # --- Case logic handling ---
            match_case = self.CASE_REGEX.match(line)
            if match_case:
                case_var = match_case.group(1)
                self.case_stack.append(
                    {
                        "var": case_var,
                        "value": self.context.get(case_var, "unknown"),
                        "active": False,
                        "found_match": False,
                    }
                )
                continue

            match_esac = self.ESAC_REGEX.match(line)
            if match_esac:
                if self.case_stack:
                    self.case_stack.pop()
                continue

            # If we are inside a case, check for patterns
            if self.case_stack:
                current_case = self.case_stack[-1]
                match_pattern = self.CASE_PATTERN_REGEX.match(line)
                if match_pattern:
                    pattern = match_pattern.group(1).strip()
                    # Check if pattern matches current branch/value
                    # Simplified: if pattern is "current|edge" and branch is "current"
                    patterns = [p.strip() for p in pattern.split("|")]
                    if current_case["value"] in patterns or "*" in patterns:
                        current_case["active"] = True
                        current_case["found_match"] = True
                    else:
                        current_case["active"] = False
                    continue

                # If pattern didn't match, skip lines until next pattern or esac
                if not current_case["active"]:
                    continue

            # --- Standard commands ---

            # 1. Check for variable assignment
            match_var = self.VAR_REGEX.match(line)
            if match_var:
                key, raw_value = match_var.groups()
                # Resolve value (remove quotes, expand vars)
                clean_value = raw_value.strip()

                # Strip trailing comments
                if "#" in clean_value:
                    clean_value = clean_value.split("#", 1)[0].strip()

                # Remove quotes but only if they wrap the WHOLE thing
                # OR if it's a mix like 'part'$VAR, we should be careful.
                # In bash, 'part'$VAR is just concatenation.
                # We'll just strip all ' and " that are not escaped (simplified)
                # This is safer for Armbian configs which don't use escaped quotes much.
                clean_value = clean_value.replace("'", "").replace('"', "")

                # Handle cases like VAR=${VAR:-"default"}
                if ":-" in clean_value:
                    # Very simple fallback logic
                    inner = clean_value.strip("${}")
                    parts = inner.split(":-", 1)
                    var_name = parts[0]
                    default_v = parts[1].strip("\"'")
                    clean_value = self.context.get(var_name, default_v)

                self.context[key] = self.expand_variables(clean_value)
                continue

            # 2. Check for source directive
            match_source = self.SOURCE_REGEX.match(line)
            if match_source:
                src_path_raw = match_source.group(1)
                resolved_path = self.resolve_path(src_path_raw, file_path)
                self.parse_file(resolved_path)
                continue

    def get(self, key, default=None):
        val = self.context.get(key, default)
        if isinstance(val, str) and "$" in val:
            # Recursive expansion (max 3 levels to avoid infinite loops)
            for _ in range(3):
                new_val = self.expand_variables(val)
                if new_val == val:
                    break
                val = new_val
        return val

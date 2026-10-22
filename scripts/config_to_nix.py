#!/usr/bin/env python3
import sys
import re

def convert_config_to_nix(config_content):
    nix_lines = ["{ lib, ... }:", "{"]
    
    for line in config_content.splitlines():
        line = line.strip()
        if not line:
            continue
        
        # Match "# CONFIG_FOO is not set"
        not_set_match = re.match(r"^#\s*CONFIG_([A-Za-z0-9_]+)\s+is\s+not\s+set$", line)
        if not_set_match:
            option_name = not_set_match.group(1)
            if re.match(r"^[a-zA-Z_][a-zA-Z0-9_]*$", option_name):
                key = option_name
            else:
                key = f'"{option_name}"'
            nix_lines.append(f"  {key} = lib.kernel.no;")
            continue
            
        # Ignore other comments
        if line.startswith("#"):
            continue
            
        # Match "CONFIG_FOO=value"
        value_match = re.match(r"^CONFIG_([A-Za-z0-9_]+)=(.*)$", line)
        if value_match:
            option_name = value_match.group(1)
            value = value_match.group(2)
            
            if re.match(r"^[a-zA-Z_][a-zA-Z0-9_]*$", option_name):
                key = option_name
            else:
                key = f'"{option_name}"'
            
            if value == "y":
                nix_lines.append(f"  {key} = lib.kernel.yes;")
            elif value == "m":
                nix_lines.append(f"  {key} = lib.kernel.module;")
            elif value.startswith('"') and value.endswith('"'):
                # String value
                nix_lines.append(f'  {key} = lib.kernel.freeform {value};')
            else:
                # Numbers or other types
                nix_lines.append(f'  {key} = lib.kernel.freeform "{value}";')
                
    nix_lines.append("}")
    return "\n".join(nix_lines) + "\n"

def main():
    if len(sys.argv) < 2:
        print("Usage: config_to_nix.py <path_to_dot_config> [output_nix_file]")
        sys.exit(1)
        
    config_path = sys.argv[1]
    try:
        with open(config_path, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading file {config_path}: {e}")
        sys.exit(1)
        
    nix_content = convert_config_to_nix(content)
    
    if len(sys.argv) >= 3:
        output_path = sys.argv[2]
        try:
            with open(output_path, "w", encoding="utf-8") as f:
                f.write(nix_content)
            print(f"Successfully converted {config_path} to {output_path}")
        except Exception as e:
            print(f"Error writing file {output_path}: {e}")
            sys.exit(1)
    else:
        print(nix_content)

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Create an isolated Xcode project using this checkout, without changing the app pin."""
import argparse
from pathlib import Path
import re
import shutil
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument("repository", type=Path, help="Wirkraum repository root")
args = parser.parse_args()
source = args.repository.resolve()
library = Path(__file__).resolve().parents[1]
project = source / "ios/Wirkraum.xcodeproj"
if not project.is_dir():
    parser.error("Expected ios/Wirkraum.xcodeproj in the supplied repository")

destination = Path(tempfile.mkdtemp(prefix="lubaui-wirkraum-"))
(destination / "ios").mkdir()
for child in (source / "ios").iterdir():
    if child.name != "Wirkraum.xcodeproj":
        (destination / "ios" / child.name).symlink_to(child, target_is_directory=child.is_dir())
for name in ("dist", "data"):
    (destination / name).symlink_to(source / name, target_is_directory=True)
copied = destination / "ios/Wirkraum.xcodeproj"
shutil.copytree(project, copied, ignore=shutil.ignore_patterns("xcuserdata", "project.xcworkspace"))
pbx = copied / "project.pbxproj"
text = pbx.read_text()
pattern = r'isa = XCRemoteSwiftPackageReference;\s*repositoryURL = "https://github.com/ermanakar/LubaUI";\s*requirement = \{[^}]+\};'
replacement = f'isa = XCLocalSwiftPackageReference;\n\t\t\trelativePath = "{library}";'
text, count = re.subn(pattern, lambda _: replacement, text)
if count != 1:
    raise SystemExit(f"Expected exactly one LubaUI package reference, found {count}; copy at {destination}")
pbx.write_text(text.replace('XCRemoteSwiftPackageReference "LubaUI"', 'XCLocalSwiftPackageReference "LubaUI"'))
print(destination)

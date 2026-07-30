import subprocess
import sys
from pathlib import Path

EXCLUDE_ENTRY = "_untracked"


def git(*args: str, cwd: Path) -> str:
    return subprocess.run(
        ["git", *args], cwd=cwd, check=True, capture_output=True, text=True
    ).stdout


def main() -> None:
    root = Path(git("rev-parse", "--show-toplevel", cwd=Path.cwd()).strip())

    if (root / ".jj").is_dir():
        sys.exit(f"{root}: already colocated (.jj exists)")

    untracked_dir = root / EXCLUDE_ENTRY
    untracked_dir.mkdir(exist_ok=True)

    exclude_file = root / ".git" / "info" / "exclude"
    exclude_lines = (
        exclude_file.read_text().splitlines() if exclude_file.exists() else []
    )
    if EXCLUDE_ENTRY not in exclude_lines:
        with exclude_file.open("a") as f:
            _ = f.write(f"{EXCLUDE_ENTRY}\n")

    for relpath in git(
        "ls-files", "--others", "--exclude-standard", cwd=root
    ).splitlines():
        src = root / relpath
        dst = untracked_dir / relpath
        if dst.exists():
            sys.exit(f"refusing to overwrite existing {dst}")
        dst.parent.mkdir(parents=True, exist_ok=True)
        _ = src.rename(dst)
        print(f"moved {relpath}")

    _ = subprocess.run(
        ["jj", "git", "init", "--colocate"], cwd=root, check=True
    )


if __name__ == "__main__":
    main()

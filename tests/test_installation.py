"""Check that the package is installed, not just importable from the repo root."""

import subprocess
import sys
from pathlib import Path


def test_package_imports_outside_repository(tmp_path: Path) -> None:
    result = subprocess.run(
        [sys.executable, "-I", "-c", "import app"],
        cwd=tmp_path,
        capture_output=True,
        text=True,
        timeout=10,
    )

    assert result.returncode == 0, result.stderr

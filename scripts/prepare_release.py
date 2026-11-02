"""Prepare an immutable plugin archive without publishing it."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import io
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def git(*args: str) -> bytes:
    return subprocess.run(
        ["git", "-C", str(ROOT), *args], check=True, capture_output=True
    ).stdout


def committed(commit: str, path: str) -> bytes:
    return git("show", f"{commit}:{path}")


def write_once(path: Path, content: bytes) -> None:
    if path.exists():
        if path.read_bytes() != content:
            raise ValueError(f"Refusing to replace different output: {path.name}")
        return
    with path.open("xb") as output:
        output.write(content)


def prepare(commit: str, output: Path) -> dict[str, str]:
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        raise ValueError("--commit must be a full lowercase 40-character Git commit")
    resolved = git("rev-parse", f"{commit}^{{commit}}").decode().strip()
    if resolved != commit:
        raise ValueError("Selected object must itself be the exact commit")

    plugin = json.loads(committed(commit, ".claude-plugin/plugin.json"))
    marketplace = json.loads(committed(commit, ".claude-plugin/marketplace.json"))
    entries = marketplace["plugins"]
    if (
        plugin["name"] != "mangrove-trader"
        or marketplace["name"] != "mangrove-trader-plugin"
    ):
        raise ValueError("Unexpected plugin or marketplace identity")
    if (
        len(entries) != 1
        or entries[0]["name"] != plugin["name"]
        or entries[0]["source"] != "./"
    ):
        raise ValueError("Marketplace must select this repository's plugin")
    version = plugin["version"]
    if not re.fullmatch(r"(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)", version):
        raise ValueError("Expected a stable three-part plugin version")
    if entries[0]["version"] != version:
        raise ValueError("Plugin and marketplace versions differ")

    license_bytes = committed(commit, "LICENSE")
    if not license_bytes.strip():
        raise ValueError("Committed license must not be empty")
    archive_name = f"mangrove-trader-{version}-{commit[:12]}.tar.gz"
    archive = io.BytesIO()
    with gzip.GzipFile(filename="", mode="wb", fileobj=archive, mtime=0) as compressed:
        compressed.write(
            git("archive", "--format=tar", f"--prefix=mangrove-trader-{version}/", commit)
        )
    archive_bytes = archive.getvalue()
    digest = hashlib.sha256(archive_bytes).hexdigest()
    provenance = {
        "repository": "https://github.com/MangroveTechnologies/mangrove-trader-plugin",
        "source_commit": commit,
        "plugin": plugin["name"],
        "marketplace": marketplace["name"],
        "version": version,
        "archive": archive_name,
        "archive_sha256": digest,
        "declared_license": plugin["license"],
        "license_sha256": hashlib.sha256(license_bytes).hexdigest(),
        "publication": "prepared-only",
    }
    output.mkdir(parents=True, exist_ok=True)
    files = {
        archive_name: archive_bytes,
        archive_name + ".sha256": f"{digest}  {archive_name}\n".encode(),
        "release-provenance.json": (
            json.dumps(provenance, indent=2, sort_keys=True) + "\n"
        ).encode(),
    }
    for name, content in files.items():
        path = output / name
        if path.exists() and path.read_bytes() != content:
            raise ValueError(f"Refusing to replace different output: {name}")
    for name, content in files.items():
        write_once(output / name, content)
    return provenance


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--commit", required=True)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    print(json.dumps(prepare(args.commit, args.output), indent=2, sort_keys=True))


if __name__ == "__main__":
    main()

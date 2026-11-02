# Trader plugin release preparation

Repository/plugin version 2.0.5 is newer than the last GitHub release, v2.0.1.
The plugin is distributed by repository marketplace or local checkout, not by a
PyPI or npm package. A manifest version alone does not establish a tagged release.

## Prepare an exact source bundle

Select a full, reviewed commit and run:

```bash
python3 scripts/prepare_release.py --commit FULL_REVIEWED_COMMIT --output OUTPUT_DIRECTORY
```

The command validates the committed plugin and marketplace identity/version,
then creates a deterministic archive, SHA-256 checksum and provenance JSON. It
reads committed files, so uncommitted changes are excluded. It never creates a
tag, calls GitHub, or publishes a release. Repeating the same commit produces the
same bytes; an existing different output is rejected.

Preparation also verifies that the archive contains the exact committed license
and both catalog manifests. Git archive attributes that omit or change those
files fail before any output is written.

For a source install, clone the repository, check out that exact commit with
`git checkout --detach FULL_REVIEWED_COMMIT`, then point `claude --plugin-dir` at
the checkout. Record both the full commit and manifest version. The marketplace
name is `mangrove-trader-plugin`; the plugin name is `mangrove-trader`.

## Publication gates

Actual GitHub tag/release publication is separate from this preparation:

1. Human review and merge the source PR, then qualify the exact current `main`
   commit and its Catalog CI result. Rebuild the bundle from that commit.
2. Preserve the existing license grant and bind its exact hash in the bundle and
   provenance. Only changing or replacing those terms requires the copyright
   owner's specific decision; retaining the existing grant adds no release hold.
3. Inspect existing tags and releases. The intended version is read from the
   qualified manifest. An existing version at another commit or with different
   archive/provenance bytes is a conflict, not permission to move a tag or replace
   assets. An identical completed release needs no writes.
4. Only after explicit release authorization, create the annotated version tag
   at that exact commit and attach the verified bundle, checksum and provenance
   to its GitHub release. Never force a tag or overwrite an existing asset.
5. Read back the peeled tag commit and download/hash every asset before reporting
   the release complete. A successful upload or source PR is not that readback.

No GitHub release was created by adding this preparation process. No separate
public npm or PyPI channel is introduced.

## License-text decision

The existing `LICENSE` is an abbreviated permissive MIT-style grant. The plugin
metadata declares MIT, but the text differs from canonical MIT in its notice
condition and warranty wording. Replacing it with canonical text could change
the existing terms, so this work leaves its bytes unchanged.

Changing the text to canonical MIT requires the copyright owner's approval of a
specific replacement and its release scope. Until then, releases can retain the
existing grant. The offline bundle records the actual license hash; it does not
certify canonical MIT wording or authorize relicensing.

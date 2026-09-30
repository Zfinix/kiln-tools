# Release kiln and the tools

The tools depend on tagged kiln releases, so a kiln change reaches a tool in
three steps: release kiln, update the tool, move the submodule here.

## Release kiln

In `kiln/`, bump `version` in `Cargo.toml`, update the install line in the
README, then tag and publish:

```sh
git commit -am "chore: release 0.3.0"
git tag -a v0.3.0 -m "kiln 0.3.0"
git push && git push origin v0.3.0
gh release create v0.3.0 --title "kiln 0.3.0" --notes "What changed"
```

## Update a tool

In the tool's repository, point it at the new tag and check it:

```toml
kiln = { git = "https://github.com/Zfinix/kiln", tag = "v0.3.0" }
```

```sh
cargo update -p kiln
cargo test
git commit -am "build: depend on kiln v0.3.0"
git push
```

## Move the submodules here

```sh
git submodule update --remote
cargo build
cargo test --workspace
git commit -am "chore: update the tools"
git push
```

Inside this repository you do not need a kiln release to try a change: the
workspace builds every tool against the `kiln/` checkout, so edit kiln and
run `cargo build`.

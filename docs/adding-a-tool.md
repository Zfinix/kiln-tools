# Add a tool to the collection

Each tool is its own repository. This page takes a new one from an empty
folder to a submodule here.

## 1. Build it next to kiln

Start from the [tutorial](tutorial.md) and follow the
[conventions](conventions.md). While you work, you can point the tool at a
local kiln checkout:

```toml
kiln = { path = "../kiln" }
```

## 2. Switch to a kiln release

Before publishing, depend on a tagged kiln release so the tool builds on its
own:

```toml
kiln = { git = "https://github.com/Zfinix/kiln", tag = "v0.2.0" }
```

## 3. Give it a README and a screenshot

The README opens with the one-line pitch and a screenshot, then covers
install, usage with real commands, a keys table, and configuration. Copy the
layout from `tock/README.md`.

## 4. Add CI and publish

Copy `.github/workflows/ci.yml` from any tool. It runs fmt, clippy and the
tests on Linux, macOS and Windows. Then create the repository and push:

```sh
gh repo create Zfinix/<name> --public --source . --push
```

## 5. Add it here

From the root of this repository:

```sh
git submodule add https://github.com/Zfinix/<name>.git <name>
```

Add `"<name>"` to `members` in the root `Cargo.toml`, then check that
everything still builds:

```sh
cargo build
cargo test --workspace
```

Finally, add a row and a screenshot for the tool to the README.

# kiln-tools

Small terminal tools built on [kiln](https://github.com/Zfinix/kiln), my
library of inline terminal components for Rust.

Each tool does one job, lives in its own repository, and is pulled in here as
a git submodule. This repository ties them together: one checkout, one
`cargo build`, and the docs for building more.

## The tools

| Tool | What it does | Install |
|---|---|---|
| [tock](https://github.com/Zfinix/tock) | A pomodoro timer in your terminal | `cargo install --git https://github.com/Zfinix/tock` |
| [pulse](https://github.com/Zfinix/pulse) | Internet speed in your terminal | `cargo install --git https://github.com/Zfinix/pulse` |
| [ship](https://github.com/Zfinix/ship) | Conventional commits in your terminal | `cargo install --git https://github.com/Zfinix/ship` |

### tock

![tock counting down with big digits and a progress bar](https://raw.githubusercontent.com/Zfinix/tock/main/assets/demo.gif)

### pulse

![pulse measuring download speed with a big readout, a sparkline and a progress bar](https://raw.githubusercontent.com/Zfinix/pulse/main/assets/demo.gif)

### ship

![ship asking for a commit summary after the staged files, type and scope](https://raw.githubusercontent.com/Zfinix/ship/main/assets/demo.gif)

## Working on the code

Clone with the submodules:

```sh
git clone --recurse-submodules https://github.com/Zfinix/kiln-tools
cd kiln-tools
```

Build and test everything at once:

```sh
cargo build
cargo test --workspace
```

Run a tool from here:

```sh
cargo run -p pulse
cargo run -p tock -- 10m --label reading
```

The workspace points every tool at the `kiln/` checkout in this repository, so
a change to kiln shows up in all the tools on the next build. Outside this
repository, each tool depends on a tagged kiln release instead.

To pull the latest commit of every tool:

```sh
git submodule update --remote
```

## Docs

- [Build your first tool](docs/tutorial.md): a countdown in about 50 lines
- [Conventions](docs/conventions.md): how every tool behaves, from flags to exit codes
- [Add a tool to the collection](docs/adding-a-tool.md)
- [Release kiln and the tools](docs/releasing.md)
- [Record a demo](docs/recording-demos.md): the GIFs above, made in a real Ghostty window
- [Why inline, not full screen](docs/why-inline.md)

## License

Apache 2.0. Each tool and kiln carry their own copy of the license.

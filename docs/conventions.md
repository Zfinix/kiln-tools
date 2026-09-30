# Conventions

Every tool in this collection behaves the same way, so learning one teaches
you the rest. New tools should follow these rules.

## Shape

- One job per tool, stated in one line: "X in your terminal".
- The name is one short word.
- Running the tool with no arguments opens the interactive pane.
- Everything the pane can do is also possible with flags, so the tool works
  in scripts.
- Input can be piped in where it makes sense (`echo "fix the bug" | ship -t fix`).

## Output

- By default the tool prints the result and nothing else.
- `--quiet` or `-q` prints only errors.
- `--json` prints one JSON object and nothing else, for scripts.
- Finished results go into scrollback with a kiln cell, so they stay after
  the tool exits. The live pane is cleared on exit.

## Errors

- Say what happened and what to do next in one plain sentence:
  "Could not reach speed.cloudflare.com. Check your connection and try again."
- Put the raw error from the system or library on a dimmer line below it.
- Exit with status 1 on any error and 0 on success, at every verbosity.

## Keys

| Key | Action |
|---|---|
| `q`, `ctrl+c` | quit |
| `?` | show or hide the help list |
| `esc` | cancel the current step |
| `enter` | confirm |
| arrows | move |

Show the most useful keys in a one-row footer with `kiln::keys::footer`, and
the full list with `kiln::keys::help`.

## Configuration

Settings are read in this order, first match wins:

1. Flags, such as `--theme nord`
2. Environment variables named after the tool, such as `TOCK_THEME`
3. Built-in defaults

Every tool takes `--theme` with any kiln theme name.

## Code

- Rust 2024 on stable, with `cargo fmt` and `cargo clippy -- -D warnings` clean.
- A thin `main.rs` for arguments and wiring. Logic lives in modules named after
  what they do (`duration.rs`, `measure.rs`, `message.rs`), with tests in a
  sibling `*_test.rs` file.
- No `unwrap` or `expect` outside tests.
- Arguments are parsed by hand; the tools are small enough not to need clap.
- Commit messages follow Conventional Commits:
  `type(scope): summary`, lowercase, no trailing period.

# Why inline, not full screen

Most terminal apps switch to the alternate screen: they take over the whole
window and hide your shell history until they exit. kiln does the opposite.
It keeps a small live pane at the bottom of the terminal and writes everything
that is finished into the terminal's own scrollback.

## What that buys

- **Your terminal keeps working.** Scrolling, mouse selection, copy and search
  are the terminal's own, not an imitation drawn by the app.
- **Results outlive the tool.** When `pulse` exits, the speeds are still on
  screen. When `ship` commits, every answer you gave is still there to read.
- **The tool fits in the flow.** It opens under your prompt, does its job and
  leaves one clean record, like any other command.

## What it costs

- **The pane has to stay small.** kiln caps it at three fifths of the screen
  so there is always room for output above it. Big layouts belong in a full
  screen app.
- **Output above the pane is final.** Once a line is in scrollback it cannot
  change, so live values belong in the pane and only finished ones go above.
- **Resizing is hard.** When the window narrows, the terminal rewraps the
  scrollback on its own. kiln tracks how wide every line was printed so it can
  put the pane back directly under the last line. The details are in
  `kiln/src/term.rs`, and `kiln/src/tests/term_test.rs` checks them against a
  simulated terminal.

## Where the idea comes from

The layout follows the terminal UI of
[Codex CLI](https://github.com/openai/codex), and the way each tool feels
follows [Charm](https://charm.sh) tools such as `gum`.

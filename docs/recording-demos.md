# Record a demo

Every tool's README opens with a GIF recorded in a real
[Ghostty](https://ghostty.org) window, so it shows the real font, colours and
timing. `scripts/record/rec.sh` does the whole thing: it opens a small window,
types the command, presses the keys you script, and turns the recording into
a GIF. It runs on macOS and needs Ghostty, ffmpeg and the Xcode command line
tools (for `swiftc`).

## Record one

```sh
scripts/record/rec.sh tock 58 13 20 "$HOME" '{
  "runs": [{
    "show": "tock 8s --label tea",
    "cmd": "tock 8s --label tea",
    "keys": [{"wait": 3.5, "keys": " "}, {"wait": 1.6, "keys": " "}]
  }]
}' tock/assets/demo.gif
```

The arguments are the window title, its size in columns and rows, the longest
the recording may run in seconds, the folder the command runs in, the script,
and where to write the GIF.

The first time you record, macOS asks to let your terminal record the screen.
Allow it in System Settings under Privacy & Security, then run the command
again.

## The script

| Field | Meaning |
|---|---|
| `pre` | seconds to wait before typing the first command (default 1) |
| `runs` | the commands to run, one after another |
| `runs[].show` | what the fake prompt types, like `tock 8s` |
| `runs[].cmd` | what actually runs, often the same with a full path |
| `runs[].keys` | key presses to send while it runs |
| `runs[].after` | seconds to wait after the command exits (default 0.8) |

Each entry in `keys` waits `wait` seconds after the one before it, then sends
either `keys`, typed one character at a time (`gap` sets the pause between
them), or `raw`, sent all at once. Use `raw` for enter (`"\r"`), tab (`"\t"`)
and arrow keys (`"\u001b[B"` for down), because an escape sequence split into
single characters reads as a lone esc.

## How it works

- `puppet.py` runs inside the Ghostty window. It types the prompt, runs the
  command in its own pseudo-terminal, forwards the output, and sends the
  scripted keys. Nothing takes over your real keyboard.
- `bounds.swift` finds the window on screen by its title, and
  `screencapture` records just that rectangle.
- `park.swift` moves the mouse pointer to the corner of the screen first, so
  it does not show up in the recording.
- The first 1.4 seconds are cut, so the shell's login line never shows.
- When the last command finishes, the recording is cut 2.5 seconds later and
  the window is closed, so a recording never shows anything else on your
  screen.

## Tips

- Keep the window small. The GIFs are 1000 pixels wide, and a 60 column
  window stays readable at that size.
- Leave enough rows for the pane: kiln never lets it take more than three
  fifths of the window.
- Use a throwaway git repository for tools that change things, like `ship`.

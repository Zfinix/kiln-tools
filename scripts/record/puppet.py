"""Types a fake prompt, runs each command in a pty, and presses its scripted keys.

Usage: puppet.py CWD SCRIPT_JSON DONE_MARKER. Runs inside the recorded window.
"""
import fcntl, json, os, pty, select, struct, sys, termios, time, tty

cwd, script, marker = sys.argv[1], json.loads(sys.argv[2]), sys.argv[3]
os.chdir(cwd)
out = sys.stdout.buffer

def say(text, delay=0.045):
    for ch in text:
        out.write(ch.encode()); out.flush(); time.sleep(delay)

rows, cols = struct.unpack("HH", fcntl.ioctl(1, termios.TIOCGWINSZ, b"\0" * 4))
old = termios.tcgetattr(0)
tty.setraw(0)
try:
    out.write(b"\x1b[2J\x1b[H"); out.flush()
    time.sleep(script.get("pre", 1.0))
    for run in script["runs"]:
        say("\x1b[38;2;120;130;150m$\x1b[0m ", 0)
        say(run["show"])
        time.sleep(0.35)
        out.write(b"\r\n"); out.flush()
        pid, fd = pty.fork()
        if pid == 0:
            os.execvp("/bin/sh", ["/bin/sh", "-c", run["cmd"]])
        fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", rows, cols, 0, 0))
        steps = list(run.get("keys", []))
        start = time.time()
        clock = 0.0
        alive = True
        while alive:
            if steps and time.time() - start >= clock + steps[0].get("wait", 0):
                step = steps.pop(0)
                clock += step.get("wait", 0)
                keys = step.get("keys", "")
                for ch in keys:
                    os.write(fd, ch.encode()); time.sleep(step.get("gap", 0.07))
                if "raw" in step:
                    os.write(fd, step["raw"].encode())
            r, _, _ = select.select([fd, 0], [], [], 0.02)
            if fd in r:
                try:
                    data = os.read(fd, 65536)
                except OSError:
                    data = b""
                if not data:
                    alive = False
                out.write(data); out.flush()
            if 0 in r:
                os.write(fd, os.read(0, 1024))
        os.waitpid(pid, 0)
        time.sleep(run.get("after", 0.8))
    open(marker, "w").write("done")
    time.sleep(600)
finally:
    termios.tcsetattr(0, termios.TCSADRAIN, old)

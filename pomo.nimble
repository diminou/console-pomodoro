# Package

version       = "0.1.0"
author        = "divanov"
description   = "Console-based pomodoro timer"
license       = "MIT"
srcDir        = "src"
bin           = @["pomo"]


# Dependencies

requires "nim >= 1.4.0"
requires "https://github.com/status-im/nim-chronos.git"

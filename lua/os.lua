--[[
Windows:
  machine = "x86_64",
  release = "10.0.19043",
  sysname = "Windows_NT",
  version = "Windows 10 Home China"
WSL-arch:
  machine = "x86_64",
  release = "5.10.60.1-microsoft-standard-WSL2",
  sysname = "Linux",
  version = "#1 SMP Wed Aug 25 23:20:18 UTC 2021"
WSL-ubuntu:
  machine = "x86_64",
  release = "4.4.0-19041-Microsoft",
  sysname = "Linux",
  version = "#1237-Microsoft Sat Sep 11 14:32:00 PST 2021"
Mac-intel:
  machine = "x86_64",
  release = "21.6.0",
  sysname = "Darwin",
  version = "Darwin Kernel Version 21.6.0: Sat Jun 18 17:07:25 PDT 2022; root:xnu-8020.140.41~1/RELEASE_X86_64"
]]

-- windows, unix(wsl, mac, linux)
-- _G.is_windows = vim.fn.has('win32') == 1 and true or false
-- _G.is_wsl = vim.fn.has('wsl') == 1 and true or false
_G.is_windows = vim.loop.os_uname().version:match 'Windows' and true or false
_G.is_unix = not is_windows
_G.is_wsl = vim.loop.os_uname().release:lower():match 'microsoft' and true or false
_G.is_mac = vim.loop.os_uname().sysname:match 'Darwin' and true or false
_G.is_linux = _G.is_unix and not (_G.is_wsl or _G.is_mac)

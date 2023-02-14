import std/[os]

import errorhandling
import database
import packagemanager
import networking

discard download("https://mirror.0xem.ma/arch/iso/2023.02.01/archlinux-2023.02.01-x86_64.iso")
quit(1)

proc getCommandArgs(): seq[string] =
  for i in 2 .. paramCount():
    result.add(paramStr(i))



if paramCount() == 0:
  error("No arguments given")

case paramStr(1):
of "-s", "--sync":
  syncDb()
of "-i", "--install":
  echo "Installing..."
of "--search":
  if paramCount() == 1:
    error("No search term given")
  search(getCommandArgs())
else:
  error("Unknown command: " & paramStr(1))
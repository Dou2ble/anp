import std/[terminal, strformat]

proc error*(error: string) =
  styledEcho(fgRed, styleBright, &"ERROR: {error}")
  quit(1)
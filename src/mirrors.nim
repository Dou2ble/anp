import std/[os, strutils, random]
import errorhandling

const mirrorlistPath = "/var/lib/anp/mirrorlist"

proc getMirror*(): string =
  var mirrorList: seq[string]
  if not fileExists(mirrorlistPath):
    error("Mirrorlist does not exist")
  try:
    mirrorList = readFile("/var/lib/anp/mirrorlist").strip().splitLines()
  except:
    error("Could not read mirrorlist")
  result = mirrorList[rand(mirrorList.len)-1]

import std/[strformat, asyncdispatch, options, json]

import mirrors
import networking
import errorhandling


proc syncDb*() =
  discard download(&"{getMirror()}/database.json", some("/var/lib/anp/database.json"))

proc getDb*(): JsonNode =
  return parseFile("/var/lib/anp/database.json")
  
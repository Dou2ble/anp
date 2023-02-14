import std/[asyncdispatch, httpclient, strutils, options, terminal]

import libcurl

import errorhandling


let webData: ref string = new string
proc curlWriteFn(
  buffer: cstring,
  size: int,
  count: int,
  outstream: pointer): int =
  
  let outbuf = cast[ref string](outstream)
  outbuf[] &= buffer
  result = size * count

proc curlProgressFn(
  clientp: pointer,
  dltotal: float, dlnow: float,
  ultotal: float, ulnow: float) {.cdecl.} =
  if dlnow == 0 or dltotal == 0:
    return

  let cols = terminalWidth()
  let barSize = cols-2
  let percent = dlnow.toInt() / dltotal.toInt()
  let percentHuman = $toInt(percent * 100) & '%'
  stdout.eraseLine()
  stdout.write('x'.repeat(toInt(barSize.float*percent)))
  #stdout.write(percentHuman)

  stdout.flushFile()


  #echo $(dlnow / dltotal * 100).toInt() & "%"

var curl = easy_init()
discard curl.easy_setopt(OPT_HTTPGET, 1)
discard curl.easy_setopt(OPT_WRITEDATA, webData)
discard curl.easy_setopt(OPT_WRITEFUNCTION, curlWriteFn)

discard curl.easy_setopt(OPT_NOPROGRESS, 0)
discard curl.easy_setopt(OPT_PROGRESSFUNCTION, curlProgressFn)

discard curl.easy_setopt(OPT_CONNECTTIMEOUT, 10)


proc download*(src: string, dest = none(string)): string =
  discard curl.easy_setopt(OPT_URL, src)

  let ret = curl.easy_perform()
  if ret != E_OK:
    error("Failed to download file: " & $ret)

  if dest.isSome:
    writeFile(dest.get, webData[])
  
  return webData[]
  
  

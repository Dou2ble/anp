import std/[json, strutils, strformat, sequtils]

import database

proc search*(query: seq[string]) =
  let db = getDb()
  let queryString = query.join(" ")

  var results: seq[(string, int)]

  # for each key in the json
  for package, packageInfo in db:
    #echo packageInfo
    let name = packageInfo["name"].getStr()
    let description = packageInfo["description"].getStr()

    if name.contains(queryString) or description.contains(queryString):
      var rating: int

      # give the package a rating based on how many times the query appears in the name and description
      for term in query:
        rating += name.count(term) * 2
        rating += description.count(term)
      
      results.add((package, rating))

  var resultsSorted: seq[string]
  # print the results
  for i in 1 .. results.len:
    var worstPackage = ("", 100000000)
    for (package, rating) in results:
      if rating < worstPackage[1]:
        worstPackage = (package, rating)
    
    resultsSorted.add(worstPackage[0])
    results.delete(results.find(worstPackage))

  for package in resultsSorted:
    echo (
      $(resultsSorted.len - resultsSorted.find(package)) & " " &
      package & "\n    " & db[package]["description"].getStr()) &
      '\n'
    #stdout.write(package)
  
      



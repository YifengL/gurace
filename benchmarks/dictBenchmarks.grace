import "biDictionary" as bD

def dict = bD.biDictionary

def cap = 100

var md := dict.empty

method addKeyValues {
  for (1..cap) do { k ->
    md.at(k)put(cap + k)
  }
  print (md.size)
}



method checkContains {
  for (1..cap) do { k ->
    if (!md.containsKey(k)) then {
      print "Error at key {k}"
      return
    }
    if (md.containsKey(k + cap)) then {
      print "Error at key {k + cap}"
      return
    }
    if (!md.containsValue(cap + k)) then {
      print "Error at value {cap + k}"
      return
    }
    if (md.containsValue(k)) then {
      print "Error at value {k}"
      return
    }
  }
  print "Check contains success"
}

method checkContainsMany(n) {
  for (1..n) do { i -> checkContains }
}

method checkKeyValues {
  var rev := md.reversed
  for (1..cap) do { k ->
    if (md[k] != (cap + k)) then {
      print "Error at {k} --> {cap + k}"
      return
    }
    if (rev[cap + k] != k) then {
      print "Error at {k} <-- {cap + k}"
      return
    }
  }
  print "Check key-value success"
}

method checkKeyValuesMany(n) {
  for (1..n) do { i -> checkKeyValues }
}

method checkDeletions {
  for (1..cap) do { k ->
    md.removeKey(k)
    if (md.containsKey(k) || md.containsValue(cap + k)) then {
      print "Error at remove {k} -> {cap + k}"
      return
    }
    md.at(k)put(cap+k)
  }
  print "Check deletions uccess"
}

method checkDeletionsMany(n) {
  for (1..n) do { i -> checkDeletions }
}

addKeyValues
checkContainsMany(1)  
checkKeyValuesMany(1)
checkDeletionsMany(1)


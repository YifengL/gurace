import "immutableSet" as imSet

def iSet = imSet.immutableSet
//def iSet = set

var set_1 := iSet.withAll(1..400)
var set_2 := iSet.withAll(200..600)
var set_3 := iSet.withAll(1..16000)


method printHash {
  print (set_1.hash)
  print (set_2.hash)
  print ((set_1 ++ set_2).hash)
  print ((set_1 -- set_2).hash)
  print ((set_2 -- set_1).hash)
  print ((set_1 ** set_2).hash) 
}


method checkContains(times:Number, _set) {
  var sz := _set.size
  for (1..times) do { t ->
    _set.do { each ->
      if (!_set.contains(each)) then { 
        print "Error at {each}"
        return
      }
      if (_set.contains(each + sz)) then {
        print "Error at {each + sz}"
        return
      }
    }
  }
  print "finished"
}

checkContains(3, set_3)

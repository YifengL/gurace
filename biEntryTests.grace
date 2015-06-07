import "gUnit" as gU
import "biEntry" as bE

def biEntryTest = object {
  factory method forMethod(m) {
    inherits gU.testCaseNamed(m)

    method testEqual {
      var e1 := bE.newEntry("a"::"A")
      var e2 := bE.newEntry("a"::"A")

      assert (e1 == e2)
      deny (e1 != e2)
    }

    method testNotEqual {
      var e1 := bE.newEntry("a"::"A")
      var e2 := bE.newEntry("A"::"a")

      assert (e1 != e2)
      deny (e1 == e2)
    }
    
    method testNotEqualWithKToVLink {
      var e1 := bE.newEntry("a"::"A")
      var e2 := bE.newEntry("a"::"A")
      e1.nextKToVBucket := e2
      
      deny (e1 == e2)
      assert (e1 != e2)
    }
    
    method testNotEqualWithVToKLink {
      var e1 := bE.newEntry("a"::"A")
      var e2 := bE.newEntry("a"::"A")
      e1.nextVToKBucket := e2
      
      deny (e1 == e2)
      assert (e1 != e2)
    }

    method testAttributes {
      var e := bE.newEntry("a"::"A")
      
      assert (e.key == "a")
      assert (e.value == "A")
      assert (e.asString == "biEntry a::A")
    }

    method testEnd {
      var e := bE.newEntry("a"::"A")
      
      assert (e.nextKToV == bE.unused)
      assert (e.nextVToK == bE.unused)
    }
  }
}
  
def biEntryTests = gU.testSuite.fromTestMethodsIn(biEntryTest)
biEntryTests.runAndPrintResults


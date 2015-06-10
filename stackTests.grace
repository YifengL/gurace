import "stack" as stack
import "gUnit" as gU

def stackTest = object {
  factory method forMethod(m) {
    inherits gU.testCaseNamed(m)

    def empty = stack.newStack(1)
    
    method testSizeEmpty {
      assert (empty.size == 0)
    }

    method testEmptyPop {
      assert (empty.pop) shouldBe ("stack underflow")
    }

    method testLarge {
      var large := stack.newStack(0)
      for (1..100) do { i -> large.push(i)}
      assert (large.size == 100)
      for (1..100) do { i ->
        assert (large.pop == (101-i))
      }
      assert (large.size == 0)
    }

    method testSmall {
      var small := stack.newStack(0)
      for (1..4) do { i -> small.push(i) }
      assert (small.size == 4)
      for (1..4) do { i ->
        assert (small.pop == (5-i))
      }
      assert (small.size == 0)
    }
  }
}

def tests = gU.testSuite.fromTestMethodsIn(stackTest)
tests.runAndPrintResults

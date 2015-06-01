import "gUnit" as gU
import "biDictionary" as bD

def dictionaryTest = object {
    factory method forMethod(m) {
        inherits gU.testCaseNamed(m)
        def oneToFive = dictionary.with("one"::1, "two"::2, "three"::3, 
            "four"::4, "five"::5)
        def evens = bD.biDictionary.with("two"::2, "four"::4, "six"::6, "eight"::8)
        def empty = dictionary.empty
        
        method testDictionaryEvensBindingsIterator {
            def ei = evens.iterator
            assert (evens.size == 4) description "evens doesn't contain 4 elements!"
            assert (ei.hasNext) description "the evens iterator has no elements"
            def copyDict = bD.biDictionary.with(ei.next, ei.next, ei.next, ei.next)
            deny (ei.hasNext) description "the evens iterator has more than 4 elements"
            assert (copyDict==evens)
            assert (copyDict) shouldBe (evens)
        }
        
        method testReversed{
            def rev=evens.reversed.reversed
            assert(rev==evens)
        }
    }
}

def dictTests = gU.testSuite.fromTestMethodsIn(dictionaryTest)
dictTests.runAndPrintResults
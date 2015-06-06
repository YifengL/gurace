import "gUnit" as gU
import "biDictionary" as bD

def dictionaryTest = object {
    factory method forMethod(m) {
        inherits gU.testCaseNamed(m)
        def oneToFive = bD.biDictionary.with("one"::1, "two"::2, "three"::3, 
            "four"::4, "five"::5)
        def evens = bD.biDictionary.with("two"::2, "four"::4, "six"::6, "eight"::8)
        def empty = bD.biDictionary.empty
        
        method testDictionaryTypeCollection {
            assert (oneToFive) hasType (Collection<Binding<String,Number>>)
        }
        
        method testDictionaryTypeDictionary {
            assert (oneToFive) hasType (bD.BiDictionary<String,Number>)
        }
        
        method testDictionaryTypeNotTypeWithWombat {
            deny (oneToFive) hasType (bD.BiDictionary<String,Number> & type { wombat })
        }
        
        method testDictionarySize {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }
        
        method testDictionarySizeAfterRemove {
            oneToFive.removeKey "one"
            deny(oneToFive.containsKey "one") description "\"one\" still present"
            oneToFive.removeKey "two"
            oneToFive.removeKey "three"
            assert(oneToFive.size) shouldBe 2
        }
        
        method testDictionaryEmptyDo {
            empty.do {each -> failBecause "emptySet.do did with {each}"}
            assert (true)   // so that there is always an assert
        }
        
        method testDictionaryInequalityEmpty {
            deny(empty == bD.biDictionary.with("one"::1)) 
                description "empty dictionary equals dictionary with \"one\"::1"
            assert(empty != bD.biDictionary.with("two"::2))
                description "empty dictionary equals dictionary with \"two\"::2"
            deny(empty == 3)
            deny(empty == evens)
        }
        method testDictionaryEqualityEmpty {
            assert(empty == bD.biDictionary.empty)
            deny(empty != bD.biDictionary.empty)
        }
        
        method testDictionaryInequalityFive {
            evens.at "ten" put 10
            assert(evens.size == oneToFive.size) description "evens.size should be 5"
            deny(oneToFive == evens)
            assert(oneToFive != evens)
        }
        
        method testDictionaryEqualityFive {
            assert(oneToFive == bD.biDictionary.with("one"::1, "two"::2, "three"::3,
                "four"::4, "five"::5))
        }
        
        method testDictionaryKeysAndValuesDo {
            def accum = bD.biDictionary.empty
            var n := 1
            oneToFive.keysAndValuesDo { k, v ->
                accum.at(k)put(v)
                assert (accum.size) shouldBe (n)
                n := n + 1
            }
            assert(accum) shouldBe (oneToFive)
        }
        
        method testDictionaryEmptyBindingsIterator {
            deny (empty.bindings.iterator.hasNext) 
                description "the empty bindings iterator has elements"
        }
        
        
        method testDictionaryEvensBindingsIterator {
            def ei = evens.bindings.iterator
            assert (evens.size == 4) description "evens doesn't contain 4 elements!"
            assert (ei.hasNext) description "the evens iterator has no elements"
            def copyDict = bD.biDictionary.with(ei.next, ei.next, ei.next, ei.next)
            //deny (ei.hasNext) description "the evens iterator has more than 4 elements"
            assert (copyDict==evens)
            assert (copyDict) shouldBe (evens)
        }
        
        method testDictionaryAdd {
            assert (empty.at "nine" put(9)) 
                shouldBe (bD.biDictionary.with("nine"::9))
            assert (evens.at "ten" put(10).values.onto(set)) 
                shouldBe (set.with(2, 4, 6, 8, 10))
        }
        
        method testDictionaryRemoveKeyTwo {
            assert (evens.removeKey "two".values.onto(set)) shouldBe (set.with(4, 6, 8))
            assert (evens.values.onto(set)) shouldBe (set.with(4, 6, 8))
        }
        
        method testDictionaryRemoveValue4 {
            print "{evens}"
            assert (evens.size == 4) description "evens doesn't contain 4 elements"
            evens.removeValue(4)
            assert (evens.size == 3) 
                description "after removing 4, 3 elements should remain"
            assert (evens.containsKey "two") description "Can't find key \"two\""
            assert (evens.containsKey "six") description "Can't find key \"six\""
            assert (evens.containsKey "eight") description "Can't find key \"eight\""
            deny (evens.containsKey "four") description "Found key \"four\""
            assert (evens.values.onto(set)) shouldBe (set.with(2, 6, 8))
            assert (evens.keys.onto(set)) shouldBe (set.with("two", "six", "eight"))
        }
        
        method testDictionaryContentsAfterMultipleRemove {
            oneToFive.removeKey("one", "two", "three")
            assert(oneToFive.size) shouldBe 2
            deny(oneToFive.containsKey "one") description "\"one\" still present"
            deny(oneToFive.containsKey "two") description "\"two\" still present"
            deny(oneToFive.containsKey "three") description "\"three\" still present"
            assert(oneToFive.containsKey "four")
            assert(oneToFive.containsKey "five")
        }
        
        method testReversed{
            def rev=evens.reversed.reversed
            assert(rev==evens)
        }
    }
}

def dictTests = gU.testSuite.fromTestMethodsIn(dictionaryTest)
dictTests.runAndPrintResults
import "immutableSet" as imSet
import "gUnit" as gU

def iSet = imSet.immutableSet
 
def setTest = object {
    factory method forMethod(m) {
        inherits gU.testCaseNamed(m)

        def oneToFive = iSet.with(1, 2, 3, 4, 5)
        def evens = iSet.with(2, 4, 6, 8)
        def empty = iSet.empty

        method testSetTypeCollection {
            def witness = iSet<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (Collection<Number>)
        }
        method testSetTypeSet {
            def witness = iSet<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (Set<Number>)
        }
        method testSetTypeNotSequence {
            def witness = iSet<Number>.with(1, 2, 3, 4, 5, 6)
            deny (witness) hasType (Sequence<Number>)
        }

        method testSetSize {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }

        method testSetEmptyDo {
            empty.do {each -> failBecause "emptySet.do did with {each}"}
        }
        
        method testSetEqualityEmpty {
            assert(empty == iSet.empty)
            deny (empty != iSet.empty)
        }
        
        method testSetInequalityEmpty {
            deny(empty == iSet.with(1))
            assert(empty != iSet.with(1))
            deny(empty == 3)
            deny(empty == evens)
        }
        
        method testSetInequalityFive {
            deny(oneToFive == iSet.with(1, 2, 3, 4, 6))
            assert(oneToFive != iSet.with(1, 2, 3, 4, 6))
        }

        method testSetEqualityFive {
            def isEqual = (oneToFive == iSet.with(1, 2, 3, 4, 5))
            assert(isEqual)
            deny(oneToFive != iSet.with(1, 2, 3, 4, 5))
        }

        method testSetOneToFiveDo {
            var n := 1
            oneToFive.do { each -> 
                assert (each == n)
                n := n + 1
            }
        }

        method testSetAdd {
            assert {empty.add(9)} shouldRaise (imSet.UnsupportedOperation)
        }
        
        method testSetRemove {
            assert {evens.remove(2)} shouldRaise (imSet.UnsupportedOperation)
        }
        
        method testSetRemoveAll {
          assert {iSet.withAll(1..10).removeAll(evens)} shouldRaise (imSet.UnsupportedOperation)
        }
        
        method testSetExtend {
          assert {evens.extend(oneToFive)} shouldRaise (imSet.UnsupportedOperation)
        }

        method testSetChaining {        
            var set_1 := iSet.withAll(1..10)
            var set_2 := iSet.withAll(11..20)
            var set_3 := iSet.withAll(21..30)
            
            assert (set_1 ++ set_2 ++ set_3) shouldBe (iSet.withAll(1..30))
        }
        
    
        method testEvensIterator {
            def ei = evens.iterator
            assert (evens.size == 4) description "evens doesn't contain 4 elements!"
            assert (ei.hasNext) description "the evens iterator has no elements"
            def copySet = iSet.with(ei.next, ei.next, ei.next, ei.next)
            deny (ei.hasNext) description "the evens iterator has more than 4 elements"
            assert (copySet) shouldBe (evens)
        }
        method testSetFold {
            assert(oneToFive.fold{a, each -> a + each}startingWith(5))shouldBe(20)
            assert(evens.fold{a, each -> a + each}startingWith(0))shouldBe(20)        
            assert(empty.fold{a, each -> a + each}startingWith(17))shouldBe(17)
        }
        
        method testSetDoSeparatedBy {
            var d := iSet.with(6, 8)
            var s := ""
            d.do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
            assert ((s == "6, 8") || (s == "8, 6")) 
                description "{s} should be \"8, 6\" or \"6, 8\""
        }
        
        method testHash {
          var s1 := iSet.with(1, 2, 3, 4)
          var s2 := iSet.with(4, 2, 1, 3)
          assert (s1.hash == s2.hash)
        }
        
        method testSetDoSeparatedByEmpty {
            var s := "nothing"
            empty.do { failBecause "do did when list is empty" }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }
        
        method testSetDoSeparatedBySingleton {
            var s := "nothing"
            iSet.with(1).do { each -> assert(each)shouldBe(1) } 
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }
         
        method testSetAsStringNonEmpty {
            assert ((evens.asString == "set\{2, 4, 6, 8\}"))
                description "set\{2, 4, 6, 8\}.asString is {evens.asString}"
        }
             
        method testSetAsStringEmpty {
            assert (empty.asString) shouldBe ("set\{\}")
        }
        
        method testSetMapEmpty {
            assert (empty.map{x -> x * x}.onto(set)) shouldBe (set.empty)
        }
        
        method testSetMapEvens {
            assert(evens.map{x -> x + 1}.onto(set)) shouldBe (set.with(3, 5, 7, 9))
        }
        
        method testSetMapEvensInto {
            assert(evens.map{x -> x + 10}.into(set.withAll(evens)))
                shouldBe (set.with(2, 4, 6, 8, 12, 14, 16, 18))
        }
        
        method testSetCopy {
            def evensCopy = evens.copy
            assert (evensCopy) shouldBe (iSet.with(2, 4, 6, 8))
        }
        method testSetUnion {
            assert (oneToFive ++ evens) shouldBe (iSet.with(1, 2, 3, 4, 5, 6, 8))
        }
        method testSetDifference {
            assert (oneToFive -- evens) shouldBe (iSet.with(1, 3, 5))
        }
        method testSetIntersection {
            assert (oneToFive ** evens) shouldBe (iSet.with(2, 4))
        }
    }
} 

def tests = gU.testSuite.fromTestMethodsIn(setTest)
tests.runAndPrintResults
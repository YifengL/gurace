//def UnsupportedOperation = Error.refine "UnsupportedOperation" 

class immutableSet.trait<T>{
    inherits collection.trait<T>  
    method do { abstract }
    method iterator { abstract }
    method isEmpty {
        // override if size is known
        iterator.hasNext.not
    }
    method asSequence {
        sequence.withAll(self)
    }
    method asList {
        list.withAll(self)
    }
    method asSet { 
        set.withAll(self)
    }
}
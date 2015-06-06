def UnsupportedOperation = Error.refine "UnsupportedOperation" 

class immutableSet.trait<T>{
    inherits collection.trait<T>  
    method add{ UnsupportedOperation.raise "immutableSet does not support method: add"}
    method addAll{ UnsupportedOperation.raise "immutableSet does not support method: addAll"}
    method remove { UnsupportedOperation.raise "immutableSet does not support method: remove"}
    method removeAll {UnsupportedOperation.raise "immutableSet does not support method: removeAll"}
    method removeAllifAbsent {UnsupportedOperation.raise "immutableSet does not support method: removeAllifAbsent"}
    method removeifAbsent { UnsupportedOperation.raise "immutableSet does not support method: removeifAbsent"}
    method includes { UnsupportedOperation.raise "immutableSet does not support method: includes"}
}
type BiEntry<K,V> = Object & type{
    nextKToV -> BiEntry<K,V>
    nextVToK -> BiEntry<V,K>
    key -> K
    value -> V
}

def unused = object {
  inherits Singleton.new
  method key {}
  method value {}
  method nextKToV {}
  method nextVToK {}
  method asString { "unused" }
}


factory method newEntry<K,V>(binds:Binding<K,V>) -> BiEntry<K,V>{
    
    var nextKToVBucket is public:=unused
    var nextVToKBucket is public:=unused
    var k:=binds.key
    var v:=binds.value
    
    method ==(other){
        if((self.asString=="unused") && (other.asString=="unused"))then{
            return true
        }

        if ((self.asString == "unused") || (other.asString == "unused")) then { return false }

        if((self.key != other.key) || (self.value != other.value)) then { return false }
            
        if (self.nextKToV != other.nextKToV) then { return false }
            
        if (self.nextVToK != other.nextVToK) then { return false }

        return true
    }
    
    method !=(other){
        !(self == other)
    }
    
    method asString { return "biEntry {k}::{v}" }
    method key{ k }
    method value{ v }
    method nextKToV{ nextKToVBucket }
    method nextVToK{ nextVToKBucket }
  
}

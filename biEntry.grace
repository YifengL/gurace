type BiEntry<K,V> = Object & type{
    nextKToV -> BiEntry<K,V>
    nextVToK -> BiEntry<V,K>
    key -> K
    value -> V
}

factory method newEntry<K,V>(binds:Binding<K,V>) -> BiEntry<K,V>{
    def unused = object { 
        def k  = self
        def v  = self
        method nextKToV { self } 
        method nextVToK { self }
        method asString { "unused" }
    }
    
    var nextKToVBucket is public:=unused
    var nextVToKBucket is public:=unused
    var k:=binds.key
    var v:=binds.value
    
    method ==(other){
        if((self.asString=="unused") && (other.asString=="unused"))then{
            return true
        }elseif((self.key==other.key) && (self.value==other.value) &&(self.nextKToV==other.nextKToV) &&(self.nextVToK==other.nextVToK))then{
            return true
        }
    }
    
    method !=(other){
        if(self==other)then{
            return false
        }else{
            return true
        }
    }
    
    method asString { return "biEntry {k}::{v}" }
    method key{ k }
    method value{ v }
    method nextKToV{ nextKToVBucket }
    method nextVToK{ nextVToKBucket }
  
}
import "biEntry" as biEntry


  
type BiDictionary<K,V>=Collection<V> & type{
    size -> Number
    containsKey(k:K) -> Boolean
    containsValue(v:V) -> Boolean
    at(key:K)put(value:V) -> Done
    seekByKey -> biEntry.BiEntry<K,V>
    seekByValue -> biEntry.BiEntry<V,K>
    reversed -> BiDictionary<V,K>
    keys -> Enumerable<K>
    values -> Enumerable<V>
}

factory method biDictionary<K,V>{
    inherits collectionFactory.trait<V>
    method at(k:K)put(v:V) {
            self.empty.at(k)put(v)
    }
    method withAll(initialBindings:Collection<Binding<K,V>>)size(expectedSize:Number) -> BiDictionary<K,V>{
        object {
            outer.fromBindings(initialBindings,expectedSize)
        }
    }
    
    method withAll(initialBindings:Collection<Binding<K,V>>) -> BiDictionary<K,V> {
        object {
            def defaultSize = 16
            outer.fromBindings(initialBindings,defaultSize)
        }
    }
    method fromBindings(bindings,eSize){
        object{
            inherits collection.trait<V>
            var hashTableKToV := _prelude.PrimitiveArray.new(eSize)
            var hashTableVToK := _prelude.PrimitiveArray.new(eSize)
            var numEntries := 0
            def unused = object { 
                def key is public = self
                def value is public = self
                method asString { "unused" }
            }
            for (0..(hashTableKToV.size-1)) do {i->
                hashTableKToV.at(i)put(unused)
                hashTableVToK.at(i)put(unused)
            }
            
            for (bindings) do { i -> at(i.key)put(i.value) }
            
            method size{ return numEntries }
            
            factory method biEntryIterator -> Iterator<biEntry.BiEntry<K,V>>{
                var count:=1
                var i:=0
                var entry:=hashTableKToV[i]
                method hasNext { size >= count }
                method next{
                    if (size < count) then {
                        Exhausted.raise "over {outer.asString}"
                    }
                    while{entry==unused}do{
                        i:=i+1
                        entry:=hashTableKToV[i]
                    }
                    def result=entry
                    entry:=entry.nextKToV
                    count:=count+1
                    return result
                }
            }
            
            method at(key:K)put(value:V){
                def oldEntryKey=seekByKey(key)
                if((oldEntryKey!=unused) && (oldEntryKey.value==value))then{
                    return value  
                }
                
                def oldEntryValue=seekByValue(value)
                if(oldEntryValue!=unused)then{
                  //  "value already present"
                    delete(oldEntryValue)
                }
                if(oldEntryKey!=unused)then{
                    delete(oldEntryKey)
                }
                def newEntry=biEntry.newEntry(key::value)
                insert(newEntry)
                
            }
            
            method insert(entry){
                def keyBucket = entry.key.hash % hashTableKToV.size
                entry.nextKToVBucket:=hashTableKToV[keyBucket]
                hashTableKToV[keyBucket]:=entry
                
                def valueBucket =entry.value.hash % hashTableVToK.size
                entry.nextVToKBucket:=hashTableVToK[valueBucket]
                hashTableVToK[valueBucket]:=entry
                
                numEntries:=numEntries+1
            }
            
            method delete(entry){
                def keyBucket=entry.key.hash % hashTableKToV.size
                var bucketEntry:=hashTableKToV[keyBucket]
                var prevEntry:=unused
                while{bucketEntry!=unused}do{
                    if(entry==bucketEntry)then{
                        if(prevEntry==unused)then{
                            hashTableKToV[keyBucket]:=entry.nextKToVBucket
                        }else{
                            prevEntry.nextKToVBucket:=entry.nextKToVBucket  
                        }
                    }
                    prevEntry:=bucketEntry
                    bucketEntry:=bucketEntry.nextKToVBucket
                }
                
                def valueBucket=entry.value.hash % hashTableVToK.size
                prevEntry:=unused
                bucketEntry:=hashTableVToK[valueBucket]
                while{bucketEntry!=unused}do{
                    if(entry==bucketEntry)then{
                        if(prevEntry==unused)then{
                            hashTableVToK[valueBucket]:=entry.nextVToKBucket  
                        }else{
                            prevEntry.nextVToKBucket:=entry.nextVToKBucket
                        }
                    }
                    prevEntry:=bucketEntry
                    bucketEntry:=bucketEntry.nextVToKBucket
                }
            }
            
            method seekByKey(key:K){
                def h=key.hash % hashTableKToV.size
                var entry:= hashTableKToV[h]
                while{entry!=unused}do{
                    if(entry.key==key)then{
                        return entry  
                    }
                    entry:=entry.nextKToVBucket     
                }
                return entry
            }
            
            method seekByValue(value:V){
                def h=value.hash % hashTableVToK.size
                var entry:= hashTableVToK.at(h)
                while{entry!=unused}do{
                    if(entry.value==value)then{
                        return entry  
                    }
                    entry:=entry.nextVToKBucket     
                }
                return entry
            }
            
            
        }
    }
      
    
}


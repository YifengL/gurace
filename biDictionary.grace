import "biEntry" as biEntry


  
type BiDictionary<K,V>=Collection<V> & type{
    size -> Number
    containsKey(k:K) -> Boolean
    containsValue(v:V) -> Boolean
    at(key:K)put(value:V) -> Done
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
        fromBindings(initialBindings,expectedSize)
    }
    
    method withAll(initialBindings:Collection<Binding<K,V>>) -> BiDictionary<K,V> {
        def defaultSize = 16
        fromBindings(initialBindings,defaultSize)
        
    }
    method fromBindings(initialBindings,eSize){
        object{
            inherits collection.trait<V>
            var hashTableKToV := _prelude.PrimitiveArray.new(eSize)
            var hashTableVToK := _prelude.PrimitiveArray.new(eSize)
            var numEntries := 0
            def unused = object { 
                def key is public = self
                def value is public = self
                method nextVToK { self }
                method nextKToV { self }
                method asString { "unused" }
            }
            for (0..(hashTableKToV.size-1)) do {i->
                hashTableKToV.at(i)put(unused)
                hashTableVToK.at(i)put(unused)
            }
            
            for (initialBindings) do { i -> at(i.key)put(i.value) }
            
            method isEmpty { numEntries==0 }
            method at(k) ifAbsent(action) {
                var entry:= seekByKey(k)
                if (entry.key == k) then {
                    return entry.value
                }
                return action.apply
            }
            
            method do(block1){ valuesDo(block1) }
            
            method keysDo(block1){
                var i:=0
                var entry:=hashTableKToV[i]
                while{i < hashTableKToV.size}do{
                    if(entry!=unused)then{
                        block1.apply(entry.key)
                        entry:=entry.nextKToV
                    }else{
                        i:=i+1
                        entry:=hashTableKToV[i]
                    }
                }
            }
            
            method valuesDo(block1){
                var i:=0
                var entry:=hashTableVToK[i]
                while{i < hashTableVToK.size}do{
                    if(entry!=unused)then{
                        block1.apply(entry.value)
                        entry:=entry.nextVToK
                    }
                }
            }
            method keysAndValuesDo(block2) {
                var i:=0
                var entry:=hashTableKToV[i]
                while{i < hashTableKToV.size}do{
                    if(entry!=unused)then{
                        block2.apply(entry.key,entry.value)
                        entry:=entry.nextKToV
                    }else{
                        i:=i+1
                        entry:=hashTableKToV[i]
                    }
                }
                
            }
            method asString{}
            
            method []:=(k, v) { 
                at(k)put(v) 
                done
            }
            
            method [](key) { at(key) }
            
            method removeKey(*keys) {
                removeAllKeys(keys)
            }
            
            method removeAllKeys(keys){
                for(keys)do{k->
                    def entry=seekByKey(k)
                    if(entry.key==k)then{
                        delete(entry)
                    } else {
                        NoSuchObject.raise "dictionary does not contain entry with key {k}"
                    }
                }
                return self
            }
            
            method removeValue(*values) {
                removeAllValues(values)
            }
            
            method removeAllValues(values) {
                for(values)do{v->
                    def entry=seekByValue(v)
                    if(entry.value==v)then{
                        delete(entry)
                    }else{
                        NoSuchObject.raise "dictionary does not contain entry with value {v}"
                    }
                }
            }
            
            method size{ return numEntries }
            
            method keys -> Enumerable<K> {
                object{
                    inherits enumerable.trait<K>
                    factory method iterator {
                        def sourceIterator = self.biEntryIterator
                        method hasNext { sourceIterator.hasNext }
                        method next { sourceIterator.next.key }
                        method asString { 
                            "an iterator over keys of {self}"
                        }
                    }
                }
            }
            
            method values -> Enumerable<V> {
                object{
                    inherits enumerable.trait<V>
                    factory method iterator {
                        def sourceIterator = outer.biEntryIterator
                        method hasNext { sourceIterator.hasNext }
                        method next { sourceIterator.next.value }
                        method asString { 
                            "an iterator over values of {self}"
                        }
                    }
                }
            }
            
            method bindings -> Enumerable<Binding<K,V>>{
                object{
                    inherits enumerable.trait<V>
                    factory method iterator{
                        def sourceIterator =outer.biEntryIterator
                        method hasNext{ sourceIterator.hasNext }
                        method next{ sourceIterator.next.key::sourceIterator.next.value}
                        method asString{ "an iterator over bindings of {self}"}
                    }
                }
            }
            
            method containsKey(k) { return false}
            
            method containsValue(v) { return false}
            
            method ++(other) {}
            
            method ==(other){
                match(other)
                    case{o:BiDictionary->
                        if(self.size!= o.size) then{ return false }
                        self.keysAndValuesDo{k,v ->
                            if(o.at(k)ifAbsent{return false} != v)then{
                                return false
                            }
                           
                        }
                        return true
                    }
                    case {_ ->
                        return false
                    } 
            }
           
            method reversed{
                def reversedBindings= set.empty
                keysAndValuesDo{k,v ->
                    reversedBindings.add(v::k)     
                }
                outer.fromBindings(reversedBindings,eSize)
                
            }
            method iterator -> Iterator<V> { biEntryIterator }
            
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
            
            method at(key) { 
                def entry= seekByKey(key)
                if (entry.key == key) then {
                    return key.value
                }
                NoSuchObject.raise "dictionary does not contain entry with key {key}"
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
            
            method insert(entry) is confidential{
                def keyBucket = entry.key.hash % hashTableKToV.size
                entry.nextKToVBucket:=hashTableKToV[keyBucket]
                hashTableKToV[keyBucket]:=entry
                
                def valueBucket =entry.value.hash % hashTableVToK.size
                entry.nextVToKBucket:=hashTableVToK[valueBucket]
                hashTableVToK[valueBucket]:=entry
                
                numEntries:=numEntries+1
            }
            
            method delete(entry) is confidential{
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
            
            method seekByKey(key:K) is confidential{
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
            
            method seekByValue(value:V) is confidential{
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


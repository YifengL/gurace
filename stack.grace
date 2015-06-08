factory method newStack(defaultSize){
    var capacity:=defaultSize
    var arr := _prelude.PrimitiveArray.new(capacity)   
    var top := -1
    
    method size{ top+1 }
    method push(elem){
        if (top >= (capacity - 1)) then { expand }
        top:=top+1
        arr[top]:=elem
    }
    
    method pop(){
        if(top >= 0)then{
            top:=top-1
            return arr[top+1]
        }else{"stack underflow"}
        
    }
    
    method expand is confidential{
        def n=capacity*2
        def old = arr
        arr :=_prelude.PrimitiveArray.new(n)
        capacity:=n
        for(0..(old.size-1))do{i->
            arr[i]:= old[i]
        }
    }
}

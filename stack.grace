factory method newStack(defaultSize){
    var capacity:=defaultSize
    var arr := _prelude.PrimitiveArray.new(capacity)   
    var top := -1
    
    method size{ top+1 }
    method push(elem){
        if(top < (capacity-1))then{
            top:=top+1
            arr[top]:=elem
            if()
        }else{"stack overflow"}
    }
    
    method pop(){
        if(top >= 0)then{
            top:=top-1
            return arr[top+1]
        }else{"stack underflow"}
        
    }
}
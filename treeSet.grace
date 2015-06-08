import "AVLTree" as avl
import "stack" as stack
type TreeSet<T>=Set<T> & type{
}

factory method treeSet<T>{
    inherits collectionFactory.trait<T>
    method withAll(a:Collection<T>) -> TreeSet<T> {
        object {
            inherits collection.trait<T>
            def tree=avl.avlTree
            var numElements := 0
            
            for (a) do { x-> add(x) }
            
            method size { numElements }
            
            method add(*elements) { addAll(elements) }
            method preOrder{tree.preOrder(tree.root)}
            method addAll(elements) {
                for(elements)do{x->
                    if(tree.add(x))then{
                        numElements:=numElements+1
                    }
                }
            }
            
            method contains(elem){ tree.contains(tree.root,elem)}
            
            method remove(*elements) { removeAll(elements) }
            
            method removeAll(elements) {
                for (elements) do { x ->
                    tree.remove(x)
                    numElements:=numElements-1
                }
            }
            
            method find(booleanBlock)ifNone(notFoundBlock) {
                self.do { each ->
                    if (booleanBlock.apply(each)) then { return each }
                }
                return notFoundBlock.apply
            }
            method removeAll(elements)ifAbsent(block) {
                for (elements) do { x ->
                    def isExist=tree.remove(x)
                    if (isExist)then {
                        numElements := numElements - 1
                    } else { 
                        block.apply
                    }
                }
            
            }
            
            method includes(booleanBlock) {
                self.do { each ->
                    if (booleanBlock.apply(each)) then { return true }
                }
                return false
            }
            
            method do(block1) {
                preOrderDo(tree.root,block1)
            }
            
            method preOrderDo(node,block){
                if(node!=avl.unused)then{
                    block.apply(node.elem)
                    preOrderDo(node.left)
                    preOrderDo(node.right)
                }
            }
            
          
            method iterator{
                object{
                    var count:=1
                    var node:=tree.root
                    var s:=stack.newStack(2)
                    while{node!=avl.unused}do{
                        s.push(node)
                        print "push {node.elem}"
                        node:=node.left
                    }
                    method hasNext{size >= count}
                    method next{
                        if(!hasNext)then{Exhausted.raise "iterator over {outer.asString}"}
                        def nextNode=s.pop
                        
                        var temp:=nextNode
                        if(temp.right!= avl.unused)then{
                            temp:=temp.right
                            while{temp!=avl.unused}do{
                                s.push(temp)
                                temp:=temp.left
                            }
                        }
                        count:=count+1
                        return nextNode
                    }
                }
            }
            method copy {
                outer.withAll(self)
            }
            
            method ++ (other) {
                copy.addAll(other)
            }
            method ** (other) {
                treeSet.withAll( self.filter {each -> other.contains(each)} )
            }
            
            
            method -- (other) {
                def result = treeSet.empty
                for (self) do {v->
                    if (!other.contains(v)) then {
                        result.add(v)
                    }
                }
                result
            }
            
            method onto(f: CollectionFactory<T>) -> Collection<T> {
                f.withAll(self)
            }
            method into(existing: Collection<T>) -> Collection<T> {
                do { each -> existing.add(each) }
                existing
            }
        }
    }
}

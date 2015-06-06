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
            
            method remove(*elements) { removeAll(elements) }
            
            method removeAll(elements) {
                for (elements) do { x ->
                    tree.remove(x)
                    numElements:=numElements-1
                }
            }
            
            method iterator{
                object{
                    var count:=1
                    var node:=tree.root
                    var s:=stack.newStack(16)
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
        }
    }
}

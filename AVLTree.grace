def unused=object{
    def height is public=0
    method asString{"unused node"}
}
    

factory method avlTree{
    var root is public:=unused
    var isExist:=false
    method newNode(e){
       object{
           var elem is public:=e
           var height is public:=1 
           var left is public:=unused
           var right is public:=unused
           var parent is public:=unused
           
           method asString{ print "Node Key:{elem} "}
        }
    }
    
    method preOrder(node){
            print "{node.elem}"
            if(node.left!=unused)then{preOrder(node.left)}
            if(node.right!=unused)then{preOrder(node.right)}
    }
    method updateNode(node,newN){
        if(node==node.parent.left)then{
            node.parent.left:=newN
        }else{
            node.parent.right:=newN
        }
        if(newN!=unused)then{ newN.parent:=node.parent }
        return newN
    }
    method add(elem){
        isExist:=false
        insert(root,elem)
        if(isExist)then{ 
            return false
        }else{
            return true
        }
    }
    
    method remove(elem){
      
        delete(self.root,elem)
        print "root {root.elem}"
        
    }
    method delete(node,elem){
        if(node==unused)then{
            return
        }else{
            if(node.elem > elem)then{
                delete(node.left,elem)
            }elseif(node.elem < elem)then{
                delete(node.right,elem)
            }else{
                removeFoundNode(node)
            }
        }
      
    }
    method removeFoundNode(node){
        var r
        if((node.left==unused) || (node.right==unused))then{
            if(node.parent==unused)then{
                self.root:=unused
            }
            r:=node
        }else{
            r:=successor(node)
            node.elem:=r.elem
        }
        var p
        if(r.left!=unused)then{
            p:=r.left
        }else{
            p:=r.right
        }
        if(p!=unused)then{
            p.parent:=r.parent
        }
        if(r.parent==unused)then{
            self.root:=p
        }else{
            if(r==r.parent.left)then{
                r.parent.left:=p
            }else{
                r.parent.right:=p
            }
            recursiveBalance(r.parent)
        }
    }
    
    method balanceFactor(node){
        if(node==unused)then{
            return 0
        }
        return node.right.height-node.left.height
    }
    method max(a,b){ 
        if(a > b)then{
          return a
        }else{ return b}
    }
    
    method successor(node){
        if(node.right!=unused)then{
            var r:=node.right
            while{r.left!=unused}do{
                r:=r.left
            }
            return r
        }else{
            var q:=node
            var p:=node.parent
            while{(p!=unused) && (q==p.right)}do{
                q:=p
                p:=q.parent
            }
            return p
        }
        
    }
   
    method recursiveBalance(node){
        var cur:=node
        var balance:=balanceFactor(cur)
        if(balance < -1)then{
            if(balanceFactor(node.left) <= 0)then{
                cur:=rightRotate(cur)
            }else{
                cur.left:=leftRotate(cur.left)
                cur:=rightRotate(cur)
            }
        }elseif(balance > 1)then{
            if(balanceFactor(node.right) >=0 )then{
                cur:=leftRotate(cur)
            }else{
                cur.right:=rightRotate(cur.right)
                cur:=leftRotate(cur)
            }
            
        }
        
        if(cur.parent!=unused)then{
            recursiveBalance(cur.parent)
        }else{
            self.root:=cur
        }
        
    }
    method insert(node,elem){
        if(node==unused)then{ 
            self.root:=newNode(elem) 
        }else{
            if(elem < node.elem)then{
                if(node.left==unused)then{
                    var temp:=newNode(elem)
                    node.left:=temp
                    temp.parent:=node
                    recursiveBalance(node)
                }else{
                    insert(node.left,elem)
                }
            }
            elseif(elem > node.elem)then{
                if(node.right==unused)then{
                    var temp:=newNode(elem)
                    node.right:=temp
                    temp.parent:=node
                    recursiveBalance(node)
                }else{
                    insert(node.right,elem)
                }
            }else{
                isExist:=true
            }
        }
        
      
       
        return node
    }
   
    method rightRotate(y){
        var x:=y.left
        var t2:=x.right
        x.parent:=y.parent
        x.right:=y
        if(y!=unused)then{
            y.parent:=x
        }
       
        y.left:=t2
        if(t2!=unused)then{
            t2.parent:=y
        }
        
        
        
        y.height:=max(y.left.height, y.right.height)+1
        x.height:=max(x.left.height, x.right.height)+1
        
        return x
    }
    
    method leftRotate(x){
        var y:=x.right
        y.parent:=x.parent
        var t2:=y.left
        
        y.left:=x
        if(x!=unused)then{
            x.parent:=y
        }
       
        x.right:=t2
        if(t2!=unused)then{
            t2.parent:=x
        }
      
        
        
        x.height:=max(x.left.height,x.right.height)+1
        y.height:=max(y.left.height,y.right.height)+1
        
        return y
    }
    
   
    
    
    
    
}
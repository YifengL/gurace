import "stack" as stack 

def P = 1000000007
def PP = ((P*P)+1)

def noNode = object {
  inherits Singleton.new
  method asString { "Null node" }
}


factory method treeNode<T> {
  method newNode(t:T) {
    object {
      var value is public := t
      var left is public := noNode
      var right is public := noNode
    }
  }
}

method mean(a, b) {
  var s := (a + b)
  if ((s%2) > 0) then { s := (s + 1)}
  (s / 2)
}

factory method simpleBST<T> {
  method withAll(existing:Collection<T>) {
    object {
      var elements := list.withAll(existing).sort
      
      var _size := 1
      var ix := 2
      while {ix <= elements.size} do {
        if (elements[ix] != elements[ix-1]) then { 
          _size := _size + 1
          elements[_size] := elements[ix]
        }
        ix := ix + 1
      }
      
      if (elements.size == 0) then { _size := 0 }
      
      var hashCode := 0
      
      for (1.._size) do { i ->
        hashCode := (((hashCode * P) + elements[i].hash) % PP)
      }
      
      method hash { hashCode }
      
      var root is readable := buildTree(elements, 1, _size)

      method size { _size }

      method buildTree(_elems, i, j) is confidential {
        if (i > j) then { return noNode }
        var mid := mean(i, j)
        var currNode := treeNode.newNode(_elems[mid])
        currNode.left := buildTree(_elems, i, mid-1)
        currNode.right := buildTree(_elems, mid+1, j)
        return currNode
      }
      
    }
  }
}


factory method immutableSet<T> {
  method with(*existings:Collection<T>) {
    var existing := list.empty
    for (existings) do { e->
      existing.addAll(e)
    }
    withAll(existing)
  }
  method withAll(existing:Collection<T>) {
    object {
      inherits collection.trait<T>
      
      var bst := simpleBST.withAll(existing)

      method size { bst.size }

      method contains(elem:T) {
        var curr := bst.root
        while { curr != noNode } do {
          if (curr.value == elem) then {
            return true
          } elseif ( elem < curr.value ) then {
            curr := curr.left
          } else { curr := curr.right }
        }
        return false
      }

      method includes(boolBlock) {
        self.do { each ->
          if (boolBlock.apply(each)) then { return true }
        }
        return false
      }

      method find(boolBlock)ifNone(notFoundBlock) {
        self.do { each ->
          if (boolBlock.apply(each)) then { return each }
        }
        notFoundBlock.apply
      }

      method asString {
        "set\{" ++ stringify(bst.root) ++ "\}"
      }
      
      method stringify(node) is confidential {
        if (node == noNode) then { return "" }
        var ls := stringify(node.left)
        var rs := stringify(node.right)
        var s := node.value.asString
        if (ls != "") then { s := ls ++ ", " ++ s}
        if (rs != "") then { s := s ++ ", " ++ rs}
        s
      }

      method hash {
        bst.hash
      }
      
      method copy {
        outer.withAll(self)
      }
      
      method ++(other) {
        outer.with(self, other)
      }
      
      method --(other) {
        var _l := list.empty
        self.do { each ->
          if (!other.contains(each)) then {
            _l.add(each)
          }
        }
        outer.withAll(_l)
      }
      
      method **(other) {
        var _l := list.empty
        self.do { each ->
          if (other.contains(each)) then {
            _l.add(each)
          }
        }
        outer.withAll(_l)
      }
      
      method onto(f:CollectionFactory<T>) -> Collection<T> {
        f.withAll(self)
      }
      
      method into(e:Collection<T>) -> Collection<T> {
        self.do { each -> e.add(each) } 
        existing
      }

      method asList {
        var _l := list.empty
        self.do { each ->
          _l.add(each)
        }
        _l
      }

      method isEmpty { self.size == 0 }

      method do(block1) {
        self.process(bst.root, block1)
      }

      method process(node, block1) is confidential {
        if (node == noNode) then { return }
        self.process(node.left, block1)
        block1.apply(node.value)
        self.process(node.right, block1)
      }
      
      
      method iterator {
        object {
          var S := stack.newStack(1)
          var p := bst.root
          var init := true
          
          method hasNext {
            if (init) then {
              while {p != noNode} do {
                S.push(p)
                p := p.left
              }
              init := false
            }
            return (S.size > 0)
          }
          method next {
            var n := S.pop
            p := n.right
            while {p != noNode} do {
              S.push(p)
              p := p.left
            }
            n.value
          } 
        }
      }
      
    }
  }
}

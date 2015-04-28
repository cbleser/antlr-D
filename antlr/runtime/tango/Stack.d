module antlr.runtime.tango.Stack;
/**
This object emulates the Stack class in java

*/

import tango.util.container.LinkedList;

class Stack(V) : LinkedList!(V) {

   this() {
     super();
   }

  bool empty(){
   return isEmpty;
  }

  V peek() {
	return head();
  }

  V pop () {
	return removeHead();
  }   

  Stack push(V value) {
    add(value);
	return this;
  }

  V elementAt(size_t index) {
	return get(index);
  }
/++
  unit search(V value) {
	return search(V);
  }
++/

  unittest {
    auto stack=new Stack!(int);

    assert(stack.empty);
    stack.push(7);
    stack.push(-7);
    stack.push(77);
    stack.push(-77);
    stack.push(-777);
    stack.push(10);
    stack.push(12);
    assert(stack.search(-777)==5);
    auto x=stack.pop;
    assert(x==12);
    assert(stack.peek==10);
    assert(stack.pop==10);
    assert(stack.pop==-777);
    assert(stack.pop==-77);
    assert(!stack.empty);
    assert(stack.pop==77);
    assert(stack.pop==-7);
    assert(stack.pop==7);
    assert(stack.empty);
	assert(0);

  }

}
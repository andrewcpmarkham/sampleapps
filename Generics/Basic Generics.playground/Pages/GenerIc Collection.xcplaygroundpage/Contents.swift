import UIKit

//Generic use of a collection of Items of udefined types
struct Stack<T>{
    private var items = [T]()
    
    mutating func put(item: T){
        items.insert(item, at: 0)
    }
    
    mutating func pop() -> T? {
        return items.count > 0 ? items.removeFirst() : nil
    }
    
    func peek() -> T? {
        return items.first
    }
}

//Using Strings
var st = Stack<String>()
st.put(item: "Hello")
st.put(item: "World")
st.put(item: "!")
print(st.peek())

var item = st.pop()
while item != nil{
    print(item ?? "")
    item = st.pop()
}
//Now Ints
var st2 = Stack<Int>()
st2.put(item: 1)
st2.put(item: 2)
st2.put(item: 3)
print(st2.peek())

var item2 = st2.pop()
while item2 != nil{
    print(item2 ?? 0)
    item2 = st2.pop()
}

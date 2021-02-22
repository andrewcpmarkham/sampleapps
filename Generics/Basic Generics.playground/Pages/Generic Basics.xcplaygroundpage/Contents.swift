import UIKit

// Create a function that uses Generics with Numberic constraint
// so that any types parameter can be used as long as it
// complies to the numeric protocol

//SOURCE: https://youtu.be/w4qgPheFyYU

func genericAdd<T: Numeric>(a: T, b: T) -> T{
    return a + b
}

let c = genericAdd(a: 1, b: 2)
let d = genericAdd(a: 3.2422, b: 8.102)


// Comparison Function using a generic in find an item
// in a collection
func linearSearch<T: Equatable>(array: [T], key: T) -> Int? {
    for i in 0..<array.count{
        if array[i] == key{
            return i
        }
    }
    return nil
}

let cars = ["Honda", "Toyota", "Ford", "Tesla"]
if let car = linearSearch(array: cars, key: "Ford"){
    print(car)
}

let items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
if let itemIdx = linearSearch(array: items, key: 10){
    print(itemIdx)
}

//How to use a protocol as a custom contraint
protocol Addable {
    static func +(lhs: Self, rhs: Self) -> Self
}

extension Int: Addable {}
extension Double: Addable {}

func customAdd<T: Addable>(a: T, b: T) -> T {
    return a + b
}

let addInt = customAdd(a: 4, b: 5)
print(addInt)

let addDouble = customAdd(a: 3.14, b: 1.24)
print(addDouble)

//Using associated Types to create generic storage that defines the type being stored
protocol Storage {
    associatedtype Item
    func store(item: Item)
    func retrieve(index: Int) -> Item
}

class Box<Item>: Storage{
    
    var items = [Item]()
    
    func store(item: Item) {
        items.append(item)
    }

    func retrieve(index: Int) -> Item {
        return items[index]
    }
}

struct Book{
    var title = ""
    var author = ""
}

struct VideoGame{
    var title = ""
    var publisher = ""
}

let booksBox = Box<Book>()
booksBox.store(item: Book(title: "Swift Development", author: "Dev Techie"))
booksBox.store(item: Book(title: "IOS Development", author: "Dev Techie"))

print(booksBox.retrieve(index: 0))

//Reuse the Generic collection for another type
let gameBox = Box<VideoGame>()
gameBox.store(item: VideoGame(title: "Swift Ninja", publisher: "Dev Techie"))
gameBox.store(item: VideoGame(title: "IOS Ninja", publisher: "Dev Techie"))

print(gameBox.retrieve(index: 1))

//You can even then subclass the box
class GiftBox<Item>: Box<Item> {
    func wrap() {
        print("Gift wrap the box")
    }
}

struct Toy {
    var name: String
}

let toyBox = GiftBox<Toy>()
toyBox.store(item: Toy(name: "Sheriff Woody"))
toyBox.store(item: Toy(name: "Buzz Lightyear"))
toyBox.wrap()


//Using Generics in Enums for when you want to implement another type like an address object instead of String or Double
enum Location {
    //The options are either be a string or coordinate type
    case address(String)
    case coordinate(Double, Double)
}

let loc1 = Location.address("17 Boyd Ave")
let loc2 = Location.coordinate(40.23211, -122.23244)


enum GenLocation<T> {
    case address(T)
    case coodinate(T)
}

struct Address {
    var streetNumber: Int
    var streetName: String
    var city: String
    var zipCode: Int
}

struct Coordinate {
    let lat: Double
    let long: Double
}

let loc3 = GenLocation.address(Address(streetNumber: 123, streetName: "Main Street", city: "New York", zipCode: 2123))
let loc4 = GenLocation.coodinate(Coordinate(lat: 40.23211, long: -122.23244))

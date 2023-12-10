// Packages require at least one swift file to prevent errors
// This file is there for it
// Feel free to add any code you wanna share accross multiple days


extension String : Error {}
public typealias Position = SIMD2<Int>

public extension Position {
    var description: String { "(\(x), \(y))" }
}

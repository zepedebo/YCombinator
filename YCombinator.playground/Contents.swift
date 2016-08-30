//: Playground - noun: a place where people can play

import Cocoa

// Normal function
func fact (_ n: Int) -> Int {
    return (n == 0) ? 1 : n * fact(n-1)
}

fact(5)


// The problem

// From a lamda
// let lfact = {(n: Int) -> Int in
//    return (n == 0) ? 1 : n * lfact(n-1)
//}

//lfact(5);

// Terser lambda
//let lfact2 = {
//    ($0 == 0) ? 1 : $0 * lfact2($0-1)
// }

// lfact2(5)

// _ = { ($0 == 0) ? 1 : $0 * fact($0-1) }

// * Traditional function declaration
// func add1(_ n: Int) -> Int {
//    return n + 1;
// }

// * Lambda version
//let add1 = {(n: Int) -> Int in
//    return n + 1
//}

// * Lambda version with some type inference
// let add1 = {n in
//    return n + 1
// }

// * Terse lambda version
//let add1 = {$0 + 1}
//add1(10)

let mul3 = {$0 * 3}

//mul3(add1(10))

// Higher Order Funcitons

func makeAddr(_ x: Int) -> (Int) -> Int {
    return {$0 + x}
}

// Immediate call of a lambda works in Swift
_ = { $0+1}(5)


let high_order = {(n) -> (Int) ->Int in
    return {(q) -> Int in
        return q + n
    }
}

//let add1 = high_order(1)
let add1 = makeAddr(1)

add1(7)
mul3(3)
let q = mul3(add1(10))

// Composition

func compose(f: @escaping (Int) -> Int, g:@escaping (Int) -> Int) -> (_ n: Int) -> Int {
    return { n in return f(g(n))}
}


//let  compose = {(f: @escaping (Int) -> Int, g: @escaping (Int) -> Int) in
//    return { n in return f(g(n))}
//}

//func compose<T>(f: @escaping (T) -> T, g:@escaping (T) -> T) -> (_ n: T) -> T {
//    return { n in return f(g(n))}
//}



let mul3add1 = compose(f: mul3, g: add1)
let x = mul3add1(10);

// Refactorings
// (1) Tennent Correspondence Principle
// Immediate call of a lambda works in Swift
_ = { $0+1}(5)
_ = {5}()


// let mul3 = {n in n* 3}
// does the same thing as
//let mul3 = {n in {n * 3}()}

let  composet = {(f: @escaping (Int) -> Int, g: @escaping (Int) -> Int) in
    return { n in {() in return f(g(n))}()}
}

let m3a1 = composet(mul3, add1)
m3a1(10)


// (2) Introduce a binding
let ibmul3 = {n in return n * 3}
let mult3 = {n in {z in n * 3}(1234)}



mult3(10)

// (3) Wrap Function
let  makeAddrwf = {(x:Int) in
    {(v: Int) in return {$0 + x}}(x)
}

let add5 = makeAddrwf(5)
add5(6)

// (4) Inline Definition

let add5id = {(x:Int) in
    {(v: Int) in return {$0 + x}}(x)
}(5)

add5id(7)

// Recursion

enum FactorialError: Error {
    case NeverGoHere
}

func error(_ n: Int) throws -> Int { throw FactorialError.NeverGoHere; return 0 }

func fact_improver(partial:  @escaping (Int) throws -> (Int)) -> (Int) throws -> Int  {
    func t(n: Int) throws -> Int {
        return try (n == 0) ? 1 : n * partial(n-1)
    }
    return t;
}

//func fact_improver(partial: throws @escaping  (Int) -> Int) -> (Int) -> Int  {
//    return {(n: Int) -> Int in
//        return  (n == 0) ? 1 : n * partial(n-1)
//    }
//}


let f0 = fact_improver(partial: error)
let f1 = fact_improver(partial: f0)
let f2 = fact_improver(partial: f1)
let n0 = try? f0(0)
let n1 = try? f1(1)
let n2 = try? f2(2)
let n3 = try? f2(0)

protocol addable {
    static func + (lhs: Self, rhs: Self) -> Self;
}

extension String: addable {}
extension Int: addable {}

func f<T: addable>(_ v: T) -> T {return v+v}

f("Hi")
f(2)

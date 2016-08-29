//: Playground - noun: a place where people can play

import Cocoa

func fact (_ n: Int) -> Int {
    return (n == 0) ? 1 : n * fact(n-1)
}

fact(5)

let fact2 = {(n: Int) -> Int in
    return (n == 0) ? 1 : n * fact(n-1)
}

fact2(5);

let a = { $0+1}(5)


let high_order = {(n) -> (Int) ->Int in
    return {(q) -> Int in
        return q + n
    }
}

let add1 = high_order(1)

add1(7)
let mul3 = {n in return {$0 * 3}(n)}
mul3(3)
let q = mul3(add1(10))

func compose(f: @escaping (Int) -> Int, g:@escaping (Int) -> Int) -> (_ n: Int) -> Int {
    return { n in return f(g(n))}
}


let  compose1 = {(f: @escaping (Int) -> Int, g: @escaping (Int) -> Int) in
    return { n in return f(g(n))}
}

func composet<T>(f: @escaping (T) -> T, g:@escaping (T) -> T) -> (_ n: T) -> T {
    return { n in return f(g(n))}
}



let mul3add1 = composet(f: mul3, g: add1)
let x = mul3add1(10);

_ = {5}()

protocol addable {
    static func + (lhs: Self, rhs: Self) -> Self;
}

extension String: addable {}
extension Int: addable {}

func f<T: addable>(_ v: T) -> T {return v+v}

f("Hi")
f(2)
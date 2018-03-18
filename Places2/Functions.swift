//
//  Functions.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(
    _ a: A,
    _ f: (A) -> B)
    -> B {
        return f(a)
}

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >=>: EffectfulComposition

func >=> <A, B, C, D>(
    _ f: @escaping (A) -> (B, [D]),
    _ g: @escaping (B) -> (C, [D]))
    -> (A) -> (C, [D]) {
        return { x in
            let (y, d1) = f(x)
            let (z, d2) = g(y)
            return (z, d1 + d2)
        }
}

func >=> <A, B, C>(
    _ f: @escaping (A) -> B?,
    _ g: @escaping (B) -> C?)
    -> (A) -> C? {
        return { x in
            guard let y = f(x) else { return nil }
            return g(y)
        }
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: EffectfulComposition
}

infix operator >>>: ForwardComposition

func >>><A, B, C>(
    _ f: @escaping (A) -> B,
    _ g: @escaping (B) -> C)
    -> (A) -> C {
        return { x in
            g(f(x))
        }
}

precedencegroup BackwardComposition {
    associativity: right
}

infix operator <<<: BackwardComposition

func <<< <A, B, C>(
    _ g: @escaping (B) -> C,
    _ f: @escaping (A) -> B)
    -> (A) -> C {
        return { x in
            g(f(x))
        }
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

func <><A>(
    f: @escaping (A) -> A,
    g: @escaping (A) -> A)
    -> (A) -> A {
        return f >>> g
}

func <> <A>(
    f: @escaping (inout A) -> Void,
    g: @escaping (inout A) -> Void)
    -> ((inout A) -> Void) {
        
        return { a in
            f(&a)
            g(&a)
        }
}

func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
    return { $0.map(f) }
}

func map<A, B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
    return { $0.map(f) }
}

func filter<A>(_ f: @escaping (A) -> Bool) -> ([A]) -> [A] {
    return { $0.filter(f) }
}

func reduce<A, B>(_ start: B, _ f: @escaping (B, A) -> B) -> ([A]) -> B {
    return { $0.reduce(start, f) }
}

func prop<A, B>(_ keyPath: WritableKeyPath<A, B>)
    -> (@escaping (B) -> B)
    -> (A)
    -> A {
        return { f in
            return { obj in
                var obj = obj
                obj[keyPath: keyPath] = f(obj[keyPath: keyPath])
                return obj
            }
        }
}



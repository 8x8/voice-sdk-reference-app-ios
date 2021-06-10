//
//  Foundation+Observable.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import Foundation

class WeakObjectCollection<Element: AnyObject> {
    
    private let collection: NSHashTable<Element> = .weakObjects()

    // MARK: -
    
    func add(_ object: Element) {
        collection.add(object)
    }
    
    func remove(_ object: Element) {
        collection.remove(object)
    }
    
    func contains(_ object: Element) -> Bool {
        return collection.contains(object)
    }
    
    func allObjects() -> [Element] {
        return collection.allObjects
    }
    
    func removeAllObjects() {
        return collection.removeAllObjects()
    }

}

// MARK: -

protocol Observable: AnyObject {
    var observers: WeakObjectCollection<AnyObject> { get }
    
    func addObserver(_ observer: AnyObject)
    func removeObserver(_ observer: AnyObject)
    
    func notifyObservers<T: Any>(context: (_ observer: T) -> Void)
}

// MARK: -

extension Observable {
    
    private func hasObserver(_ observer: AnyObject) -> Bool {
        return observers.contains(observer)
    }
    
    func addObserver(_ observer: AnyObject) {
        if hasObserver(observer) {
            return
        }
        observers.add(observer)
    }
    
    func removeObserver(_ observer: AnyObject) {
        if !hasObserver(observer) {
            return
        }
        observers.remove(observer)
    }
    
    func notifyObservers<T: Any>(context: (_ observer: T) -> Void) {
        for object in observers.allObjects() {
            if let observer = object as? T {
                context(observer)
            }
        }
    }
    
}

//
//  Array+Tools.swift
//  OdetteNew
//
//  Created by Eugene Braginets on 28/6/16.
//  Copyright © 2016 xs2. All rights reserved.
//


extension Array {
    func containsObject<T>(_ obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}


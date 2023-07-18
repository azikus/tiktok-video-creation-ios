//
//  Optional+.swift
//  Ohmics
//
//  Created by Krešimir Baković on 10/04/2021.
//  Copyright © 2021 Kreso Bakovic. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        if let unwrapped = self {
            return unwrapped.isBlank
        } else {
            return true
        }
    }
}

extension Optional where Wrapped == Bool {
    var isNilOrFalse: Bool {
        return !(self ?? false)
    }
}

extension Optional where Wrapped == [String: String] {
    var isEmptyOrNil: Bool {
        if let dictionary = self {
            return dictionary.isEmpty
        } else {
            return true
        }
    }
}

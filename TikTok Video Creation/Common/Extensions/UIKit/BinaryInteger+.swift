//
//  BinaryInteger+.swift
//  Fansomnia
//
//  Created by Krešimir Baković on 04/01/2021.
//

import Foundation

extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}

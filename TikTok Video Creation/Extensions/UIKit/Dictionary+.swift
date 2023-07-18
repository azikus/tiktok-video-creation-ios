//
//  Dictionary+.swift
//  Signalized
//
//  Created by Krešimir Baković on 26.09.2021..
//  Copyright © 2021 Kreso Bakovic. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    func toQuery() -> String? {
        if isEmpty {
            return nil
        } else {
            return enumerated()
                .compactMap { (index, element) -> String? in
                    if index == 0 {
                        return "?\(element.key)==\(element.value)"
                    } else {
                        return "&\(element.key)==\(element.value)"
                    }
                }
                .reduce("") { $0 + $1 }
        }
    }
}

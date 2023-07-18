//
//  Double+.swift
//  Fansomnia
//
//  Created by Azzaro Mujic on 28/08/2020.
//  Copyright © 2020 Speck. All rights reserved.
//

import Foundation

extension Double {
    static var oneDayInSeconds: TimeInterval {
        return 24 * 60 * 60
    }
    
    func toString() -> String {
        return String(self)
    }
    
    func toInt() -> Int? {
        if self >= Double(Int.min), self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

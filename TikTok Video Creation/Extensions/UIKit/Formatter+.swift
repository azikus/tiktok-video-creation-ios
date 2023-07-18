//
//  Formatter+.swift
//  Ohmics
//
//  Created by Krešimir Baković on 09.05.2021..
//  Copyright © 2021 Kreso Bakovic. All rights reserved.
//

import Foundation

extension Formatter {
    static let withDotSeparatorAndOneDecimalPlace: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        return formatter
    }()
}

public extension Numeric {
    var formattedWithDotSeparator: String { Formatter.withDotSeparatorAndOneDecimalPlace.string(for: self) ?? "" }
}

public extension Numeric {
    var signalStrengthMessage: String {
        guard let signalValue = self as? Int else { return "" }
        switch signalValue {
        case 0...9:
            return "Bad".localized()
        case 10...14:
            return "Ok".localized()
        case 15...19:
            return "Good".localized()
        case 20...:
            return "Excellent".localized()
        default:
            return ""
        }
    }
}

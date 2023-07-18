//
//  TimeInterval+.swift
//  Fansomnia
//
//  Created by Krešimir Baković on 18/01/2021.
//

import Foundation

extension TimeInterval {
    static func yearsInSeconds(years: Int) -> TimeInterval {
        return TimeInterval(years * 365 * 24 * 3600)
    }
}

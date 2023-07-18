//
//  Date+.swift
//  Fansomnia
//
//  Created by Azzaro Mujic on 01/09/2020.
//  Copyright © 2020 Speck. All rights reserved.
//

import UIKit

extension Date {
    func toDefaultString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: self)
    }
    
    /// dateFormat: eg. "d MMM yyyy"
    func toStringWithoutTimeComponent(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
    
    /// 18:54
    func toStringWithoutDateComponent() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
}

extension Date {
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var withStartTime: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension Date {
    func dateAfter(numberOfDays: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)!
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

extension Date {
    func getDayText() -> String {
        let dayNumber = Calendar.current.component(.weekday, from: self)
        if dayNumber == 1 {
            return "SUN"
        } else if dayNumber == 2 {
            return "MON"
        } else if dayNumber == 3 {
            return "TUE"
        } else if dayNumber == 4 {
            return "WED"
        } else if dayNumber == 5 {
            return "THU"
        } else if dayNumber == 6 {
            return "FRI"
        } else {
            return "SAT"
        }
    }
    
    func getDateNumber() -> Int {
        return Calendar.current.component(.day, from: self)
    }
}

//
//  Date.swift
//  EZER
//
//  Created by TimerackMac1 on 21/12/17.
//  Copyright © 2017 TimerackMac1. All rights reserved.
//

import Foundation
extension Date {
    var startOfWeek: (startDate :Date?, endDate:Date?) {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return (nil,nil)}
        //print(sunday,"sunday")
        return (gregorian.date(byAdding: .day, value: 1, to: sunday) ,gregorian.date(byAdding: .day, value: 7, to: sunday))
    }
    
    /*var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }*/

        
        func offsetFrom(date: Date) -> Int {
            
            let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
            
            
            let hours = difference.hour!
            
            
            //        if let day = difference.day, day          > 0 { return days }
            if let hour = difference.hour, hour       > 0 { return hours }
            //        if let minute = difference.minute, minute > 0 { return minutes }
            //        if let second = difference.second, second > 0 { return seconds }
            
            return 0
        }
        
    
}


//
//  DateExtensions.swift
//  DateNumberFormat
//
//  Created by Jose Ines Cantu Arrambide on 8/17/16.
//  Copyright © 2016 Jose Ines Cantu Arrambide. All rights reserved.
//

import Foundation

extension String {
    func psoStringByPaddingLeft(toLength length: Int, withString string: String) -> String {
        let padLength = length - self.characters.count
        guard padLength > -1 else {
            return self.stringByPaddingToLength(length, withString: string, startingAtIndex: 0)
        }
        
        
        return "".stringByPaddingToLength(padLength, withString: string, startingAtIndex: 0) + self
    }
    
}


public extension NSDate{
    func psoNumberFormat(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> Int?{
        let components = calendar.components([.Day, .Month, .Year, .Hour, .Minute, .Second], fromDate: self)
        
        let year = "\(components.year)".psoStringByPaddingLeft(toLength: 4, withString: "0")
        let month = "\(components.month)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        let day = "\(components.day)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        let hour = "\(components.hour)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        let minutes = "\(components.minute)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        let seconds = "\(components.second)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        
        let string = year + month + day + hour + minutes + seconds
        
        guard string.characters.count == 14 else{
            print("Incorrect number of characters in NSDate Number Format should be 14, currently: \(string.characters.count) string: \(string) original date:\(self)")
            return nil
        }
        
        return Int(string)
    }
    
    static func psoDate(withNumberFormat numberFormat: Int, andCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDate?{
        let string = String(numberFormat)
        
        guard string.characters.count == 14 else{
            print("Could not create date with number format, incorrect number of characters, need 14, supplied: \(string.characters.count) number:\(numberFormat)")
            return nil
        }
        
        var startIndex = string.startIndex
        var endIndex = startIndex.advancedBy(4)
        let year = string.substringWithRange(startIndex ..< endIndex)
        
        startIndex = endIndex
        endIndex = endIndex.advancedBy(2)
        let month = string.substringWithRange(startIndex ..< endIndex)
        
        startIndex = endIndex
        endIndex = endIndex.advancedBy(2)
        let day = string.substringWithRange(startIndex ..< endIndex)
        
        startIndex = endIndex
        endIndex = endIndex.advancedBy(2)
        let hour = string.substringWithRange(startIndex ..< endIndex)
        
        startIndex = endIndex
        endIndex = endIndex.advancedBy(2)
        let minute = string.substringWithRange(startIndex ..< endIndex)
        
        startIndex = endIndex
        endIndex = endIndex.advancedBy(2)
        let second = string.substringWithRange(startIndex ..< endIndex)
        
        guard let yearNmbr = Int(year), monthNmbr = Int(month), dayNmbr = Int(day), hourNmbr = Int(hour), minuteNmbr = Int(minute), secondNmbr = Int(second) else {
            return nil
        }
        
        let components = NSDateComponents()
        components.year = yearNmbr
        components.month = monthNmbr
        components.day = dayNmbr
        components.hour = hourNmbr
        components.minute = minuteNmbr
        components.second = secondNmbr
        return NSCalendar.currentCalendar().dateFromComponents(components)
    }
}

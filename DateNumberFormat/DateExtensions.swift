//
//  DateExtensions.swift
//  DateNumberFormat
//
//  Created by Jose Ines Cantu Arrambide on 8/17/16.
//  Copyright © 2016 Jose Ines Cantu Arrambide. All rights reserved.
//

import Foundation

/// This extension allows us to `throw` a string.
extension String : ErrorType { }

// Convenience extension for using psoStringByPaddingLeft on ints.
extension Int {
    func psoStringByPaddingLeft(toLength length: Int, withString string: String) -> String {
        return "\(self)".stringByPaddingLeft(toLength: length, withString: string)
    }
}

// Provides us with a way to pad a string to the left.
extension String {

    /**
     Given a string of length n, pad it to `length` by adding `string` to the left until we reach lenght.
     If we're given a string with length < than the provided length, we trim the given string.

     - parameter length: the total length after padding
     - parameter string: the pad

     - returns: a string of provided length with padding if necessary
     */
    func stringByPaddingLeft(toLength length: Int, withString string: String) -> String {

        let padLength = length - self.characters.count
        guard padLength > -1 else {
            return self.stringByPaddingToLength(length, withString: string, startingAtIndex: 0)
        }

        return "".stringByPaddingToLength(padLength, withString: string, startingAtIndex: 0) + self
    }
}

extension NSDateComponents {

    func psoString(unit: NSCalendarUnit) throws -> String {

        switch unit {

        case NSCalendarUnit.Year:
            return self.year.psoStringByPaddingLeft(toLength: 4, withString: "0")

        case NSCalendarUnit.Month:
            return self.month.psoStringByPaddingLeft(toLength: 2, withString: "0")

        case NSCalendarUnit.Day:
            return self.day.psoStringByPaddingLeft(toLength: 2, withString: "0")

        case NSCalendarUnit.Hour:
            return self.hour.psoStringByPaddingLeft(toLength: 2, withString: "0")

        case NSCalendarUnit.Minute:
            return self.minute.psoStringByPaddingLeft(toLength: 2, withString: "0")

        case NSCalendarUnit.Second:
            return self.second.psoStringByPaddingLeft(toLength: 2, withString: "0")

        default:
            throw "Only Year, Month, Day, Hour, Minute and Second are supported"
        }
    }
}


public extension NSDate {

    func psoNumber(usingCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) throws -> Int {

        let components = calendar.components([.Day, .Month, .Year, .Hour, .Minute, .Second], fromDate: self)

        do {
            let year = try components.psoString(.Year)
            let month = try components.psoString(.Month)
            let day = try components.psoString(.Day)
            let hour = try components.psoString(.Hour)
            let minutes = try components.psoString(.Minute)
            let seconds = try components.psoString(.Second)
            
            let psoNumberString = year + month + day + hour + minutes + seconds
            
            guard psoNumberString.characters.count == 14 else {
                throw "Incorrect number of characters in NSDate Number Format should be 14, currently: \(psoNumberString.characters.count) string: \(psoNumberString) original date:\(self)"
            }

            guard let psoNumber = Int(psoNumberString) else {
                throw "Resulting psoNumber is not a valid integer"
            }
            
            return psoNumber
        }

        catch {
            throw "\(error)"
        }
    }

    convenience init(numberFormat: Int, calendar: NSCalendar = NSCalendar.currentCalendar()) throws {
        let string = String(numberFormat)
        guard string.characters.count == 14 else{
            throw "Could not create date with number format, incorrect number of characters, need 14, supplied: \(string.characters.count) number:\(numberFormat)"
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
            throw "Given number format is not a valid Int after processing"
        }

        let components = NSDateComponents()
        components.year = yearNmbr
        components.month = monthNmbr
        components.day = dayNmbr
        components.hour = hourNmbr
        components.minute = minuteNmbr
        components.second = secondNmbr

        guard let date = calendar.dateFromComponents(components) else {
            throw "Given number format is not a valid date"
        }

        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }

}
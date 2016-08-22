//
//  DateExtensions.swift
//  DateNumberFormat
//
//  Created by Jose Ines Cantu Arrambide on 8/17/16.
//  Copyright © 2016 Jose Ines Cantu Arrambide. All rights reserved.
//

import Foundation

public func psoDispatch_sync_to_main_queue(dispatch_Block: () -> Void){
    if NSThread.isMainThread() == true {
        dispatch_Block()
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), dispatch_Block)
    }
}

extension String {
    
    // Adds the string supplied to the left of the string until it meets the lenght specified, if the lenght passed is less than the size of the string, it will return a substring
    func psoStringByPaddingLeft(toLength length: Int, withString string: String) -> String {
        let padLength = length - self.characters.count
        guard padLength > -1 else {
            return self.substringToIndex(self.endIndex.advancedBy(padLength))
        }
        
        return "".stringByPaddingToLength(padLength, withString: string, startingAtIndex: 0) + self
    }
}


public extension NSDate{
    
    /// returns an Int64 representing the date, human readable. Old format only works with gregorian calendar, the default is old format.
    func psoNumberFormat(withCalendar calendar: NSCalendar = NSCalendar.currentCalendar(), useOldFormat: Bool = true) -> Int64?{
        
        if useOldFormat {
            guard calendar.calendarIdentifier == NSCalendarIdentifierGregorian else{
                print("WARNING: Old Format only accepts gregorian calendar")
                return nil
            }            
        }
        
        let components = calendar.components([.Era, .Year, .Day, .Month, .Hour, .Minute, .Second], fromDate: self)
        
        let era = "\(components.era)".psoStringByPaddingLeft(toLength: 3, withString: "0")
        let year = "\(components.year)".psoStringByPaddingLeft(toLength: 4, withString: "0")
        let month = "\(components.month)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        let day = "\(components.day)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        let hour = "\(components.hour)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        let minutes = "\(components.minute)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        let seconds = "\(components.second)".psoStringByPaddingLeft(toLength: 2, withString: "0")
        
        let string: String
        if useOldFormat{
            string = year + month + day + hour + minutes + seconds
        }
        else{
            string = "1" + era + year + month + day + hour + minutes + seconds
        }
        
        let charsNeeded = (useOldFormat ? 14 : 18)
        guard string.characters.count == charsNeeded else{
            print("Incorrect number of characters in NSDate Number Format should be \(charsNeeded), currently: \(string.characters.count) string: \(string) original date:\(self)")
            return nil
        }
        
        return Int64(string)
    }
    
    convenience init?(withNumberFormat numberFormat: Int64, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()){
        if let date = NSDate.psoDate(withNumberFormat: numberFormat, withCalendar: calendar){
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        }
        else{
            return nil
        }
        
    }
    
    static func psoDate(withNumberFormat numberFormat: Int64, withCalendar calendar: NSCalendar = NSCalendar.currentCalendar()) -> NSDate?{
        var string = String(numberFormat)
        var characterCount = string.characters.count
        
        if characterCount == 11 {
            string = "00" + string
            characterCount = string.characters.count
        }
        
        
        guard [14,18].contains(characterCount) else{
            print("Could not create date with number format, incorrect number of characters supplied: \(string.characters.count) number:\(numberFormat)")
            return nil
        }
        
        let oldFormat = characterCount == 14
        if oldFormat {
            guard calendar.calendarIdentifier == NSCalendarIdentifierGregorian else{
                print("WARNING: Old format date number must use gregorian calendar")
                return nil
            }
        }
        
        
        
        var startIndex = string.startIndex
        var endIndex = string.startIndex
        
        let era: String
        if !oldFormat{
            startIndex = string.startIndex.advancedBy(1)
            endIndex = startIndex.advancedBy(3)
            era = string.substringWithRange(startIndex ..< endIndex)
        }
        else{
            era = "0"
        }
        
        startIndex = endIndex
        endIndex = startIndex.advancedBy(4)
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
        
        guard let eraNmbr = Int(era), yearNmbr = Int(year), monthNmbr = Int(month), dayNmbr = Int(day), hourNmbr = Int(hour), minuteNmbr = Int(minute), secondNmbr = Int(second) else {
            return nil
        }
        
        let components = NSDateComponents()
        if !oldFormat {
            components.era = eraNmbr
        }
        components.year = yearNmbr
        components.month = monthNmbr
        components.day = dayNmbr
        components.hour = hourNmbr
        components.minute = minuteNmbr
        components.second = secondNmbr
        return calendar.dateFromComponents(components)
    }
}

extension NSDateComponents{
    func psoPrintDescription() -> String{
        return "Era: \(era)\nYear: \(year), Month: \(month), Day: \(day)\nHour: \(hour), Minutes: \(minute), Seconds: \(second)"
    }
}

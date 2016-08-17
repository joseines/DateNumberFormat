//
//  DateNumberFormatTests.swift
//  DateNumberFormatTests
//
//  Created by Jose Ines Cantu Arrambide on 8/17/16.
//  Copyright © 2016 Jose Ines Cantu Arrambide. All rights reserved.
//

import XCTest

@testable import DateNumberFormat

class DateNumberFormatTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    // Convierte en fecha utilizando el viejo formato de 14 numeros utilizando el calendario actual
    func testOldFormat(){
        let originalDate = NSDate()
        
        guard let numberFormat = originalDate.psoNumberFormat(useOldFormat: true) else{
            XCTFail("Coult not create number format")
            return
        }
        
        
        guard let newDate = NSDate.psoDate(withNumberFormat: numberFormat) else{
            XCTFail("Could not get date from old number format")
            return
        }
        
        XCTAssert(NSCalendar.currentCalendar().compareDate(originalDate, toDate: newDate, toUnitGranularity: [.Second]) == .OrderedSame)
        
        // Verificar que solo funcione con gregoriano
        guard let otherCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierChinese) else{
            XCTFail("Could not create calendar")
            return
        }
        
        XCTAssert(originalDate.psoNumberFormat(withCalendar: otherCalendar, useOldFormat: true) == nil)
        XCTAssert(NSDate.psoDate(withNumberFormat: numberFormat, andCalendar: otherCalendar) == nil)
    }
    
    var calendarIdentifierArray: [String]{
        return [NSCalendarIdentifierGregorian, NSCalendarIdentifierBuddhist,
                NSCalendarIdentifierChinese,
                NSCalendarIdentifierCoptic,
                NSCalendarIdentifierEthiopicAmeteMihret,
                NSCalendarIdentifierEthiopicAmeteAlem,
                NSCalendarIdentifierHebrew,
                NSCalendarIdentifierISO8601,
                NSCalendarIdentifierIndian,
                NSCalendarIdentifierIslamic,
                NSCalendarIdentifierIslamicCivil,
                NSCalendarIdentifierJapanese,
                NSCalendarIdentifierPersian,
                NSCalendarIdentifierRepublicOfChina
        ]
    }
    
    func testDistantPastDate(){
        testAllCalendars(withDate: NSDate.distantPast())
    }
    
    func testDistantFuture(){
        testAllCalendars(withDate: NSDate.distantFuture())
    }
    
    func testCurrentDate(){
        testAllCalendars(withDate: NSDate())
    }
    
    
    
    // Convierte la fecha en numero, después la vuelva a crear en fecha y verifica que sean igual hasta el segundo.
    func testAllCalendars(withDate date: NSDate = NSDate()){
        var failedCalendars = [String]()
        var passedCalendars = [String]()
        for identifier in calendarIdentifierArray{
            guard let calendar = NSCalendar(calendarIdentifier: identifier) else{
                failedCalendars.append(identifier)
                continue
            }
            
            if test(withCalendar: calendar, withDate: NSDate()) == false{
                failedCalendars.append(identifier)
            }
            else{
                passedCalendars.append(identifier)
            }
        }
        
        if failedCalendars.count > 0 {
            print("FAILED CALENDARS: \(failedCalendars)\n\nPASSED CALENDARS: \(passedCalendars)")
            XCTFail()
        }
        else{
            XCTAssert(true)
        }
    }
    
    func test(withCalendar calendar: NSCalendar, withDate originalDate: NSDate = NSDate()) -> Bool{
        // CONVERTIR A NUMERO
        guard let numberFormat = originalDate.psoNumberFormat(withCalendar: calendar) else{
            return false
        }
        
        // CONVERTIR A FECHA DE REGRESOx
        guard let newDate = NSDate.psoDate(withNumberFormat: numberFormat, andCalendar: calendar) else{
            return false
        }
        
        // VERIFICAR QUE SEA LA MISMA FECHA
        let isEqual = calendar.compareDate(originalDate, toDate: newDate, toUnitGranularity: [.Second]) == .OrderedSame
        if !isEqual {
            print("\nOriginal Date: \(originalDate)\n New Date: \(newDate)")
        }
        
        return isEqual
    }
    
    func testPerformanceWithoutSupplyingCalendar() {
        // This is an example of a performance test case.
        self.measureBlock {
            self.testAllCalendars()
        }
    }
    
}

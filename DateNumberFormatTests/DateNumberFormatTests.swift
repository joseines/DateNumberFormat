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
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // Convierte la fecha en numero, después la vuelva a crear en fecha y verifica que sean igual hasta el segundo.
    func testGregorianCalendar(){
        guard let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else{
            return
        }
        
        XCTAssert(test(withCalendar: calendar))
    }
    
    func testAllCalendars(){
        let identifierArray = [NSCalendarIdentifierGregorian, NSCalendarIdentifierBuddhist,
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
        
        var failedCalendars = [String]()
        for identifier in identifierArray{
            guard let calendar = NSCalendar(calendarIdentifier: identifier) else{
                failedCalendars.append(identifier)
                return
            }
            
            if test(withCalendar: calendar) == false{
                failedCalendars.append(identifier)
            }
        }
        
        if failedCalendars.count > 0 {
            print("FAILED CALENDARS: \(failedCalendars)")
            XCTFail()
        }
        else{
            XCTAssert(true)
        }
        
        
    }
    
    func test(withCalendar calendar: NSCalendar) -> Bool{
        let originalDate = NSDate()
        
        // CONVERTIR A NUMERO
        guard let numberFormat = try? originalDate.psoNumber() else{
            return false
        }
        
        
        // CONVERTIR A FECHA DE REGRESO
        guard let newDate = try? NSDate(numberFormat: numberFormat) else {
            return false
        }
        
        print("\nOriginal Date: \(originalDate)\n New Date: \(newDate)")
        
        
        // VERIFICAR QUE SEA LA MISMA FECHA
        return calendar.compareDate(originalDate, toDate: newDate, toUnitGranularity: [.Second]) == .OrderedSame
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

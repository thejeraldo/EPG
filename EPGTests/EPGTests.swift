//
//  EPGTests.swift
//  EPGTests
//
//  Created by Jerald Abille on 3/17/18.
//  Copyright © 2018 Jerald Abille. All rights reserved.
//

import XCTest
@testable import EPG

class EPGTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  func testProgramDuration() {
    let program = Program(title: "Game of Thrones: S1E1 - Winter is coming.", schedule: Schedule(start: 1521133200, end: 1521138600))
    XCTAssert(program.duration == 5400, "The program should be 1.5 hours long!")
  }
  
  func testProgramDate() {
    let program = Program(title: "Game of Thrones: S1E1 - Winter is coming.", schedule: Schedule(start: 1521133200, end: 1521138600))
    let startDateString = "2018-03-15 17:00:00 +0000"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
    let startDate = dateFormatter.date(from: startDateString)
    XCTAssert(program.startDate == startDate, "The program start date must be 2018-03-15 17:00:00 +0000")
  }
  
  func testProgramViewModel() {
    let program = Program(title: "Game of Thrones: S1E1 - Winter is coming.", schedule: Schedule(start: 1521133200, end: 1521138600))
    let programViewModel = ProgramViewModel(program: program)
    XCTAssert(programViewModel.startTimeString == "21:00", "Start time must be 21:00.")
    XCTAssert(programViewModel.endTimeString == "22:30", "Start time must be 22:30.")
    XCTAssert(programViewModel.durationString == "1 hr, 30 min", "Duration string must 1 hr, 30 min.")
  }
  
  func testDateGeneration() {
    var jan1970 = Date(timeIntervalSince1970: TimeInterval(0))
    let jan1970interval = jan1970.timeIntervalSince1970
    print(jan1970)
    print(jan1970interval)
    
    // Program's timing is 1am.
    jan1970.addTimeInterval(3600)
    print(jan1970)
    
    // Get the date today
    let today = Date()
    let todayInterval = today.timeIntervalSince1970
    print(today)
    print(todayInterval)
    
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
    dateFormatter.timeZone = TimeZone.current
    let string = dateFormatter.string(from: today)
    let d = dateFormatter.date(from: string)
  }
  
  func testWeek() {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let today = calendar.startOfDay(for: Date())
    print(today)
    var dateComp = DateComponents()
    dateComp.day = -1
    let yesterday = Calendar.current.date(byAdding: dateComp, to: today)
    print(yesterday)
    var week: [Date]? = [Date]()
    week?.append(yesterday!)
    week?.append(today)
    for x in 1...3 {
      dateComp.day = x
      let day = calendar.date(byAdding: dateComp, to: today)
      week?.append(day!)
    }
    print(week)
    
    for date: Date in week! {
      print(date.timeIntervalSince1970)
    }
    print("")
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}

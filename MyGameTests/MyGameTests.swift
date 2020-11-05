//
//  MyGameTests.swift
//  MyGameTests
//
//  Created by Xcode User on 2020-11-04.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import XCTest

class MyGameTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRandom() {
        
        let gs = GameScene()
        XCTAssertNotNil(gs.random())
        XCTAssertNoThrow(gs.random())
        
        XCTAssertNotEqual(gs.random(min: 1.33, max: 1.33), 1.0)
        XCTAssertEqual(gs.random(min: 5, max: 5), 5)
    }
    func testExplosion(){
        let gs = GameScene()
        
        
        XCTAssertNoThrow(gs.spawnExplosion(spawnPosition: CGPoint(x: 1,y: 1)))
        
        XCTAssertNotNil(gs.spawnExplosion(spawnPosition: CGPoint(x: 1,y: 1)))
        
        
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual(2+2, 4)
        
        
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

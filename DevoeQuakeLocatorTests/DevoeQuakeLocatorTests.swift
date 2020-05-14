//
//  DevoeQuakeLocatorTests.swift
//  DevoeQuakeLocatorTests
//
//  Created by Dana Devoe on 5/10/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import XCTest
@testable import DevoeQuakeLocator

class DevoeQuakeLocatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Test the QuakeDataSource, that it is loading the data correctly and waiting for the
    // server to connection, it waits indefinately right now, which I might want to have it timeout
    func testQuakeDataSource() throws {
        let exception = expectation(description: "Wait for Quake server to complete")
        let qds = QuakeDataSource()
        let startTime = "2020-01-01"
        let endTime = "2020-01-02"
        let mag = 5
        
        qds.loadQuakeData(startTime: startTime, endTime: endTime, magnitude: mag, completion: {success in
            QuakeServer.featuresFor(startTime: startTime, endTime: endTime, magnitude: mag, completion: { features in
                DispatchQueue.main.async {
                    let count1 = qds.tableView(UITableView(), numberOfRowsInSection: 0)
                    let count2 = features.features?.count
                    
                    XCTAssertTrue( count1 == count2, "Counts should be the same, there is a disconnect" )
                    exception.fulfill()
                }
            }, failure: { error in
                XCTFail( "error (\(error) attempting to retrieve features" )
                exception.fulfill()
            })
        })
        self.waitForExpectations(timeout: 100, handler: nil)
    }
    
    func testListFeatureProperties() throws {
        let exception = expectation(description: "Wait for Quake server to complete")
        let qds = QuakeDataSource()
        let startTime = "2020-01-01"
        let endTime = "2020-01-02"
        let mag = 5
        
        qds.loadQuakeData(startTime: startTime, endTime: endTime, magnitude: mag, completion: {success in
            
            for index in 0...qds.featureCount {
                if let str = qds.featureURLAt(IndexPath(row: index, section: 0)) {
                    print( "URL: \(str)" )
                }
            }
            exception.fulfill()
        })
        
        self.waitForExpectations(timeout: 100, handler: nil)
    }

    // Test the creation of a large data sets
    // ...
    func testExample() throws {
        let exception = expectation(description: "Wait for Quake server to complete")
        
        QuakeServer.featuresFor(startTime: "2020-01-01", endTime: "2020-01-02", magnitude: nil, completion: { features in
            self.printFeatures( features )
            exception.fulfill()
        }, failure: { error in
            XCTFail( "error (\(error) attempting to retrieve features" )
            exception.fulfill()
        })
        
        self.waitForExpectations(timeout: 100, handler: nil)
    }

    // Test a data set generated with a magnitude value
    func testMagnitude5() throws {
        let exception = expectation(description: "Wait for Quake server to complete")
        
        QuakeServer.featuresFor(startTime: "2020-01-01", endTime: "2020-01-02", magnitude: 5, completion: { features in
            self.printFeatures( features )
            exception.fulfill()
        }, failure: { error in
            XCTFail( "error (\(error) attempting to retrieve features" )
            exception.fulfill()
        })
        
        self.waitForExpectations(timeout: 100, handler: nil)
    }
    
    // simple endpoint test
    func testEndpoint() {
        
        let url = EndPoints.queryURLFor(startTime: "2020-01-01", endTime: "2020-01-02" )
        let urlMag5 = EndPoints.queryURLFor(startTime: "2020-01-01", endTime: "2020-01-02", magnitude: 5)
        
        XCTAssertFalse( url == urlMag5, "Values should not be the same" )
        print( "print = \(url)" )
    }
    
    func testMinder() {
        
    }
    
    func testTime() {
        
        let dateString = "2020-01-01"
        
        if let a = Date().fromYYYYMMDD(string: dateString) {
            let newDateString = a.toYYYYMMDD()
        
            XCTAssertTrue( dateString == newDateString,"should be the same" )
            
            let pastDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            let string = pastDate.toYYYYMMDD()
            
            print( "Last Month Date:\(string)" )

        } else {
            XCTFail()
        }
    }
    
    //
    //MARK: - Helpers
    //
    
    func printFeatures( _ features: FeatureCollection ) {
        print( "Number of Features: \(features.features?.count ?? 0 )" )
        
        if let features = features.features {
            for feature in features {
                printFeature( feature )
            }
        }
    }
    
    func printFeature( _ feature: Feature ) {
        print( "\nID: \(feature.id ?? "?" )" )
        
        if let properties = feature.properties {
            print( "Magnitude: \(properties.mag ?? 0)" )
            print( "Where: \(properties.place ?? "?" )" )
            print( "Time: \(properties.time ?? Date() )" )
            print( "\(properties.alert ?? "" )" )
        }
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

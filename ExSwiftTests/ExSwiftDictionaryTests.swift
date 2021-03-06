//
//  ExSwiftDictionaryTests.swift
//  ExSwift
//
//  Created by pNre on 04/06/14.
//  Copyright (c) 2014 pNre. All rights reserved.
//

import XCTest

class ExSwiftDictionaryTests: XCTestCase {
    
    var dictionary = [
        "A": 1,
        "B": 2,
        "C": 3
    ]
    
    func testHas() {
        XCTAssertTrue(dictionary.has("A"))
        XCTAssertFalse(dictionary.has("Z"))
    }

    func testMapValues() {
        let mapped = dictionary.mapValues(mapFunction: { key, value -> Int in return value + 1 })
        XCTAssertEqualDictionaries(mapped, ["A": 2, "B": 3, "C": 4])
    }
    
    func testMapFilterValues() {
        let result = dictionary.mapFilterValues { (key, value) -> Int? in
            if key == "B" {
                return nil
            }
            
            return value + 1
        }
        
        XCTAssertEqualDictionaries(result, ["A": 2, "C": 4])
    }
    
    func testMap() {
        let mapped = dictionary.map(mapFunction: { key, value -> (String, Int) in return (key + "A", value + 1) })
        XCTAssertEqualDictionaries(mapped, ["AA": 2, "BA": 3, "CA": 4])
    }
    
    func testMapFilter() {
        let mapped = dictionary.mapFilter(mapFunction: { key, value -> (String, String)? in
            if key == "C" {
                return ("D", key)
            }
            
            return nil
        })
        
        XCTAssertEqualDictionaries(mapped, ["D": "C"])
    }
    
    func testFilter() {
        let filtered = dictionary.filter { key, _ in return key != "A" }
        XCTAssertEqualDictionaries(filtered, ["B": 2, "C": 3])
    }

    func testCount() {
        XCTAssertEqual(2, dictionary.count({ key, _ in return key != "A" }))
    }

    func testShift() {
        let (key, value) = dictionary.shift()!
        
        XCTAssertEqual(2, dictionary.count)
        XCTAssertNotNil(key)
        XCTAssertNotNil(value)
    }
    
    func testGroupBy() {
        let group = [
            "A": 2,
            "B": 4,
            "C": 5
        ]
        
        let g = group.groupBy(groupingFunction: {
            _, value -> Bool in
            return (value % 2 == 0)
        })
        
        XCTAssertTrue(Array(g.keys).difference([false, true]).isEmpty)
        XCTAssertTrue(Array(g[true]!).difference([2, 4]).isEmpty)
        XCTAssertEqualArrays(Array(g[false]!), [5])
    }
    
    func testCountBy() {
        let group = [
            "A": 2,
            "B": 4,
            "C": 5
        ]
        
        let g = group.countBy(groupingFunction: {
            _, value -> Bool in
            return (value % 2 == 0)
        })
        
        XCTAssertEqualDictionaries(g, [false: 1, true: 2])
    }
    
    func testAny() {
        let any = dictionary.any {
            _, value -> Bool in
            return value % 2 == 0
        }

        XCTAssertTrue(any)
    }

    func testAll() {
        let all = dictionary.all {
            _, value -> Bool in
            return value % 2 == 0
        }
        
        XCTAssertFalse(all)
    }

    func testReduce () {
        let reduced = dictionary.reduce(Dictionary<Int, String>(), {
            (var initial: Dictionary<Int, String>, couple: (String, Int)) in
            initial.updateValue(couple.0, forKey: couple.1)
            return initial
        })
        
        XCTAssertEqualDictionaries(reduced, [2: "B", 3: "C", 1: "A"])
    }
    
    func testDifference () {
        let dictionary1 = [ "A": 1, "B": 2, "C": 3 ]
        let dictionary2 = [ "A": 1 ]
        let dictionary3 = [ "B": 2, "C": 3 ]
        
        XCTAssertEqualDictionaries(dictionary1.difference(dictionary2, dictionary3), [:])
        XCTAssertEqualDictionaries(dictionary1 - dictionary2, ["C": 3, "B": 2])
    }
    
    func testUnion () {
        let dictionary1 = [ "A": 1, "B": 2, "C": 3 ]
        let dictionary2 = [ "A": 1 ]
        let dictionary3 = [ "D": 4 ]
        
        XCTAssertEqualDictionaries(dictionary1.union(dictionary2, dictionary3), [ "A": 1, "B": 2, "C": 3, "D": 4 ])
        XCTAssertEqualDictionaries(dictionary1 | dictionary2, dictionary1)
    }
    
    func testIntersection () {
        let dictionary1 = [ "A": 1, "B": 2, "C": 3 ]
        let dictionary2 = [ "A": 1 ]
        let dictionary3 = [ "D": 4 ]

        XCTAssertEqualDictionaries(dictionary1.intersection(dictionary2), ["A": 1])
        XCTAssertEqualDictionaries(dictionary1.intersection(dictionary3), [:])
        XCTAssertEqualDictionaries(dictionary1 & dictionary1, dictionary1)
    }
    
    func testPick () {
        let dictionary = [1: "A", 2: "B", 3: "C"]
        
        let pick1 = dictionary.pick([1, 3])
        let pick2 = dictionary.pick(1, 3)

        XCTAssertEqualDictionaries(pick1, [1: "A", 3: "C"])
        XCTAssertEqualDictionaries(pick2, pick1)
        XCTAssertEqualDictionaries(dictionary.pick(), [:])
    }
}

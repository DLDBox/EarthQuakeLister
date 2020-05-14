//
//  Models.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/10/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation

/*
 The models used by U.S. Geological Survey - Earth quak hazards program
 
 */

class FeatureCollection: Decodable {
    
    let type: String?
    let metadata: MetaData?
    let box: BBox?
    let features: [Feature]?

}

class MetaData: Decodable {
    
    let generated: Int64?
    let url: String?
    let title: String?
    let api: String?
    let count: Int32?
    let status: Int32?
    
}

class BBox: Decodable {
    
    let minLongitude: Float?
    let minLatitude: Float?
    let minDepth: Float?
    let maxLongitude: Float?
    let maxLatitude: Float?
    let maxDepth: Float?
    
}

class Feature: Decodable {
    
    let type: String?
    let properties: Property?
    let geometry: Geometry?
    let id: String?
}

class Property: Decodable {
    
    let mag: Decimal?
    let place: String?
    let time: Date?
    let updated: Date?
    let tz: Int?
    let url: String?
    let detail: String?
    let felt: Int?
    let cdi: Decimal?
    let mmi: Decimal?
    let alert: String?
    let status: String?
    let tsunami: Int?
    let sig: Int?
    let net: String?
    let code: String?
    let ids: String?
    let sources: String?
    let types: String?
    let nst: Int?
    let dmin: Decimal?
    let rms: Decimal?
    let gap: Decimal?
    let magType: String?
    let type: String?    
}

class Geometry: Decodable {
    let type: String?
    let coordinates: [Float32]?
}


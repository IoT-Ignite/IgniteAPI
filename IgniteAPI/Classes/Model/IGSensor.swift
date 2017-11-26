//
//  IGSensor.swift
//  IgniteGreenhouse
//
//  Created by Doruk Gezici on 30/06/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGSensor: NSObject, NSCoding {
    
    public let nodeId: String!
    public let sensorId: String!
    public let vendor: String!
    public let sensorType: String!
    
    public init(json: JSON) {
        nodeId = json["nodeId"].stringValue
        sensorId = json["sensorId"].stringValue
        vendor = json["vendor"].stringValue
        sensorType = json["sensorType"].stringValue
    }
    
    public required init?(coder aDecoder: NSCoder) {
        nodeId = aDecoder.decodeString(forKey: "nodeId")
        sensorId = aDecoder.decodeString(forKey: "sensorId")
        vendor = aDecoder.decodeString(forKey: "vendor")
        sensorType = aDecoder.decodeString(forKey: "sensorType")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(nodeId, forKey: "nodeId")
        aCoder.encode(sensorId, forKey: "sensorId")
        aCoder.encode(vendor, forKey: "vendor")
        aCoder.encode(sensorType, forKey: "sensorType")
    }
    
}

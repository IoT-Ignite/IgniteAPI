//
//  IGSensorData.swift
//  IgniteGreenhouse
//
//  Created by Doruk Gezici on 30/06/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGSensorData {
    
    public let cloudDate: TimeInterval!
    public let createDate: TimeInterval!
    public var data: String!
    public let deviceId: String!
    public let nodeId: String!
    public let sensorId: String!
    
    public init(json: JSON) {
        cloudDate = json["cloudDate"].doubleValue / 1000 // Change milliseconds to seconds.
        createDate = json["createDate"].doubleValue / 1000
        if let str = json["data"].string {
            let array = str.filter { $0 != "\"" && $0 != "[" && $0 != "]" }
            self.data = String(array)
        } else {
            if let tmp = json["data"].float {
                self.data = String(tmp)
            } else { self.data = "" }
        }
        deviceId = json["deviceId"].stringValue
        nodeId = json["nodeId"].stringValue
        sensorId = json["sensorId"].stringValue
    }
    
}

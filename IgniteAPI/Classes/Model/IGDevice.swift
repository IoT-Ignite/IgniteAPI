//
//  IGDevice.swift
//  IgniteGreenhouse
//
//  Created by Doruk Gezici on 29/06/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGDevice: NSObject, NSCoding {
    
    public let deviceId: String!
    public let deviceCode: String!
    public let status: String!
    public let osVersion: String!
    public let model: String!
    public let label: String!
    public var state: String!
    public var clientIp: String!
    public let code: String!
    
    public init(json: JSON) {
        deviceId = json["deviceId"].stringValue
        deviceCode = json["location"]["deviceCode"].stringValue
        status = json["status"].stringValue
        osVersion = json["osVersion"].stringValue
        model = json["model"].stringValue
        label = json["label"].stringValue
        state = json["presence"]["state"].stringValue
        clientIp = json["presence"]["clientIp"].stringValue
        code = json["code"].stringValue
    }
    
    public required init(coder aDecoder: NSCoder) {
        deviceId = aDecoder.decodeString(forKey: "deviceId")
        deviceCode = aDecoder.decodeString(forKey: "deviceCode")
        status = aDecoder.decodeString(forKey: "status")
        osVersion = aDecoder.decodeString(forKey: "osVersion")
        model = aDecoder.decodeString(forKey: "model")
        label = aDecoder.decodeString(forKey: "label")
        state = aDecoder.decodeString(forKey: "state")
        clientIp = aDecoder.decodeString(forKey: "clientIp")
        code = aDecoder.decodeString(forKey: "code")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(deviceId, forKey: "deviceId")
        aCoder.encode(deviceCode, forKey: "deviceCode")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(osVersion, forKey: "osVersion")
        aCoder.encode(model, forKey: "model")
        aCoder.encode(label, forKey: "label")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(clientIp, forKey: "clientIp")
        aCoder.encode(code, forKey: "code")
    }
    
}

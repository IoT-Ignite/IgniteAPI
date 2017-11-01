//
//  IGDROM.swift
//  IgniteAPI
//
//  Created by Doruk Gezici on 12/07/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGDROM {
    
    public let configurationId: String!
    public let deviceId: String!
    public let links: [IGLink]!
    public let name: String!
    public let tenantDomain: String!
    
    public init(json: JSON) {
        configurationId = json["configurationId"].stringValue
        deviceId = json["deviceId"].stringValue
        links = [IGLink]()
        if let array = json["links"].array {
            for json in array {
                let link = IGLink(json: json)
                links.append(link)
            }
        }
        name = json["name"].string
        tenantDomain = json["tenantDomain"].stringValue
    }
    
}

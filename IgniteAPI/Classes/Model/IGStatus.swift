//
//  IGStatus.swift
//  IgniteAPI
//
//  Created by Doruk Gezici on 10/07/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGStatus {
    
    public let status: String!
    
    public init(json: JSON) {
        status = json["status"].stringValue
    }
 
}

//
//  IGAuditor.swift
//  IgniteAPI
//
//  Created by Doruk Gezici on 12/07/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGAuditor {
    
    public let mail: String!
    public let brand: String!
    public let tenantDomain: String!
    public let code: String!
    public let firstName: String!
    public let lastName: String!
    
    public init(json: JSON) {
        mail = json["mail"].stringValue
        brand = json["brand"].stringValue
        tenantDomain = json["tenantDomain"].stringValue
        code = json["code"].stringValue
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
    }
    
}

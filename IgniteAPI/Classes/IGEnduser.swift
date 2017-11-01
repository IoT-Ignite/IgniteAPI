//
//  IGEnduser.swift
//  IgniteAPI
//
//  Created by Doruk Gezici on 17/07/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGEnduser {
    
    public let identityNo: String!
    public let activated: Bool!
    public let lastName: String!
    public let firstName: String!
    public let profile: [String:JSON]!
    public let activationCode: String!
    public let adminArea: [String:JSON]!
    public let createdDate: TimeInterval!
    public let code: String!
    public let activationDate: TimeInterval!
    public let enabled: Bool!
    public let links: [String:JSON]!
    public let mail: String!
    
    public init(json: JSON) {
        identityNo = json["identityNo"].stringValue
        activated = json["activated"].boolValue
        lastName = json["lastName"].stringValue
        firstName = json["firstName"].stringValue
        profile = json["profile"].dictionaryValue
        activationCode = json["activationCode"].stringValue
        adminArea = json["adminArea"].dictionaryValue
        createdDate = json["createdDate"].doubleValue / 1000
        code = json["code"].stringValue
        activationDate = json["activationDate"].doubleValue / 1000
        enabled = json["enabled"].boolValue
        links = json["links"].dictionaryValue
        mail = json["mail"].stringValue
    }
    
}

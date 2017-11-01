//
//  IGDROMConfiguration.swift
//  IgniteAPI
//
//  Created by Doruk Gezici on 17/07/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGDROMConfiguration {
    
    public let appKey: String!
    public let activationCode: String!
    public let autoLogin: Bool!
    public let profileName: String!
    public let policyName: String!
    public let checkProvision: Bool!
    public let empoweredMode: Bool!
    public let userConfigurationMode: String!
    public let json: JSON!
    
    public init(appKey: String, enduser: IGEnduser) {
        self.appKey = appKey
        activationCode = enduser.activationCode
        autoLogin = true
        profileName = "Default"
        policyName = "Default"
        checkProvision = false
        empoweredMode = false
        userConfigurationMode = "none"
        json = [
            "appKey": appKey,
            "activationCode": activationCode,
            "autoLogin": autoLogin,
            "profileName": profileName,
            "policyName": policyName,
            "checkProvision": checkProvision,
            "empoweredMode": empoweredMode,
            "userConfigurationMode": userConfigurationMode
        ]
    }
    
}

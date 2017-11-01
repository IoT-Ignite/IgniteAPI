//
//  IGUser.swift
//  IgniteGreenhouse
//
//  Created by Doruk Gezici on 29/06/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGUser: NSObject, NSCoding {
    
    public let accessToken: String!
    public var expiresIn: TimeInterval!
    public let refreshToken: String!
    public let scope: String!
    public let tokenType: String!
    
    public init(json: JSON) {
        accessToken = json["access_token"].stringValue
        expiresIn = json["expires_in"].doubleValue
        refreshToken = json["refresh_token"].stringValue
        scope = json["scope"].stringValue
        tokenType = json["token_type"].stringValue
        if expiresIn == nil {
            IgniteAPI.refreshToken(completion: { (user) in
                IgniteAPI.currentUser = user
            })
        } else {
            Timer.scheduledTimer(withTimeInterval: expiresIn - 100, repeats: false) { (timer) in
                IgniteAPI.refreshToken() { (user) in
                    IgniteAPI.currentUser = user
                }
            }
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        accessToken = aDecoder.decodeString(forKey: "accessToken")
        expiresIn = aDecoder.decodeTimeInterval(forKey: "expiresIn")
        refreshToken = aDecoder.decodeString(forKey: "refreshToken")
        scope = aDecoder.decodeString(forKey: "scope")
        tokenType = aDecoder.decodeString(forKey: "tokenType")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(expiresIn, forKey: "expiresIn")
        aCoder.encode(refreshToken, forKey: "refreshToken")
        aCoder.encode(scope, forKey: "scope")
        aCoder.encode(tokenType, forKey: "tokenType")
    }
    
}

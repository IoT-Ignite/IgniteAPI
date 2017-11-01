//
//  IGLink.swift
//  IgniteAPI
//
//  Created by Doruk Gezici on 18/07/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IGLink {
    
    public let href: String!
    public let rel: String!
    public let templated: Bool!
    
    public init(json: JSON) {
        href = json["href"].stringValue
        rel = json["rel"].stringValue
        templated = json["templated"].boolValue
    }

}

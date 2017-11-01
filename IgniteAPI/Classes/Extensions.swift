//
//  Extensions.swift
//  IgniteAPI
//
//  Created by Doruk Gezici on 12/07/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension NSCoder {
    
    func decodeString(forKey key: String) -> String {
        return decodeObject(forKey: key) as? String ?? ""
    }
    
    func decodeTimeInterval(forKey key: String) -> TimeInterval {
        return decodeObject(forKey: key) as? TimeInterval ?? 0.0
    }
    
    func decodeData(forKey key: String) -> Data {
        return decodeObject(forKey: key) as? Data ?? Data()
    }
    
}

extension TimeInterval {
    
    public var milliseconds: Int {
        return Int(self * 1000)
    }
    
}

extension Dictionary where Key == String {
    
    public var stringified: String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            guard let str = String(data: data, encoding: String.Encoding.utf8) else { return "" }
            return str
        } catch {
            return error.localizedDescription
        }
    }
    
}

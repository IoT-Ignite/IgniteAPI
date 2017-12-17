//
//  IgniteAPI.swift
//  IgniteGreenhouse
//
//  Created by Doruk Gezici on 29/06/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class IgniteAPI {
    
    static var endpoints: Endpoints = Endpoints()
    public static var currentUser: IGUser? {
        get {
            guard
                let data = UserDefaults.standard.data(forKey: "currentUser"),
                let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? IGUser
                else { return nil }
            return user
        } set {
            if let value = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: value)
                UserDefaults.standard.set(data, forKey: "currentUser")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentUser")
            }
        }
    }
    public static var currentEnduser: IGEnduser?
    public static var currentAuditor: IGAuditor?
    public static var currentDevice: IGDevice? {
        get {
            guard
                let data = UserDefaults.standard.data(forKey: "currentDevice"),
                let device = NSKeyedUnarchiver.unarchiveObject(with: data) as? IGDevice
                else { return nil }
            return device
        } set {
            if let value = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: value)
                UserDefaults.standard.set(data, forKey: "currentDevice")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentDevice")
            }
        }
    }
    public static var currrentNode: IGNode? {
        get {
            guard
                let data = UserDefaults.standard.data(forKey: "currentNode"),
                let node = NSKeyedUnarchiver.unarchiveObject(with: data) as? IGNode
                else { return nil }
            return node
        } set {
            if let value = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: value)
                UserDefaults.standard.set(data, forKey: "currentNode")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentNode")
            }
        }
    }
    public static var currentSensor: IGSensor? {
        get {
            guard
                let data = UserDefaults.standard.data(forKey: "currentSensor"),
                let sensor = NSKeyedUnarchiver.unarchiveObject(with: data) as? IGSensor
                else { return nil }
            return sensor
        } set {
            if let value = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: value)
                UserDefaults.standard.set(data, forKey: "currentSensor")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentSensor")
            }
        }
    }
    public static var appKey: String? {
        get {
            guard let str = UserDefaults.standard.string(forKey: "appKey") else { return nil }
            return str
        } set {
            UserDefaults.standard.set(newValue, forKey: "appKey")
        }
    }
    
    public static var brand: String? {
        get {
            guard let str = UserDefaults.standard.string(forKey: "brand") else { return nil }
            return str
        } set {
            UserDefaults.standard.set(newValue, forKey: "brand")
        }
    }
    
    static func getHeaders() -> HTTPHeaders {
        let headers = [
            "Authorization": "Bearer \(currentUser?.accessToken ?? "")",
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    public static func isLoggedIn() -> Bool {
        if let _ = currentUser?.accessToken { return true }
        else { return false }
    }
    
    public static func login(username: String, password: String, completion: @escaping (_ user: IGUser?, _ error: String?) -> ()) {
        let parameters: Parameters = [
            "grant_type": "password",
            "username": username,
            "password": password
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Basic ZnJvbnRlbmQ6",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(endpoints.login, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let error = json["error"].string {
                    completion(nil, error)
                } else {
                    let user = IGUser(json: json)
                    completion(user, nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func refreshToken(completion: @escaping (_ user: IGUser) -> ()) {
        guard let user = IgniteAPI.currentUser else { return }
        let parameters: Parameters = [
            "grant_type": "refresh_token",
            "refresh_token": user.refreshToken
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Basic ZnJvbnRlbmQ6",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(endpoints.login, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let user = IGUser(json: json)
                completion(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func createRestrictedUser(firstName: String, lastName: String, mail: String, password: String, appKey: String = IgniteAPI.appKey!, brand: String = IgniteAPI.brand!, profileName: String = DEVICE_MODE, completion: @escaping (_ newUser: IGUser?, _ error: String?) -> ()) {
        let parameters: Parameters = [
            "appKey": appKey,
            "brand": brand,
            "firstName": firstName,
            "lastName": lastName,
            "mail": mail,
            "password": password,
            "profileName": profileName
        ]
        Alamofire.request(endpoints.createRestricteduser, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let _ = json["activationCode"].string {
                    IgniteAPI.login(username: mail, password: password) { (user, error) in
                        completion(user, nil)
                    }
                } else {
                    if let err = json["message"].string {
                        completion(nil, err)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func forgotPassword(alias: String = "IoT-Ignite", mail: String, mailSender: String = "noreply@ardich.com", completion: @escaping (_ response: IGStatus) -> ()) {
        let parameters: Parameters = [
            "fromAlias": alias,
            "mail": mail,
            "mailSender": mailSender,
            "url": "https://devzone.iot-ignite.com/dpanel/forgot-password.php"
        ]
        Alamofire.request(endpoints.forgotPassword, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status = IGStatus(json: json)
                completion(status)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func changePassword(mail: String, password: String, token: String, completion: @escaping (_ response: IGStatus) -> ()) {
        let parameters = [
            "mail": mail,
            "password": password,
            "token": token
        ]
        Alamofire.request(endpoints.changePassword, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status = IGStatus(json: json)
                completion(status)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func getAppKey(completion: @escaping (_ appKey: String) -> ()) {
        Alamofire.request(endpoints.appKey, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let appKey = json["appkey"].string else {
                    print("Couldn't get App Key.")
                    return
                }
                completion(appKey)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func logout() {
        currentUser = nil
        currentDevice = nil
        currrentNode = nil
        currentSensor = nil
        currentEnduser = nil
        currentAuditor = nil
        UserDefaults.standard.removeObject(forKey: "appKey")
    }
    
    public static func getDefaultQR() {
        
    }
    
    public static func getEndusers(mail: String = "", completion: @escaping (_ endusers: [IGEnduser]?, _ error: String?) -> ()) {
        let parameters: Parameters = [
            "mail": mail
        ]
        Alamofire.request(endpoints.enduser, parameters: parameters, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let array = json["content"].array else {
                    let error = json["message"].string ?? "Error getting endusers."
                    completion(nil, error)
                    return
                }
                var endusers = [IGEnduser]()
                for json in array {
                    let enduser = IGEnduser(json: json)
                    endusers.append(enduser)
                }; completion(endusers, nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func getAuditor(completion: @escaping (_ auditor: IGAuditor) -> ()) {
        Alamofire.request(endpoints.auditor, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let auditor = IGAuditor(json: json)
                completion(auditor)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func getDevice(deviceId: String, completion: @escaping(_ device: IGDevice) -> ()) {
        Alamofire.request(endpoints.device(deviceId: deviceId), headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let device = IGDevice(json: json)
                completion(device)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    public static func getDevices(completion: @escaping (_ devices: [IGDevice]) -> ()) {
        if isLoggedIn() {
            Alamofire.request(endpoints.device, headers: getHeaders()).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let array = json["content"].array {
                        var devices = [IGDevice]()
                        for json in array {
                            let device = IGDevice(json: json)
                            devices.append(device)
                        }; completion(devices)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    public static func getDeviceNodes(deviceId: String, pageSize: Int, completion: @escaping (_ nodes: [IGNode]) -> ()) {
        let parameters: Parameters = [
            "device": deviceId,
            "pageSize": pageSize
        ]
        Alamofire.request(endpoints.nodes, parameters: parameters, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let array = json["list"].array {
                    var nodes = [IGNode]()
                    for json in array {
                        let node = IGNode(json: json)
                        nodes.append(node)
                    }; completion(nodes)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func getDeviceSensors(deviceId: String, nodeId: String, pageSize: Int, completion: @escaping (_ sensors: [IGSensor]) -> ()) {
        let parameters: Parameters  = [
            "device": deviceId,
            "node": nodeId,
            "pageSize": pageSize
        ]
        Alamofire.request(endpoints.sensors, parameters: parameters, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let array = json["list"].array {
                    var sensors = [IGSensor]()
                    for json in array {
                        let sensor = IGSensor(json: json)
                        sensors.append(sensor)
                    }; completion(sensors)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func getSensorData(deviceId: String, nodeId: String, sensorId: String, completion: @escaping (_ sensorData: IGSensorData) -> ()) {
        let parameters: Parameters = [
            "nodeId": nodeId,
            "sensorId": sensorId
        ]
        Alamofire.request(endpoints.sensorData(deviceId: deviceId), parameters: parameters, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)["data"]
                let sensorData = IGSensorData(json: json)
                completion(sensorData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func getSensorDataHistory(deviceId: String, nodeId: String, sensorId: String, startDate: TimeInterval? = 0.0, endDate: TimeInterval? = Date().timeIntervalSince1970, pageSize: Int, completion: @escaping (_ sensorData: [IGSensorData]) -> ()) {
        let parameters: Parameters = [
            "nodeId": nodeId,
            "sensorId": sensorId,
            "startDate": startDate?.milliseconds ?? 0,
            "endDate": endDate?.milliseconds ?? Date().timeIntervalSince1970.milliseconds,
            "pageSize": pageSize
        ]
        Alamofire.request(endpoints.sensorDataHistory(deviceId: deviceId), parameters: parameters, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let array = json["list"].array {
                    var sensorData = [IGSensorData]()
                    for json in array {
                        let sensor = IGSensorData(json: json)
                        sensorData.append(sensor)
                    }; completion(sensorData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func saveActionMessage(name: String, message: String, completion: @escaping (_ response: JSON) -> ()) {
        let parameters:  Parameters = [
            "message":message,
            "name":name
        ]
        Alamofire.request(endpoints.actionMessage, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func sendSensorAgentMessage(deviceCode: String, nodeId: String, sensorId: String, message: String, completion: @escaping (_ messageId: String) -> ()) {
        let msg: Parameters = [
            "message": message
        ]
        let parameters: Parameters = [
            "nodeId": nodeId,
            "sensorId": sensorId,
            "params": msg.stringified,
            "type": nodeId
        ]
        let url = endpoints.sensorAgentMessage(deviceCode: deviceCode)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let messageId = json["response"].string else { return }
                completion(messageId)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func getDROMTenantConfiguration(completion: @escaping (_ configs: [IGDROM]) -> ()) {
        Alamofire.request(endpoints.dromTenantConfiguration, method: .get, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let array = JSON(value).array {
                    var configs = [IGDROM]()
                    for json in array {
                        let config = IGDROM(json: json)
                        configs.append(config)
                    }; completion(configs)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func addDROMConfiguration(configuration: IGDROMConfiguration, configurationName: String, tenantDomain: String, completion: @escaping (_ configurationId: String?, _ error: String?) -> ()) {
        guard let configStr = configuration.json.rawString(.utf8, options: []) else { return }
        let parameters: Parameters = [
            "configuration": configStr,
            "links": [
                [
                    "href": "",
                    "rel": "",
                    "templated": true
                ]
            ],
            "name": configurationName,
            "tenantDomain": tenantDomain
        ]
        Alamofire.request(endpoints.addDROMConfiguration, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let id = json["configurationId"].string {
                    completion(id, nil)
                } else {
                    print("Configuration Id Not Found! : \(json)")
                }
                switch json["code"].stringValue {
                case "201":
                    if let dict = json["fields"][0].dictionary {
                        guard let message = dict["message"]?.string else { return }
                        let json = JSON(parseJSON: message)
                        guard let configurationId = json["configurationId"].string else {
                            completion(nil, "ERROR")
                            return
                        }
                        completion(configurationId, nil)
                    } else { print("No configuration found.") }
                default:
                    guard let errorMsg = json["message"].string else { return }
                    completion(nil, errorMsg)
                }
            case .failure(let error):
                completion(nil, "ERROR: \(error)")
                print(error)
            }
        }
    }
    
    public static func addDROMDeviceConfiguration(configurationId: String, deviceId: String, tenantDomain: String, completion: @escaping (_ response: JSON) -> ()) {
        let parameters: Parameters = [
            "configurationId": configurationId,
            "deviceId": deviceId,
            "links": [
                [
                    "href": "",
                    "rel": "",
                    "templated": true
                ]
            ],
            "tenantDomain": tenantDomain
        ]
        Alamofire.request(endpoints.addDROMDeviceConfiguration, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func pushDROMDeviceConfiguration(deviceId: String!, completion: @escaping (_ response: Bool) -> ()) {
        Alamofire.request(endpoints.pushDROMConfiguration(deviceId: deviceId), method: .post, headers: getHeaders()).response { (response) in
            guard let response = response.response else { return }
            switch response.statusCode {
            case 200:
                completion(true)
            default:
                completion(false)
            }
        }
    }
    
    public static func addDROMTenantConfiguration(configurationId: String, tenantDomain: String, completion: @escaping (_ response: JSON) -> ()) {
        let parameters: Parameters = [
            "configurationId": configurationId,
            "links": [
                [
                    "href": "",
                    "rel": "",
                    "templated": true
                ]
            ],
            "tenantDomain": tenantDomain
        ]
        Alamofire.request(endpoints.addDROMTenantConfiguration, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getHeaders()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    struct Endpoints {
        
        let base: String! = API_URL
        let login: String!
        let createRestricteduser: String!
        let forgotPassword: String!
        let changePassword: String!
        let appKey: String!
        let defaultQR: String!
        let enduser: String!
        let auditor: String!
        let device: String!
        func device(deviceId: String) -> String {
            return device + "/\(deviceId)"
        }
        let nodes: String!
        let sensors: String!
        func nodeInventory(deviceId: String) -> String {
            return device + "\(deviceId)/device-node-inventory"
        }
        func sensorData(deviceId: String) -> String {
            return device + "/\(deviceId)/sensor-data"
        }
        func sensorDataHistory(deviceId: String) -> String {
            return device + "/\(deviceId)/sensor-data-history"
        }
        let actionMessage: String!
        func sensorAgentMessage(deviceCode: String) -> String {
            return device + "/\(deviceCode)/control/sensor-agent-message"
        }
        let dromTenantConfiguration: String!
        let addDROMTenantConfiguration: String!
        let addDROMConfiguration: String!
        let addDROMDeviceConfiguration: String!
        func pushDROMConfiguration(deviceId: String) -> String {
            return base + "/dromdeviceconfiguration/push/" + deviceId
        }
        
        init() {
            login = base + "/login/oauth"
            createRestricteduser = base + "/public/create-restricted-user"
            forgotPassword = base + "/login/password/forget"
            changePassword =  base + "/login/password/change"
            appKey = base + "/settings/messager/appkey"
            defaultQR = base + "/ignite/default-qr"
            enduser = base + "/enduser"
            auditor = base + "/sysuser/auditor"
            device = base + "/device"
            nodes = device + "/iotlabel/all-nodes"
            sensors = device + "/iotlabel/all-sensors"
            actionMessage = base + "/action-message"
            dromTenantConfiguration = base + "/drom-tenant-configuration"
            addDROMTenantConfiguration = dromTenantConfiguration + "/add"
            addDROMConfiguration = base + "/dromconfiguration/add"
            addDROMDeviceConfiguration = base + "/dromdeviceconfiguration/add"
        }
        
    }
    
}

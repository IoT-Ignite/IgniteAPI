//
//  LoginVC.swift
//  IgniteAPI
//
//  Created by dorukgezici on 11/01/2017.
//  Copyright (c) 2017 dorukgezici. All rights reserved.
//

import UIKit
import IgniteAPI

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var showPassButton: UIButton!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = UserDefaults.standard.string(forKey: "username"),
            let pass = UserDefaults.standard.string(forKey: "password") {
            usernameField.text = username
            passwordField.text = pass
        }
        dismissKeyboardWhenTapped()
    }
    
    @IBAction func showPassPressed(_ sender: Any) {
        if passwordField.isSecureTextEntry {
            passwordField.isSecureTextEntry = false
            showPassButton.setTitle("Hide", for: .normal)
            showPassButton.setImage(UIImage(named: "hide_password"), for: .normal)
        } else {
            passwordField.isSecureTextEntry = true
            showPassButton.setTitle("Show", for: .normal)
            showPassButton.setImage(UIImage(named: "show_password"), for: .normal)
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let username = usernameField.text, let password = passwordField.text else { return }
        if username != "" && password != "" {
            IgniteAPI.login(username: username, password: password) { (user, error) in
                guard let user = user else {
                    self.showAlert(title: "Error", message: error ?? "Error logging in.")
                    return
                }
                IgniteAPI.currentUser = user
                IgniteAPI.getEndusers(mail: username) { (endusers, error) in
                    guard let enduser = endusers?.first else { print("Couldn't get enduser."); return }
                    IgniteAPI.currentEnduser = enduser
                    IgniteAPI.getAuditor { (auditor) in
                        IgniteAPI.currentAuditor = auditor
                        if self.rememberSwitch.isOn {
                            UserDefaults.standard.set(username, forKey: "username")
                            UserDefaults.standard.set(password, forKey: "password")
                        } else {
                            UserDefaults.standard.removeObject(forKey: "username")
                            UserDefaults.standard.removeObject(forKey: "password")
                        }
                        self.performSegue(withIdentifier: "toDevices", sender: nil)
                    }
                }
            }
        } else {
            showAlert(title: "Alert", message: "Please enter your credentials first.")
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        guard let mail = usernameField.text else { return }
        if mail != "" {
            IgniteAPI.forgotPassword(mail: mail) { (status) in
                if status.status == "OK" {
                    self.showAlert(title: "Forgot Password", message: "An e-mail is sent to you. Open the link to reset your password.")
                } else {
                    self.showAlert(title: "Forgot Password", message: "ERROR")
                }
            }
        } else {
            showAlert(title: "Alert", message: "Please enter your e-mail first.")
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
//        performSegue(withIdentifier: "register", sender: nil)
    }
    
}

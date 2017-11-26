//
//  DeviceCell.swift
//  IgniteGreenhouse
//
//  Created by Doruk Gezici on 29/06/2017.
//  Copyright © 2017 ARDIC. All rights reserved.
//

import UIKit
import IgniteAPI

class DeviceCell: UICollectionViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    var device: IGDevice!
    var vc: DevicesVC!
    
    func configureCell(device: IGDevice, vc: DevicesVC) {
        clipsToBounds = false
        layer.cornerRadius = 6
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 1, height: 1)
        self.device = device
        self.vc = vc
        idLabel.text = device.deviceId
        nameLabel.text = device.label
        switch device.model {
        case "iot_rpi3":
            let img = UIImage(named: "Raspberry")
            deviceImage.image = img
        default:
            break
        }
        switch device.state {
        case "ONLINE":
            statusImage.image = UIImage(named: "wireless_signal")
        case "OFFLINE":
            statusImage.image = UIImage(named: "wireless_error")
        default:
            break
        }
    }
    
    @IBAction func infoPressed(sender: UIButton) {
        vc.selectedDevice = device
        let maskView = UIView(frame: vc.view.frame)
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        vc.view.addSubview(maskView)
        vc.performSegue(withIdentifier: "toGateway", sender: maskView)
    }
    
}

//
//  SettingObject.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 10/27/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import UIKit

class SettingObject {
    var type: SettingType = .unclickable
    var settingLabel: String
    var secondaryLabel: String
    var nextController: UIViewController? //ViewController launched on selecting clickable cell
    var secondaryViewType: SecondaryViewType //the secondary view appearing on the right hand side of the cell
    var notificationType: NotificationType?

    init( label: String, secondary: String, next: UIViewController?, secType: SecondaryViewType, notifType: NotificationType? = nil) {
        self.settingLabel = label
        self.secondaryLabel =  secondary
        self.secondaryViewType = secType
        self.nextController = nil
        self.notificationType = notifType
        if let controller = next {
            self.nextController = controller
            self.type = .clickable
        }
    }
}

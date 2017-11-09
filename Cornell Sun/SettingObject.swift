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
    var type: SettingType = SettingType.Unclickable
    var settingLabel: String
    var secondaryLabel: String
    var nextController: UIViewController? //ViewController launched on selecting clickable cell
    var secondaryViewType: SecondaryViewType //the secondary view appearing on the right hand side of the cell
    
    init( label: String, secondary: String, next: UIViewController?, secType: SecondaryViewType) {
        settingLabel = label
        secondaryLabel =  secondary
        secondaryViewType = secType
        nextController = nil
        if let controller = next {
            nextController = controller
            type = SettingType.Clickable
        }
    }
}


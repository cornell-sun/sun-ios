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
    var type: SettingType!
    var settingLabel: String
    var nextController: UIViewController? //ViewController launched on selecting clickable cell

    init(label: String, next: UIViewController?, setType: SettingType) {
        settingLabel = label
        nextController = next
        type = setType
    }

    func isClickable() -> Bool {
        return !(nextController == nil)
    }
}

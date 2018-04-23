//
//  Button.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/22/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class Button: UIButton {
    // Minimum touch targets for interactive elements per Apple human interface guidelines
    let tapWidth: CGFloat = 44
    let tapHeight: CGFloat = 44

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = bounds.insetBy(dx: bounds.width < tapWidth ? bounds.width - tapWidth : 0, dy: bounds.height < tapHeight ? bounds.height - tapHeight : 0)
        return area.contains(point)
    }

}

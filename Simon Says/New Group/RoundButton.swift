//
//  RoundButton.swift
//  Simon Says
//
//  Created by Ryan Tallmage on 1/13/18.
//  Copyright © 2018 Ryan Tallmage. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 1.0
            } else {
                alpha = 0.5
            }
        }
    }
}

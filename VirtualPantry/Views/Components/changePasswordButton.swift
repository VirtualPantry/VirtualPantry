//
//  changePasswordButton.swift
//  VirtualPantry
//
//  Created by Sidney Pho on 12/8/20.
//

import UIKit

class changePasswordButton: UIButton {

    // Called when we creating the button programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // Called when we creating the button on the storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // Configure the button
    func setup() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(red: 255/255, green: 197/255, blue: 66/255, alpha: 1.0)
    }
}

//
//  GroceryItemCell.swift
//  VirtualPantry
//
//  Created by Mathew Chanda on 11/22/20.
//

import UIKit
//@IBDesignable
class GroceryItemCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // Rendering @IBDesignable
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    // Configure the button
    func setup(){
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }

}

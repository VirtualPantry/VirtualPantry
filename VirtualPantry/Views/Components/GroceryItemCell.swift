//
//  GroceryItemCell.swift
//  VirtualPantry
//
//  Created by Mathew Chanda on 11/22/20.
//

import UIKit
@IBDesignable
class GroceryItemCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var groceryItemPicture: UIImageView!
    
    var emergencyFlag : Int = 1
    var warningFlag : Int = 2
    var okayFlag : Int = 3
    var currentQuantity : Int?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    // Configure the button
    func setup(){
        
        // Setup for the cell
        self.layer.cornerRadius = 40
        self.layer.masksToBounds = true
        self.isSelected = false
    }
}

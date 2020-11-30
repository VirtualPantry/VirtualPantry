//
//  PantryItemCell.swift
//  VirtualPantry
//
//  Created by Mathew Chanda on 11/28/20.
//

import UIKit
@IBDesignable
class PantryItemCell: UICollectionViewCell {
    
    @IBOutlet weak var pantryItemPicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var expirationDateLabel: UILabel!
    
    var emergencyFlag : Int = 1
    var warningFlag : Int = 2
    var okayFlag : Int = 3
    var currentQuantity : Int?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.setColor()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        self.setColor()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        self.setColor()
    }

    // Configure the button
    func setup(){
        
        // Setup for the cell
        self.layer.cornerRadius = 40
        self.layer.masksToBounds = true
        self.isSelected = false
        self.setColor()
    }
    
    
    func setColor(){
        guard let quantity = currentQuantity

        else{
            return
        }

        if(quantity == okayFlag){
            let headerColor = UIColor(hexString: "#3DD598")
            let textColor = UIColor(hexString: "#329A75")
            let backgroundColor = UIColor(hexString: "#286053")
            self.contentView.backgroundColor = backgroundColor
            nameLabel?.textColor = headerColor
            nameLabel?.highlightedTextColor = headerColor
            quantityLabel?.textColor = textColor
            quantityLabel?.highlightedTextColor = textColor
            expirationDateLabel?.textColor = textColor
            expirationDateLabel?.highlightedTextColor = textColor
        }

        else if(quantity == warningFlag){
            let headerColor = UIColor(hexString: "#FFC542")
            let textColor = UIColor(hexString: "#B0903D")
            let backgroundColor = UIColor(hexString: "#625B39")
            self.contentView.backgroundColor = backgroundColor
            nameLabel?.textColor = headerColor
            nameLabel?.highlightedTextColor = headerColor
            quantityLabel?.textColor = textColor
            quantityLabel?.highlightedTextColor = textColor
            expirationDateLabel?.textColor = textColor
            expirationDateLabel?.highlightedTextColor = textColor
        }

        else if(quantity == emergencyFlag){
            let headerColor = UIColor(hexString: "#FF565E")
            let textColor = UIColor(hexString: "#B04850")
            let backgroundColor = UIColor(hexString: "#623A42")
            self.contentView.backgroundColor = backgroundColor
            nameLabel?.textColor = headerColor
            nameLabel?.highlightedTextColor = headerColor
            quantityLabel?.textColor = textColor
            quantityLabel?.highlightedTextColor = textColor
            expirationDateLabel?.textColor = textColor
            expirationDateLabel?.highlightedTextColor = textColor
        }

    }
    
    @IBAction func selectedItem(_ sender: Any) {
        if(switcher.isOn == true){
            self.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            nameLabel?.textColor = UIColor.black
            quantityLabel?.textColor = UIColor.black
            expirationDateLabel?.textColor = UIColor.black
            nameLabel?.highlightedTextColor = UIColor.black
            quantityLabel?.highlightedTextColor = UIColor.black
            expirationDateLabel?.highlightedTextColor = UIColor.black
        }
        
        else{
            self.setColor()
        }
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}





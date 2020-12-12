//
//  MenuButton.swift
//  VirtualPantry
//
//  Created by Mathew Chanda on 11/24/20.
//

import UIKit
@IBDesignable
class GroceryListMenuButton: UIButton {

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
    
    // Rendering @IBDesignable
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
           setup()
    }
    
    // Configure the button
    func setup(){
        self.layer.cornerRadius = 9
        self.menu = createMenu()
        self.showsMenuAsPrimaryAction = true
    }
    
    // Creating the Menu
    func createMenu() -> UIMenu {
        
     let addItem = UIAction(
        title: "Add Item Manually",
        image: UIImage(systemName: "plus")
      ) { (_) in
        NotificationCenter.default.post(name: Notification.Name("addGroceryItem"), object: nil)
      }
        
    let removeAll = UIAction(
        title: "Remove all Items",
        image: UIImage(systemName: "delete.left"), attributes: UIMenuElement.Attributes.destructive
        ) { (_) in
        NotificationCenter.default.post(name: Notification.Name("removeGroceryItem"), object: nil)
    }
        
        
    let menuActions = [addItem, removeAll]
      
    let addNewMenu = UIMenu(
      title: "",
      children: menuActions)
      
      return addNewMenu
  }
}

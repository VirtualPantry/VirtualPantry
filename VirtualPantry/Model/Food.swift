//
//  Food.swift
//  
//
//  Created by Mathew Chanda on 12/6/20.
//

import Foundation
import UIKit

public class Food : Equatable{
   
    var name: String = ""
    var description: String  = ""
    var price : Int = 0
    var quantity : Int = 0
    var emergencyFlag : Int = 0;
    var warningFlag : Int = 0;
    var okayFlag : Int = 0;
    var expirationDate: String = ""
    var docItemRef: String = ""
    
    public static func == (lhs: Food, rhs: Food) -> Bool {
        if(lhs.docItemRef == rhs.docItemRef){
            return true
        }
        
        return false
    }
}

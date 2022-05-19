//
//  TradeBuyLabelController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/18/22.
//

import Foundation
import UIKit
class TradeBuyLabelController{
    
    static let shared = TradeBuyLabelController()
    private init(){
        
    }
    
    func controlLabels(item : Item, tradeLabel : UILabel, buyLabel : UILabel){
        if item.isTradable {
            tradeLabel.isHidden=false
            tradeLabel.text="Looking to trade"
        }else{
            tradeLabel.isHidden=true
        }
        
        if item.isBuyable{
            buyLabel.isHidden=false
            buyLabel.text = "Looking for buyers"
        }else{
            buyLabel.isHidden=true
        }
    }
}

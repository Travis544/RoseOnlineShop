//
//  Item.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/13/22.
//

import Foundation
import Firebase
class Item{
    var category : String
    var id : String
    var imageUrl : String
    var name : String
    var owner : String
    var isAvailable : Bool
    var description : String
    var isTradable : Bool
    var isBuyable : Bool
    
//    public init(){
//
//    }
    
    init (doc : DocumentSnapshot ){
        let data=doc.data()
        self.id=doc.documentID
     self.name=data?[kItemName] as? String ?? ""
        self.imageUrl=data?[kItemImage] as? String ?? ""
        self.category=data?[kItemCategory] as? String ?? ""
        self.owner=data?[kItemOwner] as? String ?? ""
        self.isAvailable=data?[kItemAvailable] as? Bool ?? false
        self.description=data?[kItemDescription] as? String  ?? ""
        print("SICK MAN")
        print(doc.description)

        self.isTradable=data?[kItemTradable] as? Bool ?? true
        self.isBuyable=data?[kItemIsBuyable] as? Bool ?? true
    }
}

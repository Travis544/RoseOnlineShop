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
//    public init(){
//
//    }
    
    init (doc : DocumentSnapshot ){
        self.id=doc.documentID
        self.name=doc[kItemName] as! String
        self.imageUrl=doc[kItemImage] as! String
        self.category=doc[kItemCategory] as! String
        self.owner=doc[kItemOwner] as! String
        self.isAvailable=doc[kItemAvailable] as! Bool
        self.description=doc[kItemDescription] as! String
    }
}

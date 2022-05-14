//
//  Request.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/14/22.
//

import Foundation
import Firebase
class Request{
    var id : String?
    var requestLocation : String
    var message : String
    var itemProposed : [String : Bool]
    var itemRequested : String
    var moneyOffered : Int
    var fromUser : String
    var status : String
    init (doc : DocumentSnapshot ){
        let data=doc.data()
        self.id=doc.documentID
        self.requestLocation=data?[kRequestLocation] as? String ?? ""
        self.message=data?[kRequestMessage] as? String ?? ""
        self.itemProposed=data?[kItemProposed] as? [String : Bool] ??  [String:Bool]()
        self.moneyOffered=data?[kMoneyOffered] as? Int ?? 0
        self.itemRequested=data?[kItemRequested] as? String ?? ""
        self.fromUser=data?[kFromUser] as? String ?? ""
        self.status=data?[kStatus] as? String ?? "pending"
    }
    
    
    init(location:String, money:Int, fromUser:String, itemProposed:[String:Bool], itemRequested:String, message:String, status: String){
        self.requestLocation=location
        self.moneyOffered=money
        self.fromUser=fromUser
        self.itemRequested=itemRequested
        self.message=message
        self.itemProposed=itemProposed
        self.status=status
    }
}

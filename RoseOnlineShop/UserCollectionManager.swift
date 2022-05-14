//
//  UserCollectionManager.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/13/22.
//

import Foundation
//
//  UsersCollectionManager.swift
//  Groupchat
//
//  Created by Yuanhang on 5/6/22.
//
import Firebase
class UsersCollectionManager{
    var _collectionRef : CollectionReference
    var latestUsers: [String : DocumentSnapshot]
    var listener : ListenerRegistration?

    public init(){
        _collectionRef=Firestore.firestore().collection(kUsersCollectionPath)
        latestUsers =  [String : DocumentSnapshot]()
    }
    
    func startListening(changeListener: @escaping (() -> Void)){
        var query = _collectionRef
        self.listener = query.addSnapshotListener({ querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("error fetching document")
                return
            }
            
            self.latestUsers.removeAll()
            for document in documents{
                self.latestUsers[document.documentID ]=document
                
            }
            print("LOADING")
            changeListener()
        })
    }
    
    func stopListening(){
        self.listener?.remove()
    }
    
    func getFullName(uid:String) -> String{
        if latestUsers[uid] != nil {
            var data=latestUsers[uid]!.data()
            var displayName = data?[kDisplayName] as! String
            return displayName
        }else{
            return "User not found"
        }
    }
    


}
    
    
    
    
    


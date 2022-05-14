//
//  ItemDocumentManager.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/13/22.
//

import Foundation
//
//  GroupDocumentManager.swift
//  Groupchat
//
//  Created by Yuanhang on 5/6/22.
//


import Firebase

class ItemDocumentManager {

    var _collectionRef: CollectionReference
    var item : Item?
    var listener : ListenerStrategy
  
    
    public init() {
        _collectionRef = Firestore.firestore().collection(kItemCollectionPath)
        listener=ListenerStrategy()
        
    }

    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void)) {
        let query=_collectionRef.document(documentId)
        listener.listenForOneDoc(query: query) { doc in
            self.item=Item(doc: doc)
            changeListener()
        }
    }
    
    func stopListening(){
        listener.stopListening()
    }
    
    

    
   
    
}
    
    

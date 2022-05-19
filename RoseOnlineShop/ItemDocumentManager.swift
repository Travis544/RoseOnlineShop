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
    var cudStrategy : CUDStrategy
    
    public init() {
        _collectionRef = Firestore.firestore().collection(kItemCollectionPath)
        listener=ListenerStrategy()
        cudStrategy=CUDStrategy()
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
    
    func updateAvailability(isAvailable : Bool){
        if let item=item{
            let docRef=_collectionRef.document(item.id!)
            let data=[kItemAvailable: isAvailable]
            cudStrategy.update(documentRef: docRef, data: data)
        }
    }
    
    func updateDescription(newDesc : String){
        if let item=item{
            let docRef=_collectionRef.document(item.id!)
            let data=[kItemDescription: newDesc]
            cudStrategy.update(documentRef: docRef, data: data)
        }
    }

    
   
    
}
    
    

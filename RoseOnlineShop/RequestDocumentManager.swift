//
//  RequestDocumentManager.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/19/22.
//

import Foundation
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

class RequestDocumentManager {

    var _collectionRef: CollectionReference
    var request : Request?
    
    var listener : ListenerStrategy
    var cudStrategy : CUDStrategy
    
    public init() {
        _collectionRef = Firestore.firestore().collection(kRequestCollectionPath)
        listener=ListenerStrategy()
        cudStrategy=CUDStrategy()
    }
    

    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void)) {
        let query=_collectionRef.document(documentId)
        listener.listenForOneDoc(query: query) { doc in
            self.request=Request(doc: doc)
            changeListener()
        }
    }
    
    func stopListening(){
        listener.stopListening()
    }
    
    func update(location : String, message : String, offerPrice : Int){
        if let request = request {
        
            let docRef=self._collectionRef.document(request.id!)
            let data=[
                kRequestLocation : location,
                kRequestMessage : message,
                kMoneyOffered : offerPrice
            ] as [String : Any]
            cudStrategy.update(documentRef: docRef, data: data)
        }

    }
    
    

    
   
    
}
    
    

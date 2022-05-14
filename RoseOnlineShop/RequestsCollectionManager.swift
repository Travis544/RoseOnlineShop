//
//  RequestsCollectionManager.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/14/22.
//

import Foundation
import Firebase
class RequestCollectionMaanger{
    var _collectionRef: CollectionReference
    var listener : ListenerStrategy
    var latestRequests: [Request]
    var cudStrategy : CUDStrategy
//    var recentlyAddedItem : String?
    
    
    public init() {
        _collectionRef = Firestore.firestore().collection(kRequestCollectionPath)
        listener=ListenerStrategy()
        latestRequests = [Request]()
       cudStrategy=CUDStrategy()
//        recentlyAddedItem = nil
    }
    
    
    public func startListening(uid:String,changeListener: @escaping (() -> Void)){
        var query = _collectionRef.limit(to: 50)
        query.order(by: "created")
        
        query = query.whereField(kFromUser, isEqualTo: uid)

        listener.listenForCollection(query: query) { docs in
            self.latestRequests.removeAll()
            for doc in docs{
                print(doc.data())
                self.latestRequests.append(Request(doc: doc))
            }
            print("UPATE!!!!")
            print(self.latestRequests)
            changeListener()
        }
    }
    
    public func stopListening(){
        listener.stopListening()
    }
    
    public func addRequest(request : Request){
       var data=[
        kRequestMessage: request.message,
        kFromUser: request.fromUser,
        kMoneyOffered: request.moneyOffered,
        kItemProposed: request.itemProposed,
        kItemRequested: request.itemRequested,
        kStatus: request.status,
        kRequestLocation: request.requestLocation
       ] as [String : Any]
        
        self.cudStrategy.add(collectionRef: self._collectionRef, data: data) { docRef in
            print(docRef.documentID)
            print("ADDED SUCCESSFULLY")
        }
    }
    
    
    
}

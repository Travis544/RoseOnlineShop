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
    var isListeningForItemRequest : Bool
//    var recentlyAddedItem : String?
    
    
    public init() {
        _collectionRef = Firestore.firestore().collection(kRequestCollectionPath)
        listener=ListenerStrategy()
        latestRequests = [Request]()
       cudStrategy=CUDStrategy()
        isListeningForItemRequest = false
//        recentlyAddedItem = nil
    }
    
    

    public func getUserRequest(uid : String) -> Request?{
        for request in latestRequests {
            if request.fromUser==uid{
              return request
            }
        }
        
       return nil
    }
    
    
    public func didUserMakeRequest(uid : String) -> Bool{
        for request in latestRequests {
            if request.fromUser==uid{
                return true
            }
        }
        
        return false
    }
    
    public func startListening(uid:String?, itemID:String?, changeListener: @escaping (() -> Void)){
        isListeningForItemRequest=false
        var query = _collectionRef.order(by: kStatus).order(by: "created")
        if let uid=uid{
            query=query.whereField(kFromUser, isEqualTo: uid)
        }

        if let itemID = itemID {
            isListeningForItemRequest=true
            query=query.whereField(kItemRequested, isEqualTo: itemID)
        }
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
        kRequestLocation: request.requestLocation,
        "created": Timestamp.init()
       ] as [String : Any]
        
        self.cudStrategy.add(collectionRef: self._collectionRef, data: data) { docRef in
            print(docRef.documentID)
            print("ADDED SUCCESSFULLY")
        }
    }
    
    public func acceptRequest(id : String){
        print("REQUEST ACCEPTED!!!")
        var docRef=self._collectionRef.document(id)
        let data=[kStatus:"accepted"]
        cudStrategy.update(documentRef: docRef,
                           data:data)
        
        if isListeningForItemRequest{
            for request in latestRequests {
                if request.id != id{
                    rejectRequest(id: request.id!)
                }
            }
        }
        
    }
    
    public func rejectRequest(id : String){
        let data=[kStatus:"rejected"]
        let docRef=self._collectionRef.document(id)
        cudStrategy.update(documentRef: docRef, data: data)
    }
    
    
    
}

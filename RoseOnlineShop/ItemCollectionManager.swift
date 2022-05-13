//
//  ItemCollectionManager.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/13/22.
//

import Foundation
import Firebase
class ItemCollectionManager{
    var _collectionRef: CollectionReference
    var listener : ListenerStrategy
    var latestItems: [Item]
//    var cudStrategy : CUDStrategy
    var recentlyAddedItem : String?
    
    
    public init() {
        _collectionRef = Firestore.firestore().collection(kItemCollectionPath)
        listener=ListenerStrategy()
        latestItems = [Item]()
//        cudStrategy=CUDStrategy()
        recentlyAddedItem = nil
    }
    
    
    public func startListening(byCategory: String?, byAuthor : String?, changeListener: @escaping (() -> Void)){
        var query = _collectionRef.limit(to: 50)
        query.order(by: kItemLastTouched)
        if let byCategory=byCategory{
            query = query.whereField(kItemCategory, isEqualTo:byCategory)
        }
        
        if let authorFilter = byAuthor{
            query=query.whereField(kItemOwner, isEqualTo:authorFilter)
//        }
        }
        listener.listenForCollection(query: query) { docs in
            self.latestItems.removeAll()
            for doc in docs{
                self.latestItems.append(Item(doc: doc))
            }
            print("UPATE!!!!")
            print(self.latestItems)

            changeListener()
        }
    }
    
    public func addItem(item : Item) {
//        print(album.albumMembers)
////
//        let data=[
//            kAlbumName :  album.name,
//            kAlbumOwner: album.owner,
//            kAlbumMembers: album.albumMembers,
//            kCoverImage : album.coverImage,
//            kAlbumCreated: Timestamp.init()
//        ] as [String : Any]
//        cudStrategy.add(collectionRef: _collectionRef, data: data){ docRef in
//            self.recentlyAddedAlbum = docRef.documentID
//        }
    }
    
//    public func deleteAlbum(docId : String){
//        cudStrategy.delete(self._collectionRef, docId)
//    }
    
    public func stopListening(){
        listener.stopListening()
    }

}

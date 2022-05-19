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
    
    var idToItem : [String : Item]
    
    public init() {
        _collectionRef = Firestore.firestore().collection(kItemCollectionPath)
        listener=ListenerStrategy()
        latestItems = [Item]()
        idToItem = [String : Item]()
//        cudStrategy=CUDStrategy()
        recentlyAddedItem = nil
    }
    
    
    public func getItemById(id : String) -> Item?{
        return idToItem[id]
    }
    
    

    public func startListening(byCategory: String?, byAuthor : String?, changeListener: @escaping (() -> Void)){
        var query = _collectionRef.limit(to: 50)
        query=query.order(by: kItemLastTouched)
        
        query = query.whereField(kItemAvailable, isEqualTo: true)
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
                print(doc.data())
                self.latestItems.append(Item(doc: doc))
                self.idToItem[doc.documentID]=Item(doc: doc)
            }
            print("UPATE!!!!")
            print(self.latestItems)

            changeListener()
        }
    }
    
    
//    func startListening(filterByAuthor authorFilter: String?, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
//        var query = _collectionRef.limit(to: 50)
//        query.order(by: kItemLastTouched)
//        
//    }
    
    
    
    public func getAvailableTradingItems() -> [Item]{
        var res = [Item]()
        for item in latestItems{
            if item.isAvailable&&item.isTradable{
                res.append(item)
            }
        }
        
        return res
    }
    
    public func addItem(item : Item) {
//        print(album.albumMembers)
        var ref: DocumentReference? = nil
        ref = _collectionRef.addDocument(data:[
            kItemCategory:item.category,
            kItemDescription:item.description,
            kItemImage:item.imageUrl,
            kItemAvailable:item.isAvailable,
            kItemIsBuyable:item.isBuyable,
            kItemTradable:item.isTradable,
            kItemOwner:item.owner,
            kItemName:item.name,
            kItemLastTouched:Timestamp.init(),
            
        ])

    }
    
//    public func deleteAlbum(docId : String){
//        cudStrategy.delete(self._collectionRef, docId)
//    }
    
    public func stopListening(){
        listener.stopListening()
    }

}

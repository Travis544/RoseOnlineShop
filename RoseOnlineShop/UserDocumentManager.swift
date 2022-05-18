//
//  UserDocumentManager.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/7/22.
//

import Foundation
//
//  UserDocumentManager.swift
//  Groupchat
//
//  Created by Yuanhang on 5/3/22.
//
import Firebase
import Foundation
class UserDocumentManager {
    
    var _latestDocument : DocumentSnapshot?
    static let shared = UserDocumentManager()
    var _collectionRef: CollectionReference
    var listener : ListenerStrategy
    var displayName : String{
        return _latestDocument?.data()?[kDisplayName] as! String ?? ""
    }
    
    var displayEmail : String{
        return _latestDocument?.data()?[kUserEmail] as! String ?? ""
    }
    
    var imageUrl : String{
        return _latestDocument?.data()?[kImageUrl] as! String ?? ""
    }
//    var userEmail : String{
//        return _latestDocument?.documentID ?? ""
//    }
    
    
    
    private init() {
        _collectionRef = Firestore.firestore().collection(kUsersCollectionPath)
        listener = ListenerStrategy()
    }
    
    
    func addNewUserMaybe(uid : String, displayName: String?, email : String?, url : String,
                         finishedListener: @escaping (() -> Void)){
//        get the user document for this uid
//        if it exist do nothing
//        if there is not user document, make it using the name and photo url
        let docRef = _collectionRef.document(uid)
        
        docRef.getDocument { document, error in
            if let document=document, document.exists{
                print("Document exist. Do nothin. Here is the data: \(document.data()!)")
                finishedListener()
            }else{
                print("Document does not exist. Create this user")
                docRef.setData([kDisplayName : displayName ?? "",
                                   kUserEmail:email,
                                     kImageUrl: url
                               ])
                finishedListener()
            }
        }
    }
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void))  {
        let query = _collectionRef.document(documentId)
        self._latestDocument=nil
        self.listener.listenForOneDoc(query: query) { doc in
            self._latestDocument = doc
            changeListener()
        }
    }
    

    
    func stopListening() {
        listener.stopListening()
    }
    
    func updateName(name: String) {
        _collectionRef.document(_latestDocument!.documentID).updateData([
            kDisplayName: name
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
}
    
    

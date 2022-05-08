//
//  ListenerStrategy.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/7/22.
//

import Foundation
//
//  ListenerStrategy.swift
//  Groupchat
//
//  Created by Yuanhang on 5/6/22.
//
import Firebase
class ListenerStrategy{
    var _listener: ListenerRegistration?
    
    
    public init() {
    }
    
    func listenForOneDoc(query : DocumentReference, changeListener: @escaping ((_ doc : DocumentSnapshot) -> Void)) {
      
        _listener = query.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard document.data() != nil else {
              print("Document data was empty.")
              return
            }
//            print("Current data: \(data)")
            changeListener(document)
          }
    }
    
    func stopListening() {
        _listener?.remove()
    }
    
}


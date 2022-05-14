//
//  CUDStrategy.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/14/22.
//

import Foundation
import Firebase
class CUDStrategy{
    
    func delete(_ collectionRef : CollectionReference, _ documentId : String ){
        
        collectionRef.document(documentId).delete() {
            err in
            if let err = err{
                print("error removing document :\(err)")
            }else{
                print("document removed successfully ")
            }
        }
    }
    

    
    func add(collectionRef : CollectionReference, data : [String : Any], changeListener: @escaping ((_ docRef : DocumentReference) -> Void)){
        var ref : DocumentReference? = nil
        ref = collectionRef.addDocument(data: data) {err in
            if let err=err{
                print("Error adding document \(err)")
                
            }else{
                print("Document added with id \(ref)")
                changeListener(ref!)
            }
        }
    }
    
    func update(documentRef : DocumentReference, data: [String : Any]){
        documentRef.updateData(data)
    }
    
   
    
    
    
    
}

//
//  OrderRequestViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/14/22.
//

import UIKit
import SwiftUI

class OrderRequestViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var priceStack: UIStackView!
    
    @IBOutlet weak var priceField: UITextField!
    
    @IBOutlet weak var itemTradeView: UIScrollView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    var itemId : String!
    var itemManager : ItemDocumentManager!
    var itemAdded=[String : Bool]();
    var requestManager : RequestCollectionMaanger!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.isHidden=false
       
        if let item=itemManager.item{
            print(item.isBuyable)
            
            if item.isBuyable{
                priceStack.isHidden=false
            }else{
                priceStack.isHidden=true
            }
        }
        
        requestManager=RequestCollectionMaanger()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func pressedSubmitOffer(_ sender: Any) {
        var price : Int = 0
        if !priceField.isHidden{
            price = Int(priceField.text!) ?? 0
        }
        let message=messageTextField.text!
        let location = locationTextField.text!
        let itemRequested=self.itemId ?? ""
    
        let request = Request(location: location, money:price, fromUser:"", itemProposed: self.itemAdded, itemRequested:itemRequested, message: message, status: "pending"  )
        
        requestManager.addRequest(request: request)
        
        
    }
   

    @IBAction func pressedItemToTrade(_ sender: Any) {
        showSelectDialog()
    }
    
    func showSelectDialog(){
        let alertController  = UIAlertController(title:"Choose an option" , message: "",preferredStyle: UIAlertController.Style.alert)

        //        configure
        let cancelAction = UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler:nil)
//        add to alert controller the cancel action
        let createNewAction=UIAlertAction(title:"Create group",
                                            style: UIAlertAction.Style.default){
            action in
            
        }
        
        let selectExisting=UIAlertAction(title:"Create group",
                                            style: UIAlertAction.Style.default){
            action in
            
        }
//        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        alertController.addAction(createNewAction)
        present(alertController, animated: true, completion: nil)
    }
    
//    func showAddNewItemDialog(){
//        let alertController  = UIAlertController(title:"Choose an option" , message: "",preferredStyle: UIAlertController.Style.alert)
//
//        alertController.addTextField { textField in
//            textField.placeholder="Item name"
//        }
//
//
//
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

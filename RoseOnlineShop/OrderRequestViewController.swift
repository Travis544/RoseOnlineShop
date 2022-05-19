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
    
    @IBOutlet weak var selectedItemImageView: UIImageView!
    
    @IBOutlet weak var itemSelectedForTradeLabel: UILabel!
    
    @IBOutlet weak var itemToTradeStack: UIStackView!
    
    @IBOutlet weak var addItemTradeButton: UIButton!
    var itemId : String!
    var itemManager : ItemDocumentManager!
    
    var requestManager : RequestCollectionMaanger!
//    to get the current user's items that are available for trade
    var itemCollectionManager : ItemCollectionManager!
    var imageUtil : ImageUtils!
    
    var itemToTrade : Item?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        itemToTrade=nil
        messageTextField.isHidden=false
       imageUtil=ImageUtils()
        if let item=itemManager.item{
            print(item.isBuyable)
            
            if item.isBuyable{
                priceStack.isHidden=false
            }else{
                priceStack.isHidden=true
            }
            
            
            if item.isTradable{
                itemToTradeStack.isHidden=false
                addItemTradeButton.isHidden=false
            }else{
                itemToTradeStack.isHidden=true
                addItemTradeButton.isHidden=true
            }
        }
        
        requestManager=RequestCollectionMaanger()
        itemCollectionManager = ItemCollectionManager()
        itemCollectionManager.startListening(byCategory: nil, byAuthor: AuthManager.shared.currentUser!.uid) {
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    
    @IBAction func pressedSubmitOffer(_ sender: Any) {
        var price : Int = 0
        if !priceField.isHidden{
            price = Int(priceField.text!) ?? 0
        }
        
        if let item=itemManager.item{
            
            if item.isTradable&&item.isBuyable{
                if self.priceField.text!.isEmpty && itemToTrade==nil{
                    return
                }
            }else if item.isTradable{
                if itemToTrade==nil{
                    return
                }
            }else if item.isBuyable{
                if self.priceField.text!.isEmpty{
                    return
                }
            }
            
            var itemAdded=[String : Bool]();
            if let itt=self.itemToTrade{
                itemAdded[itt.id!]=true
            }
            
            
            let message=messageTextField.text!
            let location = locationTextField.text!
            let itemRequested=self.itemId ?? ""
        
            let request = Request(location: location, money:price, fromUser:AuthManager.shared.currentUser!.uid, itemProposed: itemAdded, itemRequested:itemRequested, message: message, status: "pending")
            
            requestManager.addRequest(request: request)
            self.performSegue(withIdentifier: kProposeOfferSegue, sender: self)
        }
    }
   

    @IBAction func pressedItemToTrade(_ sender: Any) {
        showItemToSelectForTrade()
    }
    
    
    func showItemToSelectForTrade(){
        let items = itemCollectionManager.getAvailableTradingItems()
      let alertController  = UIAlertController(title:"Choose an item" , message: "",preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler:nil)
        
        for item in items {
            let chooseItemAction=UIAlertAction(title:item.name,
                                               style: UIAlertAction.Style.default
            ){ action in
                self.selectItem(item: item)
            }
            
            alertController.addAction(chooseItemAction)
        }
        
        present(alertController, animated:true)
    }
    
    
    
    func selectItem(item : Item){
        imageUtil.load(imageView: self.selectedItemImageView, from: item.imageUrl)
        itemSelectedForTradeLabel.text=item.name
        self.itemToTrade=item
    }
    
    func showSelectDialog(){
        let alertController  = UIAlertController(title:"Choose an option" , message: "",preferredStyle: UIAlertController.Style.alert)

        //        configure
        let cancelAction = UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler:nil)
//        add to alert controller the cancel action
        let createNewAction=UIAlertAction(title:"Create new item",
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

//
//  ItemDetailViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/13/22.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var tradeLabel: UILabel!
    @IBOutlet weak var buyerLabel: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    
  
    @IBOutlet weak var soldByLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userBox: UIStackView!
    var itemId : String!
    var imageUtil = ImageUtils()
    var itemManger : ItemDocumentManager!
//    var userManager : UserDocumentManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDescription.isEditable=false
        itemManger=ItemDocumentManager()
//        userManager=UserDocumentManager()
        itemManger.startListening(for: itemId) {
            if let item=self.itemManger.item{
                UserDocumentManager.shared.startListening(for: item.owner) {
                        self.updateView()
                }
            }
            
            
        }
        
       
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func updateUserBox(userName : String, imageUrl:String ){
        userBox.isHidden=userName.isEmpty && imageUrl.isEmpty
        soldByLabel.text=userName
        imageUtil.load(imageView: userProfileImage, from: imageUrl)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       itemManger.stopListening()
    }
    
    
    
    func showOrHideTradeBuyLabel(item : Item){
        if item.isTradable{
            tradeLabel.isHidden=false
            tradeLabel.text="Looking to trade"
        }else{
            tradeLabel.isHidden=true
        }
        
        if item.isBuyable{
            buyerLabel.isHidden=false
            buyerLabel.text = "Looking for buyers"
        }else{
            buyerLabel.isHidden=true
        }
        
        updateUserBox(userName: UserDocumentManager.shared.displayName, imageUrl: UserDocumentManager.shared.imageUrl)
    }
    
    
    func updateView(){
        if let item=itemManger.item{
            itemName.text=item.name
            itemDescription.text=item.description
            showOrHideTradeBuyLabel(item: item)
            imageUtil.load(imageView: itemImage, from: item.imageUrl)
        }
    
    }
    

    @IBAction func pressedProposedOffer(_ sender: Any) {
        
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier==kProposeOfferSegue{
            var dest : OrderRequestViewController = segue.destination as! OrderRequestViewController
            dest.itemManager=self.itemManger
            dest.itemId=itemId
        }
    }
    

}

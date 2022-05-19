//
//  RequestDetailViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/19/22.
//

import UIKit

class RequestDetailViewController: UIViewController {
    @IBOutlet weak var itemOfferStackView: UIStackView!
   
    @IBOutlet weak var offerStack: UIStackView!
    
    @IBOutlet weak var messageField: UITextView!
    
    @IBOutlet weak var updateRequestButton: UIButton!
    @IBOutlet weak var changeItemTradeButton: UIButton!
    
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var offerPriceField: UITextField!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemOfferedImage: UIImageView!

    @IBOutlet weak var contactInfoField: UITextField!
    var requestManager : RequestDocumentManager!
//    will be passed in
//    var itemManager : ItemDocumentManager!
    var item : Item?
    var requestID : String!

    var imageUtils = ImageUtils()
    var itemToTradeManager : ItemDocumentManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requestManager = RequestDocumentManager()
        itemToTradeManager = ItemDocumentManager()
        
        requestManager.startListening(for: requestID) {
            if let request = self.requestManager.request{
                if request.fromUser != AuthManager.shared.currentUser!.uid{
                    self.locationField.isEnabled=false
                    self.offerPriceField.isEnabled=false
                    self.messageField.isEditable=false
                    self.updateRequestButton.isHidden=true
                    self.changeItemTradeButton.isHidden=true
                    self.contactInfoField.isEnabled=false
                }
                    
                if request.itemProposed.count != 0{                self.itemToTradeManager.startListening(for: request.itemProposed.first!.key) {
                    
                    self.updateItemOfferedImage()
                    
                    }
                }else if request.itemProposed.count==0{
                    self.itemOfferStackView.isHidden=true
                }
                
                self.messageField.isHidden=false
                self.updateView(request: request)
                
                UserDocumentManager.shared.startListening(for: request.fromUser) {
                    self.contactInfoField.text=UserDocumentManager.shared.displayEmail
                }

                
            }
            
        }
        
        
        if let item=item{
            if !item.isBuyable{
                offerStack.isHidden=false
            }
        }
//            if !item.isTradable{
//                itemOfferStackView.isHidden=true
//            }
        
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        userDocumentManager.stopListening()
//
//    }
//
    
    func updateView(request : Request){
        locationField.text=request.requestLocation
        offerPriceField.text = "\(request.moneyOffered)"
        messageField.text=request.message
        print(messageField.text)
    }
    
    
    func updateItemOfferedImage(){
        if let item=itemToTradeManager.item{
            imageUtils.load(imageView: itemOfferedImage, from: item.imageUrl)
            itemNameLabel.text=item.name
        }
        
        
        
    }
    
    
    @IBAction func pressedUpdateRequestButton(_ sender: Any) {
        let location = self.locationField.text
        let offerPrice = self.offerPriceField.text
        let message=self.messageField.text
        requestManager.update(location: location!, message: message!, offerPrice: Int(offerPrice!) ?? 0)
    }
    
    
    @IBAction func pressedView(_ sender: Any) {
        print("PRESSED VIEW")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

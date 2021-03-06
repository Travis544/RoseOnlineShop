//
//  MyItemsTableViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/16/22.
//

import UIKit

class MyListingTableViewCell : UITableViewCell{
    @IBOutlet weak var listingNameLabel: UILabel!
    @IBOutlet weak var soldByLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tradeLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
}

class MyItemsTableViewController: UITableViewController {
    var category : String!
    var imageUtil : ImageUtils!
    var itemManager : ItemCollectionManager!
    var userManager : UsersCollectionManager!
    var requestManager : RequestCollectionMaanger!
    var isItemPrivate=false
    override func viewDidLoad() {
        super.viewDidLoad()
        isItemPrivate=false
        imageUtil=ImageUtils()
        itemManager=ItemCollectionManager()
        userManager=UsersCollectionManager()
        userManager.startListening {
        }
        requestManager=RequestCollectionMaanger()
        
        requestManager.startListening(uid: AuthManager.shared.currentUser!.uid, itemID: nil) {
          self.tableView.reloadData()
        }
        
        
        self.itemManager.startListening(available:nil, byCategory:nil, byAuthor:AuthManager.shared.currentUser!.uid) {
            self.tableView.reloadData()
        }
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
//                                                            target: self,
//                                                            action: #selector(showAddQuoteDialog))
        
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"☰", style: .plain, target: self, action: #selector(showMenu))
        
    }
    
    
    
    @objc func showAddQuoteDialog() {
            let alertController = UIAlertController(title: "Create a new Post",
                                                    message: "",
                                                    preferredStyle: UIAlertController.Style.alert)
            
            alertController.addTextField { textField in
                textField.placeholder = "Category"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Image Url"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Description"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Name"
            }
        
            alertController.addTextField { textField in
                textField.placeholder = "Is the Item for Purchase?(yes/no)"
            }
            alertController.addTextField { textField in
                textField.placeholder = "Is the Item for Trade?(yes/no)"
            }
        
            
            // Cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
                print("You pressed cancel")
            }
        
        
            alertController.addAction(cancelAction)
       
        
    
            // Positive button
            let createPhotoAction = UIAlertAction(title: "Add Post", style: UIAlertAction.Style.default) { action in
                print("You pressed create post")
                
                let categoryField = alertController.textFields![0] as UITextField
                let imageField = alertController.textFields![1] as UITextField
                let descriptionField = alertController.textFields![2] as UITextField
                let nameField = alertController.textFields![3] as UITextField
                let buyableField = alertController.textFields![4] as UITextField
                let tradeableField = alertController.textFields![5] as UITextField
                
                var buyState = Bool()
                var tradeState = Bool()
                if buyableField.text! == "yes"{
                    buyState = true
                }else {
                    buyState = false
                }
                
                if tradeableField.text! == "yes"{
                    tradeState = true
                }else {
                    tradeState = false
                }

                
                let item = Item(category:  categoryField.text!, imageUrl: imageField.text!, name: nameField.text!, owner: AuthManager.shared.currentUser!.uid, isAvailable: true, description: descriptionField.text!, isTradable: tradeState, isBuyable: buyState)
                self.itemManager.addItem(item: item)
                
            }
            alertController.addAction(createPhotoAction)
                // finish calling upload
            present(alertController, animated: true)
            
            
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(itemManager.latestItems.count)
        return itemManager.latestItems.count
    }
    
    @objc func showMenu(){
        //TODO: SHOW AN ACTION SHEET
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("Canceled")
        }
        
        let showAddItemDialogAction = UIAlertAction(title: "Add An Item", style: UIAlertAction.Style.default) { action in
            self.showAddQuoteDialog()
        }
        
        let deleteItemDialogAction = UIAlertAction(title: "Delete An Item", style: UIAlertAction.Style.default) { action in
            self.tableView.setEditing(!self.tableView.isEditing, animated: true )
        }
        
//
//        let signOutAction=UIAlertAction(title: "Sign out", style: UIAlertAction.Style.default) { action in
//            AuthManager.shared.signOut()
//        }
//
        
        alertController.addAction(deleteItemDialogAction)
        alertController.addAction(showAddItemDialogAction)
        //alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMyItemListingCell, for: indexPath) as! MyListingTableViewCell
        // Configure the cell...
        let item = itemManager.latestItems[indexPath.row]
        print("did run")
        if item.isTradable{
            cell.tradeLabel.isHidden=false
            cell.tradeLabel.text="Looking to trade"
        }else{
            cell.tradeLabel.isHidden=true
        }
        
        if item.isBuyable{
            cell.priceLabel.isHidden=false
            cell.priceLabel.text = "Looking for buyers"
        }else{
            cell.priceLabel.isHidden=true
        }
        
        cell.listingNameLabel.text = item.name
        var solder = userManager.getFullName(uid: item.owner)
        cell.soldByLabel.text = "Sold by:\(solder)"
        imageUtil.load(imageView: cell.itemImageView, from: item.imageUrl)
        

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        let item=self.itemManager.latestItems[indexPath.row]
        return item.isAvailable
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let id=itemManager.latestItems[indexPath.row].id{
               self.itemManager.deleteItem(itemId: id)
                var requestManagerForItem : RequestCollectionMaanger! = RequestCollectionMaanger()
                requestManagerForItem.startListening(uid: nil, itemID: id) {
                    requestManagerForItem.deleteRequestsForItems(itemID: id)
                    requestManagerForItem.stopListening()
                }
                
                
            }
//            delete all request associated with item
    
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier==kMyItemDetailSegue{
            let idtvc=segue.destination as! MyItemDetailWithRequestTableViewController
            if let indexPath=tableView.indexPathForSelectedRow{
                let id=itemManager.latestItems[indexPath.row].id
                idtvc.itemID=id
            }
        }
    }
    

}

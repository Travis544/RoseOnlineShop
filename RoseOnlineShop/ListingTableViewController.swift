//
//  ListingTableViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/13/22.
//

import UIKit


class ListingTableViewCell : UITableViewCell{
    @IBOutlet weak var listingNameLabel: UILabel!
    @IBOutlet weak var soldByLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tradeLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
}

class ListingTableViewController: UITableViewController {
    var category : String!
    var imageUtil : ImageUtils!
    var itemManager : ItemCollectionManager!
    var userManager : UsersCollectionManager!
    var requestManager : RequestCollectionMaanger!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageUtil=ImageUtils()
        itemManager=ItemCollectionManager()
        print(category)
        userManager=UsersCollectionManager()
        userManager.startListening {
        }
        requestManager=RequestCollectionMaanger()
        
        requestManager.startListening(uid: AuthManager.shared.currentUser!.uid, itemID: nil) {
            self.itemManager.startListening(available: true, byCategory:self.category, byAuthor:nil ) {
                self.tableView.reloadData()
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemManager.latestItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kListingCell, for: indexPath)
        as! ListingTableViewCell
        let item = itemManager.latestItems[indexPath.row]
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
//        need to get user name here....
        
        var name = userManager.getFullName(uid: item.owner)
        cell.soldByLabel.text = "Sold by:\(name)"
        imageUtil.load(imageView: cell.itemImageView, from: item.imageUrl)
        
         let requests=requestManager.latestRequests
        print(requests)
         for req : Request in requests{
             print(req.itemRequested)
             if req.itemRequested==item.id{
                print("REQUEST EXISTS")
//                 cell.isUserInteractionEnabled=false
                 cell.isOpaque=true
//                 maybe make it tinted
             }
        }
    
        // Configure the cell...
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        
        if segue.identifier==kItemDetailSegue{
            let idvc=segue.destination as! ItemDetailViewController
            
            if let indexPath=tableView.indexPathForSelectedRow{
                let id=itemManager.latestItems[indexPath.row].id
                idvc.itemId=id
            }
        }
    
        
    }
    

}

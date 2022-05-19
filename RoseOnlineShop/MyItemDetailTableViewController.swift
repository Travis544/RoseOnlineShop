//
//  MyItemDetailTableViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/18/22.
//

import UIKit

class ItemRequestTableViewCell : UITableViewCell{
    @IBOutlet weak var requestFromUserLabel: UILabel!
    @IBOutlet weak var tradeOfferedLabel: UILabel!
    @IBOutlet weak var moneyOfferedLabel: UILabel!
}


class MyItemDetailWithRequestTableViewController: UITableViewController {
    @IBOutlet weak var itemImage : UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var tradeLabel: UILabel!
    
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var buyLabel: UILabel!
    var itemManager : ItemDocumentManager!
    var itemID : String!
    var requestManager : RequestCollectionMaanger!
    var userCollectionManager : UsersCollectionManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestManager = RequestCollectionMaanger()
        itemManager = ItemDocumentManager()
        userCollectionManager = UsersCollectionManager()
        itemManager.startListening(for: itemID) {
            self.requestManager.startListening(uid: nil, itemID: self.itemManager.item!.id) {
                
                if let item=self.itemManager.item{
                    self.itemNameLabel.text=item.name
                    TradeBuyLabelController.shared.controlLabels(item: item, tradeLabel: self.tradeLabel, buyLabel: self.buyLabel)
                }
                
                
                self.tableView.reloadData()
            }
            
            self.userCollectionManager.startListening {
                
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
//        need to change this
        return requestManager.latestRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kItemRequestTabelViewCell, for: indexPath)
        as! ItemRequestTableViewCell

        // Configure the cell...
        let request : Request = requestManager.latestRequests[indexPath.row]
        let userID=request.fromUser
        cell.requestFromUserLabel.text=userCollectionManager.getFullName(uid: userID)
        if let item=self.itemManager.item{
            TradeBuyLabelController.shared.controlLabels(item: item, tradeLabel: cell.tradeOfferedLabel, buyLabel: cell.moneyOfferedLabel)
            
            cell.moneyOfferedLabel.text = "Money offered:\(request.moneyOffered)"
        }
//        cell.tradeOfferedLabel.text = " "
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

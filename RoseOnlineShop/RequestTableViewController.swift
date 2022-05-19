//
//  RequestTableViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/16/22.
//

import UIKit
class RequestTableViewCell : UITableViewCell{
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tradeOfferLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    func determineStatusLabel(status : String){
        switch status {
        case "pending":
           
            self.statusLabel.textColor = UIColor.systemOrange
        case "rejected":
            statusLabel.textColor = UIColor.systemRed
            rejectStatus()
        case "accepted":
            
            statusLabel.textColor = UIColor.systemGreen
            acceptStatus()
        default:
            statusLabel.textColor = UIColor.black
        }
    }
    
    func acceptStatus(){
        
    }
    
    func rejectStatus(){
        
    }
}


class RequestTableViewController: UITableViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    var requestManager : RequestCollectionMaanger!
    var itemManager : ItemCollectionManager!
    var userManager : UserDocumentManager!
    var imageUtils = ImageUtils()
    
    override func viewDidLoad() {
//
       super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 300
////        self.tableView.rowHeight=UITableView.automaticDimension
//
//
//
//                // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestManager = RequestCollectionMaanger()
        itemManager=ItemCollectionManager()
        requestManager.startListening(uid: AuthManager.shared.currentUser!.uid, itemID:nil) {

            self.itemManager.startListening(byCategory: nil, byAuthor: nil) {
                 self.tableView.reloadData()
                 print("Listening to items")
             }
            
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return requestManager.latestRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRequestTableViewCell, for: indexPath) as! RequestTableViewCell

        // Configure the cell...
       
        let request=requestManager.latestRequests[indexPath.row]
//        cell.statusLabel.text=request.status
        if let item = itemManager.idToItem[request.itemRequested]{
            cell.itemLabel.text = item.name
            print("LOADING \(item.imageUrl)")
            imageUtils.load(imageView: cell.itemImageView, from: item.imageUrl)
            
            TradeBuyLabelController.shared.controlLabels(item: item, tradeLabel: cell.tradeOfferLabel, buyLabel: cell.priceLabel)
            
        }else{
            cell.itemLabel.text = "Item no longer exist"
        }
        
        if request.itemProposed.count==0{
            cell.tradeOfferLabel.text = "No item offered for trade"
        }else if let tradeItem = itemManager.idToItem[request.itemProposed.first?.key ?? ""]{
//        change this later
            cell.tradeOfferLabel.text = "Offered to trade for \(tradeItem.name)"
        }else{
            cell.tradeOfferLabel.text = "Item no longer exist"
        }
        
        cell.determineStatusLabel(status: request.status)
        cell.priceLabel.text="Amount offered $\(request.moneyOffered)"
        cell.statusLabel.text=request.status
        
        
        
        
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
        if segue.identifier==kItemDetailFromRequestSegue{
            let idvc = segue.destination as! ItemDetailViewController
            if let indexPath=tableView.indexPathForSelectedRow{
                let id=requestManager.latestRequests[indexPath.row].itemRequested
                idvc.itemId=id
            }
        }
    }
    

}

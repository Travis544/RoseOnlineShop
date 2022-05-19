//
//  RequestDetailViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/19/22.
//

import UIKit

class RequestDetailViewController: UIViewController {
    @IBOutlet weak var itemOfferStackView: UIStackView!
    var requestID : String!
    @IBOutlet weak var offerStack: UIStackView!
    
    @IBOutlet weak var messageField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

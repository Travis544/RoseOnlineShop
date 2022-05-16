//
//  SideNavViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/16/22.
//

import UIKit

class SideNavViewController: UIViewController {
    var tableViewController : ProfilePageViewController! {
            let navController = presentingViewController as! UINavigationController
            return navController.viewControllers.last as? ProfilePageViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pressedMyItems(_ sender: Any) {
        self.dismiss(animated: true)
        tableViewController.performSegue(withIdentifier: kMyItemsSegue, sender: self)
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

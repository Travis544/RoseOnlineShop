//
//  ProfilePageViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/16/22.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var userListenerRegistration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDocumentManager.shared.startListening(for: AuthManager.shared.currentUser!.uid){
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    @IBAction func nameChanged(_ sender: Any) {
        UserDocumentManager.shared.updateName(name: nameTextField.text!)
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)    }
    
    func updateView(){
        print("show the name")
        nameTextField.text = UserDocumentManager.shared.displayName
        print(UserDocumentManager.shared.displayName)
        emailTextField.text = UserDocumentManager.shared.displayEmail
        print(UserDocumentManager.shared.displayName)
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

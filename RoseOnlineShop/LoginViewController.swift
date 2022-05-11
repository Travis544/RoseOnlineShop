//
//  LoginViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/7/22.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    var rosefireName : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var loginHandle : AuthStateDidChangeListenerHandle!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginHandle=AuthManager.shared.addLoginObserver {
            self.performSegue(withIdentifier:kShowCategorySegue , sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AuthManager.shared.removeObserver(self.loginHandle)
    }
    
    

    @IBAction func pressedRoseFire(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate=self
        Rosefire.sharedDelegate().signIn(registryToken: kRoseFireRegistraryToken) { error, result in
            if let error = error{
                print("error signing in with RoseFire \(error)")
            }
            self.rosefireName=result?.name
            AuthManager.shared.signInWithRosefireToken(result!.token)
            
        }

    }
    
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        UserDocumentManager.shared.addNewUserMaybe(uid: AuthManager.shared.currentUser!.uid, displayName: self.rosefireName ?? AuthManager.shared.currentUser!.displayName ){
        }
        
    }
    

}

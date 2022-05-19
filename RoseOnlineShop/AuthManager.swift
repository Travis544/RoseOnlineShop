//
//  AuthManager.swift
//  PhotoBucket
//
//  Created by Yuanhang on 4/22/22.
//


import Foundation

import Firebase
import FirebaseAuth


class AuthManager{
    static let shared = AuthManager()
    private init(){
        
    }
    
    var isSignedIn : Bool{
        currentUser != nil
    }
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    func addLoginObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener{ auth, user in
            if(user != nil){
                callback()
            }
        }
    }
    
    func addLogoutObserver(callback: @escaping(()-> Void )) -> AuthStateDidChangeListenerHandle{
        return Auth.auth().addStateDidChangeListener { auth, user in
            if (user==nil){
                callback()
            }
        }
    }
    
    
    func removeObserver(_ authDidChangeHandle : AuthStateDidChangeListenerHandle?){
        if authDidChangeHandle != nil{
            Auth.auth().removeStateDidChangeListener(authDidChangeHandle!)
        }
    }
    
    func signInNewEmailPasswordUser(email: String, password : String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error=error{
                print("There was an error in creating the user \(error)")
                return
            }
            
            print("User created.")
        }
    }
    
    func loginExistingEmailPasswordUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error=error{
                print("There was an error in signing in \(error)")
                return
            }
            
            print("User signed in.")
        }
    }
    
    func signInWithRosefireToken(_ rosefireToken: String){
        Auth.auth().signIn(withCustomToken: rosefireToken) { authResult
            , error in
            if let error=error{
                print("error signing in \(error)")
                return
            }
            
        
        }
    }
    
    func signInWithGoogleCredential(_ googleCredential : AuthCredential){
        Auth.auth().signIn(with: googleCredential) { auth, error in
            print("GOOGLE SIGNED IN WITH FIREBASE")
        }
    }
//
    func signInAnonymously(){
        Auth.auth().signInAnonymously() {authResult, error in
            if let error = error{
                print("There was an error with anonymous sign in: \(error)")
                return
            }
            print("Anonymous sign in complete")
        }
    }
    
    
    func signOut(){
        do{
            try Auth.auth().signOut()
        } catch{
            print("Sign out failed \(error)")
        }
        
    }
}


//
//  ViewController.swift
//  Social App
//
//  Created by Lin Myat on 07/08/2021.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: keyUid) {
            print("ID not found in KEychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    @IBAction func FBLogin(_ sender: Any) {
        let facebookLogin = LoginManager()
        facebookLogin.logIn(permissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to Auth With FB - \(error)")
            }else if result?.isCancelled == true {
                print("User Canclled FB Auth")
            }else {
                print("Success Auth with FB")
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: {( user , error ) in
            if error != nil  {
                print("Unable to Auth with Firebase - \(error) ")
            }else {
                print("Successfully Auth with Firebase")
                if let userID = Auth.auth().currentUser?.uid {
                    self.completeSignIn(userID : userID)
                }
            }
        })
    }
    
    @IBAction func signInTap(_ sender: Any) {
        if let email = emailField.text,
           let passowrd = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: passowrd, completion: { (user , error) in
                if user != nil {
                    print("Email User Auth with Firebase")
                    if let userID = Auth.auth().currentUser?.uid {
                        self.completeSignIn(userID : userID)
                    }
                }else {
                    Auth.auth().createUser(withEmail: email, password: passowrd, completion: { ( user, error ) in
                        if error != nil {
                            print("Unable to Auth Firebase with Email")
                        }else {
                            print("Successfully Auth with Firebase")
                            if let userID = Auth.auth().currentUser?.uid {
                                self.completeSignIn(userID : userID)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(userID: String) {
        let keychainResult = KeychainWrapper.standard.set(userID, forKey: keyUid)
            print("Data saved to keychain \(keychainResult)")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
}
    



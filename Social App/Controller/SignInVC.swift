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

class SignInVC: UIViewController {

    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let loginButton = FBLoginButton()
//                loginButton.center = view.center
//                view.addSubview(loginButton)
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
            }
        })
    }
    
    @IBAction func signInTap(_ sender: Any) {
        if let email = emailField.text,
           let passowrd = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: passowrd, completion: { (user , error) in
                if error != nil {
                    print("Email User Auth with Firebase")
                }else {
                    Auth.auth().signIn(withEmail: email, password: passowrd, completion: { ( user, error ) in
                        if error != nil {
                            print("Unable to Auth Firebase with Email")
                        }else {
                            print("Successfully Auth with Firebase")
                        }
                    })
                }
            })
        }
    }
    
}


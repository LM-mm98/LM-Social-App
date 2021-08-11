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
}


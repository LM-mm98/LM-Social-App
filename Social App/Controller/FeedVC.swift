//
//  FeedVC.swift
//  Social App
//
//  Created by Lin Myat on 12/08/2021.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedTableViewCell else{
            return UITableViewCell() }
        return cell 
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var feedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func signOutTap(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: keyUid)
        print("ID removed from KeyChain \(keychainResult)")
        try! Auth.auth().signOut()
//        performSegue(withIdentifier: "goToSignin", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

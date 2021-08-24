//
//  FeedVC.swift
//  Social App
//
//  Created by Lin Myat on 12/08/2021.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ImagePickerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
//        print("\(post.caption)")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedTableViewCell {
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: image)
            }else {
                
            }
            cell.configureCell(post: post)
            return cell
        }else {
            return UITableViewCell() }
    }
    
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var feedTableView: UITableView!
    
    @IBOutlet weak var addImage: CircleImageView!
    
    var posts = [Post]()
    var imagePicker : ImagePicker!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
//        imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = true
//        imagePicker.delegate = self
        
        DataService.dataService.reference_Posts.observe(.value, with: { (snapshot) in
//            print(snapshot.value)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.feedTableView.reloadData()
        })
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController] as? UIImage {
//
//        }
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
    func didSelect(image: UIImage?) {
        self.addImage.image = image
    }
    
    @IBAction func addimageTap(_ sender: UITapGestureRecognizer) { //tapguster
        self.imagePicker.present()
    }
    
    @IBAction func signOutTap(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: keyUid)
        print("ID removed from KeyChain \(keychainResult)")
        try! Auth.auth().signOut()
//        performSegue(withIdentifier: "goToSignin", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

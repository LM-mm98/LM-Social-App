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
                cell.configureCell(post: post)
            }
            return cell
        }else {
            return UITableViewCell() }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var addImage: CircleImageView!
    @IBOutlet weak var captionField: UITextField!
    
    
    var posts = [Post]()
    var imagePicker : ImagePicker!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        DataService.dataService.reference_Posts.observe(.value, with: { (snapshot) in
            self.posts = []
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
            self.posts.reverse()
            self.feedTableView.reloadData()
        })
    }
    

    func didSelect(image: UIImage?) {
        imageSelected = true
        self.addImage.image = image
    }
    
    @IBAction func addimageTap(_ sender: UITapGestureRecognizer) { //tapguster
        self.imagePicker.present()
    }
    
    @IBAction func postBtnTap(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("CaptionField is Empty")
            return
        }
        guard let image = addImage.image, imageSelected == true else {
            print("Image not selected")
            return
        }
        if let imageData = image.jpegData(compressionQuality: 0.2) {
            let imageUid = NSUUID().uuidString
            let storageRef = DataService.dataService.reference_Post_Images.child(imageUid)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Unable to upload image to Firebase Storage")
                }else {
                    print("Successfully uploaded image to Firebase Storage")
                    storageRef.downloadURL { (url, error ) in
                        guard let downloadURL = url?.absoluteString else { return }
                        self.postToFirebase(imageUrl: downloadURL)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imageUrl: String) {
        let post : Dictionary<String, Any> = [
            "caption": captionField.text!,
            "imageUrl": imageUrl,
            "likes": 0 ]
        let firebasePost = DataService.dataService.reference_Posts.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "add-image")
        
        feedTableView.reloadData()
    }
    
    @IBAction func signOutTap(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: keyUid)
        print("ID removed from KeyChain \(keychainResult)")
        try! Auth.auth().signOut()
//        performSegue(withIdentifier: "goToSignin", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

//
//  DataServices.swift
//  Social App
//
//  Created by Lin Myat on 17/08/2021.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let dataBase = Database.database().reference()
let storageBase = Storage.storage().reference()

class DataService {
    
    static let dataService = DataService()
    
    // DataBase References
    private var referenceBase = dataBase
    private var referencePosts = dataBase.child("posts")
    private var referenceUsers = dataBase.child("users")
    
    //Storage references
    private var referencePostImages = storageBase.child("post-pics")
    
    var reference_Base : DatabaseReference {
        return referenceBase
    }
    var reference_Posts : DatabaseReference {
        return referencePosts
    }
    var reference_Users : DatabaseReference {
        return referenceUsers
    }
    
    var reference_User_Current : DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: keyUid)
        let user = referenceUsers.child(uid!)
        return user
    }
    
    var reference_Post_Images : StorageReference {
        return referencePostImages
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        referenceUsers.child(uid).updateChildValues(userData)
    }
}

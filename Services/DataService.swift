//
//  DataServices.swift
//  Social App
//
//  Created by Lin Myat on 17/08/2021.
//

import Foundation
import Firebase

let dataBase = Database.database().reference()

class DataService {
    
    static let dataService = DataService()
    
    private var referenceBase = dataBase
    private var referencePosts = dataBase.child("posts")
    private var referenceUsers = dataBase.child("users")
    
    var reference_Base : DatabaseReference {
        return referenceBase
    }
    var reference_Posts : DatabaseReference {
        return referencePosts
    }
    var reference_Users : DatabaseReference {
        return referenceUsers
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        referenceUsers.child(uid).updateChildValues(userData)
    }
}

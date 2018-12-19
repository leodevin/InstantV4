//
//  User.swift
//  Instant
//
//  Created by Xavier de Cazenove on 12/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class UserProfile {
    
    var id : String?
    var name : String?
    var email : String?
    var tabPellicule : [Pellicule] = [Pellicule(_state: false, _nom: "addButton", _icone: "plus")]
    
    init(db : Firestore) {
        db.collection("users").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.id = document.documentID
                    self.name = (querySnapshot?.value(forKey: "name") as? String)!
                    self.email = (querySnapshot?.value(forKey: "email") as? String)!
                    
                }
            }
        }
        
        db.collection("users").document(self.id!).collection("pellicule").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.tabPellicule.append(Pellicule(_state: false, _nom: document.documentID, _icone: "appareil_photo" ))
                }
            }
        }
    }
}

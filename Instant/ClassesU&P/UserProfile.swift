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
    
    var id : String!
    var name : String!
    var email : String!
    var tabPellicule : [Pellicule] = []
    var tabHistoric : [Pellicule] = []
    
    init(db : Firestore, id : String) {
        self.id = id
        
        let docRef = db.collection("users").document(self.id)
        docRef.getDocument{ (document, err) in
            if let document = document, document.exists {
                self.name = document.get("name") as? String
                self.email = document.get("email") as? String
                print(document.get("name")!)
                print(document.get("email")!)
            } else {
                print("ERROR")
                }
        }
        
        self.tabPellicule.append(Pellicule(_state: false, _nom: "addButton", _icone: "plus", _date : ""))
        db.collection("users").document(self.id).collection("pellicule").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.get("fini") as! Bool == false{
                         self.tabPellicule.append(Pellicule(_state: false, _nom: document.get("name") as! String, _icone: document.get("icon") as! String, _date : document.get("date_init") as! String ))
                    }
                    else{
                        self.tabHistoric.append(Pellicule(_state: true, _nom: document.get("name") as! String, _icone: document.get("icon") as! String, _date : document.get("date_init") as! String ))
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
            }
        }
    }
}

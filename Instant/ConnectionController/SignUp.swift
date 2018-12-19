//
//  Subscribe.swift
//  Instant
//
//  Created by Xavier de Cazenove on 06/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class SignUp: UIViewController {
    
    @IBOutlet var username : UITextField!
    @IBOutlet var email : UITextField!
    @IBOutlet var password : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func boutonDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func signUpAuthentification(sender : Any?){
        
        if username.text != "" && email.text != "" && password.text != "" {
            // Création d'un USER
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ User, Error in
                if Error == nil && User != nil{
                    print("User created !")
                    Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!)
                    
                    // Création d'un USERNAME pour le USER
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.username.text
                    changeRequest?.commitChanges{ Error in
                        if Error == nil{
                            print("User display name changed !")
                            self.performSegue(withIdentifier: "signup", sender: self)
                        }
                    }
                } else{
                    print("Error creating user : \(String(describing: Error?.localizedDescription))")
                }
            }
        } else{
            alert("Error", message: "Please fill up all fields in order to subscribe")
        }
    }
    
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

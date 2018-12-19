//
//  Login.swift
//  Instant
//
//  Created by Xavier de Cazenove on 06/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit
import Firebase


class LogIn: UIViewController {
    
    @IBOutlet var email : UITextField!
    @IBOutlet var password : UITextField!
    @IBOutlet weak var imageLogo: UIImageView!
    
    // CACHE TOP BAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if Auth.auth().currentUser != nil{
            if CheckInternet.Connection(){
                self.performSegue(withIdentifier: "login", sender: self)
            } else{
                alert("Internet", message: "Disconnected")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // SHOW TOP BAR
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func logInAuthentification(sender : Any?){
        if  email.text != "" && password.text != "" {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!){ User, Error in
                if Error == nil && User != nil{
                    print("User sign in !")
                    self.performSegue(withIdentifier: "login", sender: self)
                    
                } else{
                    print("Error creating user : \(String(describing: Error?.localizedDescription))")
                }
            }
        } else{
            alert("Error", message: "Please fill up all fields in order to login")
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

//
//  addPellStoryBoardController.swift
//  Instant
//
//  Created by Léonard Devincre on 09/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestore

protocol ChangeImageIcone {
    func changeIcone(toIcone: UIImage)
}

class addPellViewController : UIViewController, ChangeImageIcone {
    @IBOutlet weak var pellNameTF: UITextField!
    @IBOutlet weak var iconeButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    //initialize an instance database
    let db =  Firestore.firestore()
    var user : UserProfile!
    
    override func viewDidLoad() {
        iconeButton.layer.cornerRadius = 6
        createButton.layer.cornerRadius = 20
        createButton.layer.backgroundColor = UIColor.orange.cgColor
        createButton.titleLabel?.textColor = UIColor.white
    }
    
    func changeIcone(toIcone : UIImage) {
        iconeButton.setImage(toIcone, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "selectIconeSegue"){
        let PellIconeController = segue.destination as? PellIconeController
        PellIconeController?.delegate = self
        }
    }
    
    @IBAction func closeAddPell(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addPellButton(_ sender: Any) {
        //on récupère les informations et on les envoies dans la firebase
        //self.user = UserProfile(db: Firestore.firestore(), id : (Auth.auth().currentUser?.uid)!, type : 1)
        
        if(pellNameTF.text != nil)
        {
            db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("pellicule").document(pellNameTF.text!).setData([
                "name": pellNameTF.text!,
                "date_init": initDate(),
                "icon": iconeButton.image(for: .normal)?.accessibilityIdentifier ?? "randonné",
                "fini": false
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
            }
            NotificationCenter.default.post(name: NSNotification.Name("reloadFromDB"), object: nil)
            
        }
        self.dismiss(animated: true, completion: nil)
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

func initDate () -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = Date.init()
    let stringDate = formatter.string(from: date)
    return stringDate
}



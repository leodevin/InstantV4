//
//  Account.swift
//  Instant
//
//  Created by Xavier de Cazenove on 18/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit
import Firebase

class Account: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var titleUser : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleUser.text = Auth.auth().currentUser?.displayName 
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 2
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:return "Get some help"
        case 1:return "E-Mail"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "basic")
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "About us"
            } else {
                cell.textLabel?.text = "Contact us"
            }
        }
        if indexPath.section == 1{
            if indexPath.row == 0 {
                cell.textLabel?.text = Auth.auth().currentUser?.email
                cell.textLabel?.textColor = UIColor.blue
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = "Deconnexion"
                cell.textLabel?.textColor = UIColor.red
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {

            } else {

            }
        }
        if indexPath.section == 1{
            if indexPath.row == 0 {

                
            }
            if indexPath.row == 1 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOut"), object: nil)

            }
        }
    }
}

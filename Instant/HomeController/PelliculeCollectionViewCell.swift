//
//  PelliculeCollectionViewCell.swift
//  Instant
//
//  Created by Léonard Devincre on 08/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//
import UIKit
import Firebase

class PelliculeCollectionViewCell: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cellButton: PelliculeView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteView: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    var homeController : HomeController!
    
    func displayContent(homeController : HomeController, pellicule: Pellicule, pell_name : String, pell_initDate : String) {
        
        self.homeController = homeController
        
        if pellicule.nom == "addButton" {
            image.image = pellicule.icone
            image.layer.cornerRadius = 6
            image.contentMode = UIView.ContentMode.center
            cellButton.layer.cornerRadius = 6
            cellButton.accessibilityIdentifier = "addButton"
            cellLabel.text = ""
            dateLabel.text = ""
            deleteView.layer.isHidden = true
        } else {
            image.image = pellicule.icone
            image.layer.cornerRadius = 6
            image.contentMode = UIView.ContentMode.scaleAspectFit
            cellLabel.text = pell_name
            dateLabel.text = pell_initDate
            cellButton.accessibilityIdentifier = pell_name
            deleteView.layer.isHidden = true
            
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
            longPressGestureRecognizer.minimumPressDuration = TimeInterval.init(exactly: 1.0)!
            self.addGestureRecognizer(longPressGestureRecognizer)
        }
    }
    
    @objc func didLongPress(sender: UILongPressGestureRecognizer){
        if cellButton.accessibilityIdentifier != "addButton" {
            self.deleteView.layer.isHidden = false
            print("Long Press")
        }
    }
    
    @IBAction func addButonAction(_ sender: Any) {
        if cellButton.accessibilityIdentifier == "addButton" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addPellicule"), object: nil)
        } else{
            if self.deleteView.layer.isHidden{
                self.homeController.currentCell = cellButton.accessibilityIdentifier
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "takePhoto"), object: nil)
            } else {
                self.deleteView.layer.isHidden = true
            }
        }
    }
    
    
    @IBAction func pressDelete(_ sender : Any){
        if cellButton.accessibilityIdentifier != "addButton" {
            
            self.homeController.currentCell = cellButton.accessibilityIdentifier
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCell"), object: nil)
        }
    }
    
    
}

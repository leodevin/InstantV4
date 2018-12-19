//
//  PellIconeViewCell.swift
//  Instant
//
//  Created by Léonard Devincre on 16/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit

class PellIconeViewCell : UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    
    var pellIconeController : PellIconeController!
    
    func displayContent(_pellIconeController : PellIconeController, iconeName : String){
        self.pellIconeController = _pellIconeController
        cellImage.image = UIImage.init(imageLiteralResourceName: iconeName)
        cellImage.image?.accessibilityIdentifier = iconeName
        self.layer.cornerRadius = 6
    }
    
    @IBAction func ClickAction(_ sender: Any) {
        pellIconeController.selectedImage = cellImage.image
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ItemSelected"), object: nil)
    }
}

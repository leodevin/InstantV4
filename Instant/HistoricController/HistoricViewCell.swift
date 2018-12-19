//
//  historicViewCellCollectionViewCell.swift
//  Instant
//
//  Created by Xavier de Cazenove on 17/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit

class HistoricViewCell: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cellButton: PelliculeView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteView: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    var historicController : HistoricController!
    
    func displayContent(historicController : HistoricController, pellicule: Pellicule, pell_name : String, pell_initDate : String) {
       
        self.historicController = historicController
        image.image = pellicule.icone
        image.layer.cornerRadius = 6
        cellLabel.text = pell_name
        dateLabel.text = pell_initDate
        cellButton.accessibilityIdentifier = pell_name
        deleteView.layer.isHidden = true
        cellButton.layer.cornerRadius = 6
        image.layer.cornerRadius = 6
    }
    
    @IBAction func clickOnCell(_ sender: Any) {
        self.historicController.currentCell = cellButton.accessibilityIdentifier
        NotificationCenter.default.post(name: NSNotification.Name("ViewPhotoPellicule"), object: nil)
    }
}

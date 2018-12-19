//
//  PelliculeView.swift
//  Instant
//
//  Created by Léonard Devincre on 06/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//
import UIKit

class PelliculeView : UIButton {
    
    
    
    //initialiseur
    required init?(coder aDecoder: NSCoder) {
        //initialisateur de la classe parente
        super.init(coder : aDecoder)
        
        //Coins arrondis
        layer.cornerRadius = 8
        
        //layer.borderWidth = 2
        
        //layer.borderColor = UIColor.orange.cgColor
        
        //layer.backgroundColor = UIColor.lightGray.cgColor
        
        self.titleLabel?.textAlignment = NSTextAlignment.center
        
        //Padding a gauche et a droite
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}

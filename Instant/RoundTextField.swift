//
//  RoundTextField.swift
//  Instant
//
//  Created by Xavier de Cazenove on 08/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit

class TextFieldDesignable: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.cgColor
        //Epaisseur de la bordure
        layer.borderWidth = 2
        //Couleur du texte
        layer.backgroundColor = UIColor.black.cgColor
        
        //Padding a gauche et a droite
        //contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    }
}

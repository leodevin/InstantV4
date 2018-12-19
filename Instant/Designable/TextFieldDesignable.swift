//
//  RoundTextField.swift
//  Instant
//
//  Created by Xavier de Cazenove on 08/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit

@IBDesignable class TextFieldDesignable: UITextField {
    
    @IBInspectable var borderWidth : CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

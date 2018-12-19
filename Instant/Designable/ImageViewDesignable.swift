//
//  ImageViewDesignable.swift
//  Instant
//
//  Created by Xavier de Cazenove on 17/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit

@IBDesignable class ImageViewDesignable: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }

}

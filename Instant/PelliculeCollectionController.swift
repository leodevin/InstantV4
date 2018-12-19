//
//  PelliculeCollectionController.swift
//  Instant
//
//  Created by Léonard Devincre on 08/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//
import UIKit

class PellicyleCollectionController : UICollectionViewController {
    var pelArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pelArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var button
    }
}

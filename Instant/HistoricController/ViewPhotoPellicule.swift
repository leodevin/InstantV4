//
//  ViewPhotoPellicule.swift
//  Instant
//
//  Created by Xavier de Cazenove on 18/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit
import Firebase

class ViewPhotoPellicule: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var userTabImage : [UIImage]!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("download"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUser), name: NSNotification.Name("reloadUser") , object: nil)
    }
    
    @IBAction func onClickDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reloadUser(){
        photoCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userTabImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath)
        let image = cell.viewWithTag(1) as! UIImageView
        image.image = self.userTabImage[indexPath.row]
        image.layer.cornerRadius = 6
        
        return cell
    }
}

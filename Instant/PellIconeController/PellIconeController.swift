//
//  PellIconeController.swift
//  Instant
//
//  Created by Léonard Devincre on 16/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit

class PellIconeController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var PellIconeCollectionView: UICollectionView!
    var delegate: ChangeImageIcone?
    var selectedImage : UIImage!
    let ImageBank : [String] = ["copains", "culture", "famille", "mer", "musique", "randonné", "sport", "ville", "chateau_de_sable"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(IconeSelected), name: NSNotification.Name("ItemSelected") , object: nil)
    }
    
    @objc func IconeSelected(){
        delegate?.changeIcone(toIcone: selectedImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closePellIconeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// _______________ COLLECTION VIEW INIT ___________________ ///
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageBank.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconeCell", for: indexPath) as! PellIconeViewCell
        cell.displayContent(_pellIconeController: self, iconeName: ImageBank[indexPath.row])
        return cell
    }
    /// ____________________________________________________________ ///
    
}

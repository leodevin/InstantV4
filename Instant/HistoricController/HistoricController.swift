//
//  historiqueControllerViewController.swift
//  Instant
//
//  Created by Xavier de Cazenove on 17/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit
import Firebase

class HistoricController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var historicCollectionView: UICollectionView!
    var user : UserProfile!
    var currentCell : String!
    var tabImage : [UIImage] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = UserProfile(db: Firestore.firestore(), id : (Auth.auth().currentUser?.uid)!)
        NotificationCenter.default.addObserver(self, selector: #selector(launchWiewPhoto), name: NSNotification.Name("ViewPhotoPellicule"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHistoricCollectionView), name: NSNotification.Name("reloadHistoricCollectionView") , object: nil)
    }
    
    
    @IBAction func reloadUser(_ sender: Any) {
        self.user = UserProfile(db: Firestore.firestore(), id : (Auth.auth().currentUser?.uid)!)
    }
    
    
    //____________________________
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.tabHistoric.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! HistoricViewCell
        cell.displayContent(historicController: self,pellicule: self.user.tabHistoric[indexPath.row], pell_name: self.user.tabHistoric[indexPath.row].nom, pell_initDate: self.user.tabHistoric[indexPath.row].startDate)
        return cell
    }
    
    
    //____________________________
    
    @objc func reloadHistoricCollectionView(){
        self.historicCollectionView.reloadData()
        
    }
    
    
    
    
    
    @objc func launchWiewPhoto(){
        
        for tab in self.user.tabHistoric{
            if tab.nom == self.currentCell{
                self.tabImage = tab.tabImage
            }
        }
        self.performSegue(withIdentifier: "ViewPhotoPellicule", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewPhotoPellicule"{
            let viewPhoto = segue.destination as! ViewPhotoPellicule
            viewPhoto.userTabImage = self.tabImage
        }
    }
}

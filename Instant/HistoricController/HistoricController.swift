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
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet var back : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        back.layer.cornerRadius = 10
        self.user = UserProfile(db: Firestore.firestore(), id : (Auth.auth().currentUser?.uid)!, type : 2)
        NotificationCenter.default.addObserver(self, selector: #selector(launchWiewPhoto), name: NSNotification.Name("ViewPhotoPellicule"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHistoricCollectionView), name: NSNotification.Name("reloadHistoricCollectionView") , object: nil)
        
    }
    

    
    /// _________________ COLLECTION VIEW INIT _____________________ ///
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.tabHistoric.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! HistoricViewCell
        cell.displayContent(historicController: self,pellicule: self.user.tabHistoric[indexPath.row], pell_name: self.user.tabHistoric[indexPath.row].nom, pell_initDate: self.user.tabHistoric[indexPath.row].startDate)
        return cell
    }
    
    
    /// _________________ RELOAD COLLECTION VIEW _____________________ ///
    
    @IBAction func reloadUser(_ sender: Any) {
        self.user = UserProfile(db: Firestore.firestore(), id : (Auth.auth().currentUser?.uid)!, type : 2)
    }
    
    @objc func reloadHistoricCollectionView(){
        self.historicCollectionView.reloadData()
        
    }
    
    
    
    
    /// _________________ LAUNCH PHOTOS DE LA PELLICULE SELECTIONNER CONTROLLER _____________________ ///
    
    @objc func launchWiewPhoto(){
        for tab in self.user.tabHistoric{
            if tab.nom == self.currentCell{
                self.back.isHidden = false
                activityIndicator.center = self.view.center // Création cercle de chargement
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                self.download(pell: tab) // Lancement download images
            }
        }
    }
    
    /// _________________ TRANSMITION DES IMAGES DE LA PELLICULE AU PHOTO CONTROLLER _____________________ ///
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewPhotoPellicule"{
            let viewPhoto = segue.destination as! ViewPhotoPellicule
            viewPhoto.userTabImage = self.tabImage
        }
    }
    
    
    
    
    /// _________________ VA CHERCHER LES URL DES IMAGES DE LA PELLICULE _____________________ ///

    func download(pell : Pellicule){
            pell.downloadURL = []
            
            _ = Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("pellicule").document(pell.nom).collection("images").getDocuments {(QuerySnapshot, Error) in
                if Error != nil {
                    print("Error getting documents: \(String(describing: Error))")
                } else {
                    for document in QuerySnapshot!.documents {
                        pell.downloadURL.append(document.get("downloadURL") as! String)
                    }
                    self.launchDwnloadImage(pell :pell)
                }
            }
    }
    
    
    func launchDwnloadImage(pell : Pellicule){
        for urlDownload in pell.downloadURL{
            let url = URL(string: urlDownload.description)
            downloadImage(from: url!, pell : pell)
        }
        
        
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    /// _________________ REMPLI LE TAB IMAGE POUR POUVOIR LES AFFICHER _____________________ ///

    
    func downloadImage(from url: URL, pell : Pellicule) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.tabImage.append(UIImage(data: data)!)
                if pell.downloadURL.count == self.tabImage.count{
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.back.isHidden = true
                    self.performSegue(withIdentifier: "ViewPhotoPellicule", sender: self)
                    NotificationCenter.default.post(name: NSNotification.Name("reloadUser"), object: nil)
                    self.tabImage = []
                }
            }
        }
    }
}

    
    






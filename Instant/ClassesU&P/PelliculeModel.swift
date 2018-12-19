//
//  PelliculeModel.swift
//  Instant
//
//  Created by Léonard Devincre on 06/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//
import UIKit
import Firebase
import FirebaseStorage

class Pellicule {
    ///Variables de la classe pellicules
    var state : Bool    //state définis l'état en cours=false et terminé=true
    var nbPhotos : Int  //le nombre de photos sur la pellicule
    var nom : String    //le nom de la pellicule
    var startDate : String    //date de début de la pellicule
    var icone : UIImage     //nom de l'icone de la pellicule (à définir...)
    var downloadURL : [String] = []
    var tabImage : [UIImage] = []
    
    //constructeur d'une pellicule
    init( _state : Bool, _nom : String, _icone : String, _date : String) {
        
        //initialisation des variables
        self.state = _state
        self.nbPhotos = 0    //lors de l'initialisation du pellicule, son nombre de photos est à 0
        self.nom = _nom
        self.startDate = _date //prend la valeur de l'heure et la date actuelle
        self.icone = UIImage.init(imageLiteralResourceName: _icone)
        self.downloadURL = []
        self.tabImage = []
        
        if self.state == true{
            download()
        }
    }
    
    
    //fonction qui indique que la pellicule est finis
    func terminatePellicule(){
        state = true
    }
    
    // VA CHERCHER LES URL DES IMAGES DE LA PELLICULE
    @objc func download(){
        
        _ = Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("pellicule").document(self.nom).collection("images").getDocuments {(QuerySnapshot, Error) in
            if Error != nil {
                print("Error getting documents: \(String(describing: Error))")
            } else {
                for document in QuerySnapshot!.documents {
                    self.downloadURL.append(document.get("downloadURL") as! String)
                }
                self.launchDwnloadImage()
            }
        }
        
    }
    
    
    @objc func launchDwnloadImage(){
        for urlDownload in self.downloadURL{
            let url = URL(string: urlDownload.description)
            downloadImage(from: url!)
        }
        
        
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                print("Download Finished")
                self.tabImage.append(UIImage(data: data)!)
                if self.downloadURL.count == self.tabImage.count{
                    NotificationCenter.default.post(name: NSNotification.Name("reloadHistoricCollectionView"), object: nil)
                    
                }
            }
        }
    }
}

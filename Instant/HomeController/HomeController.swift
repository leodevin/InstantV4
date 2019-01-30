//
//  ViewController.swift
//  Instant
//
//  Created by Léonard Devincre on 28/11/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import WhatsNewKit

class HomeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var welcomeMessage: UILabel!
    
    @IBOutlet var pelliculeCollectionView: UICollectionView!
    var user : UserProfile!
    var currentCell : String!
    
    //initialize an instance database
    let db =  Firestore.firestore()
    let storageRef = Storage.storage()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-----------------********--------------")
        self.user = UserProfile(db: Firestore.firestore(), id : (Auth.auth().currentUser?.uid)!, type : 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(collectionViewReload), name: NSNotification.Name("reload") , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadfromDB(_:)), name: NSNotification.Name("reloadFromDB"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(addPellicule), name: NSNotification.Name("addPellicule"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(takePhoto), name: NSNotification.Name("takePhoto"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCell), name: NSNotification.Name("deleteCell"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(logOutSettingButton), name: NSNotification.Name("signOut") , object: nil)
    }
    
    
    /// _________________ COLLECTION VIEW INIT _____________________ ///
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.user.tabPellicule.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PelliculeCollectionViewCell
        cell.displayContent(homeController: self,pellicule: self.user.tabPellicule[indexPath.row], pell_name: self.user.tabPellicule[indexPath.row].nom, pell_initDate: self.user.tabPellicule[indexPath.row].startDate)
        
        return cell
    }
    
    
    /// ________________________ RELOAD FROM DB ________________________ ///
    
    
    @IBAction func reloadfromDB(_ sender: Any) {
        self.user = UserProfile(db: Firestore.firestore(), id : (Auth.auth().currentUser?.uid)!,type : 1)
        NotificationCenter.default.addObserver(self, selector: #selector(collectionViewReload), name: NSNotification.Name("reload") , object: nil)
    }
    
    @objc func collectionViewReload(){
        let text = "Welcome on Insant " + (Auth.auth().currentUser?.displayName)!
        self.welcomeMessage.text = text
        self.pelliculeCollectionView.reloadData()
    }
    
    
    
    
    
    
    /// _________________ DELETE CELL PELL _____________________ ///
    
    @objc func deleteCell(){
        let alert = UIAlertController(title: "Delete Pellicule", message: "Are you sure to delete this pellicule ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
        self.db.collection("users").document(self.user.id).collection("pellicule").document(self.currentCell).delete()
            NotificationCenter.default.post(name: NSNotification.Name("reloadFromDB"), object: nil)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
 
        
    }

    
   
    
    /// _________________ LAUNCH THE ADD PELLICULE CONTROLLER _____________________ ///
    
    @objc func addPellicule (){
        self.performSegue(withIdentifier: "GoToAddPellStoryBoard", sender:self)
    }
    
    
    
    /// _________________ TAKE PHOTO _____________________ ///
    
    @objc func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true,completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            /// ****** INSERTION IMAGE DANS STORAGE ******** ///

            let random = generateRandomStringWithLength(length: 20)
            let imageRef = Storage.storage().reference().child("users/" + self.user.id + "/" + random)
            let metaDataForImage = StorageMetadata()
            metaDataForImage.contentType = "image/jpeg"
            
            print("Begin ......")
            
            var data = Data()
            data = (pickedImage.jpegData(compressionQuality: 0.8)!)
            _ = imageRef.putData(data, metadata: metaDataForImage){ (metadata,Error) in
                if Error != nil{
                    print(Error as Any)
                    return
                }else{
                    print("End ......")
                    imageRef.downloadURL(completion: { (Url, Error) in
                        if Error != nil{
                            print(Error as Any)
                        }else{
                            let downloadUrl = Url?.absoluteString
                            self.addDownloadURLToDatabase(downloadURL: downloadUrl!)
                        }
                    })
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func generateRandomStringWithLength(length: Int) -> String {
        
        var randomString = ""
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for _ in 1...length {
            let randomIndex  = Int(arc4random_uniform(UInt32(letters.count)))
            let a = letters.index(letters.startIndex, offsetBy: randomIndex)
            randomString +=  String(letters[a])
        }
        
        return randomString
    }
    
    
    
    
    /// ________________________ ADD THE DOWNLOAD URL TO THE DATABASE ________________________ ///

    
    /// REMPLI LES CHAMPS DE DOWNLOAD URL DE LA DATABASE AVEC LES BON URL
    func addDownloadURLToDatabase(downloadURL : String){
        db.collection("users").document(user.id).collection("pellicule").document(self.currentCell).collection("images").document().setData([
            "downloadURL" : downloadURL]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document images successfully written!")
                    self.checkNumberOfPhotos()
                }
        }
    }
    
    /// ________________________ CHECK THE NUMBER OF PHOTOS IN THE PELLICULE ________________________ ///
    
    func checkNumberOfPhotos(){
        var count : Int = 0
        db.collection("users").document(user.id).collection("pellicule").document(self.currentCell).collection("images").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for _ in querySnapshot!.documents {count = count + 1}
                if count == 10{
                self.db.collection("users").document(self.user.id).collection("pellicule").document(self.currentCell).updateData(["fini" : true])
                    NotificationCenter.default.post(name: NSNotification.Name("reloadFromDB"), object: nil)

                }
            }
        }
    }
    
    
    /// ________________________ LOG OUT USER ________________________ ///

    @objc func logOutSettingButton(){
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    
    /// --------- PAGE INFORMATION SUR LE FONCTIONNEMENT DE L'APP ----------- ///
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        whatsNewIfNeeded()
    }
    
    func whatsNewIfNeeded(){
        // Initialize WhatsNew
        let whatsNew = WhatsNew(
            // The Title
            title: "New features in Instant",
            // The features you want to showcase
            items: [
                WhatsNew.Item(
                    title: "Films",
                    subtitle: "Films are groups of 15 photos 📸",
                    image: UIImage.init(named: "pellicule")
                ),
                WhatsNew.Item(
                    title: "Add films",
                    subtitle: "To add a film, press the ➕ button",
                    image: UIImage.init(named: "add_pell")
                ),
                WhatsNew.Item(
                    title: "Real-time synchronization",
                    subtitle: "All your films are automaticaly and in real time sync in your cloud ! 🎉",
                    image: UIImage.init(named: "sync")
                ),
                WhatsNew.Item(
                    title: "Delete films",
                    subtitle: "Long press on a film to delete it 😢",
                    image: UIImage.init(named: "delete_pell")
                )
            ]
        )
        
        //configuration graphique de la page d'information
        let theme = WhatsNewViewController.Theme { configuration in
            configuration.apply(animation: .fade)
            configuration.backgroundColor = UIColor.orange
            configuration.itemsView.titleColor = UIColor.white
            configuration.itemsView.subtitleColor = UIColor.white
            configuration.titleView.titleColor = UIColor.white
            configuration.completionButton.backgroundColor = UIColor.white
            configuration.completionButton.titleColor = UIColor.orange
        }
        
        let config = WhatsNewViewController.Configuration(theme: theme)
        
        //keyvalue pour savoir si le whatsnew a deja été montré ou pas
        let keyValueVersionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard)
        
        let whatsNewVC  = WhatsNewViewController(whatsNew: whatsNew, configuration: config, versionStore: keyValueVersionStore)
        
        
        if let vc = whatsNewVC {
            self.present(vc, animated: true)
        }
        
    }
    
    
    @IBAction func showWhatsNew(_ sender: Any) {
        // Initialize WhatsNew
        let whatsNew = WhatsNew(
            // The Title
            title: "How Instant works ?",
            // The features you want to showcase
            items: [
                WhatsNew.Item(
                    title: "Films",
                    subtitle: "Films are groups of 15 photos 📸",
                    image: UIImage.init(named: "pellicule")
                ),
                WhatsNew.Item(
                    title: "Add Films",
                    subtitle: "To add a film, press the ➕ button",
                    image: UIImage.init(named: "add_pell")
                ),
                WhatsNew.Item(
                    title: "Real-time synchronization",
                    subtitle: "All your films are automaticaly and in real time sync in your cloud ! 🎉",
                    image: UIImage.init(named: "sync")
                ),
                WhatsNew.Item(
                    title: "Delete films",
                    subtitle: "Long press on a film to delete it 😢",
                    image: UIImage.init(named: "delete_pell")
                )
            ]
        )
        
        //configuration graphique de la page d'information
        let theme = WhatsNewViewController.Theme { configuration in
            configuration.apply(animation: .fade)
            configuration.backgroundColor = UIColor.orange
            configuration.itemsView.titleColor = UIColor.white
            configuration.itemsView.subtitleColor = UIColor.white
            configuration.titleView.titleColor = UIColor.white
            configuration.completionButton.backgroundColor = UIColor.white
            configuration.completionButton.titleColor = UIColor.orange
        }
        
        let config = WhatsNewViewController.Configuration(theme: theme)
        
        let whatsNewVC  = WhatsNewViewController(whatsNew: whatsNew, configuration: config)
        
        self.present(whatsNewVC, animated: true)
    }
    
}


//
//  PhotoController.swift
//  Instant
//
//  Created by Xavier de Cazenove on 15/12/2018.
//  Copyright © 2018 Léonard Devincre. All rights reserved.
//

import UIKit
import Firebase

class PhotoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

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
            
           // imageView.contentMode = .scaleToFill
           // imageView.image = pickedImage
            
            /// ****** INSERTION IMAGE DANS STORAGE ******** ///
            
            let random = generateRandomStringWithLength(length: 20)
            let metaDataForImage = StorageMetadata()
            metaDataForImage.contentType = "image/jpeg"
            
            var data = Data()
            data = (pickedImage.jpegData(compressionQuality: 0.8)!)!
            
            let imageRef = Storage.storage().reference().child("test/pell1/" + random)
            _ = imageRef.putData(data, metadata: metaDataForImage){ (metadata,Error) in
                if Error != nil{
                    print(Error as Any)
                    return
                }else{
                    imageRef.downloadURL(completion: { (Url, Error) in
                        if Error != nil{
                            print(Error as Any)
                        }else{
                            let downloadUrl = Url?.absoluteString
                            print(downloadUrl!)
                            
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
}

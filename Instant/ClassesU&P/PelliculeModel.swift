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

    //constructeur d'une pellicule
    init( _state : Bool, _nom : String, _icone : String, _date : String) {
        
        //initialisation des variables
        self.state = _state
        self.nbPhotos = 0    //lors de l'initialisation du pellicule, son nombre de photos est à 0
        self.nom = _nom
        self.startDate = _date //prend la valeur de l'heure et la date actuelle
        self.icone = UIImage.init(imageLiteralResourceName: _icone)
        self.downloadURL = []
    }
    
    //fonction qui indique que la pellicule est finis
    func terminatePellicule(){
        state = true
    }
}

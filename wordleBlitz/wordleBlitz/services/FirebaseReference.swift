//
//  FirebaseReference.swift
//  wordleBlitz
//
//  Created by Noah Frahm on 4/8/22.
//

import Firebase
import Foundation

enum FCollectionReference: String {
//    collection references to data saved in database
    case Game
//    case User
    
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}

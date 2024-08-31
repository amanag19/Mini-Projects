//
//  FCollectionReference.swift
//  LetsChitChat
//
//  Created by Aman Agrwal on 13/09/22.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
	case User
	case Recent
}

func FirebaseReference(_ colletionReference : FCollectionReference) -> CollectionReference {
	return Firestore.firestore().collection(colletionReference.rawValue)
}

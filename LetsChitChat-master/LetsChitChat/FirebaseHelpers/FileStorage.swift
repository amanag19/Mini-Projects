//
//  FirebaseStorage.swift
//  LetsChitChat
//
//  Created by Aman Agrwal on 15/09/22.
//

import Foundation
import FirebaseStorage
import ProgressHUD

let storage = Storage.storage()

class FileStorage{
	
	class func uploadImage (_ image : UIImage , directory : String , completion : @escaping (_ documentLink : String?) -> Void){
		
		let storageRef = storage.reference(forURL: kFileReference).child(directory)
		
		let imageData = image.jpegData(compressionQuality: 1.0)
		
		var task : StorageUploadTask!
		task = storageRef.putData(imageData! , metadata: nil , completion: { metaData, error in
			
			task.removeAllObservers()
			ProgressHUD.dismiss()
			
			if error != nil{
				print(error?.localizedDescription)
				return
			}else{
				storageRef.downloadURL { url, error in
					guard let downloadUrl = url else{
						completion(nil)
						return
					}
					completion(downloadUrl.absoluteString)
				}
			}
		})
		task.observe(StorageTaskStatus.progress) { snapShot in
			let progress = snapShot.progress!.completedUnitCount / snapShot.progress!.totalUnitCount
			ProgressHUD.showProgress(CGFloat(progress))
		}
	}
	
}

//
//  FirebaseUserListener.swift
//  LetsChitChat
//
//  Created by Aman Agrwal on 13/09/22.
//

import Foundation
import Firebase
import RealmSwift
import FirebaseFirestoreSwift
import CoreMedia

class FirebaseUserListener{
	static let shared = FirebaseUserListener()
	
	private init() {}
	
	//Mark: - Login
	func loginUserWithEmail(email: String , password : String , completion : @escaping (_ error : Error? ,_ isEmailVerified : Bool) -> Void){
		
		Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
			
			if error == nil , authDataResult!.user.isEmailVerified {
				
				FirebaseUserListener.shared.downloadUserFroFirebase(userId: authDataResult!.user.uid , email: email)
				completion(error , true)
			}
			else
			{
				print("Email is not verified")
				completion(error, false)
			}
			
		}
		
	}
	
	
	//Mark: - Register
	func registerUseWith(email : String , password : String , completion : @escaping (_ error: Error?) -> Void)
	{
		Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
			completion(error)
			
			if error == nil{
				authDataResult!.user.sendEmailVerification { error in
					print("auth email sent with error : ", (error?.localizedDescription))
				}
			}
			
			if authDataResult?.user != nil{
				let user = User(id: authDataResult!.user.uid, userName: email, email: email, pushId: "", avatarLink: "", status: "Hey There")
				saveUserLocally(user)
				self.saveUserToFirestore(user)
			}
		}
	}
	
	
	//Mark: - Resend link method
	
	func resendVerificationEmail(email : String , completion : @escaping (_ error : Error?) -> Void){
		
		Auth.auth().currentUser?.reload(completion: { error in
			Auth.auth().currentUser?.sendEmailVerification(completion: { error in
				
				completion(error)
			})
		})
		
	}
	
	func resetPassword(email : String , completion : @escaping (_ error : Error?) -> Void){
		Auth.auth().sendPasswordReset(withEmail: email) { errror in
			completion(errror)
		}
	}
	
	func logoutCurrentUser(completion : @escaping(_ error:Error?) -> Void){
		do {
			try Auth.auth().signOut()
			userDefaults.removeObject(forKey: kCURRENTUSER)
			userDefaults.synchronize()
			completion(nil)
		} catch {
			completion(error)
		}
		
	}
	
	//Mark: - Save User
	
	func saveUserToFirestore(_ user : User){
		do {
			let encoder = JSONEncoder()
			let data = try encoder.encode(user)
			guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
				  throw NSError()
				}
			FirebaseReference(.User).document(user.id).setData(dictionary)
		} catch{
			print("Unable to save user to firestore \(error.localizedDescription)")
		}
	}
	
	//Mark: Download
	
	func downloadUserFroFirebase(userId : String , email: String? = nil){
		FirebaseReference(.User).document(userId).getDocument { querySnapshot, error in
			
			guard let document = querySnapshot else{
				print("no document for user")
				return
			}
			
			let result = Result {
				try document.data(as: User.self)
			}
			
			switch result {
			case .success(let userObj):
				saveUserLocally(userObj)
				
			case .failure(let error):
				print("error decoading user : ", error.localizedDescription)
			}
			
		}
	}
	
	
}

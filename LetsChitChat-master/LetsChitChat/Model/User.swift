//
//  User.swift
//  LetsChitChat
//
//  Created by Aman Agrwal on 12/09/22.
//
 
import Foundation
import Firebase
import FirebaseFirestore

struct User : Codable , Equatable {
	var id = ""
	var userName : String
	var email : String
	var pushId = ""
	var avatarLink = ""
	var status : String
	
	static var currentId : String {
		return Auth.auth().currentUser!.uid
	}
	
	static var currentUser : User? {
		if(Auth.auth().currentUser != nil)
		{
			if let dict = UserDefaults.standard.data(forKey: kCURRENTUSER)
			{
				let decoder = JSONDecoder()
				
				do {
					let userObj = try decoder.decode(User.self, from: dict)
					return userObj
				} catch {
					print("Error : \(error.localizedDescription)")
				}
			}
		}
		return nil;
	}
	
	static func == (lhs : User , rhs : User) -> Bool
	{
		lhs.id == rhs.id
	}
	
}

func saveUserLocally(_ user:User){
	
	let encoder = JSONEncoder()
	do {
		let data = try encoder.encode(user)
		UserDefaults.standard.set(data, forKey: kCURRENTUSER)
	} catch {
		print("error saving user locally : \(error.localizedDescription)")
	}
	
	
}

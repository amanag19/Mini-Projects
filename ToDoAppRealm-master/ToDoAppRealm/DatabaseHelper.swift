//
//  DatabaseHelper.swift
//  ToDoAppRealm
//
//  Created by Aman Agrwal on 17/09/22.
//

import RealmSwift
import UIKit


class DatabaseHelper{
	static let shared = DatabaseHelper()
	
	private var realm = try! Realm()
	
	func getDatabaseUrl() -> URL? {
		return Realm.Configuration.defaultConfiguration.fileURL
	}
	
	func saveContact(contact : Contacts){
		try! realm.write({
			realm.add(contact)
		})
	}
	
	func getAllContacts() -> [Contacts]{
		return Array(realm.objects(Contacts.self))
	}
	
	func deleteContact(contact : Contacts){
		try! realm.write({
			realm.delete(contact)
		})
	}
	
	func updateContact(oldContact: Contacts , newContact : Contacts){
		try! realm.write({
			oldContact.firstName = newContact.firstName
			oldContact.lastName = newContact.lastName
		})
	}
	
}

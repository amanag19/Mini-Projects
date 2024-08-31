//
//  ViewController.swift
//  ToDoAppRealm
//
//  Created by Aman Agrwal on 16/09/22.
//

import RealmSwift
import UIKit

class Contacts: Object {
	@Persisted var firstName:String
	@Persisted var lastName:String
	
	convenience init(firstname:String , lastname :String) {
		self.init()
		self.firstName = firstname
		self.lastName = lastname
	}
}


class ViewController: UIViewController {
	
	@IBOutlet weak var contactsViewTable: UITableView!
	
	var contactArray = [Contacts]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configuration()
	}
	
	private func configuration(){
		contactsViewTable.delegate = self
		contactsViewTable.dataSource = self
		contactsViewTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		contactArray = DatabaseHelper.shared.getAllContacts()
	}

	@IBAction func addContactsButtonTapped(_ sender: Any) {
		contactConfig(isAdd: true, index: nil )
	}
	
	func contactConfig(isAdd : Bool , index : Int?){
		var title = ""
		var message = ""
		if(isAdd)
		{
			title = "Add Contact"
			message = "Please Enter Your Contact Details"
		}
		else{
			title = "Update Contact"
			message = "Please Update Your Contact Details"
		}
		
		let alertContrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let save = UIAlertAction(title: "Save", style: .default) { UIAlertAction in
			if let firstname = alertContrl.textFields?.first?.text , let lastname = alertContrl.textFields?[1].text{
				let contact = Contacts(firstname: firstname, lastname: lastname)
				if(isAdd){
					self.contactArray.append(contact)
					DatabaseHelper.shared.saveContact(contact: contact)
				}else{
					DatabaseHelper.shared.updateContact(oldContact: self.contactArray[index!], newContact: contact)
				}
				
				self.contactsViewTable.reloadData()
			}
		}
		
		let cancel = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
		
		alertContrl.addTextField { firstNameField in
			if(isAdd)
			{
				firstNameField.placeholder = "Enter your First name"
			}else{
				firstNameField.placeholder = self.contactArray[index!].firstName
			}
		}
		
		alertContrl.addTextField { lastNameField in
			if(isAdd){
				lastNameField.placeholder = "Enter your Last name"
			}else{
				lastNameField.placeholder = self.contactArray[index!].lastName
			}
		}
		
		alertContrl.addAction(save)
		alertContrl.addAction(cancel)
		present(alertContrl, animated: true)
	}
	
}

extension ViewController: UITableViewDataSource , UITableViewDelegate{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard var cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{
			return UITableViewCell()
		}
		cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
		cell.textLabel?.text = contactArray[indexPath.row].firstName
		cell.detailTextLabel?.text = contactArray[indexPath.row].lastName
		return cell;
		
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
			self.contactConfig(isAdd: false, index: indexPath.row )
		}
		
		edit.backgroundColor = .systemMint
		let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
			DatabaseHelper.shared.deleteContact(contact: self.contactArray[indexPath.row])
			self.contactArray.remove(at: indexPath.row)
			self.contactsViewTable.reloadData()
		}
		return UISwipeActionsConfiguration(actions: [delete,edit])
	}
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let leftSwapKrle = UIContextualAction(style: .normal, title: "left swap krle bhootnike") { _, _, _ in
			
		}
		leftSwapKrle.backgroundColor = .systemCyan
		return UISwipeActionsConfiguration(actions: [leftSwapKrle])
	}
	
}

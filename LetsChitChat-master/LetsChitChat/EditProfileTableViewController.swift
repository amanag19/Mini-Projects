//
//  EditProfileTableViewController.swift
//  LetsChitChat
//
//  Created by Aman Agrwal on 15/09/22.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController {

	var gallery : GalleryController!
	
	//Mark: - IBOutlets
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var userNameTextFiels: UITextField!
	
	@IBAction func editButtonPressed(_ sender: Any) {
		showImageGallery()
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureTextField()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		showUserInfo()
	}
	
	
	//Mark: - Update UI
	private func showUserInfo(){
		if let user = User.currentUser{
			userNameTextFiels.text = user.email
			statusLabel.text = user.status
			
			if user.avatarLink != "" {
				
			}
		}
	}
	
	//Mark: - gallery
	
	private func showImageGallery(){
		self.gallery = GalleryController()
		self.gallery.delegate = self
		Config.tabsToShow = [.imageTab , .cameraTab]
		Config.Camera.imageLimit = 1
		Config.initialTab = .imageTab
		self.present(gallery, animated: true)
	}
	
	//Mark: - Configure
	private func configureTextField(){
		userNameTextFiels.delegate = self
	}
	
	//Mark: - upload image to firebase
	private func uploadAvatarToFirebase(_ avatar : UIImage){
		let fileDir = "Avatars/" + "_\(User.currentId)" + ".jpg"
		FileStorage.uploadImage(avatar, directory: fileDir) { documentLink in
			if var user = User.currentUser{
				user.avatarLink = documentLink ?? ""
				saveUserLocally(user)
				FirebaseUserListener.shared.saveUserToFirestore(user)
			}
		}
	}
	
	
}

extension EditProfileTableViewController : UITextFieldDelegate , GalleryControllerDelegate{
	
	//Mark : galleryDelegate
	
	func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
		
		if images.count > 0 {
			images.first!.resolve { avatar in
				
				if(avatar != nil){
					self.uploadAvatarToFirebase(avatar!)
					self.avatarImageView.image = avatar
					
				}else{
					ProgressHUD.showError("Couldnt select image!")
				}
			}
		}
		controller.dismiss(animated: true)
	}
	
	func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
		controller.dismiss(animated: true)
	}
	
	func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
		controller.dismiss(animated: true)
	}
	
	func galleryControllerDidCancel(_ controller: GalleryController) {
		controller.dismiss(animated: true)
	}
	
	
	//MARK: - Table View Delegate
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
		return headerView
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 0 ? 0.0 : 30.0
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//Mark: - TextViewDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == userNameTextFiels
		{
			if textField.text != ""{
				
				if var user = User.currentUser{
					user.userName = textField.text!
					saveUserLocally(user)
					FirebaseUserListener.shared.saveUserToFirestore(user)
				}
				
			}
			textField.resignFirstResponder()
			return false
		}
		return true
	}
	
}

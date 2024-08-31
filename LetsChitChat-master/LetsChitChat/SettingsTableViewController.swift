//
//  SettingsTableViewController.swift
//  LetsChitChat
//
//  Created by Aman Agrwal on 15/09/22.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	//Mark: - IBOutlets
	
	
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var appVersionLable: UILabel!
	
	
	//Mark: - IBActions
	
	@IBAction func tellAFriendButtonPressed(_ sender: Any) {
	}
	
	
	@IBAction func termsAndConditionsButtonPressed(_ sender: Any) {
	}
	
	@IBAction func logoutButtonPressed(_ sender: Any) {
		FirebaseUserListener.shared.logoutCurrentUser { error in
			
			if(error == nil){
				
				let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
				
				DispatchQueue.main.async {
					loginView.modalPresentationStyle = .fullScreen
					self.present(loginView, animated: true)
				}
			}
			
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.tableFooterView = UIView()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		showUserInfo()
	}
	
	private func showUserInfo(){
		if let user = User.currentUser{
			userNameLabel.text = user.userName
			statusLabel.text = user.status
			appVersionLable.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
			
			if (user.avatarLink != "")
			{
				
			}
		}
	}

}

extension SettingsTableViewController{
	
	// tableViewDelegate
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
		return headerView
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 0 ? 0.0 : 10.0
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.section == 0 , indexPath.row == 0{
			performSegue(withIdentifier: "settingsToEditProfileSeg", sender: self)
		}
	}
}

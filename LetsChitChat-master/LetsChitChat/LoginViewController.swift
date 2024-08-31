//
//  ViewController.swift
//  LetsChitChat
//
//  Created by Aman Agrwal on 11/09/22.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
	@IBOutlet weak var emailLabelOutlet: UILabel!
	@IBOutlet weak var passwordLabelOutlet: UILabel!
	@IBOutlet weak var repeatPasswordLabelOutlet: UILabel!
	@IBOutlet weak var SignUpLabel: UILabel!
	
	
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var repeatPasswordTextField: UITextField!
	
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var resendEmailButton: UIButton!
	@IBOutlet weak var signUpButton: UIButton!
	
	@IBOutlet weak var repeatPasswordLineView: UIView!
	
	var isLogin = true
	
	@IBAction func loginButtonPressed(_ sender: Any) {
		if(isDataInputesForType(type: isLogin ? "login" : "registration"))
		{
			isLogin ? loginUser() : registerUser()
		}
		else
		{
			ProgressHUD.showFailed("All field are required")
		}
	}
	
	@IBAction func forgetPasswordButtonPressed(_ sender: Any) {
		if(isDataInputesForType(type: "forgetPassword"))
		{
			resetPassword()
		}
		else
		{
			ProgressHUD.showFailed("Email is required")
		}
	}
	
	@IBAction func resendEmailButtonPressed(_ sender: Any) {
		if(isDataInputesForType(type: "forgetPassword"))
		{
			resendVerificationEmail()
		}
		else
		{
			ProgressHUD.showFailed("Email is required")
		}
	}
	
	
	@IBAction func signUpButtonPressed(_ sender: UIButton) {
		isLogin.toggle()
		if(sender.titleLabel?.text == "Login")
		{
			updateUIFor(login: true)
		}
		else
		{
			updateUIFor(login: false)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		emailTextField.delegate = self
		passwordTextField.delegate = self
		repeatPasswordTextField.delegate = self
		updateUIFor(login: true)
		setUpTextFieldDelegate()
		setUpBackgrounfTapped()
	}
	
	private func setUpTextFieldDelegate(){
		emailTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
		passwordTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
		 repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
	}
	
	private func setUpBackgrounfTapped(){
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc func backgroundTapped(){
		print("Amana")
		view.endEditing(false)
	}
	
	@objc func textFieldDidChanged(_ textField :UITextField){
		updatePlaceholderLabel(textField: textField)
	}
	
	private func updatePlaceholderLabel(textField :UITextField){
		switch textField {
		case emailTextField:
			if(textField.hasText)
			{
				emailLabelOutlet.text = "Email"
			}
			else
			{
				emailLabelOutlet.text = ""
			}
		case passwordTextField:
			if(textField.hasText)
			{
				passwordLabelOutlet.text = "Password"
			}
			else
			{
				passwordLabelOutlet.text = ""
			}
		case repeatPasswordTextField:
			if(textField.hasText)
			{
				repeatPasswordLabelOutlet.text = "Repeat Password"
			}
			else
			{
				repeatPasswordLabelOutlet.text = ""
			}
		default:
			break
		}
	}
	
	private func updateUIFor(login : Bool){
		loginButton.setTitle(login ? "Login" : "Register", for: .normal)
		signUpButton.setTitle(login ? "SignUp" : "Login", for: .normal)
		SignUpLabel.text = login ? "Dont have an account? " : "Have an Account?"
		UIView.animate(withDuration: 0.2) {
			self.repeatPasswordLabelOutlet.isHidden = login
			self.repeatPasswordTextField.isHidden = login
			self.repeatPasswordLineView.isHidden = login
		}
	}
	
	private func isDataInputesForType(type : String) ->Bool
	{
		switch type {
		case "login":
			return emailTextField.text != "" && passwordTextField.text != ""
		case "registration":
			return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
		case "forgetPassword":
			return emailTextField.text != ""
		default:
			break
		}
		return true
	}
	
	private func loginUser(){
		FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField!.text!) { error, isEmailVerified in
			
			if error == nil{
				if(isEmailVerified){
					print("user logged in : ", User.currentUser?.email)
					self.goToApp()
				}else{
					ProgressHUD.showError("Please verify email")
					self.resendEmailButton.isHidden = false
				}
			}else{
				ProgressHUD.showError(error?.localizedDescription)
			}
			
		}
	}
	
	private func registerUser(){
		if passwordTextField.text! == repeatPasswordTextField.text!{
			FirebaseUserListener.shared.registerUseWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
				if error == nil{
					ProgressHUD.showSuccess("Send Verification Email.")
					self.resendEmailButton.isHidden = false
				}
				else
				{
					ProgressHUD.showFailed(error!.localizedDescription)
				}
			}
		}
		else
		{
			ProgressHUD.showError("Password don't match")
		}
	}
	
	private func resetPassword(){
		FirebaseUserListener.shared.resetPassword(email: emailTextField.text!) { error in
			if error == nil{
				ProgressHUD.showSuccess("Reset link sent to email")
			}else{
				ProgressHUD.showError(error?.localizedDescription)
			}
		}
	}
	
	private func resendVerificationEmail(){
		FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { error in
			if error == nil {
				ProgressHUD.showSuccess("New Verification email is sent")
			}else{
				ProgressHUD.showError(error?.localizedDescription)
			}
		}
	}

}

extension LoginViewController : UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case emailTextField:
			passwordTextField.becomeFirstResponder()
		case passwordTextField:
			if(isLogin)
			{
				passwordTextField.resignFirstResponder()
			}
			else
			{
				repeatPasswordTextField.becomeFirstResponder()
			}
		case repeatPasswordTextField:
			repeatPasswordTextField.resignFirstResponder()
		default:
			break
		}
		return true
	}
	
	///Mark : -  Navigation
	
	private func goToApp(){
		let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
		
		mainView.modalPresentationStyle = .fullScreen
		self.present(mainView, animated: true , completion: nil)
	}
}

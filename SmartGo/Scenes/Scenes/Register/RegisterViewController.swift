//
//  RegisterViewController.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/7/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController, ReuseIdentifier {
  
  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  @IBOutlet weak var confirmPasswordTextfield: UITextField!
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var emailStateLabel: UILabel!
  @IBOutlet weak var passwordStateLabel: UILabel!
  @IBOutlet weak var confirmPasswordStateLabel: UILabel!
  
  var viewModel = RegisterViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNav()
    setupTextfield()
    hideKeyboardWhenTappedAround()
  }
  
  override func setupNav() {
    super.setupNav()
    // Set navigation bar translucent style
    self.navigationBarTranslucentStyle()
    setupBackButton()
    setupResetButton()
  }
  
  
  @IBAction func register(_ sender: Any) {
    guard let email = emailTextfield.text else { return }
    guard let pass = passwordTextfield.text else { return }
    guard let confirmPass = confirmPasswordTextfield.text else { return }
    
    let checkEmpty = viewModel.checkValueIsEmpty(email: email, password: pass, confirmPassword: confirmPass)
    if checkEmpty {
      textFiledNotification(email: email, password: pass, confirmPassword: confirmPass)
    } else {
      UIHelper.showLoading()
      viewModel.register(email: email, password: pass) { success in
        if success {
          let signInViewModel = SignInViewModel()
          signInViewModel.signIn(email: email, password: pass) { check in
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
              let vc = Helper.getViewController(named: HomeViewController.identifier, inSb: Storyboard.home.rawValue) as! HomeViewController
              self.navigationController?.pushViewController(vc, animated: true)
            }
            UIHelper.hideLoading()
            self.showAlert(title: "Notification", mess: "Account successfully created", action: [action])
          }
        }
      }
    }
  }
}

extension RegisterViewController {
  
  private func setupUI() {
    setupUIRegisterButton()
  }
  
  private func setupUIRegisterButton() {
    registerButton.roundBorder(radius: 5)
  }
  
  private func setupResetButton() {
    let resetButton = createBarButtonItem(action: #selector(reset), image: Icons.reset, title: nil, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30))
    addLeftRightButton(button: resetButton, pos: .right)
  }
  
  @objc func reset() {
    emailTextfield.text = ""
    passwordTextfield.text = ""
    confirmPasswordTextfield.text = ""
  }
}

extension RegisterViewController: UITextFieldDelegate {
  
  func setupTextfield() {
    emailTextfield.delegate = self
    passwordTextfield.delegate = self
    confirmPasswordTextfield.delegate = self
    
    emailTextfield.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
    passwordTextfield.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
    confirmPasswordTextfield.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return true
  }
  
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  func textFiledNotification(email: String , password: String , confirmPassword: String) {
    emailStateLabel.text = viewModel.notificationTextField(text: email, of: UserProfileTextField.email)
    passwordStateLabel.text = viewModel.notificationTextField(text: password, of: UserProfileTextField.password)
    confirmPasswordStateLabel.text = viewModel.notificationTextField(text: confirmPassword, of: UserProfileTextField.confirm)
    
    emailStateLabel.textColor = UIColor.red
    passwordStateLabel.textColor = UIColor.red
    confirmPasswordStateLabel.textColor = UIColor.red
  }
  
  func resetLabel() {
    emailStateLabel.text = ""
    passwordStateLabel.text = ""
    confirmPasswordStateLabel.text = ""
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  @objc func emailTextFieldDidChange(_ textField: UITextField) {
    resetLabel()
    guard let email = emailTextfield.text else { return }
    guard let pass = passwordTextfield.text else { return }
    guard let confirmPass = confirmPasswordTextfield.text else { return }
    
    let checkEmpty = viewModel.checkValueIsEmpty(email: email, password: pass, confirmPassword: confirmPass)
    if !checkEmpty {
      viewModel.checkUserExists(email: email) { check in
        if check {
          self.emailStateLabel.text = "* Valid email"
          self.emailStateLabel.textColor = UIColor.green
        } else {
          self.emailStateLabel.text = "* Email already exists"
          self.emailStateLabel.textColor = UIColor.red
        }
      }
    } else {
      textFiledNotification(email: email, password: pass, confirmPassword: confirmPass)
    }
  }
  
  @objc func passwordTextFieldDidChange(_ textField: UITextField) {
    resetLabel()
    guard let email = emailTextfield.text else { return }
    guard let pass = passwordTextfield.text else { return }
    guard let confirmPass = confirmPasswordTextfield.text else { return }
    
    let checkEmpty = viewModel.checkValueIsEmpty(email: email, password: pass, confirmPassword: confirmPass)
    if checkEmpty {
      textFiledNotification(email: email, password: pass, confirmPassword: confirmPass)
    } else {
      let checkMatch = viewModel.checkPasswordIsMatch(password: pass, confirmPassword: confirmPass)
      if checkMatch {
        confirmPasswordStateLabel.text = "* Match password"
        confirmPasswordStateLabel.textColor = UIColor.green
      } else {
        confirmPasswordStateLabel.text = "* Password is not match"
        confirmPasswordStateLabel.textColor = UIColor.red
      }
    }
  }
}

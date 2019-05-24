//
//  SignInViewController.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/7/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController, ReuseIdentifier {

  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  @IBOutlet weak var signInView: UIView!
  @IBOutlet weak var emailStateLabel: UILabel!
  @IBOutlet weak var passwordStateLabel: UILabel!
  
  var viewModel = SignInViewModel()
  
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
    self.navigationController?.navigationItem.hidesBackButton = true
    setupNavBarButton()
  }
  
  @IBAction func signIn(_ sender: Any) {
    guard let email = emailTextfield.text else { return }
    guard let pass = passwordTextfield.text else { return }
    
    let checkEmpty = viewModel.checkValueIsEmpty(email: email, password: pass)
    if checkEmpty {
      textFiledNotification(email: email, password: pass)
    } else {
      UIHelper.showLoading()
      viewModel.signIn(email: email, password: pass) { check in
        UIHelper.hideLoading()
        if check {
          let popVC = UIAlertAction(title: "OK", style: .default) { (popVC) in
            let vc = Helper.getViewController(named: HomeViewController.identifier, inSb: Storyboard.home.rawValue) as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
          }
          self.showAlert(title: "Notification", mess: "Sign in successfully", action: [popVC])
        } else {
          self.showAlert(title: "Notification", mess: "Email or password is incorrect, please re-enter", action: [UIAlertAction(title: "OK", style: .cancel, handler: nil)])
        }
      }
    }
  }
  
  @IBAction func register(_ sender: Any) {
    let vc = Helper.getViewController(named: RegisterViewController.identifier, inSb: Storyboard.register.rawValue) as! RegisterViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension SignInViewController {
  
  private func setupUI() {
    setupUISignInButton()
  }
  
  private func setupUISignInButton() {
    signInButton.roundBorder(radius: 5)
  }
  
  private func setupNavBarButton() {
    let resetButton = createBarButtonItem(action: #selector(reset), image: Icons.reset, title: nil, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30))
    addLeftRightButton(button: resetButton, pos: .right)
    addLeftButton()
  }
  
  @objc func reset() {
    emailTextfield.text = ""
    passwordTextfield.text = ""
  }
}

extension SignInViewController: UITextFieldDelegate {
  
  func setupTextfield() {
    emailTextfield.delegate = self
    passwordTextfield.delegate = self
    
    emailTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    passwordTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
  
  func textFiledNotification(email: String , password: String) {
    emailStateLabel.text = viewModel.notificationTextField(text: email, of: UserProfileTextField.email)
    passwordStateLabel.text = viewModel.notificationTextField(text: password, of: UserProfileTextField.password)
    
    emailStateLabel.textColor = UIColor.red
    passwordStateLabel.textColor = UIColor.red
  }
  
  func resetLabel() {
    emailStateLabel.text = ""
    passwordStateLabel.text = ""
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    resetLabel()
    
    guard let email = emailTextfield.text else { return }
    guard let pass = passwordTextfield.text else { return }
    
    let checkEmpty = viewModel.checkValueIsEmpty(email: email, password: pass)
    if checkEmpty {
      textFiledNotification(email: email, password: pass)
    }
  }
}

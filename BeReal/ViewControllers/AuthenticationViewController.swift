//
//  AuthenticationViewController.swift
//  BeReal
//
//  Created by Mina on 3/4/24.
//

import UIKit
import ParseSwift

class AuthenticationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authToggleButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var continueButton: UIButton!
    
    
    var isSigningUp = true {
        didSet {
            if isSigningUp == true {
                indicatorView.isHidden = false
                indicatorView.startAnimating()
                emailTextField.isHidden = false
                authToggleButton.setTitle("Have an account?", for: .normal)
                continueButton.setTitle("Sign up", for: .normal)
                indicatorView.stopAnimating()
                indicatorView.isHidden = true
               
            } else {
                indicatorView.isHidden = false
                indicatorView.startAnimating()
                emailTextField.isHidden = true
                authToggleButton.setTitle("Don't have an account?", for: .normal)
                continueButton.setTitle("Sign in", for: .normal)
                indicatorView.stopAnimating()
                indicatorView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        setupViews()
        setupTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupTextFields() {
        usernameTextfield.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextfield.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    func setupViews() {
        indicatorView.isHidden = true
        emailTextField.isHidden = false
        authToggleButton.setTitle("Have an account?", for: .normal)
        continueButton.setTitle("Sign up", for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextfield.isFirstResponder {
            emailTextField.becomeFirstResponder()
        } else if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            view.endEditing(true)
        }
        return true
    }
    

    @IBAction func authToggleButtonPressed(_ sender: Any) {
        isSigningUp.toggle()
        
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        guard let username = usernameTextfield.text, !username.isEmpty else {
            let alert = AlertPresenter.alert(title: "Missing username", message: "put a username", actions: [UIAlertAction(title: "OK", style: .cancel)])
            navigationController?.present(alert, animated: true)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            let alert = AlertPresenter.alert(title: "Missing password", message: "put a password", actions: [UIAlertAction(title: "OK", style: .cancel)])
            navigationController?.present(alert, animated: true)
            return
        }
        
        
        if isSigningUp {
            guard let email = emailTextField.text, !email.isEmpty else {
                let alert = AlertPresenter.alert(title: "Missing email", message: "put an email", actions: [UIAlertAction(title: "OK", style: .cancel)])
                navigationController?.present(alert, animated: true)
                return
            }
            
            var newUser = User()
            newUser.username = username
            newUser.email = email
            newUser.password = password

            newUser.signup { [weak self] result in

                switch result {
                case .success(_):
                    guard let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC") as? UITabBarController else {return}
                    self?.navigationController?.pushViewController(tabBarVC, animated: true)
                    
                case .failure(let error):

                    let alert = AlertPresenter.alert(title: "failed to sing up", message: error.localizedDescription, actions: [UIAlertAction(title: "Try again", style: .cancel)])
                    self?.navigationController?.present(alert, animated: true)
                }
            }
        } else {
            
             User.login(username: username, password: password) { [weak self] result in
                switch result {
                case .success(_):
                    
                    guard let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC") as? UITabBarController else {return}
                    self?.navigationController?.pushViewController(tabBarVC, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}


//
//  ProfileViewController.swift
//  BeReal
//
//  Created by Mina on 3/4/24.
//

import UIKit
import ParseSwift

class SettingsViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUsersInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func fetchUsersInfo() {
        guard let user = User.current else {return}
        DispatchQueue.main.async { [ weak self ] in
            self?.usernameTextField.text = user.username
            self?.emailTextField.text = user.email
        }
    }
    
    @IBAction func updateUsernameButtonPressed(_ sender: Any) {
        guard var user = User.current else {return}
        user.username = usernameTextField.text
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                try user.save()
                DispatchQueue.main.async {
                    let alert = AlertPresenter.alert(title: "Username updated", actions: [UIAlertAction(title: "OK", style: .cancel)])
                    self?.present(alert, animated: true)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func updateEmailButtonPressed(_ sender: Any) {
        guard var user = User.current else {return}
        user.email = emailTextField.text
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                try user.save()
                DispatchQueue.main.async {
                    let alert = AlertPresenter.alert(title: "Email updated", actions: [UIAlertAction(title: "OK", style: .cancel)])
                    self?.present(alert, animated: true)
                }
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        guard let email = User.current?.email else {return}
        
        User.passwordReset(email: email) { [weak self] result in
            switch result {
                
            case .success():
                DispatchQueue.main.async {
                    let alert = AlertPresenter.alert(title: "Check your email", message: "an email was sent to you." , actions: [UIAlertAction(title: "OK", style: .default)])
                    self?.present(alert, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = AlertPresenter.alert(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "Try again", style: .default)])
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        User.logout() { [weak self] result in
            switch result {
                
            case .success():
                self?.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = AlertPresenter.alert(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "Try again", style: .default)])
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
        
        guard let user = User.current else {return}
        
        let alert = AlertPresenter.alert(title: "Are you sure you want to delete your account?", actions: [
            UIAlertAction(title: "cancel", style: .cancel),
            UIAlertAction(title: "Delete Account", style: .destructive, handler: { _ in
                user.delete { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.navigationController?.popToRootViewController(animated: true)
                    case .failure(let error):
                        DispatchQueue.main.async {
                        let alert = AlertPresenter.alert(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "Try again", style: .default)])
                            self?.present(alert, animated: true)
                        }
                    }
                }
            
        })])
        present(alert, animated: true)
    }
}

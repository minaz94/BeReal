//
//  LaunchViewController.swift
//  BeReal
//
//  Created by Mina on 3/6/24.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var logoTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logoTextLabel.typeOutText("BeReal", delay: 0.2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6 * 0.2) { [weak self] in
            if User.current != nil {
                self?.showTabBarVC()
            } else {
                self?.showAuthVC()
            }
        }
    }
    
    private func showTabBarVC() {
        let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    private func showAuthVC() {
        guard let authVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "authVC") as? AuthenticationViewController else {return}
        navigationController?.pushViewController(authVC, animated: true)
    }
}

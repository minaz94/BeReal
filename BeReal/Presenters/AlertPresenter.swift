//
//  AlertPressenter.swift
//  BeReal
//
//  Created by Mina on 3/4/24.
//

import UIKit

class AlertPresenter {
    
    
    static func alert(title: String, message: String? = nil, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach { action in
            alert.addAction(action)
        }
        return alert
    }
}

//
//  UILabel+Ext.swift
//  BeReal
//
//  Created by Mina on 3/6/24.
//

import UIKit


extension UILabel {
    
    func typeOutText(_ text: String, delay: TimeInterval = 0.5) {
        
        self.text = ""
        
        let writingTask = DispatchWorkItem { [weak self] in
            text.enumerated().forEach { (index, character) in
                DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(index)) {
                    self?.text?.append(character)
                }
            }
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: writingTask)
    }
}

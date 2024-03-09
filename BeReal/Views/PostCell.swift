//
//  PostCell.swift
//  BeReal
//
//  Created by Mina on 3/4/24.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func configureFor(post: Post) {
        
        DispatchQueue.main.async { [weak self] in
            if let user = post.user {
                self?.usernameLabel.text = user.username
            }

            if post.description?.replacingOccurrences(of: " ", with: "") == "" {
                self?.descriptionLabel.isHidden = true
            } else {
                self?.descriptionLabel.text = post.description
            }
            
            if let date = post.createdAt {
                self?.timeLabel.text = date.dayAndTimeText
            }
            self?.layoutIfNeeded()
        }
        
        guard let imageFile = post.imageFile, let url = imageFile.url else {return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error {
                print(error.localizedDescription)
            }
            if let data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.postImageView.image = image
                }
            }
        }.resume()
    }
}

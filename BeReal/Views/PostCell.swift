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
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    var navigationController: UINavigationController?
    var post: Post?
    
    override func awakeFromNib() {
        commentButton.addTarget(self, action: #selector(commentsVC), for: .touchUpInside)
    }
    
    func configureFor(post: Post) {
        
        guard let postCreatedDate = post.createdAt else {return}
        
        DispatchQueue.main.async { [weak self] in
            
            if let longitude = post.longitude, let latitude = post.latitude {
                print(longitude, latitude)
                self?.locationLabel.isHidden = false
                LocationManager.shared.geoCodeLocation(longitude: longitude, latitude: latitude) { locationString in
                    self?.locationLabel.text = locationString
                }
            } else {
                self?.locationLabel.isHidden = true
            }
        
            if let user = post.user {
                self?.usernameLabel.text = user.username
            }

            if post.description?.replacingOccurrences(of: " ", with: "") == "" {
                self?.descriptionLabel.isHidden = true
            } else {
                self?.descriptionLabel.text = post.description
            }
          
            self?.timeLabel.text = postCreatedDate.dayAndTimeText
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
        
        
        if let lastPostedDate = User.current?.lastPostedDate {
            if let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {
                blurView.isHidden = abs(diffHours) < 24
            } else {
                blurView.isHidden = false
            }
        } else {
            blurView.isHidden = false
        }
    }
    
    @objc func commentsVC() {
        guard let commentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "commentsVC") as? CommentsViewController else {return }
        commentsVC.post = post
        navigationController?.present(commentsVC, animated: true)
    }
    
}

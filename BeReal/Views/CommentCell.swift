//
//  CommentCell.swift
//  BeReal
//
//  Created by Mina on 3/11/24.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func configureFor(comment: Comment) {
        usernameLabel.text = comment.username
        commentLabel.text = comment.comment
    }
    
}

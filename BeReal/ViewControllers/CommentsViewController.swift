//
//  CommentsViewController.swift
//  BeReal
//
//  Created by Mina on 3/11/24.
//

import UIKit
import ParseSwift

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    var post: Post!
    var comments: [Comment] = [] {
        didSet {
            DispatchQueue.main.async {
                self.commentsTableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationsForKeyboard()
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        queryComments()
    }
    
    func queryComments() {
        if let postObjectId = post.objectId {
            let query = Comment.query()
                .where("postObjectId" == postObjectId)
                .order([.ascending("createdAt")])
            
            query.find { result in
                switch result {
                case .success(let comments):
                    self.comments = comments
                    print(comments)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        
        guard let commentText = commentTextField.text else {return}
        guard !commentText.isEmpty else {return}
        guard commentText.trimmingCharacters(in: .whitespaces) != "" else {return}
        
        guard let user = User.current else {return}
        
        let comment = Comment(username: user.username, comment: commentText, postObjectId: post.objectId)
        
        
        comment.save { result in
            switch result {
                
            case .success(_):
                self.comments.append(comment)
                NotificationManager.shared.scheduleTestNotification()
                DispatchQueue.main.async {
                    self.commentTextField.text = nil
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CommentsViewController: UITableViewDelegate {}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell else { return UITableViewCell() }
        cell.configureFor(comment: comments[indexPath.row])
        return cell
    }
}


extension CommentsViewController {

    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            
            switch notification.name {
            case UIApplication.keyboardWillShowNotification:
                UIView.animate(withDuration: 0, animations: {
                    self.inputViewBottomConstraint.constant += keyboardFrame.height - 34
                    self.view.layoutIfNeeded()
                })
            case UIApplication.keyboardWillHideNotification:
                UIView.animate(withDuration: 0, animations: {
                    self.inputViewBottomConstraint.constant = 16
                    self.view.layoutIfNeeded()
                })
            default:
                break
            }
        }
    }

    func addNotificationsForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
}

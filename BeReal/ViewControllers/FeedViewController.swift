//
//  FeedViewController.swift
//  BeReal
//
//  Created by Mina on 3/4/24.
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var refreshControl = UIRefreshControl()
    
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
            tableView.layoutIfNeeded()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryPosts()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshPosts() {
        refreshControl.beginRefreshing()
        queryPosts()
    }
    
    
    func queryPosts() {

        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])

        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts 
                self?.refreshControl.endRefreshing()
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = AlertPresenter.alert(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "Try again", style: .cancel)])
                    self?.present(alert, animated: true)
                }
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {

        guard let postVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postVC") as? PostViewController else {return }
        navigationController?.pushViewController(postVC, animated: true)
    }
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        cell.configureFor(post: posts[indexPath.row])
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {}

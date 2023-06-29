//
//  ViewController.swift
//  MultipleAPIs
//
//  Created by Cumulations Technologies Private Limited on 27/06/23.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ViewController: UIViewController{
    
    
    @IBOutlet weak var postsTableView: UITableView!
    
    @IBOutlet weak var usersCollectionView: UICollectionView!
    let postsLoader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballRotateChase, color: UIColor.red, padding: nil)
    let usersLoader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballRotateChase, color: UIColor.blue, padding: nil)
    var users: [User] = []
    var posts: [Posts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(usersLoader)
        usersLoader.center = usersCollectionView.center

        view.addSubview(postsLoader)
        postsLoader.center = postsTableView.center
        
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = self
        usersCollectionView.register(UsersCollectionViewCell.nib(), forCellWithReuseIdentifier: "UsersCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing =  10
        layout.itemSize = CGSize(width: 204, height: 176)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        usersCollectionView.collectionViewLayout = layout
        usersCollectionView.isScrollEnabled = true
        usersCollectionView!.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        usersCollectionView.isPagingEnabled = false
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(PostsTableViewCell.nib(), forCellReuseIdentifier: "PostsTableViewCell")

    }
    
    /*Sequential handling involves making API calls one after another, where each subsequent call waits for the previous one to complete before initiating the next. This approach is useful when the result of one API call is needed before making another.*/
    
    @IBAction func sequentialBtnTapped(_ sender: Any) {
        usersLoader.startAnimating()
        postsLoader.startAnimating()
        
        self.users = []
        self.posts = []
        self.usersCollectionView.reloadData()
        self.postsTableView.reloadData()
        
        
        
        let viewModel = UsersViewModel()
        viewModel.fetchUsers { users, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                self.usersLoader.stopAnimating()
                self.postsLoader.stopAnimating()
                return
            }
            
            guard let users = users else {
                self.usersLoader.stopAnimating()
                self.postsLoader.stopAnimating()
                return
            }
            self.users = users
            self.usersCollectionView.reloadData()
            print("Users: \(users)")
            self.usersLoader.stopAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                let postsViewModel = PostsViewModel()
                postsViewModel.fetchPosts { posts, error in
                    if let error = error {
                        print("Error fetching posts: \(error.localizedDescription)")
                        self.postsLoader.stopAnimating()
                        return
                    }
                    
                    guard let posts = posts else {
                        self.postsLoader.stopAnimating()
                        return
                    }
                    self.posts = posts
                    self.postsTableView.reloadData()
                    print("Posts: \(posts)")
                    self.postsLoader.stopAnimating()
                }
            }
 
        }

    }
    
    /*
     Parallel handling involves making API calls concurrently, allowing multiple calls to be executed simultaneously. This approach is beneficial when the order of the responses doesn't matter, and you want to optimize performance by leveraging parallel processing.
    */
    @IBAction func parallelBtnTap(_ sender: Any) {
        usersLoader.startAnimating()
        postsLoader.startAnimating()
        
        self.users = []
        self.posts = []
        self.usersCollectionView.reloadData()
        self.postsTableView.reloadData()
        
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        let usersViewModel = UsersViewModel()
        usersViewModel.fetchUsers { users, error in
            defer {
                dispatchGroup.leave()
            }
            
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                self.usersLoader.stopAnimating()
                return
            }
            
            guard let users = users else {
                self.usersLoader.stopAnimating()
                return
            }
            self.users = users
            
            print("Users: \(users)")
        }

        dispatchGroup.enter()
        let postsViewModel = PostsViewModel()
        postsViewModel.fetchPosts { posts, error in
            defer {
                dispatchGroup.leave()
            }
            
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                self.postsLoader.stopAnimating()
                return
            }
            
            guard let posts = posts else {
                self.postsLoader.stopAnimating()
                return
            }
            self.posts = posts
            
            print("Posts: \(posts)")
        }

        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.usersCollectionView.reloadData()
                        self.postsTableView.reloadData()
                        self.usersLoader.stopAnimating()
                        self.postsLoader.stopAnimating()
                    }
            
        }

    }
    /*
     Combined handling involves a combination of sequential and parallel approaches. You may have some API calls that depend on others, while others can be executed concurrently. This approach provides flexibility in handling different dependencies.
    */
    @IBAction func combinedBtnTap(_ sender: Any) {
        
        usersLoader.startAnimating()
        postsLoader.startAnimating()
        
        self.users = []
        self.posts = []
        self.usersCollectionView.reloadData()
        self.postsTableView.reloadData()
        
        let viewModel = UsersViewModel()
        viewModel.fetchUsers { users, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            guard let users = users else {
                return
            }
            self.users = users
            self.usersCollectionView.reloadData()
            print("Users: \(users)")
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            let postsViewModel = PostsViewModel()
            postsViewModel.fetchPosts { posts, error in
                defer {
                    dispatchGroup.leave()
                }
                
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                    return
                }
                
                guard let posts = posts else {
                    return
                }
                self.posts = posts
                self.postsTableView.reloadData()
                print("Posts: \(posts)")
            }
            

            dispatchGroup.notify(queue: .main) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.usersLoader.stopAnimating()
                            self.postsLoader.stopAnimating()
                        }
            }

        }

    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath) as! UsersCollectionViewCell
        let user = users[indexPath.row] as  User
        
        cell.nameLbl.text = user.name
        cell.userNameLbl.text = user.username
        cell.companyLbl.text = user.company.name
        cell.addressLbl.text = "\(user.address.city), \(user.address.street), \(user.address.suite)"
        
        return cell
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for: indexPath) as! PostsTableViewCell
        cell.selectionStyle = .none
        let post = posts[indexPath.row] as  Posts
        cell.titleLbl.text = post.title
        cell.bodyLbl.text = post.body
        return cell
    }
    
    
}

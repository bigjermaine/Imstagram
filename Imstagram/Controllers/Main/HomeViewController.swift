//
//  HomeViewController.swift
//  Imstagram
//
//  Created by MacBook AIR on 28/09/2023.
//


import UIKit
import Firebase
import FirebaseDatabase


class HomeViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: "HomePostCell")
        navigationItem.titleView = UIImageView(image:UIImage(named:"Instagram-Logo-2013-2015"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector( handleCamera))
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        fetch()
        
    }
    
    @objc func handleCamera() {
    let vc = CameraViewController()
     vc.modalPresentationStyle = .fullScreen
       present(vc, animated: true)
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetch()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostCell", for: indexPath) as! HomePostCell
        cell.post =  posts[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 40 + 8 + 8 + 50 + 50 + 40
        height += view.frame.width
        return CGSize(width: view.frame.width, height: height)
    }
    
    var user:User?
    var imageUrl:String?
    fileprivate func fetchUser(uid:String) {

        guard let uisd = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("posts").child(uisd).observeSingleEvent(of: .value, with:  {[weak self] snapShot  in
            
            guard let dictionary = snapShot.value as? [String:Any] else {
                
                return
            }
            if let safeSelf = self {
                dictionary.forEach { key ,value  in
                    
                    guard let dictionary =  value as? [String:Any] else {
                        
                        return
                    }
                    let newPost = Post(post: dictionary, user: User(user: dictionary, uid: uid))
                    safeSelf.posts.append(newPost)
                    self?.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    
                    safeSelf.collectionView.reloadData()
                    self?.collectionView.refreshControl?.endRefreshing()
                  
                }
                
            }
            
            
            
        })
    }
    func fetch() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) {[weak self] (snapShot )in
            guard let dictionary = snapShot.value as? [String:Any] else {
                
                return
            }
            dictionary.forEach { key ,value  in
                
                self?.fetchUser(uid:key)
            }
        }
        
    }
    
}


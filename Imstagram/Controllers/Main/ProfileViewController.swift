//
//  ProfileViewController.swift
//  Imstagram
//
//  Created by MacBook AIR on 28/09/2023.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
var posts = [Post]()
    
    var userId:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        collectionView?.backgroundColor = .white
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderId")
        collectionView.register( PhotoSelctionCollectionViewCell.self, forCellWithReuseIdentifier: "cellIds")
        fetchUser()
        setUpLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUser()
    }
    func   setUpLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(signOut))
    }
    
    
    @objc func signOut() {
        let alertController = UIAlertController(title: "Log Out", message: "Are You Sure You Want To Logout", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive,handler: { [weak self]_ in
            self?.presentLoginView()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
            
        }))
        present(alertController, animated: true)
    }
    
    
 
    
   
    func presentLoginView() {
        let loginController = SignInViewController()
        let navControlller = UINavigationController(rootViewController: SignInViewController())
        navControlller.modalPresentationStyle = .fullScreen
        self.present(navControlller, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cellIds", for: indexPath) as! PhotoSelctionCollectionViewCell
        cell.setupProfileImage(post:  posts[indexPath.row])  
        return cell
    }
     override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderId", for: indexPath) as! UserProfileHeader
         header.userId = userId
         
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    
    fileprivate func fetchUser() {
        
        let uid =  userId ??  Auth.auth().currentUser?.uid ?? ""
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapShot) in
            guard let dictionary = snapShot.value as? [String:Any] else {
                
                return
            }
            
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
        }
        
    
        Database.database().reference().child("posts").child(uid).queryOrdered(byChild: "creationDate").observe(.childAdded, with:  {[weak self] snapShot  in
          
            guard let dictionary = snapShot.value as? [String:Any] else {
                
                return
            }
            if let safeSelf = self {
                let newPost = Post(post: dictionary, user:User(user:  dictionary , uid:  uid))
                if !(safeSelf.posts.contains(where: { $0.post == newPost.post })) {
                    safeSelf.posts.append(newPost)
                    print(newPost)
                    safeSelf.collectionView.reloadData()
                }
            }

          
        
        })
       
    }
}

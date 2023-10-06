//
//  SearchViewViewController.swift
//  Imstagram
//
//  Created by MacBook AIR on 28/09/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
class SearchViewViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    
    var users = [User]()
    
    var filterArray = [User]()
    
    lazy var  SearchBar:UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Username"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .gray.withAlphaComponent(0.5)
        return sb
    }()
    let cellId = "searchCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.addSubview(SearchBar)
        SearchBar.translatesAutoresizingMaskIntoConstraints = false
        let navBar = navigationController?.navigationBar
        NSLayoutConstraint.activate ([
            SearchBar.topAnchor.constraint(equalTo: navBar?.topAnchor ?? view.topAnchor,constant: 0),
            SearchBar.leftAnchor.constraint(equalTo:navBar?.leftAnchor ?? view.leftAnchor,constant: 8),
            SearchBar.rightAnchor.constraint(equalTo: navBar?.rightAnchor ?? view.rightAnchor,constant: -8),
            SearchBar.bottomAnchor.constraint(equalTo: navBar?.bottomAnchor ?? view.topAnchor)
        ])
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.keyboardDismissMode = .onDrag
        fetchUser()
        SearchBar.delegate = self
       }
   
    override func viewWillAppear(_ animated: Bool) {
        SearchBar.isHidden = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterArray =   self.users.filter({$0.username
            .lowercased().contains(searchText.lowercased())})
        if searchText.isEmpty {
            filterArray = users
        }
        self.collectionView.reloadData()
    }
    fileprivate func  fetchUser() {
        
        let ref =  Database.database().reference().child("users").observe(.value, with:{[weak self] snapShot  in
            
            guard let dictionary = snapShot.value as? [String:Any] else {
                return
            }
           
            
            dictionary.forEach { key, value in
                guard let value = value as? [String:Any] else {
                    return
                }
                if key ==  Auth.auth().currentUser?.uid {return}
                let user = User(user: value, uid: key)
                self?.users.append(user)
                self?.filterArray = self!.users
                self?.collectionView.reloadData()
            }
            print(dictionary)
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterArray.count
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)  as! UserSearchCell
        cell.backgroundColor = .white
        cell.configureCell(user: filterArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
      
        SearchBar.isHidden = true
        SearchBar.resignFirstResponder()
        let userId = filterArray[indexPath.row]
        let userProfileController = ProfileViewController(collectionViewLayout:UICollectionViewFlowLayout())
        userProfileController.userId =  userId.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
}

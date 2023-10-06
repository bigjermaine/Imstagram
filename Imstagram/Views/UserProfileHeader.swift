//
//  UserProfileHeader.swift
//  Imstagram
//
//  Created by MacBook AIR on 28/09/2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

class UserProfileHeader:UICollectionViewCell {
    
    
    var userId:String? {
        didSet{
            setupProfileImage()
            setEditFollowButton()
        }
    }
    
   
    let profileImageView:UIImageView = {
       let ic = UIImageView()
        ic.translatesAutoresizingMaskIntoConstraints = false
     return ic
    }()
    
    let gridButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle.grid.3x3"), for: .normal)
        button.tintColor = .black
        
      return button
    }()
    let listButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.tintColor = .blue
      return button
    }()
    
    let bookmarkButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .blue
      return button
    }()
    
    
    let userName:UILabel = {
        let button = UILabel()
        button.textAlignment = .left
        button.font = .systemFont(ofSize: 12)
       return button
    }()
    
    
    let postLabel:UILabel = {
        let button = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica", size: 14)!
        ]
        
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica", size: 14)!,
            .foregroundColor: UIColor.gray // Change to your desired color
        ]
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: attributes)
        attributedText.append( NSMutableAttributedString(string: "Posts", attributes: attributes2))
        button.attributedText = attributedText
        
        button.numberOfLines = 0
        button.textAlignment = .center
       return button
    }()
    
    
    let followingLabel:UILabel = {
        let button = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica", size: 14)!
        ]
        
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica", size: 14)!,
            .foregroundColor: UIColor.gray // Change to your desired color
        ]
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: attributes)
        attributedText.append( NSMutableAttributedString(string: "Following", attributes: attributes2))
        button.attributedText = attributedText
        
        button.numberOfLines = 0
        button.textAlignment = .center
       return button
    }()
    
    
    let followersLabel:UILabel = {
        let button = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica", size: 14)!
        ]
        
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica", size: 14)!,
            .foregroundColor: UIColor.gray // Change to your desired color
        ]
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: attributes)
        attributedText.append( NSMutableAttributedString(string: "Followers", attributes: attributes2))
        button.attributedText = attributedText
        
        button.numberOfLines = 0
        button.textAlignment = .center
        return button
    }()
    
    lazy var editButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor.copy(alpha: 0.3)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
      return button
    }()
    
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview( userName)
       addSubview(editButton)

        
        setupProfileImage()
        configure()
        setUpBottomToolbar()
        setUpStaticsToolbar()
        
    
    }
    
    fileprivate func  setupProfileImage() {
        
        let uid =  userId ??  Auth.auth().currentUser?.uid ?? ""
        
        
        
        
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapShot,_  in
            guard let dictionary = snapShot.value as? [String:Any] else {
                
                return
            }
            
           guard let username = dictionary["username"] as? String else {return}
            
            guard  let profileImageUrl = dictionary["profileImageUrl"] as? String else {return}
          
            
            guard let url = URL(string: profileImageUrl ) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data  = data else {return}
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                    self.userName.text = username
                }
                
            }.resume()
        }
    
    }
    
    func setEditFollowButton() {
        guard let currentLoggedUserId =  Auth.auth().currentUser?.uid else {return
          
        }
        guard let  userId = userId else {return}
        if currentLoggedUserId ==  userId {
            self.editButton.setTitle("edit", for: .normal)
        }else {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            Database.database().reference().child("following").child(uid).child(userId).observeSingleEvent(of: .value) {[weak self] (snapshot )in
             
                
                if snapshot.key == userId   {
                    print(snapshot.key)
                    print(userId)
                    self?.editButton.setTitle("unfollow", for: .normal)
                    self?.editButton.backgroundColor = .systemBlue
                    self?.editButton.setTitleColor(.white, for: .normal)
                }else {
                   
                    self?.editButton.setTitle("follow", for: .normal)
                    self?.editButton.backgroundColor = .systemBlue
                    self?.editButton.setTitleColor(.white, for: .normal)
                }
            }
          
        }
        
    }
    
    
    
    @objc func handleEditProfileOrFollow() {
        
        if editButton.titleLabel?.text == "follow" {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let values = [userId: 1]
            guard let  userId = userId else {return}
            Database.database().reference().child("following").child(uid).child(userId).updateChildValues(values){[weak self] error,snapshot in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self?.editButton.setTitle("unfollow", for: .normal)
            }
           
        }else{
            guard let uid = Auth.auth().currentUser?.uid else {return}
            guard let  userId = userId else {return}
            Database.database().reference().child("following").child(uid).child(userId).removeValue{[weak self] error,snapshot in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self?.editButton.setTitle("follow", for: .normal)
            }
            
           
        }
    }
  
    fileprivate func  setUpBottomToolbar() {
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
         addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        stackView.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stackView.widthAnchor.constraint(equalTo:widthAnchor).isActive = true
     
        
    }
    
    fileprivate func  setUpStaticsToolbar() {
        let stackView = UIStackView(arrangedSubviews: [postLabel,followersLabel,followingLabel])
         addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        stackView.topAnchor.constraint(equalTo:topAnchor,constant: 10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        stackView.rightAnchor.constraint(equalTo:rightAnchor,constant:-20).isActive = true
        stackView.leftAnchor.constraint(equalTo:profileImageView.rightAnchor,constant: 10).isActive = true
        
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: 5).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editButton.leftAnchor.constraint(equalTo: postLabel.leftAnchor).isActive = true
        editButton.rightAnchor.constraint(equalTo:followingLabel.rightAnchor,constant: 0).isActive = true
        
  
        
      
        
    }
    func configure() {
        profileImageView.topAnchor.constraint(equalTo: topAnchor,constant: 10).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        
        profileImageView.topAnchor.constraint(equalTo: topAnchor,constant: 10).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        userName.topAnchor.constraint(equalTo:    profileImageView.bottomAnchor,constant: 20).isActive = true
        userName.leftAnchor.constraint(equalTo: leftAnchor,constant: 10).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userName.widthAnchor.constraint(equalToConstant: 120).isActive = true
    
        
    
        
      
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

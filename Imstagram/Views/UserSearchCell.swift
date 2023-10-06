//
//  UserSearchCell.swift
//  Imstagram
//
//  Created by MacBook AIR on 05/10/2023.
//

import Foundation
import UIKit
class UserSearchCell: UICollectionViewCell {
   
       
       let photoImageView:UIImageView = {
           let iv = UIImageView()
           iv.translatesAutoresizingMaskIntoConstraints = false
           iv.backgroundColor = .lightGray
           iv.clipsToBounds = true
           return iv
       }()
    
    let userName:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "jermaine"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
       return label
    }()
    
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           addSubview(photoImageView)
           addSubview(userName)
           configure()
           
          }
       
       func configure() {
           
           
          
           NSLayoutConstraint.activate ([
            photoImageView.heightAnchor.constraint(equalToConstant: 50),
               photoImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
               photoImageView.widthAnchor.constraint(equalToConstant: 50),
               photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
           ])
           photoImageView.layer.cornerRadius = 25
           NSLayoutConstraint.activate ([
            userName.centerYAnchor.constraint(equalTo: centerYAnchor),
            userName.leftAnchor.constraint(equalTo:photoImageView.rightAnchor,constant: 10),
            userName.rightAnchor.constraint(equalTo: rightAnchor,constant: -20),
            userName.bottomAnchor.constraint(equalTo: bottomAnchor)
           ])
       }
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func configureCell(user:User) {
        userName.text = user.username
        
        
        if let cacheImage = imageCache[user.userImage] {
            DispatchQueue.main.async { [weak self] in
                self?.photoImageView.image = cacheImage
                
            }
        }
        
        guard let url = URL(string:user.userImage ) else {return}
        
        
        URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            
            guard let data  = data else {return}
            //prevent dowload twice
            
            let image = UIImage(data: data)
            
            imageCache[url.absoluteString] = image
            DispatchQueue.main.async {
                self?.photoImageView.image = image
                
                
            }
            
        }.resume()
    }
    }
    
    
   


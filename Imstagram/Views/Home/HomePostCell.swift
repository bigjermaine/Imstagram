//
//  HomePostCell.swift
//  Imstagram
//
//  Created by MacBook AIR on 03/10/2023.
//

import Foundation
import UIKit

var imageCache = [String:UIImage]()
class HomePostCell:UICollectionViewCell {
    
    
    
    var post:Post? {
        didSet{
            guard let post = post else {return}
            setupProfileImage(post:post)
            setupProfileImage2(post:post)
            usernameLabel.text = post.user.username
            configure(post:post)
        }
        
        
        
    }
    
    
    func configure(post:Post) {
        
        let attributedText = NSMutableAttributedString(string:post.caption, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " Some caption text that will perhaps wrap onto the next line", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        
        attributedText.append(NSAttributedString(string:  timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        captionLabel.attributedText = attributedText
        captionLabel.numberOfLines = 0
    }
    
    
    let photoImageView:UIImageView = {
     let ic = UIImageView()
     ic.translatesAutoresizingMaskIntoConstraints = false
     return ic
    }()
    
    
    let userPhotoImageView:UIImageView = {
        let ic = UIImageView()
        ic.contentMode = .scaleToFill
        ic.clipsToBounds = true
        ic.translatesAutoresizingMaskIntoConstraints = false
        return ic
    }()
    
    
    let usernameLabel:UILabel = {
     let label = UILabel()
     label.text = "Username"
     label.textColor = .black
     label.font = UIFont.boldSystemFont(ofSize: 14)
     label.translatesAutoresizingMaskIntoConstraints = false
     return  label
    }()
    
    
    let optionButton:UIButton = {
        let button = UIButton()
        button.setTitle("...", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return   button
    }()
    
    let postButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "paperplane")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return   button
    }()
    let commentButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "tray")
           button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
           button.tintColor = .black
        return   button
    }()
    
    
    let captionLabel: UILabel = {
        let label = UILabel()
//        label.text = "SOMETHING FOR NOW"
      
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return   button
    }()
    
    
    let bookmarkButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName:  "bookmark")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return   button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(userPhotoImageView)
        
        NSLayoutConstraint.activate ([
            userPhotoImageView.topAnchor.constraint(equalTo: topAnchor,constant: 0),
            userPhotoImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 50),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        userPhotoImageView.layer.cornerRadius = 50/2
        
        
        addSubview( optionButton)
        
        NSLayoutConstraint.activate ([
            optionButton.centerYAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            optionButton.leftAnchor.constraint(equalTo:rightAnchor,constant: -50),
            optionButton.heightAnchor.constraint(equalToConstant: 50),
            optionButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        addSubview(usernameLabel)
        NSLayoutConstraint.activate ([
            usernameLabel.centerYAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            usernameLabel.leftAnchor.constraint(equalTo:  userPhotoImageView.rightAnchor,constant: 10),
            usernameLabel.rightAnchor.constraint(equalTo:   optionButton.leftAnchor,constant: -10),
            usernameLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
        
       
        
        addSubview( photoImageView)
        NSLayoutConstraint.activate ([
            photoImageView.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor,constant: 5),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 0),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor,constant: 0),
            photoImageView.heightAnchor.constraint(equalTo: widthAnchor)
        ])
        setUPActionButton()
        
    }
    fileprivate func setUPActionButton() {
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,postButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        addSubview( stackView )
        NSLayoutConstraint.activate ([
            stackView.topAnchor.constraint(equalTo:  photoImageView.bottomAnchor,constant: 5),
            stackView.leftAnchor.constraint(equalTo: leftAnchor,constant: 0),
            stackView.widthAnchor.constraint(equalToConstant: 140),
            stackView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
        addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate ([
            bookmarkButton.topAnchor.constraint(equalTo:  photoImageView.bottomAnchor,constant: 5),
            bookmarkButton.leftAnchor.constraint(equalTo:rightAnchor,constant: -50),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 50),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        addSubview(captionLabel)
        
        NSLayoutConstraint.activate ([
            captionLabel.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor,constant: 5),
            captionLabel.leftAnchor.constraint(equalTo: leftAnchor,constant:10),
            captionLabel.widthAnchor.constraint(equalTo: widthAnchor),
            captionLabel.bottomAnchor.constraint(equalTo:bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func  setupProfileImage(post:Post?) {
         guard let post  = post else {return}
         
         if let cacheImage = imageCache[post.post] {
             DispatchQueue.main.async { [weak self] in
                 self?.photoImageView.image = cacheImage

             }
         }
        
        guard let url = URL(string:post.post ) else {return}
        
        
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
    
       func  setupProfileImage2(post:Post?) {
        guard let post  = post else {return}
        
        if let cacheImage = imageCache[post.post] {
            DispatchQueue.main.async { [weak self] in
                self?.userPhotoImageView.image = cacheImage

            }
        }
       
          guard let url = URL(string:post.user.userImage ) else {return}
       
           URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
               
               guard let data  = data else {return}
               //prevent dowload twice
               let image = UIImage(data: data)
               imageCache[url.absoluteString] = image
               DispatchQueue.main.async {
                   self?.userPhotoImageView.image = image
                   

               }

           }.resume()
       }
   
    
}

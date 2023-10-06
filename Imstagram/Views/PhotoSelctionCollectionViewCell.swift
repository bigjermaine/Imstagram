//
//  PhotoSelctionCollectionViewCell.swift
//  Imstagram
//
//  Created by MacBook AIR on 29/09/2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

class PhotoSelctionCollectionViewCell: UICollectionViewCell {
    var lastUrlImageToLoad:String?
    
   
    
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        configure()
       }
    
    func configure() {
        NSLayoutConstraint.activate ([
            photoImageView.topAnchor.constraint(equalTo: topAnchor,constant: 0),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 0),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor,constant: 0),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func  setupProfileImage(post:Post?) {
        
    
        lastUrlImageToLoad = post?.post
        guard let url = URL(string:post?.post ?? "" ) else {return}
        
        
            URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
                
                guard let data  = data else {return}
                //prevent dowload twice
                if  url.absoluteString != self?.lastUrlImageToLoad   {return}
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.photoImageView.image = image

                }

            }.resume()
        }
    
    }


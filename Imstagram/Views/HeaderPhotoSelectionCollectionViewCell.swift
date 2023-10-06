//
//  HeaderPhotoSelectionCollectionViewCell.swift
//  Imstagram
//
//  Created by MacBook AIR on 29/09/2023.
//

import UIKit

class HeaderPhotoSelectionCollectionViewCell: UICollectionViewCell {
   
       
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
   }

//
//  PreviewContainerView.swift
//  Imstagram
//
//  Created by MacBook AIR on 06/10/2023.
//

import Foundation
import UIKit
import Photos
class previewContainerView:UIView {
    
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let backButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.bin"), for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    
    }()
    
    
    let saveButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector( saveAction), for: .touchUpInside)
        return button
    
    }()
    
   @objc func backButtonAction() {
       self.removeFromSuperview()
    }

    
    @objc func saveAction() {
        guard let image = photoImageView.image else {return}
        let libray = PHPhotoLibrary.shared()
        libray.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: image)
            
        }){
            sucss,err in
            if let err = err  {return}
            self.removeFromSuperview()
        }
     }
   override init(frame:CGRect) {
        super.init(frame: frame)
       addSubview( photoImageView)
       photoImageView.topAnchor.constraint(equalTo:topAnchor,constant: 0).isActive = true
       photoImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
       photoImageView.rightAnchor.constraint(equalTo:rightAnchor,constant:0).isActive = true
       photoImageView.leftAnchor.constraint(equalTo:leftAnchor,constant: 0).isActive = true
       
       addSubview(backButton)
       backButton.topAnchor.constraint(equalTo:topAnchor,constant: 30).isActive = true
       backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
       backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
       backButton.leftAnchor.constraint(equalTo:leftAnchor,constant: -50).isActive = true
       addSubview(saveButton)
       saveButton.centerXAnchor.constraint(equalTo:centerXAnchor,constant: 0).isActive = true
       saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
       saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
       saveButton.bottomAnchor.constraint(equalTo:bottomAnchor,constant: -50).isActive = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

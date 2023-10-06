//
//  ShareViewController.swift
//  Imstagram
//
//  Created by MacBook AIR on 01/10/2023.
//

import UIKit
import Firebase
import FirebaseDatabase


class ShareViewController: UIViewController {
    
    
    var selectedImage:UIImage? {
        didSet{
            print(selectedImage)
            self.photoImageView.image = selectedImage
        }
    }
    let photoImageView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    
    let textField:UITextView = {
        let iv = UITextView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .white
        iv.font = .systemFont(ofSize: 14)
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(printShare))
        
        setUpImageViewAndTextViews()
    }
    
    func setUpImageViewAndTextViews(){
        let containerView = UIView()
        containerView.backgroundColor = .brown
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            containerView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor,constant: 0),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 0),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: 0),
            containerView.heightAnchor.constraint(equalToConstant:100)
        ])
        view.addSubview(photoImageView)
        NSLayoutConstraint.activate ([
            photoImageView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor,constant: 10),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
            photoImageView.widthAnchor.constraint(equalToConstant: 80),
            photoImageView.heightAnchor.constraint(equalToConstant:80)
        ])
        view.addSubview(textField)
        
        NSLayoutConstraint.activate ([
            textField.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor,constant: 10),
            textField.leftAnchor.constraint(equalTo: photoImageView.rightAnchor,constant: 4),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -5),
            textField.heightAnchor.constraint(equalToConstant:80)
        ])
    }
    @objc func printShare() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        print("Sharing")
        guard let image = selectedImage else {return}
        guard let uploadData =  image.jpegData(compressionQuality: 0.3) else {return}
        let fileName = UUID().uuidString
        Storage.storage().reference().child("posts").child(fileName).putData(uploadData) {[weak self]data,err in
            if let err = err {
                print(err)
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            Storage.storage().reference().child("posts").child(fileName).downloadURL(completion: {[weak self] url , error in
                guard let url = url else {
                    let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .actionSheet)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
                        
                    }))
                    self?.present(alertController, animated: true)
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
                self?.saveToDatabaseWithImageUrl(url:url.absoluteString)
            }
                                                                                     
                                                              
                                                                                     
        )}
        }
    
    
    fileprivate func saveToDatabaseWithImageUrl(url:String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let caption = textField.text else {return}
      
        let values = ["imageUrl":url,
                      "caption":caption,
                      "creationDate":Date().timeIntervalSince1970
        ] as [String : Any]
        Database.database().reference().child("posts").child(uid).childByAutoId().updateChildValues(values){ (err,ref) in
            if let err = err {
                print("failed\(err)")
            }
            
            
        }
    }

 
}

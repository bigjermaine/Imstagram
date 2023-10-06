//
//  ViewController.swift
//  Imstagram
//
//  Created by MacBook AIR on 25/09/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage


class SignupController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
 
    
    
    
    let InstaImage:UIImageView  = {
        let button = UIImageView()
        button.image = UIImage(named: "Instagram-Logo-2013-2015")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let signInButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Have Account Sign in", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    let plusPhotoButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    
    }()
    @objc func handlePlusPhoto() {
    let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage") ] as? UIImage
        plusPhotoButton.setImage(editedImage, for: .normal)
        plusPhotoButton.layer.cornerRadius = 25
        plusPhotoButton.layer.masksToBounds = true
        
        dismiss(animated: true)
        
    }
     
    let emailTextField:UITextField =  {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .gray.withAlphaComponent(0.3)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(emailFieldCheck), for: .editingChanged)
        return tf
    }()
  
        
    let passwordTextField:UITextField =  {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .gray.withAlphaComponent(0.3)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(emailFieldCheck), for: .editingChanged)
        return tf
    }()
        
    let usernameTextField:UITextField =  {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .gray.withAlphaComponent(0.3)
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
        
    let signUPbutton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.isEnabled = false
        return button
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        view.addSubview(InstaImage)
        view.addSubview(plusPhotoButton)
        
        navigationController?.isNavigationBarHidden = true
        configureConstriants()
        setUpInputFields()
        signUPbutton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
    }

    
   
    func configureConstriants() {
        
        InstaImage.heightAnchor.constraint(equalToConstant: 140).isActive = true
        InstaImage.widthAnchor.constraint(equalToConstant: 140).isActive = true
        InstaImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        InstaImage.topAnchor.constraint(equalTo: view.topAnchor,constant: 40).isActive = true
        
       
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: InstaImage.bottomAnchor,constant: 10).isActive = true
        
       
    
    }
    
    @objc func emailFieldCheck() {
        if emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0{
            signUPbutton.backgroundColor = .systemBlue
          
            signUPbutton.isEnabled = true
        }else {
            signUPbutton.isEnabled = false
            signUPbutton.backgroundColor = .red
        }
     }
    
 @objc func handleSignup() {
     guard let email = emailTextField.text,email.count > 0,
              let password  = passwordTextField.text,password.count > 0,
              let username = usernameTextField.text
        else {return}
     
     
     Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
         guard error == nil else {
             let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .actionSheet)
             alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
                 
             }))
             self?.present(alertController, animated: true)
            
             return
         }
        
         UserDefaults.standard.set(email, forKey: "email")
         
         guard let image = self?.plusPhotoButton.imageView?.image?.jpegData(compressionQuality: 0.3) else {return}
         
         let userID = UUID().uuidString
         Storage.storage().reference().child("profile_image").child(userID).putData(image,metadata: nil ) { [weak self]metaData, error in
             if let error = error {
                 let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .actionSheet)
                 alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
                     
                 }))
                 self?.present(alertController, animated: true)
                 print(error.localizedDescription)
              return
             }
             
        
             Storage.storage().reference().child("profile_image").child(userID).downloadURL(completion: {[weak self] url , error in
                 guard let url = url else {
                     let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .actionSheet)
                     alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
                         
                     }))
                     self?.present(alertController, animated: true)

                     return
                 }
                 let urlString = url.absoluteString
                 print("url dowload sucessful\(urlString)")
                 
                 guard let user = result?.user.uid else {return}
                 
                 let usernameValues = ["username":username,
                                       "profileImageUrl" :urlString]
                
                 let values = [user:usernameValues]
                 let ref = Database.database().reference().child("users").updateChildValues(values){ (err,ref) in
                     if let err = err {
                         print("failed\(err)")
                     }
                     
                     DispatchQueue.main.async {
                         let navControlller = UINavigationController(rootViewController: MainTabbarViewController())
                         navControlller.modalPresentationStyle = .fullScreen
                         self?.present(navControlller, animated: true)
                     }
                 }

            }
             )}
         
       
       
       
         
     }
        
        
    }
    
    fileprivate func setUpInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,usernameTextField,signUPbutton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate ([
            stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor,constant: 40),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -40),
            stackView.heightAnchor.constraint(equalToConstant:200)
        ])
        
        
        
        view.addSubview(signInButton)
     
        
        NSLayoutConstraint.activate ([
            signInButton.topAnchor.constraint(equalTo: view.bottomAnchor,constant: -60),
            signInButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 40),
            signInButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -40),
            signInButton.heightAnchor.constraint(equalToConstant:40)
        ])
        
        signInButton.addTarget(self, action: #selector(handlesignInButton), for: .touchUpInside)
        
    }
    
    @objc func handlesignInButton() {
         let navC = SignInViewController()
        
        navigationController?.pushViewController(navC, animated: true)
     }
}


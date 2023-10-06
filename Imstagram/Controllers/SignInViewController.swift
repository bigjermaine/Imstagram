//
//  SignupViewController.swift
//  Imstagram
//
//  Created by MacBook AIR on 29/09/2023.
//

import UIKit
import FirebaseAuth
class SignInViewController: UIViewController {
    
    
    
    let InstaImage:UIImageView  = {
        let button = UIImageView()
        button.image = UIImage(named: "Instagram-Logo-2013-2015")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
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

    
    let signUPbutton:UIButton = {
        let button = UIButton()
        button.setTitle("Dont have An Account Sign Up", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    
    let signInbutton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.isEnabled = false
        return button
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signUPbutton)
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        view.addSubview(InstaImage)
        view.addSubview(signUPbutton)
        navigationController?.isNavigationBarHidden = true
        
        setUpInputFields()
       
        
        signInbutton.addTarget(self, action: #selector( handleSignin), for: .touchUpInside)
        signUPbutton.addTarget(self, action: #selector( handleSignup), for: .touchUpInside)
       
    }
    
    
    
    
    fileprivate func setUpInputFields() {
        
        
        InstaImage.heightAnchor.constraint(equalToConstant: 140).isActive = true
        InstaImage.widthAnchor.constraint(equalToConstant: 140).isActive = true
        InstaImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        InstaImage.topAnchor.constraint(equalTo: view.topAnchor,constant: 40).isActive = true
        
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,signInbutton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate ([
            stackView.topAnchor.constraint(equalTo: InstaImage.bottomAnchor,constant: 10),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -40),
            stackView.heightAnchor.constraint(equalToConstant:150)
        ])
        
        NSLayoutConstraint.activate ([
            signUPbutton.topAnchor.constraint(equalTo: view.bottomAnchor,constant: -60),
            signUPbutton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 40),
            signUPbutton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -40),
            signUPbutton.heightAnchor.constraint(equalToConstant:40)
        ])
             
    }
    @objc func emailFieldCheck() {
        if emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0{
            signInbutton.backgroundColor = .systemBlue
          
            signInbutton.isEnabled = true
        }else {
            signInbutton.isEnabled = false
            signInbutton.backgroundColor = .red
        }
     }
    
    
    
 @objc func handleSignin() {
     guard let email = emailTextField.text,email.count > 0,
        let password  = passwordTextField.text,password.count > 0
            
        else {return}
     
     
     Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, error in
     
         guard error == nil else {
             let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .actionSheet)
             alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
                 
             }))
             self?.present(alertController, animated: true)

             return
         }
         
         DispatchQueue.main.async {
          
             let navControlller = UINavigationController(rootViewController: MainTabbarViewController())
             navControlller.modalPresentationStyle = .fullScreen
             self?.present(navControlller, animated: true)
         }
         UserDefaults.standard.set(email, forKey: "email")
     }
       
         
     }
        
   @objc func handleSignup() {
        let navC = SignupController()
        navigationController?.pushViewController(navC, animated: true)
    }
   
}

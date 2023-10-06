//
//  MainTabbarViewController.swift
//  Imstagram
//
//  Created by MacBook AIR on 28/09/2023.
//

import UIKit
import Firebase
class MainTabbarViewController: UITabBarController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.delegate = self
        view.backgroundColor  = .white
        
       
        
        let Vc1 =  HomeViewController(collectionViewLayout:UICollectionViewFlowLayout())
        let Vc2 =  SearchViewViewController(collectionViewLayout:UICollectionViewFlowLayout())
        let Vc3 =  UploadViewController(collectionViewLayout:UICollectionViewFlowLayout())
        let Vc4 =  NotificationViewController()
        let Vc5 =  ProfileViewController(collectionViewLayout:UICollectionViewFlowLayout())

        // Do any additional setup after loading the view.
        
        Vc1.navigationItem.largeTitleDisplayMode = .never
        
        Vc2.navigationItem.largeTitleDisplayMode = .never
        Vc3.navigationItem.largeTitleDisplayMode = .never
        Vc4.navigationItem.largeTitleDisplayMode = .never
      
        
        let nav1 = UINavigationController(rootViewController: Vc1)
        let nav2 = UINavigationController(rootViewController: Vc2)
        let nav3 = UINavigationController(rootViewController: Vc3)
        let nav4 = UINavigationController(rootViewController: Vc4)
        let nav5 = UINavigationController(rootViewController: Vc5)
       
        
        if let originalImage = UIImage(systemName:"house") {
            let tabBarItemSize = CGSize(width: 20, height: 20) // Adjust the size as needed
            UIGraphicsBeginImageContextWithOptions(tabBarItemSize, false, UIScreen.main.scale)
            originalImage.draw(in: CGRect(origin: .zero, size: tabBarItemSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
    
            nav1.tabBarItem = UITabBarItem(title: "", image: resizedImage?.withRenderingMode(.alwaysOriginal), tag: 2)
         }
        
        nav1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        if let originalImage = UIImage(systemName: "magnifyingglass") {
            let tabBarItemSize = CGSize(width: 20, height: 20) // Adjust the size as needed
            UIGraphicsBeginImageContextWithOptions(tabBarItemSize, false, UIScreen.main.scale)
            originalImage.draw(in: CGRect(origin: .zero, size: tabBarItemSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
    
            nav2.tabBarItem = UITabBarItem(title: "", image: resizedImage?.withRenderingMode(.alwaysOriginal), tag: 2)
         }
        nav2.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        
        // Replace "notes" with the actual name of your image asset
        if let originalImage = UIImage(systemName: "plus.square") {
            let tabBarItemSize = CGSize(width: 20, height: 20) // Adjust the size as needed
            UIGraphicsBeginImageContextWithOptions(tabBarItemSize, false, UIScreen.main.scale)
            originalImage.draw(in: CGRect(origin: .zero, size: tabBarItemSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
    
            nav3.tabBarItem = UITabBarItem(title: "", image: resizedImage?.withRenderingMode(.alwaysOriginal), tag: 2)
         }
        
        nav3.tabBarItem.selectedImage = UIImage(systemName: "plus.fill")
        
           if let originalImage = UIImage(systemName:"play.rectangle") {
            let tabBarItemSize = CGSize(width: 20, height: 20) // Adjust the size as needed
            UIGraphicsBeginImageContextWithOptions(tabBarItemSize, false, UIScreen.main.scale)
            originalImage.draw(in: CGRect(origin: .zero, size: tabBarItemSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
    
            nav4.tabBarItem = UITabBarItem(title: "", image: resizedImage?.withRenderingMode(.alwaysOriginal), tag: 2)
           }
        
          nav4.tabBarItem.selectedImage = UIImage(systemName: "play.rectangle.fill")
        
            if let originalImage = UIImage(systemName:"person.circle") {
                let tabBarItemSize = CGSize(width: 20, height: 20) // Adjust the size as needed
                UIGraphicsBeginImageContextWithOptions(tabBarItemSize, false, UIScreen.main.scale)
                originalImage.draw(in: CGRect(origin: .zero, size: tabBarItemSize))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
        
                nav5.tabBarItem = UITabBarItem(title: "", image: resizedImage?.withRenderingMode(.alwaysOriginal), tag: 2)
             }
            
        nav5.tabBarItem.selectedImage = UIImage(systemName: "person.circle.fill")
        
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()

        nav2.navigationBar.backgroundColor = .clear
        nav2.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav2.navigationBar.shadowImage = UIImage()

     
        nav3.navigationBar.backgroundColor = .clear
        nav3.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav3.navigationBar.shadowImage = UIImage()

     
        nav4.navigationBar.backgroundColor = .clear
        nav4.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav4.navigationBar.shadowImage = UIImage()

    
        
        nav5.navigationBar.backgroundColor = .clear
        nav5.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav5.navigationBar.shadowImage = UIImage()
        
        
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor  = .black
        UITabBar.appearance().unselectedItemTintColor = .white
        setViewControllers([nav1,nav2,nav3,nav4,nav5], animated: false)
        
      
    }
    


}

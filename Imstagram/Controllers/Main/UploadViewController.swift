//
//  UploadViewController.swift
//  Imstagram
//
//  Created by MacBook AIR on 28/09/2023.
//

import UIKit
import Photos

class UploadViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{

    
    
    var images = [UIImage]()
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.backgroundColor = .white
        collectionView.register(PhotoSelctionCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(HeaderPhotoSelectionCollectionViewCell.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
      //collectionView.contentInsetAdjustmentBehavior = .never
        
        fetchPhotos()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleNext))
    }
    
    @objc func handleNext() {
       let  ShareViewController =  ShareViewController()
        ShareViewController.selectedImage = selectedImage
        navigationController?.pushViewController(ShareViewController, animated: false)
        
    }
    fileprivate func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        
        let allphotos = PHAsset.fetchAssets(with: .image,options: fetchOptions)
   
       
        allphotos.enumerateObjects { asset, count, stop in
            print(asset)
            let imageManager = PHImageManager.default()
            let target = CGSize(width: 350, height: 350)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: target, contentMode: .aspectFit, options: options) { image, info in
                print(image as Any)
                if let image = image {
                    self.images.append(image)
                    
                    if self.selectedImage == nil {
                        self.selectedImage = image
                    }
                }
                if count == allphotos.count - 1 {
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  images.count
    }
  
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PhotoSelctionCollectionViewCell
        cell.photoImageView.image = images[indexPath.item]
        self.collectionView.reloadData()
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedImage = images[indexPath.item]
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! HeaderPhotoSelectionCollectionViewCell
        header.photoImageView.image = selectedImage
//        if let  selectedImage = selectedImage {
//            if let index = self.images.index(of: selectedImage) {
//                let selectedAsset  = self.assets[index]
//                let imageManager = PHImageManager.default()
//                let target = CGSize(width: 350, height: 350)
//                let options = PHImageRequestOptions()
//                options.isSynchronous = true
//                imageManager.requestImage(for: selectedAsset, targetSize: target, contentMode: .aspectFit, options: options) { image, info in
//
//
//                }
//            }
//        }
//
        
        
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
}

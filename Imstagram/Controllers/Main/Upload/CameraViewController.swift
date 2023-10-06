//
//  CameraViewController.swift
//  Imstagram
//
//  Created by MacBook AIR on 05/10/2023.
//

import UIKit
import AVFoundation
class CameraViewController: UIViewController,AVCapturePhotoCaptureDelegate {

    
    let captureButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(handleCapture), for: .touchUpInside)
      return button
    }()

   let previewImage = previewContainerView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        setupCaptureSession()
        view.addSubview(captureButton)
        
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 5).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
  
        
    }
    
    
   
    let output = AVCapturePhotoOutput()
    
    
    
    @objc func handleCapture() {
        
        let settings = AVCapturePhotoSettings()
        let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String :  previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            // Handle the case where imageData is nil
            return
        }
        
        // Use the imageData here
        let previewImageView = previewContainerView()
        view.addSubview(previewImageView)
        let previewImage = UIImage(data: imageData)
        previewImageView.photoImageView.image = previewImage
        
        
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.topAnchor.constraint(equalTo:view.topAnchor,constant: 0).isActive = true
        previewImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        previewImageView.rightAnchor.constraint(equalTo:view.rightAnchor,constant:0).isActive = true
        previewImageView.leftAnchor.constraint(equalTo:view.leftAnchor,constant: 0).isActive = true
        
    }
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            } else {
                print("Failed to add input to capture session.")
            }
            
        } catch {
            print("Error setting up AVCaptureDeviceInput: \(error)")
        }
        
       
        captureSession.addOutput(output)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }

   
}

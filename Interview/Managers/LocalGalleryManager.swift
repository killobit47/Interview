//
//  LocalGalleryManager.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

enum GalleryComplation: Error {
    case userСanceled
    case notReceivedImage
    case noAccess(String)
}

class LocalGalleryManager: NSObject, Router {

    typealias completion = (_ image: UIImage?, _ error:GalleryComplation?) -> Void
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        return imagePicker
    }()
    
    private var completionBlock : (completion)?
    static let shared = LocalGalleryManager()
    
    public func locadImage(completion: @escaping(completion)) {
        
        let alert = UIAlertController(title: "Choose image from:", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alertAction) in
            LocalGalleryManager.shared.getImageFromCamera(completion: completion)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alertAction) in
            LocalGalleryManager.shared.getImageFromGallery(completion: completion)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            completion(nil, .userСanceled)
        }))
        show(viewController: alert, animated: true, completion: nil)
    }
    
    private func getImageFromGallery(completion: @escaping(completion)) {
        completionBlock = completion
        imagePicker.sourceType = .savedPhotosAlbum;

        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            show(viewController: imagePicker, animated: true)
        } else {
            if let block = completionBlock {
                block(nil, .noAccess("to gallery"))
                openApplicationSettingsWithAlert(message: "Need access to gallery")
            }
        }
    }
    
    private func getImageFromCamera(completion: @escaping(completion)) {

        if UIImagePickerController.isSourceTypeAvailable(.camera){
            completionBlock = completion
            imagePicker.sourceType = .camera
            show(viewController: imagePicker, animated: true)
        } else {
            if let block = completionBlock {
                block(nil, .noAccess("to camera"))
                openApplicationSettingsWithAlert(message: "Need access to camera")
            }
        }
    }
}

extension LocalGalleryManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hide(animated: true) {  [weak self] () -> Void in
            guard let weakSelf = self else {
                return
            }
            if let block = weakSelf.completionBlock {
                block(nil, .userСanceled)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        hide(animated: true, completion: { [weak self] () -> Void in
            guard let weakSelf = self else {
                return
            }
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                if let block = weakSelf.completionBlock {
                    block(image, nil)
                }
            } else {
                if let block = weakSelf.completionBlock {
                    block(nil, .notReceivedImage)
                }
            }
        })
    }
}

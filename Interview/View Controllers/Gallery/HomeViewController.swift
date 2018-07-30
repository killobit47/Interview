//
//  HomeViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit
import Nuke

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [[String: Any]] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(GalleryCollectionViewCell.cellNIB(), forCellWithReuseIdentifier: GalleryCollectionViewCellID)
        
        ApiManager.request(.all, nil) { [weak self] (responseObject, success, error) in
            
            if let response = responseObject as? [String: [[String: Any]]], let images = response["images"] {
                self?.images = images
            } else {
                self?.showAlert(withTitle: "Error", andMessage: "Something went wrong.")
            }
            
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapPlayButton(_ sender: Any) {
        
        showAlertWithTextField { (weather) in
            ApiManager.request(.gif, ["weather": weather], { [weak self] (responseObject, success, error) in
                if let response = responseObject as? [String: Any] {
                    self?.performSegue(withIdentifier: "gallery.toViewGif", sender: response["gif"])
                }
            })
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gallery.toViewGif" {
            if let destination = segue.destination as? GifViewerViewController, let url = URL(string: sender as! String) {
                destination.gifLink = url
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  (UIScreen.main.bounds.width - 40 ) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCellID, for: indexPath) as! GalleryCollectionViewCell
        
        let imageObject = images[indexPath.row]
        
        Nuke.loadImage(with: URL(string: imageObject["smallImagePath"] as! String )!, options: ImageLoadingOptions(placeholder: UIImage(named: "placeholder"), transition: .fadeIn(duration: 0.33)), into: cell.imageView)
        
        return cell
    }
    
    
    
}

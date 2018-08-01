//
//  HomeViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit
import Nuke
import Gifu
import JGProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var topSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()

    var images: [GImage] = [] {
        didSet {
            if topSegmentedControl.selectedSegmentIndex == 0 {
                collectionView.reloadData()
            }
        }
    }
    
    var gifs: [GGif] = [] {
        didSet {
            if topSegmentedControl.selectedSegmentIndex == 1 {
                collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(GalleryCollectionViewCell.cellNIB(), forCellWithReuseIdentifier: GalleryCollectionViewCellID)
        NotificationCenter.default.addObserver(self, selector:  #selector(HomeViewController.refresh), name: NeedsRefteshCollectionViewNotification, object: nil)
        setUPUI()
        refresh()
    }
    
    func setUPUI() {
        collectionView!.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh), for: .valueChanged)
        collectionView!.addSubview(refreshControl)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Actions
    
    @objc func refresh() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading..."
        hud.show(in: self.view)
        APIManager.loadAllPhotos { [weak self] (gallery, error) in
            if let error = error {
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.textLabel.text = "Error"
                if let apierror = error as? APIError {
                    hud.detailTextLabel.text = apierror.localizedDescription
                } else {
                    hud.detailTextLabel.text = error.localizedDescription
                }
                hud.dismiss(afterDelay: 6, animated: true)
            } else if let gallery = gallery {
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.dismiss(afterDelay: 1, animated: true)
                if let images = gallery.images {
                    self?.images = images
                }
                if let gifs = gallery.gifs {
                    self?.gifs = gifs
                }
            }
            self?.refreshControl.endRefreshing()
        }
    }

    @IBAction func didChangeValueTopSegmentedControl(_ sender: UISegmentedControl) {
        collectionView.reloadData()
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func didTapPlayButton(_ sender: Any) {
        
        showAlertWithTextField { (weather) in
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Loading gif..."
            hud.show(in: self.view)
            APIManager.loadGif(weather: weather, completion: { [weak self] (gif, error) in
                if let error = error {
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.textLabel.text = "Error"
                    if let apierror = error as? APIError {
                        hud.detailTextLabel.text = apierror.localizedDescription
                    } else {
                        hud.detailTextLabel.text = error.localizedDescription
                    }
                    hud.dismiss(afterDelay: 6, animated: true)
                } else if let gif = gif {
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.dismiss(afterDelay: 1, animated: true)
                    self?.performSegue(withIdentifier: "gallery.toViewGif", sender: gif.gif)
                }
            })
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.gallerySegue.toViewImage.rawValue {
            if let destination = segue.destination as? GifViewerViewController, let url = URL(string: sender as! String) {
                destination.imageLink = url
            }
        }
        else if segue.identifier == Segue.gallerySegue.toViewGif.rawValue {
            
            if let destination = segue.destination as? GifViewerViewController, let url = URL(string: sender as! String) {
                destination.gifLink = url
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if topSegmentedControl.selectedSegmentIndex == 0 {
            return images.count
        } else {
            return gifs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  (UIScreen.main.bounds.width - 30) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCellID, for: indexPath) as! GalleryCollectionViewCell
        
        if topSegmentedControl.selectedSegmentIndex == 0 {
            let imageObject = images[indexPath.row]
            
            cell.locationLabel.text = imageObject.parameters.address
            cell.weatherLabel.text = imageObject.parameters.weather
            
            Nuke.loadImage(with: URL(string: imageObject.smallImagePath)!, options: ImageLoadingOptions(placeholder: UIImage(named: "placeholder"), transition: .fadeIn(duration: 0.33)), into: cell.gImageView)
        } else {
            let gifObject = gifs[indexPath.row]
            cell.weatherLabel.text = gifObject.weather
            cell.locationLabel.text = String(gifObject.id)
            cell.gImageView.animate(withGIFURL: try! gifObject.path.asURL())
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if topSegmentedControl.selectedSegmentIndex == 0 {
            let imageObject = images[indexPath.row]
            performSegue(withIdentifier: Segue.gallerySegue.toViewImage.rawValue, sender: imageObject.smallImagePath)
        } else {
            let gifObject = gifs[indexPath.row]
            performSegue(withIdentifier: Segue.gallerySegue.toViewGif.rawValue, sender: gifObject.path)
        }
    }
}

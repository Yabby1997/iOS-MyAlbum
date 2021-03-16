//
//  ViewController.swift
//  MyAlbum
//
//  Created by Seunghun Yang on 2021/03/16.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    let cellIdentifier = "albumCell"
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    var albums: [PHAssetCollection] = []
    var thumbnails: [PHAsset] = []
    var numOfItems: [Int] = []
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        let halfWidth = UIScreen.main.bounds.width / 2.0
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 20
        flowLayout.itemSize = CGSize(width: halfWidth - 20, height: halfWidth + 35)
        self.collectionView.collectionViewLayout = flowLayout
        
        requestPhotoAuthority()
    }
    
    // MARK: - Functions
    func requestPhotoAuthority() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status{
        case .authorized:
            print("Authorized")
            requestCollectionList()
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Not determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("Authorized")
                    self.requestCollectionList()
                case .denied:
                    print("Denied")
                default:
                    break
                }
            })
        case .limited:
            print("Limited")
        case .restricted:
            print("Restricted")
        @unknown default:
            print("Unknown")
        }
    }
    
    func requestCollectionList() {
        let recents: PHFetchResult<PHAssetCollection>! = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favorites: PHFetchResult<PHAssetCollection>! = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let userAlbums: PHFetchResult<PHAssetCollection>! = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        for i in 0..<recents.count {
            albums.append(recents[i])
        }
        
        for i in 0..<favorites.count {
            albums.append(favorites[i])
        }
        
        for i in 0..<userAlbums.count {
            albums.append(userAlbums[i])
        }
        
        getMetaData()
    }
    
    func getMetaData() {
        for album in albums {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let asset = PHAsset.fetchAssets(in: album, options: fetchOptions)
            
            if asset.count != 0 {
                self.numOfItems.append(asset.count)
            }
            
            if let thumbnail = asset.firstObject {
                self.thumbnails.append(thumbnail)
            }
        }
    }

    // MARK: - CollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        imageManager.requestImage(
            for: thumbnails[indexPath.row],
            targetSize: CGSize(width: 300, height: 300),
            contentMode: .aspectFill,
            options: nil,
            resultHandler: { image, _ in
                cell.albumThumbnailImageView?.image = image
            })
        
        cell.albumThumbnailImageView.layer.cornerRadius = 5
        cell.albumThumbnailImageView.layer.masksToBounds = true
        
        cell.albumNameLabel.text = albums[indexPath.item].localizedTitle!
        cell.albumSizeLabel.text = String(numOfItems[indexPath.item])
        
        return cell
    }
    
    // MARK: - PHPhotoLibraryChangeObserver Methods
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("변화발생")
    }
    
}


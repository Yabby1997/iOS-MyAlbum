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
    
    var albums: [Album] = []
    
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
            self.getAlbum()
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Not determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("Authorized")
                    self.getAlbum()
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
    
    func getAlbum() {
        var collections: [PHAssetCollection] = []
        let recents = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        for i in 0..<recents.count {
            collections.append(recents[i])
        }
        
        for i in 0..<favorites.count {
            collections.append(favorites[i])
        }
        
        for i in 0..<userAlbums.count {
            collections.append(userAlbums[i])
        }
        
        for collection in collections {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            
            let numOfContents = assets.count
            
            guard let thumbnail = assets.firstObject else {
                return
            }
            
            albums.append(Album(collection: collection, thumbnail: thumbnail, numOfContents: numOfContents))
        }
    }

    // MARK: - CollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let album = albums[indexPath.item]
        
        imageManager.requestImage(
            for: album.thumbnail,
            targetSize: CGSize(width: 1000, height: 1000),
            contentMode: .aspectFill,
            options: nil,
            resultHandler: { image, _ in
                cell.albumThumbnailImageView.image = image
            })
        
        cell.albumThumbnailImageView.layer.cornerRadius = 5
        cell.albumThumbnailImageView.layer.masksToBounds = true
        
        cell.albumNameLabel.text = album.collectionTitle
        cell.albumSizeLabel.text = String(album.numOfContents)
        
        return cell
    }
    
    // MARK: - PHPhotoLibraryChangeObserver Methods
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("변화발생")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let albumViewController: AlbumViewController = segue.destination as? AlbumViewController else {
            return
        }
        
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        let album = albums[indexPath.item]
        
        albumViewController.album = album
    }
}


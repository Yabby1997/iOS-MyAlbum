//
//  AlbumViewController.swift
//  MyAlbum
//
//  Created by Seunghun Yang on 2021/03/17.
//

import UIKit
import Photos

class AlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier = "imageCell"
    var album: Album?
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 3.0
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - CollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album?.numOfContents ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell : ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let asset = album?.assets[indexPath.item] else {
            return cell
        }
        
        imageManager.requestImage(
            for: asset,
            targetSize: CGSize(width: 1000, height: 1000),
            contentMode: .aspectFill,
            options: nil,
            resultHandler: { image, _ in
                cell.imageView.image = image
            })
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageViewController: ImageViewController = segue.destination as? ImageViewController else {
            return
        }
        
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        
        guard let asset = album?.assets[indexPath.item] else {
            return
        }
        
        imageViewController.asset = asset
    }
    
}

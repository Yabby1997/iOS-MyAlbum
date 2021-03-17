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
    @IBOutlet weak var orderButton: UIBarButtonItem!
    
    // MARK: - Properties
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier = "imageCell"
    var album: Album?
    var assets: PHFetchResult<PHAsset>?
    var isAscending: Bool = false
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 3.0
        flowLayout.itemSize = CGSize(width: width - 1, height: width - 1)
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 1.5
        flowLayout.minimumInteritemSpacing = 1.5
        self.collectionView.collectionViewLayout = flowLayout
        
        self.navigationItem.title = album?.collectionTitle
        
        orderAndReload()
    }
    
    // MARK: - Functions
    func orderAndReload() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: isAscending)]
        assets = PHAsset.fetchAssets(in: album!.collection, options: fetchOptions)
        
        collectionView.reloadData()
    }
    
    // MARK: - CollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album?.numOfContents ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell : ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let asset = assets?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        OperationQueue.main.addOperation {
            self.imageManager.requestImage(
                for: asset,
                targetSize: CGSize(width: 1000, height: 1000),
                contentMode: .aspectFill,
                options: nil,
                resultHandler: { image, _ in
                    cell.imageView.image = image
                })
        }
        
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
        
        guard let asset = self.assets?[indexPath.item] else {
            return
        }
        
        imageViewController.asset = asset
    }
    
    // MARK: - IBActions
    @IBAction func touchUpOrderButton(_ sender: UIBarButtonItem) {
        isAscending.toggle()
        orderButton.title = isAscending ? "오름차순" : "내림차순"
        print(isAscending)
        orderAndReload()
    }
}

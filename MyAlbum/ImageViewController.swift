//
//  ImageViewController.swift
//  MyAlbum
//
//  Created by Seunghun Yang on 2021/03/17.
//

import UIKit
import Photos

class ImageViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var asset: PHAsset?
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter
    }()
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if asset != nil {
            OperationQueue.main.addOperation {
                let width = CGFloat(self.asset!.pixelWidth)
                let height = CGFloat(self.asset!.pixelHeight)
                self.imageManager.requestImage(
                    for: self.asset!,
                    targetSize: CGSize(width: width, height: height),
                    contentMode: .aspectFit,
                    options: nil,
                    resultHandler: { image, _ in
                        self.imageView.image = image
                    })
                self.navigationItem.title = self.dateFormatter.string(from: (self.asset!.creationDate)!)
            }
        }
    }
}

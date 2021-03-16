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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if asset != nil {
            imageManager.requestImage(
                for: asset!,
                targetSize: CGSize(width: 1000, height: 1000),
                contentMode: .aspectFill,
                options: nil,
                resultHandler: { image, _ in
                    self.imageView.image = image
                })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

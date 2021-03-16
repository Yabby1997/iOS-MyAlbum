//
//  Album.swift
//  MyAlbum
//
//  Created by Seunghun Yang on 2021/03/16.
//

import Foundation
import Photos

struct Album {
    var collection: PHAssetCollection
    var thumbnail: PHAsset
    var numOfContents: Int
    
    var collectionTitle: String {
        guard let title = collection.localizedTitle else {
            return "ERROR"
        }
        return title
    }
}

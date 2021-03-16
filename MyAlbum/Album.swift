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
    
    var assets: PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        
        return assets
    }
}

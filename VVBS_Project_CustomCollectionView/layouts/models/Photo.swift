//
//  Photo.swift
//  VVBS_Project_CustomCollectionView
//
//  Created by Vuong Vu Bac Son on 8/31/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import UIKit
struct Photo {
    var image: UIImage
    var description: String
    
    init(description: String, image: UIImage) {
        self.description = description
        self.image = image
    }
    
    init?(dictionary: [String: String]) {
        guard
            let description = dictionary["Description"],
            let photo = dictionary["Photo"],
            let image = UIImage(named: photo)
            else {
                return nil
        }
        self.init(description: description, image: image)
    }
    
    static func allPhotos() -> [Photo] {
        var photos: [Photo] = []
        guard
            let URL = Bundle.main.url(forResource: "Photos", withExtension: plist),
            let photosFromPlist = NSArray(contentsOf: URL) as? [[String: String]]
            else {
                return photos
        }
        
    }
}

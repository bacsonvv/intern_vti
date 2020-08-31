//
//  ViewController.swift
//  VVBS_Project_CustomCollectionView
//
//  Created by Vuong Vu Bac Son on 8/31/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionVew: UICollectionView!
    
    var cellIdentifier = "imageCell"
    
    var photos = [(description: "This is a description", imageName: "solo1"),
                  (description: "This is a description", imageName: "solo2"),
                  (description: "This is a description", imageName: "solo3"),
                  (description: "This is a description", imageName: "solo4"),
                  (description: "This is a description", imageName: "solo5"),
                  (description: "This is a description", imageName: "solo6"),
                  (description: "This is a description", imageName: "solo7"),
                  (description: "This is a description", imageName: "solo8"),
                  (description: "This is a description", imageName: "solo9"),
                  (description: "This is a description", imageName: "solo10")]
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionVew.register(CardViewCell.nib(), forCellWithReuseIdentifier: cellIdentifier)
        collectionVew.delegate = self
        collectionVew.dataSource = self
        
        let customLayout = PinterestLayout()
        customLayout.delegate = self
        collectionVew.collectionViewLayout = customLayout
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return UIImage(named: photos[indexPath.row].imageName)!.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CardViewCell
        cell.configure(description: photos[indexPath.row].description, imageName: photos[indexPath.row].imageName)
        return cell
    }
    
    
}



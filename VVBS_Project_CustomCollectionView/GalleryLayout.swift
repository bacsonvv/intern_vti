//
//  GalleryLayout.swift
//  VVBS_Project_CustomCollectionView
//
//  Created by Vuong Vu Bac Son on 8/31/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol GalleryLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class GalleryLayout: UICollectionViewLayout {
    
    // This keeps reference to the delegate
    weak var delegate: GalleryLayoutDelegate?
    
    // Use to configure the layout: the numbers of columnn and cell padding
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    // This array to cache the calculated attributes
    // When call prepare(), attributes of all items will be calculated and add to cache
    // When collection view requests later, we don't need to recalculate.
    // It's more efficient to query from cache
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // Store the content size
    // contentHigh will be increased as photos are added
    // Content width based on the collection view width and its content inset
    private var contentHeight: CGFloat = 0
    
    private var contenWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contenWidth, height: contentHeight)
    }
    
    override func prepare() {
        // Calculate only whenn the cache is empty and collection view exists
        guard
            cache.isEmpty,
            let collectionView = collectionView
            else {
                return
        }
        
        // Get xOffset with the x-coordinates for every columns based on the column widths
        let columnWdith = contenWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWdith)
        }
        // Get yOffset to keep track of y-position for every columns
        // Initialize each value to 0 since this is the offset of the first item in each column
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // Width is the previously calculated cellWidth with the padding between cells removed
            // Use delegate to get the height of the photo
            // Calculate frame height based on photoHeight and the predefined cellPadding for top and bottom
            // If there is no delegate set, use default cell height - 180
            // Create insetFrame using these attributes
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWdith, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Create instance of UICollectionViewLayoutAttributes, set its frame using insetFrame and append it to cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Expand contentHeight to account for the frame of the newly calculated item
            // Advance the yOffset for the current column based on the frame
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            // Advance the column so the next item will be placed in the next column
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

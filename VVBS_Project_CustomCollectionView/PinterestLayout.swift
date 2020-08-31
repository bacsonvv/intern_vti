//
//  PinterestLayout.swift
//  VVBS_Project_CustomCollectionView
//
//  Created by Vuong Vu Bac Son on 8/31/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}

class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate!
    
    
    // Numbers of column and padding between cells in collection view
    var numberOfColumns = 2
    var cellPadding: CGFloat = 10
    
    
    // Store calculated attributes
    // When collection view requests for layout attributes it's efficient to query in the array instead of recalculating every time
    fileprivate var attributesStorage = [UICollectionViewLayoutAttributes]()
    
    // contentHeight increases as the photo is added to the layout
    // Calculate contentWidth based on the collection view width and its content inset
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        return collectionView.bounds.width
    }
    
    // Return the size of the collection view's content
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // Calculate frame of every items based on its column and the position of the previous item in the same column
    // Tracking xOffset and yOffset
    // Use X coordinate of the column the item belongs to in order to calculate the horizontal position, then add the cell padding
    // The vertical position is starting position of the prior item in same column plus the height of that prior item
    // The over all height of item = image height + cell padding
    override func prepare() {
        
        // Calculate layout attributes if array is empty and the collection view exists
        guard attributesStorage.isEmpty, let collectionView = collectionView else {
            return
        }
        
        // xOffset array store x-coordinate for every columns based on the columns width
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffest = [CGFloat]()
        for column in 0..<numberOfColumns {
            xOffest.append(CGFloat(column) * columnWidth)
        }
        
        // yOffset array store y-position for every columns
        // Initialize each value = 0, since this is the offset of the first item in each column
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // MARKS: Calculate frame for each item
            // Ask the delegate to get the height of the photo
            let photoSize = delegate.collectionView(collectionView, sizeOfPhotoAtIndexPath: indexPath)
            
            // Width is the previously calculated cellWidth with the padding between cells removed
            let cellWidth = columnWidth
            
            // Height is calculated based on the height of the photo and the predefined cellPadding for the top and the bottom
            var cellHeight = photoSize.height * cellWidth / photoSize.width
            cellHeight = cellPadding * 2 + cellHeight
            
            // Create frame
            let frame = CGRect(x: xOffest[column], y: yOffset[column], width: cellWidth, height: cellHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Set ViewLayoutAttributes's frame using insetFrame, append attributes to the storage
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            attributesStorage.append(attributes)
            
            // Expand the height of content
            // Advance the yOffset for the current column based on the frame
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + cellHeight
            
            
//            if numberOfColumns > 1 {
//                var isColumnChanged = false
//                for index in (1..<numberOfColumns).reversed() {
//                    if yOffset[index] >= yOffset[index - 1] {
//                        column = index - 1
//                        isColumnChanged = true
//                    }
//                    else {
//                        break
//                    }
//                }
//
//                if isColumnChanged {
//                    continue
//                }
//            }
            
            // Advance the next item to the next column
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesStorage {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesStorage[indexPath.item]
    }
}

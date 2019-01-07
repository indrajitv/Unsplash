//
//  File.swift
//  CollectionViewCustomFlow
//
//  Created by Indrajit-mac on 14/12/18.
//  Copyright © 2018 Indrajit-mac. All rights reserved.
//

import UIKit




class SnappingFlowLayout: UICollectionViewFlowLayout {
    
    private var firstSetupDone = false
    
    override func prepare() {
        super.prepare()
        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }
    }
    
    private func setup() {
        scrollDirection = .vertical
        minimumLineSpacing = 10
        
        
        itemSize = CGSize(width: collectionView!.frame.width, height: 300)
        
        
    }
    
    
    
    
    
    
    
        override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    
            let layoutAttributes = layoutAttributesForElements(in: collectionView!.bounds)
    
            let centerOffset = collectionView!.bounds.size.height / 2
            let offsetWithCenter = proposedContentOffset.y + centerOffset
    
            let closestAttribute = layoutAttributes!
                .sorted { abs($0.center.y - offsetWithCenter) < abs($1.center.y - offsetWithCenter) }
                .first ?? UICollectionViewLayoutAttributes()
    
            return CGPoint(x: 0, y: closestAttribute.center.y - centerOffset)
        }
}



class CarouselFlowLayout: UICollectionViewFlowLayout {
    
    private var firstStupDone = false
    private let smallItemScale: CGFloat = 0.5
    private let smallItemAlpha: CGFloat = 0.2
    
    override func prepare() {
        super.prepare()
        if !firstStupDone {
            setup()
            firstStupDone = true
        }
    }
    
    private func setup() {
        scrollDirection = .horizontal
        minimumLineSpacing = -60
        itemSize = CGSize(width: collectionView!.bounds.width + minimumLineSpacing, height: collectionView!.bounds.height / 2)
        
        let inset = (collectionView!.bounds.width - itemSize.width) / 2
        collectionView!.contentInset = .init(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let allAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        for attributes in allAttributes {
            let collectionCenter = collectionView!.bounds.size.width / 2
            let offset = collectionView!.contentOffset.x
            let normalizedCenter = attributes.center.x - offset
            
            let maxDistance = itemSize.width + minimumLineSpacing
            let distanceFromCenter = min(collectionCenter - normalizedCenter, maxDistance)
            let ratio = (maxDistance - abs(distanceFromCenter)) / maxDistance
            
            let alpha = ratio * (1 - smallItemAlpha) + smallItemAlpha
            let scale = ratio * (1 - smallItemScale) + smallItemScale
            attributes.alpha = alpha
            
            let angleToSet = distanceFromCenter / (collectionView!.bounds.width / 2)
            var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            transform.m34 = 1.0 / 400
            transform = CATransform3DRotate(transform, angleToSet, 0, 1, 0)
            attributes.transform3D = transform
        }
        return allAttributes
    }
}









protocol PinterestLayoutDelegate: class {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewFlowLayout {
    
    weak var delegate: PinterestLayoutDelegate?
    
    
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6
    var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true || cache.isEmpty == false, let collectionView = collectionView else {
            return
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 100
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if cache.count == 0{
            return nil
        }
        return cache[indexPath.item]
    }
    
}

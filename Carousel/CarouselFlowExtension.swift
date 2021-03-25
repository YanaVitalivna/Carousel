/*
MIT License

Copyright (c) 2017 Yana

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */

import Foundation
import UIKit

// UICollectionViewLayout methods
extension CarouselFlowLayout {
    
    override public func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        guard let currentCollectionViewSize = collectionView?.bounds.size else{
            return
        }
        
        if currentCollectionViewSize.equalTo(lastCollectionViewSize) == false
            || itemSize.equalTo(lastItemSize) == false {
            
            configureInset()
            lastCollectionViewSize = currentCollectionViewSize
            lastItemSize = itemSize
        }
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard collectionView != nil else {
            return proposedContentOffset
        }
        
        return flowLayoutCalculator.targetContentOffsetForScrollDirection(proposedContentOffset, withScrollingVelocity: velocity)
        
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard  let contentOffset = collectionView?.contentOffset,
               let size = collectionView?.bounds.size,
               scaleItems else {
            
            return super.layoutAttributesForElements(in: rect)
        }
        
        guard let superAttributes = super.layoutAttributesForElements(in: rect)?.map({ CarouselLayoutAttributes.from($0) }) else {
            return nil
        }

        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        
        let visibleCenterYorX = flowLayoutCalculator.getVisibleCenter(in: visibleRect)
      // Y - for vertical scroll direction, X - for horizontal        

        let newAttributesArray = superAttributes.compactMap { (superAttribute) -> CarouselLayoutAttributes? in
           
            guard let newAttributes = superAttribute.copy() as? CarouselLayoutAttributes else {
                return nil
            }
            
            let distanceFromCenter = flowLayoutCalculator.getDistanceFromCenter(from: visibleCenterYorX, to: newAttributes)
            
            // calculate Item Scale
            let scale = calculateItemScale(with: distanceFromCenter)
            
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, maxScale)
            
            newAttributes.zIndex = zIndexForCenteredCell - Int(abs(distanceFromCenter)) // every next cell that have some distance from center should have smaller z-index.
            
            // setting for cells view
            settingsForCells(for: newAttributes, with: distanceFromCenter)
            
            return newAttributes
        }
        
        return newAttributesArray
        
    }
    
    func settingsForCells(for newAttributes: CarouselLayoutAttributes, with distanceFromCenter: CGFloat){
        
        if abs(distanceFromCenter) > scalingOffset {
            
            newAttributes.alpha = otherCellsAlpha // semi transparent cell
            
            newAttributes.borderColor = otherCellsBorderColor
            newAttributes.borderWidth = otherCellsBorderWidth
            newAttributes.cornerRadius = otherCellsCornerRadius
        }
        else {
            newAttributes.alpha = centeredCellAlpha
            
            newAttributes.borderColor = centeredCellBorderColor
            newAttributes.borderWidth = centeredCellBorderWidth
            newAttributes.cornerRadius = centeredCellCornerRadius
            
        }
        
    }
    
    func calculateItemScale(with distanceFromCenter: CGFloat) -> CGFloat{
        
        let absDistanceFromCenter = min(abs(distanceFromCenter), scalingOffset)
        
        // if absDistanceFromCenter = 0, scale will be max
        
        let distancesToCenterRatio = absDistanceFromCenter / scalingOffset // percentage ratio between current distance to center and max allowed distance to center.
        
        let max_minScaleDifference = maxScale - minScaleFactor // interval between min allowed scale and max
        let scale = maxScale - distancesToCenterRatio * max_minScaleDifference
        
        return scale
    }
    
}


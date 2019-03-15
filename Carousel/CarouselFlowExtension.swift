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
        
        guard let currentCollectionViewSize = self.collectionView?.bounds.size else{
            return
        }
        
        if !currentCollectionViewSize.equalTo(self.lastCollectionViewSize) || !self.itemSize.equalTo(self.lastItemSize){
            self.configureInset()
            self.lastCollectionViewSize = currentCollectionViewSize
            self.lastItemSize = self.itemSize
        }
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard self.collectionView != nil else { return proposedContentOffset }
        
        return self.flowLayoutCalculator.targetContentOffsetForScrollDirection(proposedContentOffset, withScrollingVelocity: velocity)
        
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard  let contentOffset = self.collectionView?.contentOffset, let size = self.collectionView?.bounds.size, self.scaleItems else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        guard let superAttributes = super.layoutAttributesForElements(in: rect)?.map({ CarouselLayoutAttributes.from($0) }) else {
            return nil
        }

        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        
        let visibleCenterYorX = self.flowLayoutCalculator.getVisibleCenter(in: visibleRect)
      // Y - for vertical scroll direction, X - for horizontal        

        let newAttributesArray = superAttributes.flatMap { (superAttribute) -> CarouselLayoutAttributes? in
           
            guard let newAttributes = superAttribute.copy() as? CarouselLayoutAttributes else {
                return nil
            }
            
            let distanceFromCenter = self.flowLayoutCalculator.getDistanceFromCenter(from: visibleCenterYorX, to: newAttributes)
            
            // calculate Item Scale
            let scale = self.calculateItemScale(with: distanceFromCenter)
            
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, self.maxScale)
            
            newAttributes.zIndex = self.zIndexForCenteredCell - Int(abs(distanceFromCenter)) // every next cell that have some distance from center should have smaller z-index.
            
            // setting for cells view
            self.settingsForCells(for: newAttributes, with: distanceFromCenter)
            
            return newAttributes
        }
        
        return newAttributesArray
        
    }
    
    func settingsForCells(for newAttributes: CarouselLayoutAttributes, with distanceFromCenter: CGFloat){
        
        if abs(distanceFromCenter) > self.scalingOffset {
            
            newAttributes.alpha = self.otherCellsAlpha // semi transparent cell
            
            newAttributes.borderColor = self.otherCellsBorderColor
            newAttributes.borderWidth = self.otherCellsBorderWidth
            newAttributes.cornerRadius = self.otherCellsCornerRadius
            
        } else {
            
            newAttributes.alpha = self.centeredCellAlpha
            
            newAttributes.borderColor = self.centeredCellBorderColor
            newAttributes.borderWidth = self.centeredCellBorderWidth
            newAttributes.cornerRadius = self.centeredCellCornerRadius
            
        }
        
    }
    
    func calculateItemScale(with distanceFromCenter: CGFloat) -> CGFloat{
        
        let absDistanceFromCenter = min(abs(distanceFromCenter), self.scalingOffset)
        
        // if absDistanceFromCenter = 0, scale will be max
        
        let distancesToCenterRatio = absDistanceFromCenter / self.scalingOffset // percentage ratio between current distance to center and max allowed distance to center.
        
        let max_minScaleDifference = self.maxScale - self.minScaleFactor // interval between min allowed scale and max
        let scale = self.maxScale - distancesToCenterRatio * max_minScaleDifference
        
        return scale
    }
    
}


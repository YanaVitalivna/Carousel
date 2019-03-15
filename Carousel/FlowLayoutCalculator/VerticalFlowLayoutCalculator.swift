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

import UIKit
struct VerticalFlowLayoutCalculator: OrientationFlowLayoutCalculator {
  
    var carouselFlowLayout: CarouselFlowLayout
    
    init(layout: CarouselFlowLayout){
        self.carouselFlowLayout = layout
    }
    
    func configureInsetCalculator() {
        guard self.carouselFlowLayout.collectionView != nil else { return }
        
        let inset = self.carouselFlowLayout.collectionView!.bounds.size.height / 2 - self.carouselFlowLayout.itemSize.height / 2
        self.carouselFlowLayout.collectionView!.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0)
        self.carouselFlowLayout.collectionView!.contentOffset = CGPoint(x: 0, y: -inset)
    }
    
    func getVisibleCenter(in visibleRect: CGRect) -> CGFloat {
        return visibleRect.midY
    }
    
    func getDistanceFromCenter(from visibleCenter: CGFloat, to newAttributes: CarouselLayoutAttributes) -> CGFloat {
        return visibleCenter - newAttributes.center.y
    }
   
    func targetContentOffsetForScrollDirection(_ proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionViewSize = self.carouselFlowLayout.collectionView?.bounds.size, self.carouselFlowLayout.collectionView != nil else { return proposedContentOffset }
        
        let proposedRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionViewSize.width, height: collectionViewSize.height)
        
        // find attributes in proposed rectangle
        guard
            let layoutAttributesArray = self.carouselFlowLayout.layoutAttributesForElements(in: proposedRect)?.filter({ $0.representedElementCategory == .cell }),
            let firstCandidate = layoutAttributesArray.first
            else {
                return proposedContentOffset
        }
        
        // center collection view content
        let proposedContentOffsetCenterY = proposedContentOffset.y + collectionViewSize.height / 2
        
        let candidateAttributes = layoutAttributesArray.reduce(firstCandidate) {
            
            if fabs($1.center.y - proposedContentOffsetCenterY) < fabs($0.center.y - proposedContentOffsetCenterY) {
                return $1
            } else {
                return $0
            }
        }
        
        var newOffsetY = candidateAttributes.center.y - self.carouselFlowLayout.collectionView!.bounds.size.height / 2
        
        let offsetY = newOffsetY - self.carouselFlowLayout.collectionView!.contentOffset.y
        
        // paging for first and last item
        if (velocity.y < 0 && offsetY > 0) || (velocity.y > 0 && offsetY < 0) {
            
            let pageHeight = self.carouselFlowLayout.itemSize.height + self.carouselFlowLayout.minimumLineSpacing
            newOffsetY += velocity.y > 0 ? pageHeight : -pageHeight
        }
        
        return CGPoint(x: proposedContentOffset.x, y: newOffsetY)
    }
}

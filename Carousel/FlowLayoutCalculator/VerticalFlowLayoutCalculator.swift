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
        carouselFlowLayout = layout
    }
    
    func configureInsetCalculator() {
        guard carouselFlowLayout.collectionView != nil else {
            return
        }
        
        let inset = carouselFlowLayout.collectionView!.bounds.size.height / 2 - carouselFlowLayout.itemSize.height / 2
        carouselFlowLayout.collectionView!.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        carouselFlowLayout.collectionView!.contentOffset = CGPoint(x: 0, y: -inset)
    }
    
    func getVisibleCenter(in visibleRect: CGRect) -> CGFloat {
        visibleRect.midY
    }
    
    func getDistanceFromCenter(from visibleCenter: CGFloat, to newAttributes: CarouselLayoutAttributes) -> CGFloat {
        visibleCenter - newAttributes.center.y
    }
   
    func targetContentOffsetForScrollDirection(_ proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionViewSize = carouselFlowLayout.collectionView?.bounds.size,
              carouselFlowLayout.collectionView != nil else {
            
            return proposedContentOffset
        }
        
        let proposedRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionViewSize.width, height: collectionViewSize.height)
        
        // find attributes in proposed rectangle
        guard
            let layoutAttributesArray = carouselFlowLayout.layoutAttributesForElements(in: proposedRect)?.filter({ $0.representedElementCategory == .cell }),
            let firstCandidate = layoutAttributesArray.first
            else {
                return proposedContentOffset
        }
        
        // center collection view content
        let proposedContentOffsetCenterY = proposedContentOffset.y + collectionViewSize.height / 2
        
        let candidateAttributes = layoutAttributesArray.reduce(firstCandidate) {
            
            if abs($1.center.y - proposedContentOffsetCenterY) < abs($0.center.y - proposedContentOffsetCenterY) {
                return $1
            }
            else {
                return $0
            }
        }
        
        var newOffsetY = candidateAttributes.center.y - carouselFlowLayout.collectionView!.bounds.size.height / 2
        
        let offsetY = newOffsetY - carouselFlowLayout.collectionView!.contentOffset.y
        
        // paging for first and last item
        if (velocity.y < 0 && offsetY > 0)
            || (velocity.y > 0 && offsetY < 0) {
            
            let pageHeight = carouselFlowLayout.itemSize.height + carouselFlowLayout.minimumLineSpacing
            newOffsetY += velocity.y > 0 ? pageHeight : -pageHeight
        }
        
        return CGPoint(x: proposedContentOffset.x, y: newOffsetY)
    }
}

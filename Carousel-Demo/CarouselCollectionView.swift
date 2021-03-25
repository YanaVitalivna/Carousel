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
import Carousel

protocol CarouselDelegate: class {
    func numberOfItemsInSection() -> Int
    func cellForRowAtIndexPath(_ cell: CarouselViewCell, indexPath: IndexPath)
    func didSelectItemAtIndexPath(_ indexPath: IndexPath)
}

class CarouselCollectionView: UICollectionView {

    public weak var carouselDelegate: CarouselDelegate?
   
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        collectionViewSettings()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        collectionViewSettings()
    }
    
    func collectionViewSettings(){
  
        decelerationRate = .fast
   
        dataSource = self
        delegate = self
    }
}

extension CarouselCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        carouselDelegate?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselViewCell", for: indexPath) as! CarouselViewCell
        
        carouselDelegate?.cellForRowAtIndexPath(collectionViewCell, indexPath: indexPath)
        
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isDragging
            || collectionView.isDecelerating
            || collectionView.isTracking {
            
            return
        }
        
        carouselDelegate?.didSelectItemAtIndexPath(indexPath)
    }
    
}













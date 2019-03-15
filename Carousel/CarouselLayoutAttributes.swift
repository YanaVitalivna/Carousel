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

public class CarouselLayoutAttributes: UICollectionViewLayoutAttributes {
    
    public var cornerRadius: CGFloat = 0
    public var borderWidth: CGFloat = 0
    public var borderColor: UIColor = UIColor.black
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        guard let copy = super.copy(with: zone) as? CarouselLayoutAttributes else {
            return super.copy(with: zone)
        }
        copy.borderColor = self.borderColor
        copy.borderWidth = self.borderWidth
        copy.cornerRadius = self.cornerRadius
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        
        guard let attributes = object as? CarouselLayoutAttributes else { return false }
        
        guard self.borderColor == attributes.borderColor, self.borderWidth == attributes.borderWidth, self.cornerRadius == attributes.cornerRadius else {
            return false
        }
        
        return super.isEqual(object)
      
    }
    
    static func from(_ attributes: UICollectionViewLayoutAttributes) -> CarouselLayoutAttributes {
        let copy = CarouselLayoutAttributes(forCellWith: attributes.indexPath)
        copy.frame = attributes.frame
        copy.center = attributes.center
        copy.size = attributes.size
        copy.transform = attributes.transform
        copy.transform3D = attributes.transform3D
        copy.alpha = attributes.alpha
        copy.indexPath = attributes.indexPath
        copy.isHidden = attributes.isHidden
        copy.zIndex = attributes.zIndex
        
        return copy
    }
    
}



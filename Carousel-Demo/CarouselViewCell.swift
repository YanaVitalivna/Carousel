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

class CarouselViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    func fillInCell(image: UIImage){
        self.imageView.image = image
    }
    
    override func prepareForReuse() {
        self.contentScaleFactor = 0.1
        self.layer.contentsScale = 0.1
        self.imageView.image = nil

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// apply properties from carousel layout
extension CarouselViewCell {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let customAttr = layoutAttributes as? CarouselLayoutAttributes {
            self.layer.borderWidth = customAttr.borderWidth
            self.layer.cornerRadius = customAttr.cornerRadius
            self.layer.borderColor = customAttr.borderColor.cgColor
            
        }
    }
}

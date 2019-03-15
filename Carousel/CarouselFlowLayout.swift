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

@IBDesignable public class CarouselFlowLayout: UICollectionViewFlowLayout {

    var defaultTheme: CarouselAppearence = CarouselTheme()
    
    @IBInspectable var scalingOffset: CGFloat = 0.0 {// if offsets >= scalingOffset scale factor will be minimumScaleFactor
        didSet{
            guard self.scalingOffset >= 60 else { self.scalingOffset = 60; return }
        }
    }
    
    @IBInspectable var minScaleFactor: CGFloat = 0.0 { // minimum scale allowed for cell
        didSet{
            
            guard self.minScaleFactor < 1 else { self.minScaleFactor = 1; return }
            guard self.minScaleFactor > 0 else { self.minScaleFactor = 0; return }
    
        }
    }
    
    @IBInspectable var minLineSpacing: CGFloat = 0.0 { // minimum line spacing
        didSet{
            self.minimumLineSpacing = minLineSpacing
        }
    }
    
    @IBInspectable var verticalScrollDirection: Bool = true { // scroll direction
        didSet{
            if verticalScrollDirection {
                self.scrollDirection = .vertical
                self.flowLayoutCalculator = VerticalFlowLayoutCalculator(layout: self)
                
            } else {
                self.scrollDirection = .horizontal
                self.flowLayoutCalculator = HorizontalFlowLayoutCalculator(layout: self)
            }
        }
    }
    
    @IBInspectable var cellSize: CGSize = CGSize.zero { // settings for item size (for scale = 1)
        didSet{
            if !self.itemSize.equalTo(cellSize) {
                self.itemSize = cellSize
                self.invalidateLayout()
            }
        }
    }
    
    @IBInspectable var centeredCellCornerRadius: CGFloat = 0
    @IBInspectable var centeredCellBorderWidth: CGFloat = 0
    @IBInspectable var centeredCellBorderColor: UIColor = UIColor.clear
    @IBInspectable var centeredCellAlpha: CGFloat = 1
    
    @IBInspectable var otherCellsBorderWidth: CGFloat = 0
    @IBInspectable var otherCellsBorderColor: UIColor = UIColor.clear
    @IBInspectable var otherCellsCornerRadius: CGFloat = 0
    @IBInspectable var otherCellsAlpha: CGFloat = 0.5
    
    var maxScale: CGFloat = 1
    var scaleItems: Bool = true
    var lastCollectionViewSize: CGSize = CGSize.zero
    var lastItemSize = CGSize.zero
    let zIndexForCenteredCell = 100
    var flowLayoutCalculator: OrientationFlowLayoutCalculator!
    
    fileprivate var distanceToCenter: CGFloat = 0
    
    public var carouselTheme: CarouselAppearence {
        get {
           return defaultTheme
        }
        set{
            self.defaultTheme = newValue
            self.set(theme: newValue)
        }
    }
    
    public override init() {
        super.init()
        
        self.settingForFlowLayoutCalculator()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.settingForFlowLayoutCalculator()
    }
    
    func settingForFlowLayoutCalculator() {
        self.flowLayoutCalculator = VerticalFlowLayoutCalculator(layout: self) // by default
    }
    
   // setup default theme for carousel flow
    private func set(theme: CarouselAppearence){
    
        self.scalingOffset = self.defaultTheme.scalingOffset
        self.minScaleFactor = self.defaultTheme.minScaleFactor
        self.minLineSpacing = self.defaultTheme.minLineSpacing
        self.verticalScrollDirection = self.defaultTheme.verticalScrollDirection
        self.cellSize = self.defaultTheme.cellSize
        
        self.centeredCellCornerRadius = self.defaultTheme.centeredCellCornerRadius
        self.centeredCellBorderWidth = self.defaultTheme.centeredCellBorderWidth
        self.centeredCellBorderColor = self.defaultTheme.centeredCellBorderColor
        self.centeredCellAlpha = self.defaultTheme.centeredCellAlpha
        
        self.otherCellsCornerRadius = defaultTheme.otherCellsCornerRadius
        self.otherCellsBorderWidth = self.defaultTheme.otherCellsBorderWidth
        self.otherCellsBorderColor = defaultTheme.otherCellsBorderColor
        self.otherCellsAlpha = self.defaultTheme.otherCellsAlpha
       
        self.invalidateLayout()
    }
      
    public func configureInset(){
       self.flowLayoutCalculator.configureInsetCalculator()
    }

}



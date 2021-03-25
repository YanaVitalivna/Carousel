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
    
    @IBInspectable var scalingOffset: CGFloat = 0.0 { // if offsets >= scalingOffset scale factor will be minimumScaleFactor
        didSet{
            guard scalingOffset >= 60 else {
                scalingOffset = 60
                return
            }
        }
    }
    
    @IBInspectable var minScaleFactor: CGFloat = 0.0 { // minimum scale allowed for cell
        didSet{
            
            guard minScaleFactor < 1 else {
                minScaleFactor = 1
                return
            }
            
            guard minScaleFactor > 0 else {
                minScaleFactor = 0
                return
            }
    
        }
    }
    
    @IBInspectable var minLineSpacing: CGFloat = 0.0 { // minimum line spacing
        didSet{
            minimumLineSpacing = minLineSpacing
        }
    }
    
    @IBInspectable var verticalScrollDirection: Bool = true { // scroll direction
        didSet{
            if verticalScrollDirection {
                scrollDirection = .vertical
                flowLayoutCalculator = VerticalFlowLayoutCalculator(layout: self)
                
            }
            else {
                scrollDirection = .horizontal
                flowLayoutCalculator = HorizontalFlowLayoutCalculator(layout: self)
            }
        }
    }
    
    @IBInspectable var cellSize: CGSize = CGSize.zero { // settings for item size (for scale = 1)
        didSet{
            if itemSize.equalTo(cellSize) == false {
                itemSize = cellSize
                invalidateLayout()
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
           defaultTheme
        }
        set{
            defaultTheme = newValue
            set(theme: newValue)
        }
    }
    
    public override init() {
        super.init()
        
        settingForFlowLayoutCalculator()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settingForFlowLayoutCalculator()
    }
    
    func settingForFlowLayoutCalculator() {
        flowLayoutCalculator = VerticalFlowLayoutCalculator(layout: self) // by default
    }
    
   // setup default theme for carousel flow
    private func set(theme: CarouselAppearence){
    
        scalingOffset = defaultTheme.scalingOffset
        minScaleFactor = defaultTheme.minScaleFactor
        minLineSpacing = defaultTheme.minLineSpacing
        verticalScrollDirection = defaultTheme.verticalScrollDirection
        cellSize = defaultTheme.cellSize
        
        centeredCellCornerRadius = defaultTheme.centeredCellCornerRadius
        centeredCellBorderWidth = defaultTheme.centeredCellBorderWidth
        centeredCellBorderColor = defaultTheme.centeredCellBorderColor
        centeredCellAlpha = defaultTheme.centeredCellAlpha
        
        otherCellsCornerRadius = defaultTheme.otherCellsCornerRadius
        otherCellsBorderWidth = defaultTheme.otherCellsBorderWidth
        otherCellsBorderColor = defaultTheme.otherCellsBorderColor
        otherCellsAlpha = defaultTheme.otherCellsAlpha
       
        invalidateLayout()
    }
      
    public func configureInset(){
       flowLayoutCalculator.configureInsetCalculator()
    }

}



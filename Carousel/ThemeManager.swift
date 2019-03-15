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

public protocol CarouselAppearence{
    
    /// Minimum scale allowed for cell.
    /// Possible values are between 0.0 and 1.0.
    var minScaleFactor: CGFloat { get set }
    
    /// Distance from center when attributes start applying for center cell.
    /// If offsets >= scalingOffset scale factor will be minimumScaleFactor
    /// Minimum and default value of this property is 60.0
    var scalingOffset: CGFloat { get set }
    
    /// Minimum line spacing
    var minLineSpacing: CGFloat { get set }
    
    /// Scroll direction
    var verticalScrollDirection: Bool { get set }
    
    /// Settings for item size (for scale = 1)
    var cellSize: CGSize { get set }
  
    /// Settings for centered cell: corner radius
    var centeredCellCornerRadius: CGFloat { get set }
    
    /// Settings for centered cell: border width
    var centeredCellBorderWidth: CGFloat { get set }
    
    /// Settings for centered cell:border color
    var centeredCellBorderColor: UIColor { get set }
    
    
    /// The transparency of the centered cell
    var centeredCellAlpha: CGFloat { get set }
    
    /// Settings for other cells: corner radius
    var otherCellsCornerRadius: CGFloat { get set }
    
    /// Settings for other cells: border width
    var otherCellsBorderWidth: CGFloat { get set }
    
    /// Settings for other cells: border color
    var otherCellsBorderColor: UIColor { get set }
    
    /// The transparency of the other cells
    var otherCellsAlpha: CGFloat { get set }
   
}

public struct CarouselTheme: CarouselAppearence {

    public init(){ }

    public var scalingOffset: CGFloat = 60
    public var minScaleFactor: CGFloat = 0.7
    public var minLineSpacing: CGFloat = -120
    public var verticalScrollDirection: Bool = true
    public var cellSize: CGSize = CGSize.init(width: 300, height: 210)

//---settings for centered cell
    public var centeredCellCornerRadius: CGFloat = 5
    public var centeredCellBorderWidth: CGFloat = 5
    public var centeredCellBorderColor: UIColor = UIColor.red
    public var centeredCellAlpha: CGFloat = 1
    
//---settings for other cells
    public var otherCellsCornerRadius: CGFloat = 5
    public var otherCellsBorderWidth: CGFloat = 5
    public var otherCellsBorderColor: UIColor = UIColor.lightGray
    public var otherCellsAlpha: CGFloat = 0.5
    
    
    
}

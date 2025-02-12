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

import XCTest
@testable import Carousel

class CarouselTests: XCTestCase {
    
    var collectionView: UICollectionView!
    var carouselFlow: CarouselFlowLayout!
    
    override func setUp() {
        super.setUp()
        
        carouselFlow = CarouselFlowLayout()
        carouselFlow.carouselTheme = CarouselTheme()
        collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: 300, height: 500), collectionViewLayout: self.carouselFlow)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_CollectionViewIsNotNilAfterViewDidLoad() {
       XCTAssertNotNil(carouselFlow.collectionView)
    }
    
    func test_ExpectedMinimumScaleFrom0() {
   
        carouselFlow.carouselTheme.minScaleFactor = -12
        XCTAssertEqual(carouselFlow.minScaleFactor, 0, "Minimum scale factor beyond the permissible values (from 0 to 1)")
        
    }
    
    func test_ExpectedMinimumScaleTo1() {
        
        carouselFlow.carouselTheme.minScaleFactor = 20
        XCTAssertEqual(carouselFlow.minScaleFactor, 1, "Minimum scale factor beyond the permissible values (from 0 to 1)")
       
    }
    
    func test_ExpectedScalingOffset() {
        
        carouselFlow.carouselTheme.scalingOffset = 20
        XCTAssertEqual(carouselFlow.scalingOffset, 60, "Minimum scale factor beyond the permissible values (from 0 to 1)")
        
    }
    
    func test_ExpectedVisibleRectCenterYPosition() {
        
        let contentOffset = collectionView.contentOffset
        let size = collectionView.bounds.size
        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        
        let visibleCenterY = carouselFlow.flowLayoutCalculator.getVisibleCenter(in: visibleRect)
        let expectedVisibleCenterY = collectionView.center.y
        
        XCTAssertEqual(visibleCenterY, expectedVisibleCenterY, "Visible centerY calculated wrong")
    }
    
    func test_ExpectedVisibleRectCenterXPosition() {
        
        let contentOffset = collectionView.contentOffset
        let size = collectionView.bounds.size
        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
        carouselFlow.flowLayoutCalculator = HorizontalFlowLayoutCalculator(layout: carouselFlow)
        
        let visibleCenterX = carouselFlow.flowLayoutCalculator.getVisibleCenter(in: visibleRect)
        let expectedVisibleCenterX = collectionView.center.x
        
        XCTAssertEqual(visibleCenterX, expectedVisibleCenterX, "Visible centerY calculated wrong")
    }
    
    func test_ExpectedCenteredCellScale() {
        
        let currentDistanceFromCenter: CGFloat = 50
        
        let scale = carouselFlow.calculateItemScale(with: currentDistanceFromCenter)
        let expectedScale: CGFloat = 0.75
        
        XCTAssert(scale < carouselFlow.maxScale )
        XCTAssertEqual(scale, expectedScale, "Scale calculated wrong")
    }
    
    func test_ExpectedOtherCellsScale() {
        
        let currentDistanceFromCenter: CGFloat = 0
        
        let scale = carouselFlow.calculateItemScale(with: currentDistanceFromCenter)
        let expectedScale: CGFloat = 1
        
        XCTAssertEqual(scale, expectedScale, "Scale calculated wrong")
    }

    
    func test_ExpectedCenteredCellViewSettings() {
        
        let currentDistanceFromCenter: CGFloat = 0
        
        // new attribute
        let attributes = CarouselLayoutAttributes()
        attributes.borderColor = UIColor.green
        attributes.alpha = 0.5
        
        let expectedCenteredCellBorderColor = carouselFlow.defaultTheme.centeredCellBorderColor
        let expectedCenteredCellAlpha: CGFloat = carouselFlow.defaultTheme.centeredCellAlpha
        
        carouselFlow.settingsForCells(for: attributes, with: currentDistanceFromCenter)
        
        XCTAssertEqual(attributes.borderColor, expectedCenteredCellBorderColor, "BorderColor for centered cell calculated wrong")
        XCTAssertEqual(attributes.alpha, expectedCenteredCellAlpha, "Alpha for centered cell calculated wrong")
       
    }
    
    func test_ExpectedOtherCellsViewSettings() {
        
        let currentDistanceFromCenter: CGFloat = 80 // for other call it should be > self.carouselFlow.scalingOffset
        
        // new attribute
        let attributes = CarouselLayoutAttributes()
        attributes.borderColor = UIColor.green
        attributes.alpha = 1
     
        let expectedOtherCellsBorderColor = carouselFlow.defaultTheme.otherCellsBorderColor
        let expectedOtherCellsAlpha: CGFloat = carouselFlow.defaultTheme.otherCellsAlpha
        
        carouselFlow.settingsForCells(for: attributes, with: currentDistanceFromCenter)
        
        XCTAssertEqual(attributes.borderColor, expectedOtherCellsBorderColor, "BorderColor for other cells calculated wrong")
        XCTAssertEqual(attributes.alpha, expectedOtherCellsAlpha, "Alpha for other cells calculated wrong")
        
    }

    
}






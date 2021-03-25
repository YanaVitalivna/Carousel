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

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: CarouselCollectionView!
    @IBOutlet weak var carouselLayout: CarouselFlowLayout!
    
    var cellModels: [CellModel] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        collectionView.carouselDelegate = self
        carouselLayout.carouselTheme = CarouselTheme()

        fillCellModels()

    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .all
    }
    
    func fillCellModels(){
        cellModels = []
        let images = [#imageLiteral(resourceName: "Image"), #imageLiteral(resourceName: "Image-4"), #imageLiteral(resourceName: "Image-2"), #imageLiteral(resourceName: "Image-1"), #imageLiteral(resourceName: "Image-5"), #imageLiteral(resourceName: "Image-3")]
        
        images.forEach{
            cellModels.append( CellModel.init(image: $0))
        }
        
    }
}

// fill in collection view

extension ViewController: CarouselDelegate {
    
    func numberOfItemsInSection() -> Int {
        cellModels.count
    }
    
    func cellForRowAtIndexPath(_ cell: CarouselViewCell, indexPath: IndexPath) {
        cell.fillInCell(image: cellModels[indexPath.row].image)
    }
    
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        print("CLICK")
    }
    
}

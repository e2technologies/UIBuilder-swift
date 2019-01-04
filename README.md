# UIBuilder

[![CI Status](https://img.shields.io/travis/Eric Chapman/UIBuilder.svg?style=flat)](https://travis-ci.org/Eric Chapman/UIBuilder)
[![Version](https://img.shields.io/cocoapods/v/UIBuilder.svg?style=flat)](https://cocoapods.org/pods/UIBuilder)
[![License](https://img.shields.io/cocoapods/l/UIBuilder.svg?style=flat)](https://cocoapods.org/pods/UIBuilder)
[![Platform](https://img.shields.io/cocoapods/p/UIBuilder.svg?style=flat)](https://cocoapods.org/pods/UIBuilder)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

UIBuilder is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UIBuilder'
```

## Usage

An example of using this library is shown below.  Please see the documentation at the 
[wiki](https://github.com/e2technologies/UIBuilder-swift/wiki)

Note that I don't have any unit tests yet.  Currently the supplied example is run to make sure all of the methods are
working properly.

```swift
import UIKit
import UIBuilder

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray

        let stripeHeight: CGFloat = 20

        // Build the top side
        let blueSquare = UIView()
        blueSquare.backgroundColor = UIColor.blue
        let blueSquareElement = blueSquare.element.height(7*stripeHeight).width(7*stripeHeight).halign(.left).valign(.top)

        var tStripes = [UIBuilderElement]()
        for i in 0..<7 {
            let stripe = UIView()
            stripe.backgroundColor = (i % 2) == 0 ? UIColor.red : UIColor.white
            tStripes.append(stripe.element.height(stripeHeight))
        }

        let topRightStripes = UIBuilder.stack(vertical: tStripes)
        let topHStack = UIBuilder.stack(horizontal: [blueSquareElement, topRightStripes])

        // Build the bottom side
        var bStripes = [UIBuilderElement]()
        for i in 0..<7 {
            let stripe = UIView()
            stripe.backgroundColor = (i % 2) == 0 ? UIColor.white : UIColor.red
            bStripes.append(stripe.element.height(stripeHeight))
        }
        let bottomVStack = UIBuilder.stack(vertical: bStripes)

        // Combine the top and bottom
        let mainView = UIBuilder.stack(vertical: [topHStack, bottomVStack]).build()

        self.view.addSubview(mainView)
        self.view.constrain.leftEdges(mainView).build()
        self.view.constrain.rightEdges(mainView).build()
        self.view.constrain.topEdges(mainView).build()
    }
}
```

## License

UIBuilder is available under the MIT license. See the LICENSE file for more info.

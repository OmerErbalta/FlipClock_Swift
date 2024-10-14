FlipClockFramework


https://github.com/user-attachments/assets/a55dd463-d1d3-4e2e-af39-449407ae120a  


A customizable flip clock framework for iOS applications. Easily add animated flip clocks to your app with a few lines of code. Supports UIKit and allows color and font customization.

Features

•	🕰️ Beautiful flip clock animation.
•	🎨 Customizable colors and fonts.
•	📱 Easy integration with Swift Package Manager.

Installation

Swift Package Manager (SPM)

1.	Open your Xcode project.
2.	Go to File > Add Packages.
3.	Paste the following URL into the search bar:

```
https://github.com/your-username/FlipClockFramework.git
 ```


4.	Choose the package and add it to your desired target.

## Usage

Here’s how to integrate **FlipClockView** into your view controller:

```swift
import UIKit
import FlipClockFramework

class ViewController: UIViewController {

    private let flipClockView: FlipClockView = {
        let clock = FlipClockView(clockType: .clock)
        clock.color = .black
        clock.textColor = .white
        clock.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return clock
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(flipClockView)
        setupConstraints()
    }

    private func setupConstraints() {
        flipClockView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flipClockView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flipClockView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flipClockView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            flipClockView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
```

Customization

You can customize the clock’s appearance using the following properties:
```
clock.color = .blue  // Background color
clock.textColor = .yellow  // Text color
clock.font = UIFont.systemFont(ofSize: 48, weight: .medium)  // Font
```

---

# Uptick iOS SDK Integration

This repository contains the **Uptick iOS SDK** and instructions for integrating it into your iOS app. You can integrate the SDK via **Swift Package Manager (SPM)** or **manually** by adding the provided **XCFramework**.

## Installation

### 1. Swift Package Manager (SPM)

You can integrate the Uptick SDK using Swift Package Manager. Follow these steps:

1. Open your project in **Xcode**.
2. In the project navigator, select your project file.
3. In the project editor, select your app's target under **PROJECT**.
4. Go to the **Package Dependencies** tab.
5. Click the **+** button at the bottom of the **Package Dependencies** section.
6. In the search bar, paste the Uptick SDK GitHub repository URL:
   ```
   https://github.com/axeldeploy/uptick-ios
   ```
7. Select the **main** branch and press **Add Package**.
8. Assign the package to your app target.

### 2. Manual XCFramework Integration

If you prefer manual integration, follow these steps:

1. **Download the XCFramework**: Download `UptickSDK.xcframework` from the [Releases](https://github.com/axeldeploy/uptick-ios/releases) page or other official sources.
2. **Add the Framework to Xcode**:
   - In Xcode, select your project in the project navigator.
   - Select your app target under **TARGETS**.
   - In the **General** tab, find the **Frameworks, Libraries, and Embedded Content** section.
   - Drag and drop `UptickSDK.xcframework` here.
   - Set the **Embed** option to **Embed & Sign**.
3. **Import the SDK** in Swift:
   - Swift:
     ```swift
     import UptickSDK
     ```

## UptickManager Class

The `UptickManager` class is the main interface for managing ads within the Uptick SDK. Below is a breakdown of the class and its usage:

### Class Definition

```swift
@objc final public class UptickManager: NSObject {

    @objc public static let shared: UptickManager

    @objc final public var errorMessage: ((_ errorText: String) -> Void)?

    @objc final public var backgroundColor: UIColor

    @objc final public var primaryColor: UIColor

    @objc final public var secondaryColor: UIColor

    /**
     Public method to activate an ad.
     
     - Parameters:
        - view: The `UptickAdView` where the ad will be displayed.
        - withID: The integration ID for the ad.
        - placement: Query item for all requests
     */
    @MainActor @objc final public func activateAd(in view: UptickAdView, withID: String, placement: String?)

    override dynamic public init()
}
```

### Properties

- **shared**: Singleton instance of `UptickManager`.
- **errorMessage**: A closure that will be triggered when an error occurs, providing an error message string.
- **backgroundColor**: The background color of the ad view.
- **primaryColor**: The primary color for the ad display.
- **secondaryColor**: The secondary color for the ad display.

### Methods

- **activateAd(in:withID:placement:)**: Activates an ad in the provided `UptickAdView` using an integration ID and an optional placement string for request queries.

### Example Usage

```swift
import UIKit
import UptickSDK

class ViewController: UIViewController {
    let stackView = UIStackView()
    lazy var integrationIdLabel = makeLabel()
    lazy var integrationIdTextField = makeTextField(tag: 100)
    lazy var placementLabel = makeLabel()
    lazy var placementTextField = makeTextField(tag: 101)
    lazy var showButton = makeButton()
    lazy var defaultButton = makeButton()
    lazy var uptickAdView = UptickAdView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setConstraints()
        setProperties()
    }
    
    func setSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(integrationIdLabel)
        stackView.addArrangedSubview(integrationIdTextField)
        stackView.addArrangedSubview(placementLabel)
        stackView.addArrangedSubview(placementTextField)
        stackView.addArrangedSubview(showButton)
        stackView.addArrangedSubview(defaultButton)
        view.addSubview(uptickAdView)
    }
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func setProperties() {
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .vertical
        view.backgroundColor = .white
        integrationIdLabel.text = "Enter Integration Id"
        placementLabel.text = "Enter placement"
        showButton.setTitle("Show", for: .normal)
        showButton.addTarget(self, action: #selector(onShowButton), for: .touchUpInside)
        defaultButton.setTitle("Use Default Values", for: .normal)
        defaultButton.addTarget(self, action: #selector(onDefaultButton), for: .touchUpInside)
        integrationIdTextField.text = "0bf6f068-6bf5-49f1-a6bc-822eee7d4db3"
        placementTextField.text = "order_confirmation"
        UptickManager.shared.backgroundColor = .white
        UptickManager.shared.primaryColor = .systemRed
        UptickManager.shared.secondaryColor = .lightGray
        UptickManager.shared.errorMessage = { errorMessage in
            print(errorMessage)
        }
    }
}

@objc
extension ViewController {
    func onShowButton() {
        if let integrationId = integrationIdTextField.text, let placement = placementTextField.text {
            UptickManager.shared.activateAd(in: uptickAdView, withID: integrationId, placement: placement)
        }
        integrationIdTextField.resignFirstResponder()
        placementTextField.resignFirstResponder()
    }
    
    func onDefaultButton() {
        let id = "2a1c3b6e-e148-45e5-bd43-ea0b1c11dad0"
        let placement = "order_confirmation"
        integrationIdTextField.text = id
        placementTextField.text = placement
        UptickManager.shared.activateAd(in: uptickAdView, withID: "2a1c3b6e-e148-45e5-bd43-ea0b1c11dad0", placement: "order_confirmation")
        integrationIdTextField.resignFirstResponder()
        placementTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension ViewController {
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        return label
    }
    
    func makeTextField(tag: Int) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textColor = .darkGray
        textField.clearButtonMode = .always
        textField.adjustsFontSizeToFitWidth = true
        textField.tag = tag
        return textField
    }
    
    func makeImageView() -> UIImageView {
        return UIImageView()
    }
    
    func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.green.cgColor
        button.layer.cornerRadius = 8
        return button
    }
}

```

## License

This project is licensed under the [Apache 2.0 License](LICENSE).

---

# PopupView
[![Swift Version][swift version badge]][swift version]
[![Platform][platforms badge]][platforms]
[![SPM][spm badge]][spm] 
[![IOS][ios badge]][ios]
[![MIT][mit badge]][mit]

Implementation of view popups written with SwiftUI


| **Bottom**  | **Top**  | **Center** |
|:----------|:----------|:----------|
| ![Bottom][bottom popup stack rounded corner] | ![Top][top popup] | ![Center][center popup] |

___


# Requirements

| **Platform** | **Minimum Swift Version**  | **Installation**  |
|:----------|:----------|:----------|
| iOS 15+    | 5.7   | [Swift Package Manager][installation]    |



# Installation

The [Swift package manager][spm] is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding PopupView as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.


```Swift
dependencies: [
    .package(url: "https://github.com/Mijick/PopupView.git", branch(“main”))
]
```


# Usage

1. [Setup project][setup]
1. [Implement animation protocol][animation]
1. [Present popup view][presentation]
1. [Dismiss popup view][dismiss]

## Setup project
Inside `@main` structure body call the `implementPopupView` method 
```Swift
  var body: some Scene {
        WindowGroup(content: ContentView().implementPopupView)
  }
```


## Animation protocols
The library provides an ability to use custom views. <br>
In order to present a view on top of other views, it is necessary to inherit from one of the protocols during popup creation:
- `TopPopup` - presents popup view from the top
- `CentrePopup` - presents popup view from the center
- `BottomPopup` - presents popup view from the bottom


### Common Setup
Inheritance from one of the popup protocols requires the implementation of the following requirements:

1. Set the `id` parameter to control the uniqueness of the views being presented
```Swift
let id: String { "some_id" }
```
2. Implement `createContent` method. It's used instead of the `body` property, and declares the design of the popup view
```Swift
func createContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("First")
            Spacer.height(12)
            Text("Another element")
        }
        .padding(.top, 36)
}
```

3. Implement `configurePopup(popup: Config) -> Config`  method to setup UI of presented view
Each protocol has its own set of configuration type

An example of implementing BottomPopup protocol configurations setups

```Swift
func configurePopup(popup: BottomPopupConfig) -> BottomPopupConfig {
        popup
            .contentIgnoresSafeArea(true)
            .activePopupCornerRadius(0)
            .stackedPopupsCornerRadius(0)
}
```


#### Available Configurations
|  | **TopPopup**  | **CentrePopup** | **BottomPopup**  |
|:----------|:----------|:----------|:----------|
| backgroundColour | ✅ | ✅  | ✅    |
| contentIgnoresSafeArea    | ✅ | ❌  | ✅ |
| horizontalPadding   | ✅  | ✅ | ✅  |
| bottomPadding   | ❌ | ❌ | ✅ |
| topPadding   | ✅ | ❌ | ❌ |
| stackedPopupsOffset   | ✅ | ❌ | ✅ |
| stackedPopupsScale   | ✅  | ❌ | ✅ |
| stackedElementsLimit  | ✅ | ❌ | ✅ |
| cornerRadius   | ❌ | ✅ | ❌ |
| activePopupCornerRadius    | ✅  | ❌ | ✅ |
| stackedPopupsCornerRadius  | ✅  | ❌ | ✅ |
| activePopupCornerRadius | ✅| ❌ | ✅ |
| dragGestureProgressToClose  | ✅ | ❌ | ✅ |
| dragGestureAnimation   | ✅ | ❌ | ✅ |
| tapOutsideToDismiss    | ❌ | ✅ | ❌ |
| transitionAnimation    | ✅ | ✅ | ✅ |



#### TopPopup
| Safe area  | Ignore safe area  |
|:----------|:----------|
| ![Top][top popup] | ![Top][top stack popup]    |



#### CentrePopup
![TopPopup][center popup]

#### BottomPopup
|  Safe Area  | Ignore Safe Area   | 
|:----------|:----------|
| ![Bottom][bottom popup safe area] | ![Bottom][bottom popup] | 

#### Popup Stack
The `PopupView` allows you to stack views and present several popups on the screen at the same time. The library automatically manages the display of multiple pop-up windows depending on the type of presentation.

| Bottom stack  | Top stack  | Different view heights  | Bottom stack  |
|:----------|:----------|:----------|:----------|
| ![Bottom][bottom popup stack drag]   | ![Top][top stack popup]   | ![Bottom][bottom popup stack documents]    | ![bottom][bottom popup stack old style]   |



## Popup presentation
To present a view, it is enough to initialize it and call the method `present`
```Swift
 SomeView().present()
```

## Popup dismiss
Call the method `dismiss` inside the popup view to dismiss it

It's also available to dismiss any view with methods inside the `PopupManager` class: 

- `dismissLast` - Dismisses the last presented popup view
```Swift
PopupManager.dismissLast()
```

- `dismiss(id:)` - Dismisses the presented popup view with concrate id
```Swift
PopupManager.dismiss(id: "some_id")
```

- `dismissAll` - Dismisses all presented popup views
```Swift
PopupManager.dismissAll()
```

# Project example
[PopupView-Example][PopupView-Example] - example of usage `PopupView` library

[swift version]: https://swift.org/download/
[swift version badge]: https://img.shields.io/badge/swift-5.7-orange
[platforms badge]: https://img.shields.io/badge/platforms-ios-lightgrey
[platforms]: https://swift.org/download/
[mit badge]: https://img.shields.io/badge/license-MIT-lightgrey
[mit]: https://github.com/Mijick/PopupView/blob/main/LICENSE
[spm badge]: https://img.shields.io/badge/spm-compatible-green
[spm]: https://www.swift.org/package-manager/
[ios badge]: https://img.shields.io/badge/ios-15%2B-orange 
[ios]: https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-15-release-notes

[setup]: #setup-project
[animation]: #animation-protocols
[presentation]: #popup-presentation
[dismiss]: #popup-dismiss
[installation]: #installation

[PopupView-Example]: https://github.com/Mijick/PopupView-Example

[top popup]: https://media1.tenor.com/images/5423f4c94dbe850d0a16952a83c8a1cd/tenor.gif?itemid=27638405
[bottom popup safe area]: https://media1.tenor.com/images/53db74eaaa9ac6b56fb87135781f4f20/tenor.gif?itemid=27638501
[bottom popup]: https://media1.tenor.com/images/886c15b77bb62115bbafd35c54e20234/tenor.gif?itemid=27638499
[center popup]: https://media1.tenor.com/images/28bee69f1ed4793f28aade7c21003899/tenor.gif?itemid=27638435

[top stack popup]: https://media1.tenor.com/images/3b8593c8d52fbea8ca74b46f9ebd948a/tenor.gif?itemid=27638433
[bottom popup stack documents]: https://media1.tenor.com/images/e2e9eb5a58f2c6ba42ef10da4cb10ecf/tenor.gif?itemid=27638434
[bottom popup stack drag]: https://media1.tenor.com/images/8947619538733c4394d38cfcf1daa28f/tenor.gif?itemid=27638500 
[bottom popup stack rounded corner]: https://media1.tenor.com/images/9dda5430a4c1f9ca654285a2d72c1cab/tenor.gif?itemid=27638502
[bottom popup stack old style]: https://media1.tenor.com/images/10e52a97eda60dbd81709bca45369a8e/tenor.gif?itemid=27638503

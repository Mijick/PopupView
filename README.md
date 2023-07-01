<br>

<p align="center">
  <picture> 
    <source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/23524947/229163179-2033f875-f9cc-46ea-8d27-3a8a04007824.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://user-images.githubusercontent.com/23524947/229172729-dd4fec15-8f90-4ca8-b59c-7ee109da7370.svg">
    <img alt="PopupView Logo" src="https://user-images.githubusercontent.com/23524947/229163179-2033f875-f9cc-46ea-8d27-3a8a04007824.svg" width="88%"">
  </picture>
</p>

<h3 style="font-size: 5em" align="center">
    Popups presentation made simple
</h3>

<p align="center">
    Create beautiful and fully customisable popups in no time. Keep your code clean
</p>

<p align="center">
    <a href="https://github.com/Mijick/PopupView-Example" rel="nofollow">Try demo we prepared</a>
</p>

<br>

<p align="center">
    <img alt="SwiftUI logo" src="https://github.com/Mijick/PopupView/assets/23524947/4ad7cce0-3efc-473b-bc41-9512aab2b26d.svg"/>
    <img alt="Platforms: iOS, iPadOS, macOS, tvOS" src="https://github.com/Mijick/PopupView/assets/23524947/83f8ebf0-c083-4690-8ce7-4117af7c2e8e.svg"/>
    <img alt="Release: 2.0.0" src="https://github.com/Mijick/PopupView/assets/23524947/6d916616-ad05-4079-ba92-4dab8d7c14a8.svg"/>
    <img alt="Compatible: Swift Package Manager, Cocoapods" src="https://github.com/Mijick/PopupView/assets/23524947/b54d3a61-1f4c-4a74-99d4-9b81418a70ae.svg"/>
    <img alt="License: MIT" src="https://github.com/Mijick/PopupView/assets/23524947/e3e47658-8ccd-4532-8121-fbf15853e725.svg"/>
</p>

<p align="center">
    <a href="https://github.com/Mijick/PopupView/stargazers">
        <img alt="Stargazers" src="https://github.com/Mijick/PopupView/assets/23524947/f58b4257-65f2-4a83-ab0a-5b6bc26fe773"/>
    </a>                                                                                                              
    <a href="https://twitter.com/MijickTeam">
        <img alt="Follow us on Twitter" src="https://github.com/Mijick/PopupView/assets/23524947/26c8f5fc-1162-4721-a514-10ef17833021"/>
    </a>
    <a href=mailto:team@mijick.com?subject=Hello>
        <img alt="Let's work together" src="https://github.com/Mijick/PopupView/assets/23524947/4491418b-c831-41c7-b7fa-68ae9664a943"/>
    </a>   
    <img alt="Made in Kraków" src="https://github.com/Mijick/PopupView/assets/23524947/289bb4f8-6c0e-4e97-afb5-dae0b2688965.svg"/>
</p>

<p align="center">
    <img alt="Popup Examples" src="https://github.com/Mijick/PopupView/assets/23524947/593d81ff-c3ec-4784-b92a-7e3181156576"/>
</p>

<br>

PopupView is a free and open-source library dedicated for SwiftUI that makes the process of presenting popups easier and much cleaner.
* **Improves code quality.** Show your popup using the `showAndStack()` or `showAndReplace()` method.<br/>
    Hide the selected one with `dismiss()`. Simple as never.
* **Create any popup.** We know how important customisation is; that's why we give you the opportunity to design your popup in any way you like.
* **Designed for SwiftUI.** While developing the library, we have used the power of SwiftUI to give you powerful tool to speed up your implementation process.

<br>

# Getting Started
### ✋ Requirements

| **Platforms** | **Minimum Swift Version** |
|:----------|:----------|
| iOS 14+ | 5.0 |
| iPadOS 14+ | 5.0 |
| macOS 12+ | 5.0 |
| tvOS 15+ | 5.0 |

### ⏳ Installation
    
#### [Swift Package Manager][spm]
Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

Once you have your Swift package set up, adding PopupView as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Mijick/PopupView.git", branch(“main”))
]
```

#### [Cocoapods][cocoapods]   
Cocoapods is a dependency manager for Swift and Objective-C Cocoa projects that helps to scale them elegantly.

Installation steps:
- Install CocoaPods 1.10.0 (or later)
- [Generate CocoaPods][generate_cocoapods] for your project
```Swift
    pod init
```
- Add CocoaPods dependency into your `Podfile`   
```Swift
    pod 'Mijick_PopupView'
```
- Install dependency and generate `.xcworkspace` file
```Swift
    pod install
```
- Use new XCode project file `.xcworkspace`
<br>
    
# Usage
### 1. Setup library
Inside your `@main` structure call the `implementPopupView` method. It takes the optional argument - *config*, that can be used to configure some modifiers for all popups in the application.
```Swift
  var body: some Scene {
        WindowGroup(content: ContentView().implementPopupView)
  }
```

### 2. Declare a structure of your popup
The library provides an ability to present your custom view in three predefinied places - **Top**, **Centre** and **Bottom**.<br>
In order to present it, it is necessary to confirm to one of the protocols during your view declaration:
- `TopPopup` - presents popup view from the top
- `CentrePopup` - presents popup view from the center
- `BottomPopup` - presents popup view from the bottom

So that an example view you want to present will have the following declaration:
```Swift
struct BottomCustomPopup: BottomPopup {
    ...
}
```

### 3. Implement `createContent()` method 
The function above is used instead of the body property, and declares the design of the popup view.
```Swift
struct BottomCustomPopup: BottomPopup {    
    func createContent() -> some View {
        HStack(spacing: 0) {
            Text("Witaj okrutny świecie")
            Spacer()
            Button(action: dismiss) { Text("Dismiss") } 
        }
        .padding(.vertical, 20)
        .padding(.leading, 24)
        .padding(.trailing, 16)
    }
    ...
}
```

### 4. Implement `configurePopup(popup: Config) -> Config` method
*Declaring this step is optional - if you wish, you can skip this step and leave the UI configuration to us.*<br/>
Each protocol has its own set of methods that can be used to create a unique appearance for every popup.
```Swift
struct BottomCustomPopup: BottomPopup {    
    func createContent() -> some View {
        HStack(spacing: 0) {
            Text("Witaj okrutny świecie")
            Spacer()
            Button(action: dismiss) { Text("Dismiss") } 
        }
        .padding(.vertical, 20)
        .padding(.leading, 24)
        .padding(.trailing, 16)
    }
    func configurePopup(popup: BottomPopupConfig) -> BottomPopupConfig {
        popup
            .horizontalPadding(20)
            .bottomPadding(42)
            .cornerRadius(16)
    }
    ...
}
```

### 5. Present your popup from any place you want!
Just call `BottomCustomPopup().showAndStack()` from the selected place
```Swift
struct SettingsViewModel {
    ...
    func saveSettings() {
        ...
        BottomCustomPopup().showAndStack()
        ...
    }
    ...
}
```

### 6. Closing popups
There are two methods to do so:
- By calling one of the methods `dismiss`, `dismiss(_ popup: Popup.Type)`, `dismissAll(upTo: Popup.Type)`, `dismissAll` inside the popup you created
```Swift
struct BottomCustomPopup: BottomPopup {
    ...
    func createButton() -> some View {
        Button(action: dismiss) { Text("Tap to close") } 
    }
    ...
}
```
- By calling one of three static methods of PopupManager:
    - `PopupManager.dismiss()`
    - `PopupManager.dismiss(_ popup: Popup.Type)` where popup is the popup you want to close
    - `PopupManager.dismissAll()`
    
<br>

# Try our demo
See for yourself how does it work by cloning [project][Demo] we created

# License
PopupView is released under the MIT license. See [LICENSE][License] for details.

<br><br>

# Our other open source SwiftUI libraries
[Navigattie] - Easier and cleaner way of navigating through your app


[MIT]: https://en.wikipedia.org/wiki/MIT_License
[SPM]: https://www.swift.org/package-manager

[Demo]: https://github.com/Mijick/PopupView-Example
[License]: https://github.com/Mijick/PopupView/blob/main/LICENSE

[spm]: https://www.swift.org/package-manager/
[cocoapods]: https://cocoapods.org/
[generate_cocoapods]: https://github.com/square/cocoapods-generate

[Navigattie]: https://github.com/Mijick/Navigattie  

<br>

<p align="center">
  <picture> 
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/Mijick/Assets/blob/main/PopupView/Logotype/On%20Dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/Mijick/Assets/blob/main/PopupView/Logotype/On%20Light.svg">
    <img alt="PopupView Logo" src="https://github.com/Mijick/Assets/blob/main/PopupView/Logotype/On%20Dark.svg" width="76%"">
  </picture>
</p>

<h3 style="font-size: 5em" align="center">
    Popups presentation made simple
</h3>

<p align="center">
    Create beautiful and fully customisable popups in no time. Keep your code clean
</p>

<p align="center">
    <a href="https://github.com/Mijick/Popups-Demo" rel="nofollow">Try demo we prepared</a>
    |
    <a href="https://mijick.notion.site/c95fe641ff684561a4523b9570113516?v=46960f9a652147d4a12fc9dd36cbd4fc" rel="nofollow">Roadmap</a>
    |
    <a href="https://github.com/Mijick/Popups/issues/new" rel="nofollow">Propose a new feature</a>
</p>

<br>

<p align="center">
    <img alt="SwiftUI logo" src="https://github.com/Mijick/Assets/blob/main/PopupView/Labels/Language.svg"/>
    <img alt="Platforms: iOS, iPadOS, macOS, tvOS" src="https://github.com/Mijick/Assets/blob/main/PopupView/Labels/Platforms.svg"/>
    <img alt="Current Version" src="https://github.com/Mijick/Assets/blob/main/PopupView/Labels/Version.svg"/>
    <img alt="License: MIT" src="https://github.com/Mijick/Assets/blob/main/PopupView/Labels/License.svg"/>
</p>

<p align="center">
    <img alt="Made in Kraków" src="https://github.com/Mijick/Assets/blob/main/PopupView/Labels/Origin.svg"/>
    <a href="https://twitter.com/MijickTeam">
        <img alt="Follow us on X" src="https://github.com/Mijick/Assets/blob/main/PopupView/Labels/X.svg"/>
    </a>
    <a href=mailto:team@mijick.com?subject=Hello>
        <img alt="Let's work together" src="https://github.com/Mijick/Assets/blob/main/PopupView/Labels/Work%20with%20us.svg"/>
    </a>  
    <a href="https://github.com/Mijick/PopupView/stargazers">
        <img alt="Stargazers" src="https://github.com/Mijick/Assets/blob/main/PopupView/Labels/Stars.svg"/>
    </a>                                                                                                               
</p>

<p align="center">
    <img alt="Popup Examples" src="https://github.com/Mijick/Assets/blob/main/PopupView/GIFs/PopupView-Bottom.gif" width="30%"/>
    <img alt="Popup Examples" src="https://github.com/Mijick/Assets/blob/main/PopupView/GIFs/PopupView-Centre.gif" width="30%"/>
    <img alt="Popup Examples" src="https://github.com/Mijick/Assets/blob/main/PopupView/GIFs/PopupView-Top.gif" width="30%"/>
</p>

<br>

MijickPopups is a free and open-source library dedicated for SwiftUI that makes the process of presenting popups easier and much cleaner.
* **Improves code quality.** Show your popup using the `present()` method.<br/>
    Hide with `dismissLastPopup()`. Simple as never.
* **Create any popup.** We know how important customisation is; that's why we give you the opportunity to design your popup in any way you like.
* **Designed for SwiftUI.** While developing the library, we have used the power of SwiftUI to give you powerful tool to speed up your implementation process.

<br>

# Getting Started
### ✋ Requirements

| **Platforms** | **Minimum Swift Version** |
|:----------|:----------|
| iOS 14+ | 6.0 |
| iPadOS 14+ | 6.0 |
| macOS 12+ | 6.0 |
| tvOS 15+ | 6.0 |
| watchOS 4+ | 6.0 |
| visionOS 1+ | 6.0 |

### ⏳ Installation
    
#### [Swift Package Manager][spm]
Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

Once you have your Swift package set up, adding MijickPopups as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Mijick/Popups.git", branch(“main”))
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
    pod 'MijickPopups'
```
- Install dependency and generate `.xcworkspace` file
```Swift
    pod install
```
- Use new Xcode project file `.xcworkspace`
<br>
    
# Usage
### 1. Setup library
The library can be initialised in either of two ways:
1. **DOES NOT WORK with SwiftUI sheets**<br>Inside your @main structure call the `registerPopups()` method. It takes the optional argument - `configBuilder`, that can be used to configure some modifiers for all popups in the application.
```Swift
@main struct App_Main: App {
   var body: some Scene { WindowGroup {
       ContentView()
           .registerPopups { config in config
               .vertical { $0
                   .enableDragGesture(true)
                   .tapOutsideToDismissPopup(true)
                   .cornerRadius(32)
               }
               .centre { $0
                   .tapOutsideToDismissPopup(false)
                   .backgroundColor(.white)
               }
           }
   }}
}
```
2. **WORKS with SwiftUI sheets. Only for iOS**<br>
Declare an AppDelegate class conforming to UIApplicationDelegate and add it to the @main structure. 
```Swift
@main struct App_Main: App {
   @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate


   var body: some Scene { WindowGroup(content: ContentView.init) }
}


class AppDelegate: NSObject, UIApplicationDelegate {
   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
       sceneConfig.delegateClass = CustomPopupSceneDelegate.self
       return sceneConfig
   }
}


class CustomPopupSceneDelegate: PopupSceneDelegate {
   override init() { super.init()
       configBuilder = { $0
           .vertical { $0
               .enableDragGesture(true)
               .tapOutsideToDismissPopup(true)
               .cornerRadius(32)
           }
           .centre { $0
               .tapOutsideToDismissPopup(false)
               .backgroundColor(.white)
           }
       }
   }
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

### 3. Declare `body` variable 
The variable above declares the design of the popup.
```Swift
struct BottomCustomPopup: BottomPopup {    
    var body: some View {
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

### 4. Implement `configurePopup(config: Config) -> Config` method
*Declaring this step is optional - if you wish, you can skip this step and leave the UI configuration to us.*<br/>
Each protocol has its own set of methods that can be used to create a unique appearance for every popup.
```Swift
struct BottomCustomPopup: BottomPopup {    
    var body: some View {
        HStack(spacing: 0) {
            Text("Witaj okrutny świecie")
            Spacer()
            Button(action: dismiss) { Text("Dismiss") } 
        }
        .padding(.vertical, 20)
        .padding(.leading, 24)
        .padding(.trailing, 16)
    }
    func configurePopup(config: BottomPopupConfig) -> BottomPopupConfig {
        config
            .horizontalPadding(20)
            .bottomPadding(42)
            .cornerRadius(16)
    }
    ...
}
```

### 5. Present your popup from any place you want!
Just call `BottomCustomPopup().present()` from the selected place. Popup can be closed automatically by adding the `dismissAfter()` modifier.
```Swift
struct SettingsViewModel {
    ...
    func saveSettings() {
        ...
        BottomCustomPopup()
            .dismissAfter(5)
            .present()
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
    - `PopupManager.dismissAll(upTo popup: Popup.Type)` where popup is the popup up to which you want to close the popups on the stack
    - `PopupManager.dismissAll()`
    
<br>

### Postscript
The framework has extensive documentation built in, so in case of any problems, please use the Xcode Quick Help 😉 

# Try our demo
See for yourself how does it work by cloning [project][Demo] we created

# License
PopupView is released under the MIT license. See [LICENSE][License] for details.

<br><br>

# Our other open source SwiftUI libraries
[NavigationView] - Easier and cleaner way of navigating through your app
<br>
[CalendarView] - Create your own calendar object in no time
<br>
[GridView] - Lay out your data with no effort
<br>
[CameraView] - The most powerful CameraController. Designed for SwiftUI
<br>
[Timer] - Modern API for Timer


[MIT]: https://en.wikipedia.org/wiki/MIT_License
[SPM]: https://www.swift.org/package-manager

[Demo]: https://github.com/Mijick/Popups-Demo
[License]: https://github.com/Mijick/Popups/blob/main/LICENSE

[spm]: https://www.swift.org/package-manager/
[cocoapods]: https://cocoapods.org/
[generate_cocoapods]: https://github.com/square/cocoapods-generate

[NavigationView]: https://github.com/Mijick/NavigationView
[CalendarView]: https://github.com/Mijick/CalendarView 
[CameraView]: https://github.com/Mijick/CameraView
[GridView]: https://github.com/Mijick/GridView
[Timer]: https://github.com/Mijick/Timer

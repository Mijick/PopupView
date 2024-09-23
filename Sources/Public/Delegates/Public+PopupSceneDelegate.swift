//
//  Public+PopupSceneDelegate.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

#if os(iOS)
open class PopupSceneDelegate: NSObject, UIWindowSceneDelegate {
    open var window: UIWindow?
    open var config: (GlobalConfig) -> (GlobalConfig) = { _ in .init() }
}

// MARK: - Creating Popup Scene
extension PopupSceneDelegate {
    open func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let hostingController = UIHostingController(rootView: Rectangle()
                .fill(Color.clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .implementPopupView(config: config)
            )
            hostingController.view.backgroundColor = .clear
            
            window = PassthroughWindow(windowScene: windowScene)
            window?.rootViewController = hostingController
            window?.isHidden = false
        }
    }
}


// MARK: - Helpers
///https://forums.developer.apple.com/forums/thread/762292?answerId=803885022#803885022
private final class PassthroughWindow: UIWindow {
    private static func _hitTest(
        _ point: CGPoint,
        with event: UIEvent?,
        view: UIView,
        depth: Int = 0
    ) -> Optional<(view: UIView, depth: Int)> {
        var deepest: Optional<(view: UIView, depth: Int)> = .none
        
        /// views are ordered back-to-front
        for subview in view.subviews.reversed() {
            let converted = view.convert(point, to: subview)
            
            guard subview.isUserInteractionEnabled,
                  !subview.isHidden,
                  subview.alpha > 0,
                  subview.point(inside: converted, with: event)
            else {
                continue
            }
            
            let result = if let hit = Self._hitTest(
                converted,
                with: event,
                view: subview,
                depth: depth + 1
            ) {
                hit
            } else  {
                (view: subview, depth: depth)
            }
            
            if case .none = deepest {
                deepest = result
            } else if let current = deepest, result.depth > current.depth {
                deepest = result
            }
        }
        
        return deepest
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        /// on iOS 18 `rootViewController.view` greedily captures taps, even when it's hierarchy contains no interactive views
        /// if it's hierarchy _does_ contain interactive elements, it returns *itself* when calling `.hitTest`
        /// this is problematic because it's frame likely fills the whole screen, causing everything behind it to become non-interactive
        /// to fix this, we have to perform hit testing on it's _subviews_
        /// looping through it's subviews while performing `.hitTest` won't work though, as `hitTest` doesn't return the depth at which it found a hit
        /// as we are interested in the hit at the deepest depth, we have to reimplement it
        /// once we have obtained the deepest hit, just overriding `.hitTest` and returning the deepest view doesn't work, as  gesture recognizers are registered on `rootViewController.view`, not the hit view
        /// we therefor still return the default hit test result, but only if the tap was detected within the bounds of the _deepest view_
        if #available(iOS 18, *) {
            guard let view = rootViewController?.view else {
                return false
            }
            
            let hit = Self._hitTest(
                point,
                with: event,
                /// happens when e.g. `UIAlertController` is presented
                /// not advisable when added subviews are potentially non-interactive, as `rootViewController?.view` itself is part of `self.subviews`, and therefor participates in hit testing
                view: subviews.count > 1 ? self : view
            )
            
            return hit != nil
        } else {
            return super.point(inside: point, with: event)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if #available(iOS 18, *) {
            return super.hitTest(point, with: event)
        } else {
            guard let hit = super.hitTest(point, with: event) else {
                return .none
            }
            return rootViewController?.view == hit ? .none : hit
        }
    }
}

#endif

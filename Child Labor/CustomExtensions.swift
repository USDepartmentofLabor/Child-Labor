

import Foundation

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}

extension UIDevice {
    
    static func isIPad() -> Bool {
        return self.current.userInterfaceIdiom == .pad
    }
    
    var isLandscape:Bool {
        return self.currentOrientation.isLandscape
    }
    
    var isPortrait:Bool {
        return self.currentOrientation.isPortrait
    }
    
    var currentOrientation: UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
                return interfaceOrientation
            }
        }
        return .portrait
    }
}

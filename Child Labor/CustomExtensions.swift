

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

extension UIImage {
    
    class func textEmbededImage(image: UIImage, string: String, color:UIColor, imageAlignment: Int = 0, segFont: UIFont? = nil) -> UIImage {
        let font = segFont ?? UIFont.systemFont(ofSize: 10.0)
        let expectedTextSize: CGSize = (string as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        let width: CGFloat = expectedTextSize.width + 5.0
        let height: CGFloat = max(expectedTextSize.height, 20)
        let size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        let fontTopPosition: CGFloat = 20
        let textOrigin: CGFloat = 5
        let flipVertical: CGAffineTransform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
        context.concatenate(flipVertical)
        context.draw(image.cgImage!, in: CGRect.init(x: ((width - 20) / 2.0), y: 0, width: 10, height: 20))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

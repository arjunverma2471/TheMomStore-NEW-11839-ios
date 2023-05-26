
/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */
import UIKit

extension UIImageView {
  func setImageFrom(_ url: URL?, placeholder: UIImage? = nil) {
    /* ---------------------------------
     ** If the url is provided, kick off
     ** the image request and update the
     ** current data task.
     */
 /*   if let url = url {
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [.scaleDownLargeImages,.refreshCached, .progressiveLoad], completed: { (image,err, _,url) in
      })
    } else {
      self.image       = placeholder
     }  */
      
      if let url = url {
          self.sd_setImage(with: url) { (image,err, _,url) in
              self.backgroundColor = .clear
              
          }
      }
  }
    
    
    func setRoundedImageFrom(_ url: URL?, placeholder: UIImage? = nil, radius: CGFloat) {
      /* ---------------------------------
       ** If the url is provided, kick off
       ** the image request and update the
       ** current data task.
       */
   /*   if let url = url {
          self.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [.scaleDownLargeImages,.refreshCached, .progressiveLoad], completed: { (image,err, _,url) in
        })
      } else {
        self.image       = placeholder
       }  */
        
        if let url = url {
            self.sd_setImage(with: url) { (image,err, _,url) in
                self.backgroundColor = .clear
                self.image = self.image?.sd_roundedCornerImage(withRadius: radius, corners: .allCorners, borderWidth: 0.0, borderColor: nil)
            }
        }
    }
    
    func setPNGImageFrom(_ url: URL?, placeholder: UIImage? = nil) {
        if let url = url {
            
            self.sd_setImage(with:  url.getOptUrl(), placeholderImage:  UIImage(named: "placeholder"), options: .highPriority, completed: nil)
            
        }
        
    }
  
}



extension URL{
    func getOptUrl()->URL? {
        var imageUrl = self.absoluteString
        if !imageUrl.contains("cedcommerce.com") {
            if imageUrl.contains(".png"){
                imageUrl=imageUrl.replacingOccurrences(of: ".png", with: "_\(ClientQuery.maxImageDimension)x.png")
            }
            else if imageUrl.contains(".jpg"){
                imageUrl=imageUrl.replacingOccurrences(of: ".jpg", with: "_\(ClientQuery.maxImageDimension)x.jpg")
            }
            else if imageUrl.contains(".jpeg"){
                imageUrl=imageUrl.replacingOccurrences(of: ".jpeg", with: "_\(ClientQuery.maxImageDimension)x.jpeg")
            }
        }
        return imageUrl.getURL()
    }
    
    

    
}


extension UIImageView {
  static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
    guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
      print("Gif does not exist at that path")
      return nil
    }
    let url = URL(fileURLWithPath: path)
    guard let gifData = try? Data(contentsOf: url),
          let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
    var images = [UIImage]()
    let imageCount = CGImageSourceGetCount(source)
    for i in 0 ..< imageCount {
      if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
        images.append(UIImage(cgImage: image))
      }
    }
    let gifImageView = UIImageView(frame: frame)
    gifImageView.animationImages = images
    gifImageView.image = images.last
    gifImageView.animationRepeatCount = 0
    gifImageView.animationDuration = 1
    return gifImageView
  }
}
class ImageSize{
    private init(){}
    static let shared = ImageSize()
    func sizeOfImageAt(url: URL) -> CGSize? {
        // with CGImageSource we avoid loading the whole image into memory
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        
        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }
        
        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
           let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
}

extension UIImage {
        // image with rounded corners
        public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
            let maxRadius = min(size.width, size.height) / 2
            let cornerRadius: CGFloat
            if let radius = radius, radius > 0 && radius <= maxRadius {
                cornerRadius = radius
            } else {
                cornerRadius = maxRadius
            }
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            let rect = CGRect(origin: .zero, size: size)
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
            draw(in: rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
}

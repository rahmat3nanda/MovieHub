//
//  UIImageView+Load.swift
//  SharedUI
//
//  Created by Antigravity on 04/06/26.
//

import UIKit

private var imageURLKey: UInt8 = 0

public extension UIImageView {
    
    private var currentImageURL: URL? {
        get {
            return objc_getAssociatedObject(self, &imageURLKey) as? URL
        }
        set {
            objc_setAssociatedObject(
                self,
                &imageURLKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    /// Loads an image asynchronously from a URL string, caching it in memory.
    /// - Parameters:
    ///   - urlString: The URL string of the image.
    ///   - placeholder: Optional placeholder image to show while loading.
    func loadImage(from urlString: String?, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        self.currentImageURL = url
        
        let cacheKey = urlString as NSString
        if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if error != nil {
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data),
                  self.currentImageURL == url else {
                return
            }
            
            ImageCache.shared.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

private final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}

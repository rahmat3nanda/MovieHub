//
//  RemoteImageView.swift
//  SharedUI
//
//  Created by Antigravity on 04/06/26.
//

import UIKit
import Kingfisher
import DesignSystem

public final class RemoteImageView: UIImageView {
    
    public init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    /// Loads an image asynchronously from a URL string using Kingfisher.
    /// It automatically shows a shimmering skeleton effect on the image view itself while the image is loading.
    /// - Parameters:
    ///   - urlString: The URL string of the image to load.
    ///   - placeholder: The placeholder image to use when loading or in case of error. Defaults to `Icons.icon`.
    public func loadImage(from urlString: String?, placeholder: UIImage? = Icons.icon) {
        // Cancel any pending Kingfisher download task
        kf.cancelDownloadTask()
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            hideSkeleton()
            return
        }
        
        // Show skeleton loader on the UIImageView itself
        showSkeleton(
            baseColor: .systemGray6,
            highlightColor: .systemGray5,
            cornerRadius: layer.cornerRadius,
            recursive: false
        )
        
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.25)),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self = self else { return }
            
            // Remove the skeleton layer once download finishes
            self.hideSkeleton()
            
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
            case .failure:
                self.image = placeholder
            }
        }
    }
}

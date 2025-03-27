//
//  CustomeImageView.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit

/// A type that manages image downloads and caching.
/// `CustomImageView` is a subclass of `UIImageView` that provides a convenient way to asynchronously load and cache images from a URL.
/// It integrates with an `ImageCacheManager` to efficiently manage image downloads and caching, reducing network usage and improving performance.
class CustomImageView: UIImageView {
    private let imageManager: ImageCacheManager
    
    var imageURLString: String? {
        didSet {
            // Check if the new URL is different from the old URL to avoid redundant image loading.
            guard oldValue != imageURLString else {
                return
            }
            update()
        }
    }
    
    var currentTask: Task<Void, Never>?
    
    init(frame: CGRect = .zero, imageURLString: String? = nil, imageManager: ImageCacheManager = .shared) {
        self.imageManager = imageManager
        self.imageURLString = imageURLString
        
        super.init(frame: frame)
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Loads an image from the `imageURL` asynchronously using the `ImageCacheManager` and sets it to the image view.
    /// If the `imageURL` is `nil` or the image fails to load, no image is set.
    @MainActor
    private func update() {
        guard let urlString = imageURLString, let url = URL(string: urlString) as? NSURL else {
            self.image = .init(systemName: "photo.fill")
            return
        }
        // Use the image manager to load the image asynchronously.
        currentTask = Task {
            self.image = await imageManager.load(url)
        }
    }
}


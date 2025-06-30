//
//  CustomeImageView.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit

/// A type that manages image downloads and caching.
/// `CustomImageView` is a subclass of `UIImageView` that provides a convenient way to asynchronously load and cache images from a URL.
/// It integrates with an `ImageCacheManager` to efficiently manage image downloads and caching, reducing network usage and improving performance.
class CustomImageView: UIImageView {
    var imageURLString: String? {
        didSet {
            // Check if the new URL is different from the old URL to avoid redundant image loading.
            guard oldValue != imageURLString else {
                return
            }
            Task {
                await update()
            }
        }
    }
    
    var currentTask: Task<Void, Never>?
    
    private let shimmerView = ShimmerPlaceholderView()
    
    private var gradientLayer: CAGradientLayer?

    init(frame: CGRect = .zero, imageURLString: String? = nil) {
        self.imageURLString = imageURLString
        super.init(frame: frame)
        addSubview(shimmerView)
        shimmerView.frame = bounds
        shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        Task {
            await update()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Loads an image from the `imageURL` asynchronously using the `ImageCacheManager` and sets it to the image view.
    /// If the `imageURL` is `nil` or the image fails to load, no image is set.
    @MainActor
    private func update() async {
        currentTask?.cancel()
        shimmerView.startShimmer()
        guard let urlString = imageURLString, let url = URL(string: urlString) else {
            self.image = UIImage(named: "silhouette")
            shimmerView.stopShimmer()
            return
        }
        
        if let cachedImage = await ImageCacheManager.shared.image(for: url) {
            if Task.isCancelled { return }
            self.image = cachedImage
            shimmerView.stopShimmer()
            return
        }
        
        currentTask = Task {
            do {
                let loadedImage = try await ImageCacheManager.shared.load(url)
                if Task.isCancelled { return }
                self.image = loadedImage
            } catch {
                self.image = UIImage(named: "silhouette")
            }
            shimmerView.stopShimmer()
        }
    }
    
    func reset() {
        currentTask?.cancel()
        image = nil
        shimmerView.startShimmer()
    }
}

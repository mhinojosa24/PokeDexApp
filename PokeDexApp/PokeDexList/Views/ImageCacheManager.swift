//
//  ImageCacheManager.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/26/25.
//

import UIKit


/// `ImageCacheManager` is a singleton class responsible for managing image caching and retrieval in the application.
/// It leverages `NSCache` to cache images in memory and an `APIClient` for fetching images from the network when not available in the cache.
final class ImageCacheManager {
    static let shared = ImageCacheManager(client: NetworkClient())
    
    private let cache: NSCache<NSString, UIImage>
    private let client: APIClient
    
    private init(client: APIClient, cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()) {
        self.client = client
        self.cache = cache
    }
    
    /// Loads an image from a given URL, either from the cache or by fetching it from the network if not cached.
    /// - Parameters:
    ///   - imageURL: The `NSURL` of the image to load.
    ///   - completion: A completion handler that returns an optional `UIImage`.
    func load(_ imageURL: NSURL) async -> UIImage? {
        let urlString = NSString(string: imageURL.absoluteString ?? "")
        if let cachedImage = cache.object(forKey: urlString) {
            return cachedImage
        }
        
        do {
            let (data, _) = try await client.fetchData(imageURL as URL)
            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: urlString)
                return image
            } else {
                print("Failed to create UIImage from data")
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}


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
        Task {
            self.image = await imageManager.load(url)
        }
        
    }
}


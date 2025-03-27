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


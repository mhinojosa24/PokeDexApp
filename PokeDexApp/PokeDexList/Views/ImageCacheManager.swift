//
//  ImageCacheManager.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/26/25.
//

import Foundation
import UIKit


/// `ImageCacheManager` is a singleton class responsible for managing image caching and retrieval in the application.
/// It leverages `NSCache` to cache images in memory and an `APIClient` for fetching images from the network when not available in the cache.
final class ImageCacheManager {
    static let shared = ImageCacheManager(client: NetworkClient())
    
    private let cache: NSCache<NSString, UIImage>
    private let client: APIClient
    private let cacheExpiryInterval: TimeInterval = 86400 // 24 hours in seconds
    private var cacheTimeStamps: [NSString: Date]
    
    private init(client: APIClient, cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()) {
        self.client = client
        self.cache = cache
        self.cacheTimeStamps = [:]
        
        // Observes memory warnings to clear the cache.
        NotificationCenter.default.addObserver(self, selector: #selector(clearCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        
        // Schedules regular cache clearing.
        scheduleRegularCacheClearing()
    }
    
    /// Loads an image from a given URL, either from the cache or by fetching it from the network if not cached.
    /// - Parameters:
    ///   - imageURL: The `NSURL` of the image to load.
    ///   - completion: A completion handler that returns an optional `UIImage`.
    func load(_ imageURL: NSURL) async -> UIImage? {
        let urlString = NSString(string: imageURL.absoluteString ?? "")
        if let cachedImage = cache.object(forKey: urlString), !isCacheExpired(forKey: urlString) {
            return cachedImage
        }
        
        do {
            let (data, _) = try await client.fetchData(imageURL as URL)
            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: urlString)
                cacheTimeStamps[urlString] = Date()
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
    
    /// Clears the cache to free up memory.
    @objc func clearCache() {
        cache.removeAllObjects()
        cacheTimeStamps.removeAll()
    }
    
    /// Clears the cache based on a custom expiry policy.
    @objc private func clearCacheOnExpiry() {
        let now = Date()
        for (key, timestamp) in cacheTimeStamps {
            if now.timeIntervalSince(timestamp) > cacheExpiryInterval {
                cache.removeObject(forKey: key)
                cacheTimeStamps.removeValue(forKey: key)
            }
        }
    }
    
    /// Checks if the cache is expired for a given key.
    private func isCacheExpired(forKey key: NSString) -> Bool {
        guard let timestamp = cacheTimeStamps[key] else { return false }
        return Date().timeIntervalSince(timestamp) > cacheExpiryInterval
    }
    
    /// Schedules regular cache clearing.
    private func scheduleRegularCacheClearing() {
        Timer.scheduledTimer(timeInterval: 86400, target: self, selector: #selector(clearCacheOnExpiry), userInfo: nil, repeats: true)
    }
}


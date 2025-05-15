//
//  ImageCacheManager.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/26/25.
//

import Foundation
import UIKit


/// `ImageCacheManager` is a singleton class responsible for managing image caching and retrieval in the application.
/// It leverages `NSCache` to cache images in memory and an `APIClient` for fetching images from the network when not available in the cache.
final class ImageCacheManager {
    // MARK: - Error Handling
    /// Enum to handle errors related to image loading and caching operations.
    enum LoadError: Error {
        case imageConversionFailed
        case networkError(String)

        var localizedDescription: String {
            switch self {
            case .imageConversionFailed:
                return "Failed to convert data to UIImage"
            case .networkError(let message):
                return "Network error: \(message)"
            }
        }
    }

    static let shared = ImageCacheManager(client: NetworkClient())

    private let cache: NSCache<NSString, UIImage>
    private let client: APIClient
    private let cacheExpiryInterval: TimeInterval = 86400 // 24 hours in seconds
    private var cacheTimeStamps: [NSString: Date]
    private let cacheQueue = DispatchQueue(label: "com.pokevault.imagecache", attributes: .concurrent)

    
    private init(client: APIClient, cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()) {
        self.client = client
        self.cache = cache
        self.cacheTimeStamps = [:]
        
        // Observes memory warnings to clear the cache.
        NotificationCenter.default.addObserver(self, selector: #selector(clearCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        
        // Schedules regular cache clearing.
        scheduleRegularCacheClearing()
    }

    /// Loads an image from the cache or fetches it from the network if not available in the cache.
    /// - Parameter imageURL: The URL of the image to load.
    /// - Throws: `LoadError` if image conversion fails or network fetching fails.
    /// - Returns: The loaded `UIImage` if successful, otherwise `nil`.
    func load(_ imageURL: URL) async throws -> UIImage? {
        let urlString = NSString(string: imageURL.absoluteString)

        // Check if image is already cached and still valid
        if let cachedImage = await getCachedImage(forKey: urlString) {
            return cachedImage
        }

        do {
            let (data, _) = try await client.fetchData(imageURL)
            guard let image = UIImage(data: data) else {
                throw LoadError.imageConversionFailed // Handle image conversion failure
            }

            storeImageInCache(image, forKey: urlString)
            return image
        } catch {
            throw LoadError.networkError(error.localizedDescription) // Handle network errors
        }
    }
    
    func image(for url: URL) async -> UIImage? {
        await getCachedImage(forKey: url.absoluteString as NSString)
    }
    
    /// Retrieves an image from the cache if available and not expired.
    /// - Parameter key: The key associated with the cached image.
    /// - Returns: The cached `UIImage` if available and valid, otherwise `nil`.
    private func getCachedImage(forKey key: NSString) async -> UIImage? {
        await withCheckedContinuation { continuation in
            cacheQueue.async { [weak self] in
            // TODO: fix this warning issue with self
                guard let self = self else { return }
                if let image = self.cache.object(forKey: key), !self.isCacheExpired(forKey: key) {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    /// Stores an image in the cache with the given key.
    /// - Parameter image: The image to store.
    /// - Parameter key: The key to associate the image with in the cache.
    private func storeImageInCache(_ image: UIImage, forKey key: NSString) {
        cacheQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.cache.setObject(image, forKey: key)
            self.cacheTimeStamps[key] = Date() // Store the timestamp for cache expiry management
        }
    }
    
    /// Clears all cached images and timestamps to free up memory.
    @objc func clearCache() {
        cache.removeAllObjects() // Remove all cached images
        cacheTimeStamps.removeAll() // Clear the timestamps for cache expiry
    }
    
    /// Clears images from the cache that have exceeded the expiry time.
    @objc private func clearCacheOnExpiry() {
        let now = Date()
        for (key, timestamp) in cacheTimeStamps {
            if now.timeIntervalSince(timestamp) > cacheExpiryInterval {
                cache.removeObject(forKey: key) // Remove expired images from cache
                cacheTimeStamps.removeValue(forKey: key) // Remove the corresponding timestamp
            }
        }
    }
    
    /// Checks if the cached image associated with the given key has expired.
    /// - Parameter key: The key associated with the cached image.
    /// - Returns: `true` if the cache is expired, otherwise `false`.
    private func isCacheExpired(forKey key: NSString) -> Bool {
        guard let timestamp = cacheTimeStamps[key] else {
            return false
        }
        let expired = Date().timeIntervalSince(timestamp) > cacheExpiryInterval // Determine if the cache is expired
        return expired
    }
    
    /// Schedules a regular cache clearing operation to remove expired images daily.
    private func scheduleRegularCacheClearing() {
        Timer.scheduledTimer(timeInterval: 86400, target: self, selector: #selector(clearCacheOnExpiry), userInfo: nil, repeats: true) // Schedule daily cache clearing
    }
}

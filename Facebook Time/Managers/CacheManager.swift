import UIKit

class CacheManager {
    private let cache: NSCache<NSString, AnyObject>
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.cache = NSCache<NSString, AnyObject>()
        self.fileManager = fileManager
        setupCache()
    }
    
    private func setupCache() {
        cache.countLimit = 100 // Maximum number of objects
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func cache(_ object: AnyObject, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func object(forKey key: String) -> AnyObject? {
        return cache.object(forKey: key as NSString)
    }
    
    func removeObject(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    // Disk caching for images
    func cacheImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: imageURL(for: key))
        }
    }
    
    func cachedImage(forKey key: String) -> UIImage? {
        // Check memory cache first
        if let image = cache.object(forKey: key as NSString) as? UIImage {
            return image
        }
        
        // Check disk cache
        if let data = try? Data(contentsOf: imageURL(for: key)),
           let image = UIImage(data: data) {
            cache.setObject(image, forKey: key as NSString)
            return image
        }
        
        return nil
    }
    
    private func imageURL(for key: String) -> URL {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheDirectory.appendingPathComponent("\(key).jpg")
    }
} 
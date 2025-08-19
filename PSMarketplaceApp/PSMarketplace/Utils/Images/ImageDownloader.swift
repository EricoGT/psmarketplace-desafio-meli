//
//  ImageDownloader.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import UIKit

public final class ImageDownloader : NSObject {
    
    public typealias ImageDownloaderProgress = (_ progress: CGFloat) -> Void
    public typealias ImageDownloaderResult = (_ image: UIImage?, _ data: Data?, _ error: NSError?) -> Void
    
    private var downloadTask: DownloadTask? = nil
    private(set) var currentImageURL: String? = nil
    
    public func download(url: String, progress: (ImageDownloaderProgress?), result: @escaping(ImageDownloaderResult)) -> Void {
        
        if let imageURL = URL.init(string: url) {
            let request = URLRequest(url: imageURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            downloadTask = DownloadService.shared.download(request: request)
            if downloadTask != nil {
                currentImageURL = url
            }
            downloadTask?.completionHandler = { [weak self] in
                switch $0 {
                case .failure(let error):
                    result(nil, nil, error as NSError)
                case .success(let data):
                    result(ImageDownloader.image(url: url, data: data), data, nil)
                }
                self?.downloadTask = nil
                self?.currentImageURL = nil
            }
            //
            downloadTask?.progressHandler = { [weak self] in
                if let _ = self {
                    if let p = progress {
                        let value = CGFloat.init($0)
                        p(value.clamp(low: 0.0, high: 1.0))
                    }
                }
            }
            //
            downloadTask?.resume()
        } else {
            result(nil, nil, nil)
        }
    }
    
    private class func image(url: String, data: Data) -> UIImage? {
        
        //edited...
        
        return UIImage.init(data: data)
    }
    
    public func resume() {
        self.downloadTask?.resume()
    }
    
    func suspend() {
        self.downloadTask?.suspend()
    }
    
    func cancel() {
        self.downloadTask?.cancel()
    }
}


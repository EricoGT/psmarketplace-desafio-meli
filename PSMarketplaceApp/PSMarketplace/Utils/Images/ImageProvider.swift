//
//  ImageProvider.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import UIKit

public struct BasicFileElement {
    var name: String = ""
    var creationDate: Date = Date()
}

public final class ImageProvider: NSObject {
    
    // Init:
    
    static let shared = ImageProvider()
    
    private override init(){
        self.cache.name = "ImageProviderCache"
        self.cache.totalCostLimit = 104_857_600 //100 MB
    }
    
    //Properties:
    
    private var cache = NSCache<NSString, UIImage>()
    
    //Methods:
    
    /// Resgata uma imagem do cache em memória, se existir, ou do disco quando solicitado.
    public func imageFromCache(key: String, inDisc: Bool = false) -> UIImage? {
        if let img = self.cache.object(forKey: key as NSString) {
            return img
        } else {
            if inDisc {
                let neoKey: String = key.removingSymbols()
                return ImageProvider.loadFromDisc(fileName: neoKey, subFolderName: nil, cacheDirectory: true)
            }
        }
        return nil
    }
    
    /// Salva uma imagem no cache. A URL pode ser usada como chave.
    public func saveInCache(image: UIImage, key: String, inDisc: Bool = false) -> Void {
        if let data = image.pngData() {
            self.cache.setObject(image, forKey: key as NSString, cost: data.count)
        } else {
            self.cache.setObject(image, forKey: key as NSString, cost: 1_048_576) //considera-se 1 MB quando não for possível definir...
        }
        //
        if inDisc {
            let neoKey: String = key.removingSymbols()
            ImageProvider.saveOnDisk(fileName: neoKey, image: image, customData: nil, subFolderName: nil, cacheDirectory: true)
        }
    }
    
    /// Remove uma imagem específica do cache, se existir.
    public func removeFromCache(key: String, inDisc: Bool = false) -> Void {
        self.cache.removeObject(forKey: key as NSString)
        //
        if inDisc {
            let neoKey: String = key.removingSymbols()
            ImageProvider.removeFromDisk(fileName: neoKey, subFolderName: nil, cacheDirectory: true)
        }
    }
    
    /// Remove todas as imagens do cache.
    public func clearAllCachedImages(inDisc: Bool = false) -> Void {
        self.cache.removeAllObjects()
        //
        if inDisc {
            ImageProvider.removeAllFilesFromDisk(cacheDirectory: true)
        }
    }
    
    /// Retorna a imagem na cor correspondente, quando existir.
    public class func icon(_ resourceName: String, _ tintColor: UIColor? = nil) -> UIImage? {
        if let img = UIImage.init(named: resourceName)?.withRenderingMode(.alwaysTemplate) {
            if let color = tintColor {
               return img.withTintColor(color)
            }
            return img
        }
        return nil
    }
    
    /// Retorna seguramente uma imagem.
    public class func original(_ resourceName: String) -> UIImage {
        return UIImage.init(named: resourceName)?.withRenderingMode(.alwaysOriginal) ?? UIImage.init()
    }
    
    /// Faz o download da imagem da url parâmetro. O uso de cache pode ser desligado.
    public func image(fromURL: String, usingCache: Bool = true, completion: @escaping(_ image: UIImage?) -> Void ) -> Void {
        if usingCache {
            if let img = ImageProvider.shared.imageFromCache(key: fromURL) {
                completion(img)
            }
        }
        //
        ImageDownloader().download(url: fromURL, progress: nil) { (image, _, _) in
            if let img = image {
                if usingCache {
                    ImageProvider.shared.saveInCache(image: img, key: fromURL)
                }
                completion(img)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: -
    
    /// Este método salva a imagem em disco.
    @discardableResult public class func saveOnDisk(fileName: String, image: UIImage, customData: Data?, subFolderName: String? = nil, cacheDirectory: Bool = false) -> Bool {

        var path: URL? = nil
        
        if cacheDirectory {
            path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        } else {
            path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        
        guard var filePath = path else {
            return false
        }
        
        filePath = filePath.appendingPathComponent("Images")
        if let folder = subFolderName {
            filePath = filePath.appendingPathComponent(folder)
        }
        
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        
        filePath = filePath.appendingPathComponent(fileName)
        
        guard let data: Data = customData ?? image.pngData() else {
            return false
        }
        
        return FileManager.default.createFile(atPath: filePath.path, contents: data, attributes: nil)
    }

    /// Este método busca a imagem do disco.
    public class func loadFromDisc(fileName: String, subFolderName: String? = nil, cacheDirectory: Bool = false) -> UIImage? {

        var path: URL? = nil
        
        if cacheDirectory {
            path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        } else {
            path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        
        guard var filePath = path else {
            return nil
        }
        
        filePath = filePath.appendingPathComponent("Images")
        if let folder = subFolderName {
            filePath = filePath.appendingPathComponent(folder)
        }
        filePath = filePath.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            if let imageData: Data = try? Data(contentsOf: filePath) {
                return UIImage.init(data: imageData)
            }
        }
        
        return nil
    }
    
    /// Este método remove o arquivo solicitado do disco.
    @discardableResult public class func removeFromDisk(fileName: String, subFolderName: String? = nil, cacheDirectory: Bool = false) -> Bool {
        var path: URL? = nil

        if cacheDirectory {
            path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        } else {
            path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        
        guard var filePath = path else {
            return false
        }
        
        filePath = filePath.appendingPathComponent("Images")
        if let folder = subFolderName {
            filePath = filePath.appendingPathComponent(folder)
        }
        
        do {
            try FileManager.default.removeItem(atPath: URL(fileURLWithPath: filePath.path).appendingPathComponent(fileName).path)
            return true
        } catch (let error) {
            print("Remove File Error: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Este método remove todos os arquivos de imagens do disco.
    @discardableResult public class func removeAllFilesFromDisk(subFolderName: String? = nil, cacheDirectory: Bool = false) -> Bool {
        var path: URL? = nil

        if cacheDirectory {
            path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        } else {
            path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        
        guard var filePath = path else {
            return false
        }
        
        filePath = filePath.appendingPathComponent("Images")
        if let folder = subFolderName {
            filePath = filePath.appendingPathComponent(folder)
        }
        
        do {
            try FileManager.default.removeItem(atPath: URL(fileURLWithPath: filePath.path).path)
            return true
        } catch (let error) {
            print("Remove File Error: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Este método remove todos os arquivos previamente salvos no disco.
    @discardableResult public class func removeAllOldFilesFromDisk(subFolderName: String? = nil, cacheFolder: Bool = false, keepFilesQuantity: Int) -> Bool {
        var path: URL? = nil

        if cacheFolder {
            path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        } else {
            path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
        
        guard var filePath = path else {
            return false
        }
        
        filePath = filePath.appendingPathComponent("Images")
        if let folder = subFolderName {
            filePath = filePath.appendingPathComponent(folder)
        }
        
        if let content = try? FileManager.default.contentsOfDirectory(atPath: filePath.path) {
            var fileList: [BasicFileElement] = [BasicFileElement]()
            //Buscando os dados dos arquivos salvos (nome e data criação):
            content.forEach { file in
                do {
                    let attrs = try FileManager.default.attributesOfItem(atPath: URL(fileURLWithPath: filePath.path).appendingPathComponent(file).path)
                    if let date = attrs[FileAttributeKey.creationDate] as? Date {
                        fileList.append(BasicFileElement(name: file, creationDate: date))
                    }
                } catch (let error) {
                    print("Get Attributes File Error: \(error.localizedDescription)")
                }
            }
            //Ordenando e ficando apenas com os 2 mais novos:
            fileList.sort(by: { $0.creationDate > $1.creationDate })
            var deleteList = [BasicFileElement]()
            for i in 0 ..< fileList.count {
                if i > (keepFilesQuantity - 1) {
                    deleteList.append(fileList[i])
                }
            }
            //
            deleteList.forEach { element in
                do {
                    try FileManager.default.removeItem(atPath: URL(fileURLWithPath: filePath.path).appendingPathComponent(element.name).path)
                } catch (let error) {
                    print("Remove File Error: \(error.localizedDescription)")
                }
            }
            //
            return true
        }
        
        return false
    }
}

//
//  FileServices.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 16/08/25.
//

import UIKit

public final class FileServices {
    
    public enum FileServicesError: Error {
        case nonExistentFile
        case loadFileError(reason: String)
        
        var description: String {
            switch self {
            case .loadFileError(let reason):
                return "Erro ao ler arquivo: \(reason)"
            case .nonExistentFile:
                return "O arquivo solicitado não existe ou não está disponível no momento."
            }
        }
    }
    
    public static func loadContent(from fileName: String) -> Result<Data,FileServicesError> {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return Result.failure(FileServicesError.nonExistentFile)
        }
        //
        do {
            let data = try Data(contentsOf: fileURL)
            return Result.success(data)
        } catch (let error) {
            return Result.failure(FileServicesError.loadFileError(reason: error.localizedDescription))
        }
    }
}

//
//  DownloadTask.swift
//  PCMarketplace
//
//  Created by Érico GT on 19/05/20.
//  Copyright © 2020 GO-K. All rights reserved.
//

import Foundation

protocol DownloadTask {

   var completionHandler: ResultType<Data>.Completion? { get set }
   var progressHandler: ((Double) -> Void)? { get set }

   func resume()
   func suspend()
   func cancel()
}

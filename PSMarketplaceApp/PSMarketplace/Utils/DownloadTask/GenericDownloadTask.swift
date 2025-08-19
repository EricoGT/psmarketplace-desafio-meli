//
//  GenericDownloadTask.swift
//  PCMarketplace
//
//  Created by Érico GT on 19/05/20.
//  Copyright © 2020 GO-K. All rights reserved.
//

import Foundation

class GenericDownloadTask {

   var completionHandler: ResultType<Data>.Completion?
   var progressHandler: ((Double) -> Void)?

   private(set) var task: URLSessionDataTask
   var expectedContentLength: Int64 = 0
   var buffer = Data()

   init(task: URLSessionDataTask) {
      self.task = task
   }

   //deinit {
   //   print("Deinit: \(task.originalRequest?.url?.absoluteString ?? "")")
   //}

}

extension GenericDownloadTask: DownloadTask {

   func resume() {
      task.resume()
   }

   func suspend() {
      task.suspend()
   }

   func cancel() {
      task.cancel()
   }
}

//
//  ResultType.swift
//  PCMarketplace
//
//  Created by Érico GT on 19/05/20.
//  Copyright © 2020 GO-K. All rights reserved.
//

import Foundation

public enum ResultType<T> {

   public typealias Completion = (ResultType<T>) -> Void

   case success(T)
   case failure(Swift.Error)

}

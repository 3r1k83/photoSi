//
//  NetworkError.swift
//  PhotoSì
//
//  Created by Erik Peruzzi on 28/07/22
//

import Foundation
import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

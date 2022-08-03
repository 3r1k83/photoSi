//
//  Service.swift
//  PhotoSì
//
//  Created by Erik Peruzzi on 28/07/22
//

import Foundation
import Combine
import Alamofire
import UIKit

protocol ServiceProtocol {
    func fetchCountries() -> AnyPublisher<DataResponse<[CountryModel], NetworkError>, Never>
}

class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
    @Published var downloadProgress: Double = 0.0
}

extension Service: ServiceProtocol {
    
    func fetchCountries() -> AnyPublisher<DataResponse<[CountryModel], NetworkError>, Never> {
        let url = URL(string: "https://api.photoforse.online/geographics/countries/")!
        let headers: HTTPHeaders = ["x-api-key": "AIzaSyCccmdkjGe_9Yt-INL2rCJTNgoS4CXsRDc"]
        
        return AF.request(url,
                          method: .get,
                          headers: headers )
        .validate()
        .publishDecodable(type: [CountryModel].self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}

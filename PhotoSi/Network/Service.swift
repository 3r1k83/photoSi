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
    func uploadImage(imageData: Data) -> AnyPublisher<DataResponse<ImageUploadResponseModel ,NetworkError>, Never>

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
    
    func uploadImage(imageData: Data) -> AnyPublisher<DataResponse<ImageUploadResponseModel ,NetworkError>, Never> {
        //Set Your URL
        let api_url = "https://catbox.moe/user/api.php"
        let url = URL(string: api_url)
        let boundary = UUID().uuidString

        
        var urlRequest = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.timeoutInterval = 60
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        //Set Image Data
//        let imgData = image.jpegData(compressionQuality: 0.5)!
        
        //Set Your Parameter
        let parameterDict = NSMutableDictionary()
        parameterDict.setValue("fileupload", forKey: "reqtype")
        parameterDict.setValue("caa3dce4fcb36cfdf9258ad9c", forKey: "userhash")
//        parameterDict.setValue(imageData, forKey: "fileToUpload")
        
        
        let fieldName = "reqtype"
        let fieldValue = "fileupload"

        let fieldName2 = "userhash"
        let fieldValue2 = "####"
        var data = Data()


        let filename = "avatar.png"

        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)

        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; \(imageData)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)

        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Now Execute
//        return AF.upload(multipartFormData: { multiPart in
//            for (key, value) in parameterDict {
//                if let temp = value as? String {
//                    multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
//                }
//                if let temp = value as? Int {
//                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
//                }
//                if let temp = value as? NSArray {
//                    temp.forEach({ element in
//                        let keyObj = key as! String + "[]"
//                        if let string = element as? String {
//                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
//                        } else
//                        if let num = element as? Int {
//                            let value = "\(num)"
//                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
//                        }
//                    })
//                }
//            }
//            multiPart.append(imageData, withName: "img", fileName: "img.png", mimeType: "image/png")
//        },
        return AF.upload(data , with: urlRequest)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            DispatchQueue.main.async {
                self.downloadProgress = progress.fractionCompleted
                                }
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .publishDecodable(type: ImageUploadResponseModel.self)
        .map { response in
            response.mapError() { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
//        .responseJSON(completionHandler: { data in
//
//            switch data.result {
//
//            case .success(_):
//                do {
//
//                    let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
//
//                    print("Success!")
//                    print(dictionary)
//                }
//                catch {
//                    // catch error.
//                    print("catch error")
//
//                }
//                break
//
//            case .failure(_):
//                print("failure")
//
//                break
//
//            }


//        })
//
    }
}

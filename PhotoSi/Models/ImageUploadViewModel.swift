//
//  ImageUploadViewModel.swift
//  PhotoSi
//
//  Created by Erik Peruzzi on 01/08/22.
//

import Foundation
import SwiftUI
import Alamofire
import Combine

class ImageUploadViewModel: ObservableObject {
    
    @Published var url =  String()
    @Published var imagesUploadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var uploading: Bool = false
    @Published var uploadingProgress: Double = 0.0
    
    var dataManager: ServiceProtocol
    
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
    }

    func createAlert( with error: String ) {
        imagesUploadingError = error
        self.showAlert = true
    }
    
    func uploadImage(imageData: Data) {
        self.uploading = true
        
        //Set Your Parameter
        let parameterDict = NSMutableDictionary()
        parameterDict.setValue("fileupload", forKey: "reqtype")

        AF.upload(
            multipartFormData: { multiPart in
                for (key, value) in parameterDict {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multiPart.append(imageData, withName: "fileToUpload" , fileName: "image.jpeg", mimeType: "image/jpeg")
            },
            to: "https://catbox.moe/user/api.php", method: .post , headers: nil)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
                self.uploadingProgress = progress.fractionCompleted
            
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseString { response in
            self.uploading = false
            switch response.result {
            case .success(let value):
                print("value**: \(value)")
                if value.starts(with: "https"){
                    self.url = value
                }
                else {  // In this case the response is not a proper url - the api respond success even when there are errors
                    self.createAlert(with: value)
                }
                
            case .failure(let error):
                self.createAlert(with: error.localizedDescription)
                print(error)
            }
            print(response.result)
            
        }
    }
    
    func stopUpload(){
        AF.session.getAllTasks { (tasks) in
            tasks.forEach {$0.cancel() }
            self.uploadingProgress = 0.0
        }
    }
}


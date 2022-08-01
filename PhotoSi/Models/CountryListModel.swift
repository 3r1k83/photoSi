//
//  ChatListModel.swift
//  PhotoSì
//
//  Created by Erik Peruzzi on 28/07/22
//

import Foundation
struct CountryListModel: Codable {
    var chats: [CountryModel]
}

struct CountryModel: Codable {
    var iso: Int
    var isoAlpha2: String
    var isoAlpha3: String
    var name: String
    var phonePrefix: String
}

struct ImageUploadResponseModel: Codable {
   
    var name: String
    var uploadPercentage: Double
}

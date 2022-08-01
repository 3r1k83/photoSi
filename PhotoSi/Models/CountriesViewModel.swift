//
//  ViewModel.swift
//  PhotoSì
//
//  Created by Erik Peruzzi on 28/07/22
//

import Foundation
import Combine

class CountriesViewModel: ObservableObject {
    
    @Published var countries =  [CountryModel]()
    @Published var countryListLoadingError: String = ""
    @Published var showAlert: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
        getCountryList()
    }
    
    func getCountryList() {
        dataManager.fetchCountries()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.countries = dataResponse.value!
                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError) {
        countryListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}

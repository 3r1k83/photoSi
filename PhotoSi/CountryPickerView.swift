//
//  CountryPickerView.swift
//  PhotoSì
//
//  Created by Erik Peruzzi on 30/07/22.
//

import SwiftUI

struct CountryPickerView: View {
    
    @ObservedObject var viewModel = CountriesViewModel()
    @State private var searchText = ""
    
    
    var searchResults: [CountryModel] {
        if searchText.isEmpty {
            return viewModel.countries
        } else {
            return viewModel.countries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
    }
    
    var body: some View {
        
        CustomNavBar(title: "Pick your country", content: {
                List {
                    ForEach(searchResults, id: \.iso) { country in
                        NavigationLink(destination: ImagePickerView()) {
                            Text(country.name)
                        }
                    }
                }
                .searchable(text: $searchText)
//                .navigationTitle("Pick a Country")
        }()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text (viewModel.countryListLoadingError ), dismissButton: .default(Text("OK")))
        }
        )
    }
}

struct CountryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerView()
    }
}

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
        
        NavigationView{
            VStack{
                Text("Pick your country")
                List {
                    ForEach(searchResults, id: \.iso) { country in
                        NavigationLink(destination: ImagePickerView()) {
                            Text(country.name)
                        }
                    }
                }
                .onAppear() {
                    UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
                }
                .accessibilityIdentifier("countriesList")
                    .searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Image("LogoPhotoSì")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                            Text("Pick your country")
                        }
                    }}
        }.navigationViewStyle(.stack)

        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text (viewModel.countryListLoadingError ), dismissButton: .default(Text("OK")))
        }
    }
}

struct CountryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerView()
    }
}

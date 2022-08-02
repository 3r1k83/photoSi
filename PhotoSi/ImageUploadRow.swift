//
//  ImageUploadRow.swift
//  PhotoSi
//
//  Created by Erik Peruzzi on 31/07/22.
//

import SwiftUI

struct ImageUploadRow: View {
    var image:UIImage
    var uploadBar:String
    
    @ObservedObject var viewModel = ImageUploadViewModel()
    
    var body: some View {
        VStack{
            HStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .cornerRadius(10)
                if (viewModel.uploading){
                    Button(action: {
                        viewModel.stopUpload()
                    }){
                        Text("Stop")
                            .font(.headline)
                            .frame(minWidth: 0, maxWidth: 200, minHeight: 50, maxHeight: 50)
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                    }.accessibilityIdentifier("uploadButton")
                }
                else{
                    Button(action: {
                        let imgData = image.jpegData(compressionQuality: 1)!
                        viewModel.uploadImage(imageData:imgData)
                    }){
                        
                        Text("Upload")
                            .font(.headline)
                            .frame(minWidth: 0, maxWidth: 200, minHeight: 50, maxHeight: 50)
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                    }
                    
                }
            }
            .padding(10)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text (viewModel.imagesUploadingError), dismissButton: .default(Text("OK")))
            }
            if (viewModel.uploading){
                ProgressView("Uploading image...", value: $viewModel.uploadingProgress.wrappedValue, total: 1.00)
                    .padding()
            }
            else if (viewModel.url.count > 0){
                Text("Long press to copy the url to your clipboard").padding(5)
                
                Text("url: " + viewModel.url)
                    .frame(alignment: .trailing)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = viewModel.url
                        }) {
                            Text("Copy to clipboard")
                            Image(systemName: "doc.on.doc")
                        }
                    }
            }
        }.frame(minHeight: 130)
    }
}


struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

struct ImageUploadRow_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadRow(image: UIImage(named: "LogoPhotoSì")!, uploadBar: "test")
    }
}



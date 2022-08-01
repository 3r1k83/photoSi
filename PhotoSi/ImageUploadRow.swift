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
                Button(action: {
                    let imgData = image.jpegData(compressionQuality: 0.5)!
                    viewModel.uploadImage(image: imgData)
                }){
                    
                    Text("Upload")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .padding(.horizontal)
                }
            }.padding()
            ProgressView("Uploading image...", value: $viewModel.uploadingProgress.wrappedValue, total: 100.00).padding()
            HStack{
                Text("url:" + viewModel.url)
              

//                LoaderView(tintColor: .red, scaleSize: 1.0).padding(.bottom,50).hidden(!$viewModel.uploading.wrappedValue)
            }
        }.frame(height: 160)
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



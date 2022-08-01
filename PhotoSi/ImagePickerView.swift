//
//  ImagePickerView.swift
//  PhotoSi
//
//  Created by Erik Peruzzi on 30/07/22.
//

import SwiftUI

struct ImagePickerView: View {
    @State private var photoPickerIsPresented = false
    @State var showActionSheet = false
    @State var showImagePicker = false
    
    @State var sourceType:UIImagePickerController.SourceType = .camera
    
    @State var pickerResult: [UIImage] = []
    @State var imageToUpload: UIImage?

    
    var body: some View {
        NavigationView {
            VStack{
                        List {
                            ForEach(0..<pickerResult.count, id:\.self) { imageIdx in
                                ImageUploadRow(image: pickerResult[imageIdx], uploadBar: "")
//                                Image(uiImage: pickerResult[imageIdx])
                            }.onDelete(perform: delete)
                            if imageToUpload != nil {
                                ImageUploadRow(image: imageToUpload!, uploadBar: "")
                            }
                        }

                        .actionSheet(isPresented: $showActionSheet){
                            ActionSheet(title: Text("Add a picture to your post"), message: nil, buttons: [
                                //Button1
                                
                                .default(Text("Camera"), action: {
                                    self.showImagePicker = true
                                    self.sourceType = .camera
                                }),
                                //Button2
                                .default(Text("Photo Library"), action: {
                                    self.showImagePicker = true
                                    self.sourceType = .photoLibrary
                                }),
                                
                                //Button3
                                .cancel()
                                
                            ])
                        }.sheet(isPresented: $showImagePicker){
                            if self.sourceType == .camera{
                                CameraPicker(image: self.$imageToUpload, showImagePicker: self.$showImagePicker)
                            }
                            else{
                                PhotoPicker(images: $pickerResult, selectionLimit: 50)
                            }
                        }
               
              
                Button(action: {
                    showActionSheet = true
                }){
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                        
                        Text("Choose pictures to upload")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
            }
        }
    }

    func delete(at offsets: IndexSet) {
        self.pickerResult.remove(atOffsets: offsets)
       }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
    }
}

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
    @State var imageToUpload: UIImage = UIImage()
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(0..<pickerResult.count, id:\.self) { imageIdx in
                        ImageUploadRow(image: pickerResult[imageIdx], uploadBar: "")
                    }.onDelete(perform: delete)

                }.padding(.top, -100)
                    .onAppear() {
                        UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 40)
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
                    .frame(minWidth: 0, maxWidth: 350, minHeight: 0, maxHeight: 50)
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }.accessibilityIdentifier("showActionSheet")
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
                }
                
                .sheet(isPresented: $showImagePicker){
                    if self.sourceType == .camera{
                        CameraPicker(image: self.$imageToUpload, showImagePicker: self.$showImagePicker, images:$pickerResult)
                    }
                    else{
                        PhotoPicker(images: $pickerResult, selectionLimit: 50)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("LogoPhotoSì")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .padding(.top, -100)
//                        .padding(.bottom, -100)
                    
                    
                }
            }
        }
        .navigationViewStyle(.stack)
        
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

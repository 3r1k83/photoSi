//
//  CameraPicker.swift
//  PhotoSi
//
//  Created by Erik Peruzzi on 01/08/22.
//

import Foundation
import SwiftUI


struct CameraPicker:UIViewControllerRepresentable {
    @Binding var image: UIImage
    @Binding var showImagePicker: Bool
    @Binding var images: [UIImage]

    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = CameraPickerCoordinator
        

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> CameraPicker.Coordinator {
        return CameraPickerCoordinator(image: $image, showImagePicker: $showImagePicker, parent:self)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraPicker>) {}
    
    
}



class CameraPickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage
        @Binding var showImagePicker: Bool
    
    var parent: CameraPicker
        
    init(image:Binding<UIImage>, showImagePicker: Binding<Bool>, parent:CameraPicker ) {
        _image = image
        _showImagePicker = showImagePicker
        self.parent = parent

    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiimage
            showImagePicker = false
            self.parent.images.append(uiimage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        showImagePicker = false
    }


}

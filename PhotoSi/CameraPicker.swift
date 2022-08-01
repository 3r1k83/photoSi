//
//  CameraPicker.swift
//  PhotoSi
//
//  Created by Erik Peruzzi on 01/08/22.
//

import Foundation
import SwiftUI


struct CameraPicker:UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = CameraPickerCoordinator
        

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> CameraPicker.Coordinator {
        return CameraPickerCoordinator(image: $image, showImagePicker: $showImagePicker)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraPicker>) {}
    
    
}



class CameraPickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        @Binding var showImagePicker: Bool
    
    init(image:Binding<UIImage?>, showImagePicker: Binding<Bool>) {
            _image = image
            _showImagePicker = showImagePicker
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiimage
            showImagePicker = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        showImagePicker = false
    }


}

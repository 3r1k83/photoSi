//
//  CustomNavBar.swift
//  PhotoSi
//
//  Created by Erik Peruzzi on 01/08/22.
//

import SwiftUI

struct CustomNavBar<Content>: View where Content: View {
    
    let title: String
    let content: Content
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("LogoPhotoSì")
                        .resizable()
                        .frame(height: 105)
                        .edgesIgnoringSafeArea(.all)
                    Spacer()
                }
                content
            }
            .navigationBarTitle(title, displayMode: .inline)
        }
    }
}

//
//  SettingsView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/24/22.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var profileData: ProfileData
    @State private var showActionSheet = false
    @State private var isShowPhotoLibrary = false
    @State private var isShowCamera = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Profile")
                    .bold()
                Spacer()
                Button {self.presentationMode.wrappedValue.dismiss()} label: {
                    Image("CloseIcon")
                        .foregroundColor(Color("Text"))
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            .padding()
            Button(action: {isShowPhotoLibrary.toggle()}) {
                ProfileView(profile: $profileData.profile, size: 100)
            }
            .padding(.bottom)
            
            Spacer()
            Button(action: {
                do {
                    try Auth.auth().signOut()
                } catch{
                    print("Error while signing out!")
                }
            }) {
                Text("Sign Out")
                    .bold()
                    .frame(width: 360, height: 50)
                    .background(.thinMaterial)
                    .foregroundColor(Color.red)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Profile")
        .padding()
        .sheet(isPresented: $isShowPhotoLibrary) {
            ProfilePicker(profileData: self.profileData)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

// from https://github.com/appcoda/ImagePickerSwiftUI
struct ProfilePicker: UIViewControllerRepresentable {
 
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
 
    @ObservedObject var profileData: ProfileData
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ProfilePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
 
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ProfilePicker>) {
 
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ProfilePicker
        
        init(_ parent: ProfilePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.profileData.profile.imageData = image.jpegData(compressionQuality: 0.1)
                parent.profileData.updateProfile(imageData: parent.profileData.profile.imageData!)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(profileData: ProfileData())
    }
}

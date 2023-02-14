//
//  Profile.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 12/20/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Shimmer

struct Profile: Identifiable, Equatable, Hashable, Codable {
    var id: UUID = UUID()
    var imageURL: String = ""
    var imageData: Data? = nil
}

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class ProfileData: ObservableObject {
    @Published var profile = Profile()
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    func fetchProfile(id: String) {
        if (Auth.auth().currentUser?.uid != nil) {
            db.collection("profiles").document(id).getDocument { (document, error) in
                guard document != nil else {
                    return
                }
                
                self.profile = document.map { (d) -> Profile in
                    let data = d.data()
                    let imageURL = data?["imageURL"] as? String
                    if imageURL != nil {
                        return Profile(imageURL: imageURL!)
                    } else {
                        return Profile()
                    }
                }!
            }
        } else {
            print("User not signed in.")
        }
    }
    
    func updateProfile(imageData: Data) {
        if (Auth.auth().currentUser?.uid != nil) {
            self.uploadProfile(image: imageData) { (url) in
                if url != nil {
                    self.db.collection("profiles").document(Auth.auth().currentUser!.uid).updateData([
                        "imageURL": url!
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        }
                    }
                }
            }
        }
    }
    
    private func uploadProfile(image: Data?, completion: @escaping((String?) -> ())) {
        if (Auth.auth().currentUser?.uid != nil) {
            let storageRef = self.storage.reference()
            
            // Create a reference to the file you want to upload
            let profileRef = storageRef.child("profiles/\(Auth.auth().currentUser!.uid).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            profileRef.putData(image!, metadata: metadata) { metadata, error in
                guard error == nil else {
                    // Uh-oh, an error occurred!
                    print("Error adding image: \(error!)")
                    return
                }
                
                profileRef.downloadURL { (url, error) in
                    guard url != nil else {
                        print("Error: no download url.")
                        completion(nil)
                        return
                    }
                    completion(url?.absoluteString)
                }
            }
        }
    }
}

struct ProfileView: View {
    @Binding var profile: Profile
    var size: CGFloat
    
    var body: some View {
        ZStack {
            if (profile.imageData != nil) {
                ImageHelper().getSafeImage(data: profile.imageData)
                    .resizable()
            } else {
                WebImage(url: URL(string: profile.imageURL))
                    .resizable()
                    .placeholder {
                        Circle()
                            .frame(width: size, height: size)
                            .foregroundColor(Color.gray)
                            .shimmering()
                    }
            }
        }
        .scaledToFill()
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

//
//  UploadMethods.swift
//  Social-Reality
//
//  Created by Nick Crews on 3/8/21.
//

import Foundation
import UIKit
import AVKit
import Firebase
import FirebaseStorage

struct UploadMethods {
    
    private let storageRef = Storage.storage().reference()
    
    func image(key: String, image: UIImage, completion: @escaping (String?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.6) else { completion(nil); return }
        let ref = storageRef.child(StorageChildren.images.rawValue).child(key)
        ref.putData(data, metadata: nil) { metadata, error in
            guard error == nil else { completion(nil); return }
            ref.downloadURL { (url, error) in
                completion(url?.absoluteString)
            }
        }
    }
    
    func thumbnailImage(key: String, image: UIImage, completion: @escaping (String?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.6) else { completion(nil); return }
        let ref = storageRef.child(StorageChildren.images.rawValue).child(StorageChildren.thumbnails.rawValue).child(key)
        ref.putData(data, metadata: nil) { metadata, error in
            guard error == nil else { completion(nil); return }
            ref.downloadURL { (url, error) in
                completion(url?.absoluteString)
            }
        }
    }
    
    func video(key: String, video: Data, completion: @escaping (String?) -> Void) {
        let ref = storageRef.child("videos").child(StorageChildren.videos.rawValue).child(key)
        ref.putData(video, metadata: nil) { (metadata, error) in
            guard error == nil else { completion(nil); return }
            ref.downloadURL { (url, error) in
                completion(url?.absoluteString)
            }
        }
    }
    
}

//
//  StorageManager.swift
//  Sound Seeker
//
//  Created by Hung Vu on 09/08/2023.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadAudioCompletion = (Result<String, Error>) -> Void
    
    /// Tải lên tệp âm thanh lên Firebase Storage, trả về kết quả với chuỗi URL để tải xuống
    public func uploadAudio(with fileUrl: URL, fileName: String, completion: @escaping UploadAudioCompletion) {
        let fileRef = storage.child("audios/\(fileName)")
        
        fileRef.putFile(from: fileUrl, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload audio file to Firebase: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            self.getDownloadURL(for: fileRef) { result in
                switch result {
                case .success(let urlString):
                    completion(.success(urlString))
                case .failure(let error):
                    print("Failed to get download URL for audio: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func getDownloadURL(for fileRef: StorageReference, completion: @escaping (Result<String, Error>) -> Void) {
        fileRef.downloadURL { url, error in
            if let downloadURL = url {
                let urlString = downloadURL.absoluteString
                completion(.success(urlString))
            } else if let error = error {
                completion(.failure(error))
            } else {
                let unknownError = NSError(domain: "StorageManager", code: -1, userInfo: nil)
                completion(.failure(unknownError))
            }
        }
    }
}

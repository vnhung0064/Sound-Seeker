import Foundation

func recognizeSongWithAudio(audioData: Data, apiKey: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    let apiUrl = "https://api.audd.io"
    
    var request = URLRequest(url: URL(string: apiUrl)!)
    request.httpMethod = "POST"
    
    let boundary = UUID().uuidString
    
    let contentType = "multipart/form-data; boundary=\(boundary)"
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    
    var bodyData = Data()
    
    // API Token Parameter
    bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
    bodyData.append("Content-Disposition: form-data; name=\"api_token\"\r\n\r\n".data(using: .utf8)!)
    bodyData.append("\(apiKey)\r\n".data(using: .utf8)!)
    
    // Audio File Parameter
    bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
    bodyData.append("Content-Disposition: form-data; name=\"file\"; filename=\"recording.m4a\"\r\n".data(using: .utf8)!)
    bodyData.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
    bodyData.append(audioData)
    bodyData.append("\r\n".data(using: .utf8)!)
    
    bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = bodyData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            completion(.failure(error ?? NSError(domain: "API Error", code: 0, userInfo: nil)))
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(.success(json))
            } else {
                throw NSError(domain: "JSON Parsing Error", code: 0, userInfo: nil)
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}

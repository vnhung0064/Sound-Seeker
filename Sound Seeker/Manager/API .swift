
import Foundation

func recognizeSongWithAudio(audioData: Data, apiKey: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    let apiUrl = "https://api.audd.io/"
    
    let parameters: [String: Any] = [
        "api_token": "a2c191a5a21f6513d7b9d12b5112ef24",
        "method": "recognize",
        // Add other parameters if needed
    ]
    
    var request = URLRequest(url: URL(string: apiUrl)!)
    request.httpMethod = "POST"
    
    let boundary = "Boundary-\(UUID().uuidString)"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var data = Data()
    
    for (key, value) in parameters {
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    data.append("--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"file\"; filename=\"recording.wav\"\r\n".data(using: .utf8)!)
    data.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
    data.append(audioData)
    data.append("\r\n".data(using: .utf8)!)
    data.append("--\(boundary)--".data(using: .utf8)!)
    
    request.httpBody = data
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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

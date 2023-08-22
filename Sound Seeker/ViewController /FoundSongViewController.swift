//
//  FoundSongViewController.swift
//  Sound Seeker
//
//  Created by Hung Vu on 14/08/2023.
//

import UIKit

class FoundSongViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gọi hàm để thực hiện yêu cầu và xử lý dữ liệu từ AudD
        fetchSongInfo()
    }
    
    func fetchSongInfo() {
        // URL của yêu cầu GET để lấy thông tin bài hát đã nghe
        guard let url = URL(string: "https://api.audd.io") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Kiểm tra lỗi và dữ liệu trả về
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            
            // Xử lý dữ liệu JSON
            do {
                // Parse dữ liệu từ JSON
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Truy cập các trường trong JSON để lấy link âm nhạc đã nghe
                    if let songLink = json["your_song_link_key"] as? String {
                        print("Link âm nhạc đã nghe: \(songLink)")
                        
                        // Update giao diện UI nếu cần
                        DispatchQueue.main.async {
                            // Example: Cập nhật một label hoặc hiển thị thông tin bài hát trên UI
                        }
                    } else {
                        print("Không tìm thấy link âm nhạc.")
                    }
                }
            } catch {
                print("Lỗi khi xử lý dữ liệu JSON: \(error.localizedDescription)")
            }
        }
        
        // Bắt đầu yêu cầu
        task.resume()
    }
}

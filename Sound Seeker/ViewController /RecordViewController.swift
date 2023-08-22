import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var Animation: UIImageView!
    
    var audioRecorder: AVAudioRecorder?
    var audioFilename: URL?
    var recordingTimer: Timer?
    var recordingDuration: TimeInterval = 10.0 // Đặt thời gian ghi âm là 10 giây
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioRecorder()
        
        Animation.isHidden = true

    }
        
    @IBAction func RecordTapped(_ sender: UIButton) {
 
        if audioRecorder == nil || !(audioRecorder!.isRecording) {
                startRecording()
                startRecordingTimer()
                Animation.isHidden = false
                label1.isHidden = true
            } else {
                Animation.isHidden = true
                label1.isHidden = false
                
            }
    }
    func setupAudioRecorder() {
        // Tạo đường dẫn để lưu file ghi âm
        if let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            audioFilename = documentPath.appendingPathComponent("recording.wav")
            print("Recording file path: \(audioFilename?.path ?? "N/A")")
        }
        
        // Cấu hình audio recorder
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
        }
        catch {
            print("Audio recorder setup failed: \(error.localizedDescription)")
        }
        
    }

    
    func startRecording() {
        if let recorder = audioRecorder, !recorder.isRecording {
            do {
                try recorder.record()
                print("Recording started.")
            } catch {
                print("Error starting recording: \(error.localizedDescription)")
            }
        }
    }


    
    func stopRecording() {
        if let recorder = audioRecorder, recorder.isRecording {
               recorder.stop()
               print("Recording stopped.")

               // Call the recognition function after stopping the recording
               recognizeSongFromRecording()
           }    }
    
    func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: recordingDuration, repeats: false) { [weak self] _ in
            self?.stopRecording()
            self?.stopRecordingTimer() // Dừng luôn đồng hồ đếm thời gian
        }
    }

    func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if flag {
                print("Recording finished.")
                // Gọi hàm nhận diện bài hát sau khi hoàn tất ghi âm
                recognizeSongFromRecording()
                
            } else {
                print("Recording failed.")
            }
        }
        
    func recognizeSongFromRecording() {
        // Gửi yêu cầu nhận diện bài hát với tệp ghi âm đã lưu
        if let recordingURL = audioFilename {
            let apiKey = "a2c191a5a21f6513d7b9d12b5112ef24" // Thay bằng api token của bạn
            
            do {
                let audioData = try Data(contentsOf: recordingURL)
                
                StorageManager.shared.uploadAudio(with: recordingURL, fileName: "recording.wav") { result in
                    switch result {
                    case .success(let urlString):
                        print("Audio uploaded successfully. URL: \(urlString)")
                        
                        // Tiến hành gọi hàm nhận diện bài hát sau khi tải lên thành công
                        recognizeSongWithAudio(audioData: audioData, apiKey: apiKey) { result in
                            switch result {
                            case .success(let songInfo):
                                print("Song recognized: \(songInfo)")
                                // Xử lý thông tin bài hát đã nhận diện
                            case .failure(let error):
                                print("Song recognition failed: \(error)")
                                // Xử lý lỗi khi nhận diện bài hát
                            }
                        }
                    case .failure(let error):
                        print("Failed to upload audio: \(error)")
                    }
                }
                
            } catch {
                print("Error reading audio data: \(error)")
            }
        }
    }


}

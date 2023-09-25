import UIKit
import AVFoundation
import GoogleMobileAds



class RecordViewController: UIViewController, AVAudioRecorderDelegate, GADBannerViewDelegate, GADFullScreenContentDelegate {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var Animation: UIImageView!
    
    @IBOutlet weak var Playback: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var audioFilename: URL!
    
    var recording = false

    var songLink: URL?
    
    var bannerView: GADBannerView!
    
    var recordingTimer: Timer?
    var maxRecordingDuration: TimeInterval = 10
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    private var interstitial: GADInterstitialAd?

    @IBOutlet weak var Settingbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
        
        hideLoadingScreen()

        
        
        let adSize = GADAdSizeFromCGSize(CGSize(width: view.frame.width, height: 55))
        bannerView = GADBannerView(adSize: adSize)
        bannerView.delegate = self
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.backgroundColor = UIColor.clear

        bannerView.layer.borderWidth = 2.0
        bannerView.layer.borderColor = UIColor.clear.cgColor
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        overrideUserInterfaceStyle = .dark
    }
    
    @IBAction func settingTapped(_ sender: Any) {
     showAd()
        
    }
    
    
    func loadAd() {
           let request = GADRequest()
           GADInterstitialAd.load(
               withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
               request: request,
               completionHandler: { [self] ad, error in
                   if let error = error {
                       print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                       return
                   }
                   interstitial = ad
                   interstitial?.fullScreenContentDelegate = self
               }
           )
       }
    
    
    
    func showAd() {
           if let interstitial = interstitial {
               let root = UIApplication.shared.keyWindow!.rootViewController
               interstitial.present(fromRootViewController: root!)
           } else {
               // Quảng cáo chưa sẵn sàng, bạn có thể xử lý ở đây hoặc bỏ qua.
               // Ví dụ: Hiển thị màn hình tiếp theo trực tiếp.
               self.presentNextViewController()
           }
       }

        // Được gọi khi quảng cáo đã hoàn thành
        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            print("Ad did dismiss full screen content.")
            loadAd() // Tải quảng cáo mới để chuẩn bị cho lần sau
            showAd() // Hiển thị quảng cáo hoặc chuyển sang màn hình tiếp theo
        }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
            print("Ad did fail to present full screen content.")
            self.presentNextViewController() // Chuyển sang màn hình tiếp theo nếu quảng cáo không thể hiển thị
        }
    func presentNextViewController() {
        let videoPlayerViewController = SettingViewController.makeSelf()
        self.navigationController?.pushViewController(videoPlayerViewController, animated: false) // Không sử dụng animated mặc định
       }
        
    @IBAction func RecordTapped(_ sender: UIButton) {
        
        if recording{
            stopRecording()
            label1.isHidden = false
            

        }
        else {
            startRecording()
            label1.isHidden = true
            recordingTimer = Timer.scheduledTimer(withTimeInterval: maxRecordingDuration, repeats: false) { [weak self] timer in
                           self?.stopRecording()
                       }
            self.showLoadingScreen()

        }
    }
    

    
    func startRecording(){
    
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = documentPath!.appendingPathComponent("recording.m4a")
        audioFilename = fileName
        print("Audio file path: \(fileName.path)")

        
        let settings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            print("record started")
            recording = true
                    
        }catch let error{
            print("Could not start recording: \(error)")
        }

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording finished successfully.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.recognizeSongFromRecording()
                    }
      
    
        } else {
            
            print("Recording failed.")
        }
    }
    
    func stopRecording(){
        audioRecorder?.stop()
        recording = false
        hideLoadingScreen()
        print("record Stoped")
        recordingTimer?.invalidate()
                recordingTimer = nil
    }
    

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio encoding error: \(error)")
        }
    }

    func showLoadingScreen() {
        // Hiển thị màn hình loading (ví dụ: bằng cách đặt isHidden của UIActivityIndicatorView thành false)
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }

    func hideLoadingScreen() {
        // Ẩn màn hình loading (ví dụ: bằng cách đặt isHidden của UIActivityIndicatorView thành true)
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }

            
    func recognizeSongFromRecording() {
        // Gửi yêu cầu nhận diện bài hát với tệp ghi âm đã lưu
        if let recordingURL = audioFilename {
            let apiKey = "ec0a3bb22f42de5da1c3878b0bec6070" // Thay bằng api token của bạn
            
            do {
                let audioData = try Data(contentsOf: recordingURL)
                
                StorageManager.shared.uploadAudio(with: recordingURL, fileName: "recording.m4a") { result in
                    switch result {
                    case .success(let urlString):
                        print("Audio uploaded successfully. URL: \(urlString)")
                        
                        // Tiến hành gọi hàm nhận diện bài hát sau khi tải lên thành công
                        recognizeSongWithAudio(audioData: audioData, apiKey: apiKey) { result in
                            switch result {
                            case .success(let songInfo):
                                print("Song recognized: \(songInfo)")
                                if let songResult = songInfo["result"] as? [String: Any],
                                           let songLinkString = songResult["song_link"] as? String,
                                           let songLink = URL(string: songLinkString) {
                                            self.songLink = songLink
                                    print(songLink)
                                    let recordViewController = WebViewController.makeSelf(songLink: songLink)
                                                                       DispatchQueue.main.async {
                                                                           self.navigationController?.pushViewController(recordViewController, animated: true)
                                                                       }
                                    
                                    // Xử lý thông tin bài hát đã nhận diện
                                } //else{
                                    
                                    //self.showResultsNullAlert()
                                //}
                                
                              
                                
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
    
    func showResultsNullAlert() {
        let alertController = UIAlertController(title: "Notice", message: "No results.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            view.addConstraints(
              [NSLayoutConstraint(item: bannerView,
                                  attribute: .bottom,
                                  relatedBy: .equal,
                                  toItem: view.safeAreaLayoutGuide,
                                  attribute: .bottom,
                                  multiplier: 1,
                                  constant: 0),
               NSLayoutConstraint(item: bannerView,
                                  attribute: .centerX,
                                  relatedBy: .equal,
                                  toItem: view,
                                  attribute: .centerX,
                                  multiplier: 1,
                                  constant: 0)
              ])
           }
        
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }


}


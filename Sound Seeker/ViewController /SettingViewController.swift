//
//  SettingViewController.swift
//  Sound Seeker
//
//  Created by Hung Vu on 09/08/2023.
//

import UIKit
import GoogleMobileAds

class SettingViewController: UIViewController, GADBannerViewDelegate {
    
    let Titles: [String] = ["Feedback", "Rate Us","Share with Friends"]
    
    let dataImage = ["Feedback","Rateus","Share"]
    
    var bannerView: GADBannerView!


    @IBOutlet weak var SettingTableView: UITableView!
    @IBOutlet weak var HeadView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHeadView()
        
        SettingTableView.register(SettingTableViewCell.nib(),forCellReuseIdentifier: SettingTableViewCell.identifier)

        SettingTableView.dataSource = self
        SettingTableView.delegate = self
        SettingTableView.backgroundColor = BGColor.customBackgroundColor
        
        
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
    
    static func makeSelf() -> SettingViewController {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let All_filesViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
          
            
            return All_filesViewController
        }

    func configureHeadView() {
        HeadView?.layer.cornerRadius = 24
        HeadView?.layer.masksToBounds = true
        
        var gradientContainerView: UIView? // Declare the gradientContainerView variable
        
        // Create a gradient container view
        if let headView = HeadView {
            gradientContainerView = UIView(frame: headView.bounds)
            // Continue using gradientContainerView here
        } else {
            // Handle the case when HeadView is nil (if necessary)
        }

        // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        
        if let containerView = gradientContainerView { // Check if gradientContainerView is not nil
            gradientLayer.frame = containerView.bounds
            gradientLayer.colors = [
                UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor,
                UIColor(red: 1, green: 1, blue: 1, alpha: 0.02).cgColor
            ]

            // Use normalized locations to adjust the gradient for all screen sizes
            gradientLayer.locations = [0, 1]

            let startPoint = CGPoint(x: 0.75 * view.bounds.width, y: 0.5)
            let endPoint = CGPoint(x: 0.25 * view.bounds.width, y: 0.5)
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint

            // Position the gradient according to the gradientContainerView's scale
            gradientLayer.position = containerView.center

            // Add the gradient layer to the gradient container view
            containerView.layer.addSublayer(gradientLayer)

            // Add the gradient container view to HeadView
            HeadView?.addSubview(containerView)
        }

        // Set a white border with a width of 2
        HeadView?.layer.borderColor = UIColor.white.cgColor
        HeadView?.layer.borderWidth = 0.7
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
extension SettingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = Titles[indexPath.row]
        cell.imageView?.image = UIImage(named: "\(dataImage[indexPath.row]).png")
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    
    
    
}

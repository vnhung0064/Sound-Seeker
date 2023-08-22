//
//  SettingViewController.swift
//  Sound Seeker
//
//  Created by Hung Vu on 09/08/2023.
//

import UIKit

class SettingViewController: UIViewController {
    
    let Titles: [String] = ["Feedback", "Rate Us","Share with Friends"]
    
    let dataImage = ["Feedback","Rateus","Share"]

    @IBOutlet weak var SettingTableView: UITableView!
    @IBOutlet weak var HeadView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHeadView()
        
        SettingTableView.register(SettingTableViewCell.nib(),forCellReuseIdentifier: SettingTableViewCell.identifier)

        SettingTableView.dataSource = self
        SettingTableView.delegate = self
        SettingTableView.backgroundColor = BGColor.customBackgroundColor
    }
    func configureHeadView() {
        HeadView.layer.cornerRadius = 24
        HeadView.layer.masksToBounds = true
        
        // Tạo gradient container view
        let gradientContainerView = UIView(frame: HeadView.bounds)
        
        // Tạo gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientContainerView.bounds
        gradientLayer.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.02).cgColor
        ]
        
        // Sử dụng normalized locations để điều chỉnh gradient cho mọi màn hình
        gradientLayer.locations = [0, 1]
        
        let startPoint = CGPoint(x: 0.75, y: 0.5)
        let endPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        // Định vị gradient theo tỷ lệ của gradientContainerView
        gradientLayer.position = gradientContainerView.center
        
        // Thêm gradient layer vào gradient container view
        gradientContainerView.layer.addSublayer(gradientLayer)
        
        // Thêm gradient container view vào HeadView
        HeadView.addSubview(gradientContainerView)
        
        
        // Đặt viền màu trắng với độ rộng 2
        HeadView.layer.borderColor = UIColor.white.cgColor
        HeadView.layer.borderWidth = 0.7
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

//
//  MainVC+SetupInfoView.swift
//  BookCore
//
//  Created by Zheng on 4/10/21.
//

import UIKit

enum InfoViewPosition {
    case aboveCenter
    case belowCenter
    case floating
}
extension MainViewController {
    
    func setupInfoView() {
        drawingView.addSubview(infoView)
        infoView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        infoView.frame = CGRect(x: 50, y: 100, width: 150, height: 80)
        infoView.layer.cornerRadius = 12
        infoView.clipsToBounds = true
        infoView.alpha = 0
    }
}

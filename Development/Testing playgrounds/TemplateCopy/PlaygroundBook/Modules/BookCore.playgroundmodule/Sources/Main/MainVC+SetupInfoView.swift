//
//  MainVC+SetupInfoView.swift
//  BookCore
//
//  Created by Zheng on 4/10/21.
//

import UIKit

extension MainViewController {
    
    func setupInfoView() {
        drawingView.addSubview(infoView)
        infoView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        infoView.frame = CGRect(x: 50, y: 100, width: 150, height: 80)
        infoView.layer.cornerRadius = 12
        infoView.clipsToBounds = true
        infoView.alpha = 0
        
        infoBorderView.alpha = 0
        infoBorderView.layer.borderWidth = 8
        infoBorderView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
}

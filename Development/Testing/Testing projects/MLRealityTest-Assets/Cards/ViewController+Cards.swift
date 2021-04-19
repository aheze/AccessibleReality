//
//  ViewController+Cards.swift
//  MLRealityTest
//
//  Created by Zheng on 4/4/21.
//

import SwiftUI

extension ViewController {
    
    func setupCardsView() {
        let hostingController = UIHostingController(rootView: CardsView())
        addChildViewController(hostingController, in: cardsReferenceView)
        hostingController.view.backgroundColor = .red
    }
}

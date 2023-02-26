//
//  WhatsNewObjcWrapper.swift
//  WhatsNewKit
//
//  Created by Alexander Prent on 22.02.2023.
//

import Foundation
import WhatsNewKit

@objc class WhatsNewObjcWrapper: UIViewController {
    @objc static func getWhatsNewViewController() -> UIViewController {
        let whatsNew = WhatsNew(title: "New!",
                                items: [
                                    WhatsNew.Item(
                                        title: "<Your Title>",
                                        subtitle: "Your Description",
                                        image: UIImage(named: "your-image")
                                    ),
                                    WhatsNew.Item(
                                        title: "<Your Title>",
                                        subtitle: "Your Description",
                                        image: UIImage(named: "your-image")
                                    ),
                                    WhatsNew.Item(
                                        title: "<Your Title>",
                                        subtitle: "Your Description",
                                        image: UIImage(named: "your-image")
                                    ),
                                ]
        )
        
        let whatsNewViewController = WhatsNewViewController(whatsNew: whatsNew)
        
        return whatsNewViewController
    }
}


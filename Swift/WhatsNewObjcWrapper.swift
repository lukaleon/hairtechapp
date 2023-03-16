//
//  WhatsNewObjcWrapper.swift
//  WhatsNewKit
//
//  Created by Alexander Prent on 22.02.2023.
//

import Foundation
import WhatsNewKit

@objc class WhatsNewObjcWrapper: UIViewController {
    var name: String?
    @objc static func getWhatsNewViewController() -> UIViewController {
        let whatsNew = WhatsNew(title: "What's New",
                                items: [
                                    WhatsNew.Item(
                                        title: "New Tools",
                                        subtitle: "Clippers, Razor Blade and Dot tools added",
                                        image: UIImage(systemName: "pencil.and.outline")
                                    ),
                                    WhatsNew.Item(
                                        title: "Edit Drawings",
                                        subtitle: "You can now edit lines, texts and other objects.",
                                        image: UIImage(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                                    ),
                                    WhatsNew.Item(
                                        title: "Share Diagrams",
                                        subtitle: "Share your diagrams as a file or open diagrams from other users.",
                                        image: UIImage(systemName: "paperplane")
                                    ),
                                    WhatsNew.Item(
                                        title: "New User Interface",
                                        subtitle: "New redesigned user interface for better experience.",
                                        image: UIImage(systemName: "sparkles")
                                    ),
                                  
                                ])
        
        let whatsNewViewController = WhatsNewViewController(whatsNew: whatsNew, theme: .custom)
                
        return whatsNewViewController
    }
    
}


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
                                        title: "Edit Drawings",
                                        subtitle: "You can now edit lines, texts and other objects.",
                                        image: UIImage(systemName: "pencil.line")
                                    ),
                                    WhatsNew.Item(
                                        title: "Share Diagrams",
                                        subtitle: "Share your diagrams as a file or open other user's diagrams.",
                                        image: UIImage(systemName: "paperplane")
                                    ),
                                    WhatsNew.Item(
                                        title: "iCloud Sync",
                                        subtitle: "Access your collection of diagrams from all you devices.",
                                        image: UIImage(systemName: "icloud")
                                    ),
                                  
                                ])
        
        let whatsNewViewController = WhatsNewViewController(whatsNew: whatsNew, theme: .custom)
                
        return whatsNewViewController
    }
    
}


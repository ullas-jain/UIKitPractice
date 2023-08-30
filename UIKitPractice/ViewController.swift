//
//  ViewController.swift
//  UIKitPractice
//
//  Created by Jain Ullas on 8/30/23.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onButtonClick(_ sender: Any) {
        let cardAttributes = CardAttributes(
            imageURL: URL(string: "https://images.pexels.com/photos/842571/pexels-photo-842571.jpeg"),
            titleText: "A Tasty Pasta salad. This is the title which can span into two lines",
            descriptionText: "This is a description of the card. It can span into two lines",
            isSponsored: true
        )
        let cardHeight = calculateCardHeight(cardWidth: CardViewController.cardWidth, with: cardAttributes)
        let cardViewController = CardViewController(cardAttributes: cardAttributes, cardHeight: cardHeight)
        present(cardViewController, animated: true, completion: nil)
    }
    
    private func calculateCardHeight(cardWidth width: CGFloat, with attributes: CardAttributes) -> CGFloat {
        var height: CGFloat = 0
        
        height += 16 // top padding
        
        if attributes.imageURL != nil {
            let imageHeight = width * (9 / 16) // image's aspect ratio
            height += imageHeight
        }
        
        let textWidthAvailable = width - 2 * 16 // width - padding of left and right
        
        if let title = attributes.titleText {
            height += 16 // padding top of title
            height += calculateDynamicTextHeight(text: title, availableWidth: textWidthAvailable)
        }
            
        if let desc = attributes.descriptionText {
            height += 16 // padding top of description
            height += calculateDynamicTextHeight(text: desc, availableWidth: textWidthAvailable)
        }
        
        height += 16 // bottom padding
        return height
    }
    
    private func calculateDynamicTextHeight(text: String, availableWidth width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(descriptor: bodyFontDescriptor, size: 0))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: scaledFont,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)

        let boundingRect = attributedText.boundingRect(with: maxSize, options: options, context: nil)

        return ceil(boundingRect.height)
    }
}

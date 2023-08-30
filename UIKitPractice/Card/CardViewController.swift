//
//  CardViewController.swift
//  UIKitPractice
//
//  Created by Jain Ullas on 8/30/23.
//

import Foundation
import UIKit

class CardViewController: UIViewController {

    private let cardAttributes: CardAttributes
    private let cardHeight: CGFloat
    public static let cardWidth: CGFloat = 280
    
    init(cardAttributes: CardAttributes, cardHeight: CGFloat) {
        self.cardAttributes = cardAttributes
        self.cardHeight = cardHeight
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .white
        setupCardView(with: cardAttributes, in: view)
    }
    
    func setupCardView(with cardAttributes: CardAttributes, in view: UIView) {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .lightText
        cardView.layer.cornerRadius = 10
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: CardViewController.cardWidth),
            cardView.heightAnchor.constraint(equalToConstant: cardHeight)
        ])

        let imageView = UIImageView()
        
        if let url = cardAttributes.imageURL {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.load(from: url)
            cardView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
                imageView.widthAnchor.constraint(equalToConstant: CardViewController.cardWidth),
                imageView.heightAnchor.constraint(equalToConstant: 300)
            ])
        }

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = cardAttributes.titleText
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.adjustsFontForContentSizeCategory = true
        cardView.addSubview(titleLabel)

        let topConstraint: NSLayoutConstraint = cardAttributes.imageURL != nil ? titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16) : titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            topConstraint,
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])

        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = cardAttributes.descriptionText
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        cardView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])

        if cardAttributes.isSponsored {
            let sponsoredLabel = UILabel()
            sponsoredLabel.translatesAutoresizingMaskIntoConstraints = false
            sponsoredLabel.text = "Sponsored"
            sponsoredLabel.textColor = .white
            sponsoredLabel.backgroundColor = .gray
            sponsoredLabel.textAlignment = .center
            sponsoredLabel.layer.cornerRadius = 6
            sponsoredLabel.clipsToBounds = true
            sponsoredLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
            sponsoredLabel.adjustsFontForContentSizeCategory = true
            cardView.addSubview(sponsoredLabel)

            NSLayoutConstraint.activate([
                sponsoredLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
                sponsoredLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
                sponsoredLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
                sponsoredLabel.widthAnchor.constraint(equalToConstant: 100),
                sponsoredLabel.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
    }

}

// Extension to load image from URL asynchronously
extension UIImageView {
    func load(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

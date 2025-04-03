//
//  ThumbnailGifCell.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/3/25.
//

import UIKit
import SDWebImage

class ThumbnailGifCell: UITableViewCell {

    lazy var gifImageView: SDAnimatedImageView = {
        let imageView = SDAnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayouts()
    }
    
    private func setupLayouts() {
        gifImageView.constrain(to: contentView, edges: [
            .top(0),
            .leading(0),
            .trailing(0),
            .bottom(0)
        ])
    }

    func configure(with gifURL: URL) {
        gifImageView.sd_setImage(with: gifURL)
        gifImageView.contentMode = .scaleAspectFit
    }
}

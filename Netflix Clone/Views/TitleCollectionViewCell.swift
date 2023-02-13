//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by bacho kartsivadze on 08.12.22.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    let posterImigeView: UIImageView = {
        let imigeView = UIImageView()
        imigeView.contentMode = .scaleAspectFill
        return imigeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImigeView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImigeView.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        posterImigeView.sd_setImage(with: url, completed: nil)
    }
    
}

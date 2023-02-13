//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by bacho kartsivadze on 10.12.22.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let identifier = "TitleTableViewCell"
    
    private let posterImige: UIImageView = {
        let imigeView = UIImageView()
        imigeView.contentMode = .scaleAspectFill
        imigeView.clipsToBounds = true
        imigeView.translatesAutoresizingMaskIntoConstraints = false
        return imigeView
    }()
    
    private let posterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let imige = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(imige, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImige)
        contentView.addSubview(posterLabel)
        contentView.addSubview(playTitleButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with model: TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.postURL)") else { return }
        posterImige.sd_setImage(with: url)
        posterLabel.text = model.movieTitle
    }
    
    
    
    private func applyConstraints() {
        
        let posterImigeConstraints = [
            posterImige.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImige.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImige.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImige.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let posterLabelConstraints = [
            posterLabel.leadingAnchor.constraint(equalTo: posterImige.trailingAnchor, constant: 16),
            posterLabel.widthAnchor.constraint(equalToConstant: 200),
            posterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        
        NSLayoutConstraint.activate(posterImigeConstraints)
        NSLayoutConstraint.activate(posterLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
}

//
//  SearchCellNoImage.swift
//  Cornell Sun
//
//  Created by Theodore Carrel on 5/7/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

final class SearchCellNoImage: UICollectionViewCell {
    
    let insetConstant: CGFloat = 18
    let offsetConstant: CGFloat = 12
    let imageViewWidthHeight: CGFloat = 90
    let timeLabelOffset: CGFloat = -8
    
    var post: PostObject? {
        didSet {
            if let post = post {
                authorLabel.text = post.author?.byline
                timeStampLabel.text = post.date.timeAgoSinceNow()
                contentLabel.text = post.content.htmlToString.replacingOccurrences(of: "\n", with: "")
            }
        }
    }
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .photoCaption
        label.textColor = .black
        return label
    }()
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .photoCaption
        label.textColor = .black
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = .photoCaption
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .white
        addSubview(authorLabel)
        addSubview(timeStampLabel)
        addSubview(contentLabel)
        
        authorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(insetConstant)
            make.top.equalToSuperview().inset(offsetConstant)
        }
        
        timeStampLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-insetConstant)
            make.top.equalToSuperview().inset(offsetConstant)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(insetConstant)
            make.top.equalTo(authorLabel.snp.bottom).offset(offsetConstant)
        }
    }
}

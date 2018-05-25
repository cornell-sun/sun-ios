//
//  EmptySearchView.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 5/24/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    var emptyImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    var emptyTitle: UILabel = {
        let l = UILabel()
        l.font = .headerTitle
        l.textAlignment = .center
        return l
    }()

    var emptyDescription: UILabel = {
        let l = UILabel()
        l.font = .cellInformationText
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(image: UIImage, title: String, description: String) {
        self.init(frame: .zero)
        emptyImage.image = image
        emptyTitle.text = title
        emptyDescription.text = description
    }

    func addViews() {
        addSubview(emptyImage)
        addSubview(emptyTitle)
        addSubview(emptyDescription)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        emptyImage.snp.makeConstraints { make in
            make.height.equalTo(77.5)
            make.width.equalTo(160.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(bounds.height * 0.34) //from zeplin. Image starts 34% down from the top
        }

        emptyTitle.snp.makeConstraints { make in
            make.top.equalTo(emptyImage.snp.bottom).offset(26)
            make.width.equalTo(emptyImage)
            make.height.equalTo(emptyTitle.intrinsicContentSize.height)
            make.centerX.equalToSuperview()
        }

        emptyDescription.snp.makeConstraints { make in
            make.top.equalTo(emptyTitle.snp.bottom).offset(7.5)
            make.width.equalTo(emptyImage)
            make.height.equalTo(emptyDescription.intrinsicContentSize.height)
            make.centerX.equalToSuperview()
        }
    }
}
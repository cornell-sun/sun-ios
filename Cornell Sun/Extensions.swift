//
//  Extensions.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/4/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

let categoryCache = NSCache<NSNumber, NSString>()
class CategoryLabel: UILabel {
    var categoryId: Int?

    func loadtitleUsingId(_ category: Int) {
        categoryId = category
        text = nil

        if let categoryFromCache = categoryCache.object(forKey: category as NSNumber) {
            self.text = categoryFromCache as String
            return
        }
        API.request(target: .category(categoryId: category)) { (response) in
            guard let response = response else {return}
            do {
                // swiftlint:disable:next force_cast
                let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: Any]
                if let categoryName = (jsonResult["name"] as? String)?.removingHTMLEntities {
                    DispatchQueue.main.async(execute: {
                        if self.categoryId == category {
                            self.text = categoryName
                            print(categoryName)
                        }
                        categoryCache.setObject(categoryName as NSString, forKey: category as NSNumber)
                    })
                }
            } catch {
                return
            }
        }
    }
}



let imageCache = NSCache<NSString, UIImage>()
class ArticleImageView: UIImageView {
    var imageUrlString: String?

    func loadImageUsingUrlString(_ urlString: String) {
        imageUrlString = urlString
        let url = URL(string: urlString)
        image = nil

        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }

        URLSession.shared.dataTask(with: url!) { data, _, error in
            if error != nil {
                print(error!) //@todo Crashlytics
                return
            }

            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)

                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                })
        }.resume()
    }
}

//
//  Extensions.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/4/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import Kingfisher

let tempLabel = UILabel()

func numberOfLines(text: String, font: UIFont, width: CGFloat) -> Int {
    tempLabel.text = text
    tempLabel.font = font
    let textSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
    let rHeight: Int = lroundf(Float(tempLabel.sizeThatFits(textSize).height))
    let charSize: Int = lroundf(Float(tempLabel.font.pointSize))
    return (rHeight / charSize) - 1
}

func captionMaxHeight(width: CGFloat) -> CGFloat {
     let tmpStr = "A rink attendant collect fish thrown by the Cornell students in a tradition that spans over decades. (Cameron Pollack/ Sun Photography Editor)"
    return tmpStr.height(withConstrainedWidth: width - 36, font: UIFont(name: "Georgia", size: 13)!)
}

func getCurrentViewController() -> UIViewController? {

    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
        var currentController: UIViewController! = rootController
        while currentController.presentedViewController != nil {
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    return nil
}

func taptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.prepare()
    generator.impactOccurred()
}

func cacheImage(imageURL: URL) {
//    var imageResource = ImageResource(downloadURL: imageURL)
//    KingfisherManager.shared.retrieveImage(with: imageResource, options: nil, progressBlock: nil, completionHandler: nil)
    //TODO
}

extension UITextView {

    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar
    }
}

extension String {
    func requiredHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont, lineSpacing: CGFloat = 0.0) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                            context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstraintedHeight height: CGFloat, font: UIFont, lineSpacing: CGFloat = 0.0) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                            context: nil)

        return ceil(boundingBox.width)
    }

    func getWordCount() -> Int {
        let stringComponents = components(separatedBy: .whitespacesAndNewlines)
        return stringComponents.filter { !$0.isEmpty }.count
    }

    /// Converts HTML string to a `NSAttributedString`
    var htmlToAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
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

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
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

extension UIImage {

    func resizeImage(scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }

}

extension UILabel {

    /// Set line spacing between lines on a UILabel
    func setLineSpacing(to value: CGFloat) {
        guard let labelText = text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = value
        paragraphStyle.lineBreakMode = .byTruncatingTail

        var attributedString: NSMutableAttributedString
        if let attrText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: attrText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }

}

//
//  TestCollectionViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/30/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Reuse"

class TestCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // replace this
    var posts = [PostObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .clear
        
        if let colView = collectionView {
            view.addSubview(colView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // replace this
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        cell.contentMode = .scaleAspectFill
        cell.backgroundView = imageView
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
        return 0
    }
}

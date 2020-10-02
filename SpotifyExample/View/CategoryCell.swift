//
//  CategoryCell.swift
//  SpotifyExample
//
//  Created by Daniel Kiesshau on 01/10/20.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    func update(category: Category, index: Int) {
        titleLabel.text = category.title
        subtitleLabel.text = category.subtitle
        collectionView.tag = index
        collectionView.reloadData() 
    }
    
}

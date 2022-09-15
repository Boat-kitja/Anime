//
//  CustomCollectionViewCell.swift
//  ListOfPutang
//
//  Created by Kitja  on 27/8/2565 BE.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//
//  PhotoThumbnail.swift
//  DogFace
//
//  Created by ShanMako on 15/11/4.
//  Copyright © 2015年 sspai. All rights reserved.
//

import UIKit

class PhotoThumbnail: UICollectionViewCell {
    @IBOutlet weak var emojiView: UIImageView!
    func setThumbnailImage(thumbnailImage: UIImage){
        self.emojiView.image = thumbnailImage
    }
    
}


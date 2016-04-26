//
//  OOShopCell.swift
//  swift瀑布流
//
//  Created by kouclo on 16/4/25.
//  Copyright © 2016年 李伟. All rights reserved.
//

import UIKit

class OOShopCell: UICollectionViewCell {
    
    ///图片
    @IBOutlet weak var imageView: UIImageView!
    ///价格
    @IBOutlet weak var priceLable: UILabel!
    
    
    ///设置数据
    var shops:NSDictionary?{
    
        didSet{
        
            self.imageView.sd_setImageWithURL(NSURL(string: (shops!["img"])! as! String), placeholderImage: UIImage(named: "pic"))
            //价格
            self.priceLable.text = shops!["price"] as? String
        
        }
    }
}

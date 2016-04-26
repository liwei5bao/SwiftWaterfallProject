//
//  OOWaterflowLayout.swift
//  swift瀑布流
//
//  Created by kouclo on 16/4/25.
//  Copyright © 2016年 李伟. All rights reserved.
//

import UIKit

class OOWaterflowLayout: UICollectionViewLayout {

    ///代理
    weak var delegate:OOWaterflowLayoutDeledate?
    ///默认的列数
    let OODefaultColumnCount:NSInteger = 2
    /** 每一列之间的间距 */
    let OODefaultColumnMargin:CGFloat = 10
    /** 每一行之间的间距 */
    let OODefaultRowMargin:CGFloat = 10
    /** 边缘间距 */
    let OODefaultEdgeInsets:UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    
    /** 存放所有cell的布局属性 */
    lazy var attrsArray:[UICollectionViewLayoutAttributes] = {return [UICollectionViewLayoutAttributes]()}()
    /** 存放所有列的当前高度 */
    lazy var columnHeights:NSMutableArray = {return NSMutableArray()}()
    var contentHeight:CGFloat?
    
    
    ///行间距
    var rowMargin:CGFloat{
        
        get{
            
            if ((self.delegate?.respondsToSelector("rowMarginInWaterflowLayout:")) == true){
            
                return (self.delegate?.rowMarginInWaterflowLayout!(self))!
            }else{
            
                return OODefaultRowMargin
            }
            
        }
        
    }
    
    ///列间距
    var columnMargin:CGFloat{
        
        get{
            
            if ((self.delegate?.respondsToSelector("columnMarginInWaterflowLayout:")) == true){
                
                return (self.delegate?.columnMarginInWaterflowLayout!(self))!
            }else{
                
                return OODefaultColumnMargin
            }
            
        }
    }
    
    ///列数
    var columnCount:NSInteger{
        
        get{
            
            if ((self.delegate?.respondsToSelector("columnMarginInWaterflowLayout:")) == true){
                
                return (self.delegate?.columnCountInWaterflowLayout!(self))!
            }else{
                
                return OODefaultColumnCount
            }
            
        }
    }
    
    ///边距
    var edgeInsets:UIEdgeInsets{
        
        get{
            
            if ((self.delegate?.respondsToSelector("edgeInsetsInWaterflowLayout:")) == true){
                
                return (self.delegate?.edgeInsetsInWaterflowLayout!(self))!
            }else{
                
                return OODefaultEdgeInsets
            }
            
        }
    }

}


//MARK:初始化和计算
extension OOWaterflowLayout{

    ///1.布局的初始化操作
    override func prepareLayout() {
        super.prepareLayout()
        
        self.contentHeight = 0
        //清除之前计算的高度
        self.columnHeights.removeAllObjects()
        for _ in 0...self.columnCount - 1{
        
            self.columnHeights.addObject(self.edgeInsets.top)
        }
        
        //清除之前所有的布局属性
        self.attrsArray.removeAll()
        
        //创建每一个cell的布局属性
        let count = self.collectionView?.numberOfItemsInSection(0)
        for var i = 0;i < count;i++ {
        
            let indexpath = NSIndexPath(forItem: i, inSection: 0)
            //获取布局属性
            let attrs = self.layoutAttributesForItemAtIndexPath(indexpath)
            self.attrsArray.append(attrs!)
        }
        
    }

    ///2.决定cell的排布
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return self.attrsArray
    }
    
    ///3.返回indexPath位置cell对应的布局属性
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        //创建布局属性
        let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)
        //创建collectionView的宽度
        let collectionViewW = self.collectionView?.frame.size.width
        let coCount:CGFloat = CGFloat(NSNumber(integer: self.columnCount))
        //设置布局的frame
        let w:CGFloat = (collectionViewW! - self.edgeInsets.left - self.edgeInsets.right - (coCount - 1) * self.columnMargin) / coCount
        let h:CGFloat = (self.delegate?.waterflowLayout(waterflowLayout: self, heightForItemAtIndex: indexPath.item, itemWidth: w))!
        
        //找出高度最短的那一列
        var destColumn:CGFloat = 0
        var minColumnHeight:CGFloat = (self.columnHeights[0] as? CGFloat)!
        for var i = 1;i < self.columnCount;i++ {
            
            let columnHeight = (self.columnHeights[i] as? CGFloat)!
            if minColumnHeight > columnHeight{
            
                minColumnHeight = columnHeight
                destColumn = CGFloat(i)
            }
        }
        
        let x:CGFloat = self.edgeInsets.left + destColumn * (w + self.columnMargin)
        var y:CGFloat = minColumnHeight
        if y != self.edgeInsets.top{
        
            y += self.rowMargin
        }
        
        attrs.frame = CGRectMake(x, y, w, h)
        
        //更新最短的那一列的高度
        self.columnHeights[NSInteger(destColumn)] = CGRectGetMaxY(attrs.frame)
        
        //记录内容的高度
        let columnHeight:CGFloat = self.columnHeights[NSInteger(destColumn)] as! CGFloat
        
        if self.contentHeight < columnHeight{
        
            self.contentHeight = columnHeight
        }
        
        return attrs
    }
    
    
    override func collectionViewContentSize() -> CGSize {

        return CGSizeMake(0, self.contentHeight! + self.edgeInsets.bottom)

    }
    
}

//MARK:代理
@objc protocol OOWaterflowLayoutDeledate:NSObjectProtocol{

    ///返回每个item的高度必须实现
    func waterflowLayout(waterflowLayout waterflowLayout:OOWaterflowLayout,heightForItemAtIndex index:NSInteger,itemWidth width:CGFloat)->CGFloat
    ///返回的列数不实现默认为3列
    optional func columnCountInWaterflowLayout(waterflowLayout:OOWaterflowLayout) -> NSInteger
    ///返回列间距,默认为10
    optional func columnMarginInWaterflowLayout(waterflowLayout:OOWaterflowLayout) -> CGFloat
    ///返回行间距,默认为10
    optional func rowMarginInWaterflowLayout(waterflowLayout:OOWaterflowLayout) -> CGFloat
    ///返回内边距,默认为(10,10,10,10)
    optional func edgeInsetsInWaterflowLayout(waterflowLayout:OOWaterflowLayout) -> UIEdgeInsets
    
}
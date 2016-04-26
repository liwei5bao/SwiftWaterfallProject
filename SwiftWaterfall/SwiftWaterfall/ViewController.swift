//
//  ViewController.swift
//  SwiftWaterfall
//
//  Created by kouclo on 16/4/26.
//  Copyright © 2016年 李伟. All rights reserved.
//

import UIKit

import UIKit

class ViewController: UIViewController{
    
    var collectionView:UICollectionView?
    ///重用item的标识
    let itwmID = "shopID"
    ///商品数组
    lazy var shops:NSMutableArray? = {
        
        return NSMutableArray()
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化布局
        self.setupLayout()
        //初始化上拉加载更多,下拉加载
        self.setupRefresh()
        self.loadNewShops()
    }
    
    //MARK:初始化数据
    private func setupList(){
        
        for i in 0...10{
            
            var model:NSDictionary?
            
            if Int(i % 2) == 0{
                
                model = ["w":NSNumber(int:200),"h":NSNumber(int: 300),"img":"http://s13.mogujie.cn/b7/bao/131012/vud8_kqywordekfbgo2dwgfjeg5sckzsew_310x426.jpg_200x999.jpg","price":""]
                
            }else{
                
                model = ["w":NSNumber(int:200),"h":NSNumber(int: 400),"img":"http://s6.mogujie.cn/b7/bao/131008/q2o17_kqyvcz3ckfbewv3wgfjeg5sckzsew_330x445.jpg_200x999.jpg","price":""]
            }
            
            self.shops?.addObject(model!)
        }
        self.collectionView?.header.endRefreshing()
        self.collectionView?.footer.endRefreshing()
    }
    
    //MARK:初始化的内容
    private func setupRefresh(){
        
        self.collectionView?.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "loadNewShops")//header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewShops")
        self.collectionView?.addLegendFooterWithRefreshingTarget(self, refreshingAction: "loadMoreShops")//footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: "loadMoreShops")
        self.collectionView?.footer.hidden = true
    }
    
    private func setupLayout(){
        
        let layout = OOWaterflowLayout()
        layout.delegate = self
        //创建collectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        collectionView.registerNib(UINib(nibName: "OOShopCell", bundle: nil), forCellWithReuseIdentifier: itwmID)
        self.collectionView = collectionView
        
    }
    
    
    ///加载新数据
    func loadNewShops(){
        
        self.shops?.removeAllObjects()
        self.setupList()
        //刷新数据
        self.collectionView?.reloadData()
        self.collectionView?.header.endRefreshing()
    }
    
    ///加载更多的数据
    func loadMoreShops(){
        
        self.setupList()
        //刷新数据
        self.collectionView?.reloadData()
        self.collectionView?.footer.endRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}


extension ViewController:UICollectionViewDataSource{
    
    //MARK:UICollectionViewDataSource的数据源
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.collectionView?.footer.hidden = (self.shops?.count == 0)
        return (self.shops?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(itwmID, forIndexPath: indexPath) as? OOShopCell
        cell?.shops = self.shops![indexPath.item] as? NSDictionary
        return cell!
    }
    
}

extension ViewController:OOWaterflowLayoutDeledate{
    
    ///必须实现的方法
    func waterflowLayout(waterflowLayout waterflowLayout: OOWaterflowLayout, heightForItemAtIndex index: NSInteger, itemWidth width: CGFloat) -> CGFloat {
        
        let shop = self.shops![index] as! NSDictionary
        return width * CGFloat(shop["h"] as! NSNumber) / CGFloat(shop["w"]  as! NSNumber)
    }
    
    //MARK:下边的代理可以不实现有默认值
    ///返回列数
    func columnCountInWaterflowLayout(waterflowLayout: OOWaterflowLayout) -> NSInteger {
        
        return 2
    }
    
    ///返回列间距
    func columnMarginInWaterflowLayout(waterflowLayout: OOWaterflowLayout) -> CGFloat {
        
        return 10
    }
    
    ///返回行间距
    func rowMarginInWaterflowLayout(waterflowLayout: OOWaterflowLayout) -> CGFloat {
        
        return 10
    }
    
    ///返回内边距
    func edgeInsetsInWaterflowLayout(waterflowLayout: OOWaterflowLayout) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}



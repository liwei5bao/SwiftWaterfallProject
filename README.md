# SwiftWaterfallProject
仿照MJ写的一个swift瀑布流框架,使用只需要将OOWaterflowLayout.swift拖入项目实现代理,OOWaterflowLayout.swift不需要修改
# 自定义的UICollectionViewLayout布局,需要实现一个必须实现的代理
///返回每个item的高度必须实现
func waterflowLayout(waterflowLayout waterflowLayout:OOWaterflowLayout,heightForItemAtIndex index:NSInteger,itemWidth width:CGFloat)->CGFloat

# 自定义的UICollectionViewLayout布局,返回的列数不实现默认为3列
optional func columnCountInWaterflowLayout(waterflowLayout:OOWaterflowLayout) -> NSInteger

# 自定义的UICollectionViewLayout布局,返回列间距,不实现默认为10
optional func columnMarginInWaterflowLayout(waterflowLayout:OOWaterflowLayout) -> CGFloat

# 自定义的UICollectionViewLayout布局,返回行间距,不实现默认为10
optional func rowMarginInWaterflowLayout(waterflowLayout:OOWaterflowLayout) -> CGFloat

# 自定义的UICollectionViewLayout布局,返回edgeInsets,不实现默认为(10,10,10,10)
optional func edgeInsetsInWaterflowLayout(waterflowLayout:OOWaterflowLayout) -> UIEdgeInsets

# CJImageBrowser
a custom image browser for iOS

# Installation

Use CocoaPods  

``` ruby
pod 'CJImageBrowser', '1.0.1' 
or 
pod 'CJImageBrowser'
```

# Overview

![snapshot](https://raw.githubusercontent.com/CJMaxWell2013/CJImageBrowser/master/Snapshots/Snapshot0.gif)

这个图片浏览框架经历了两次修改，使其很像今日头条、腾讯新闻、网易新闻的图片浏览框架！
今后我们还会维护和修改他，如果您在使用中有任何bug，请在github上给我留言！

# How to use it 

If you want to use this image brower in action call back, for example
 `collectionView:didSelectItemAtIndexPath:` method . like this:

``` objc
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
CJCollectionViewCell *iamgeCell = (CJCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
NSInteger count = self.imageArray.count;
// 1.封装图片数据
NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];

for (int i = 0; i < count; i++) {
CJImageInfo *photo = [[CJImageInfo alloc] init];
photo.url = [NSURL URLWithString:[self.imageArray[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]; // 图片路径
if (indexPath.row == i) {
photo.srcImageView = [iamgeCell imageView]; // 来源于哪个UIImageView
}
[photos addObject:photo];
}

// 2.显示相册
CJImageBrowser *browser = [[CJImageBrowser alloc] init];
browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
browser.photos = photos; // 设置所有的图片
[browser show];

}
```

# Release Notes

**1.0.1** - a fix SVProgressHud to -CJ  for image brower dependence.  
**1.0.0** - a simple image brower for iOS.  

# License  
MIT


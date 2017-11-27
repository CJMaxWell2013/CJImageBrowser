//
//  ViewController.m
//  Demo
//
//  Created by J.Cheng on 2017/5/23.
//  Copyright © 2017年 None. All rights reserved.
//

#import "ViewController.h"
#import "CJCollectionViewCell.h"
#import "CJImageInfo.h"
#import "CJImageBrowser.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
    
    @property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
    
    @property (nonatomic,strong) NSArray *imageArray;
    
    @end

@implementation ViewController
    static NSString *kCJCollectionViewCellId = @"kCJCollectionViewCellId";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495558573010&di=bff1abbb2c21fbc8c1f8adae58d0a785&imgtype=0&src=http%3A%2F%2Fwww.zhlzw.com%2FUploadFiles%2FArticle_UploadFiles%2F201204%2F20120412123914329.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495558702907&di=f20ec8ff232bf5ade35f4c20039536ad&imgtype=0&src=http%3A%2F%2Fpic1.juimg.com%2F150404%2F330601-1504040R23042-lp.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495558702907&di=3be6b0a3038b968510d144c813ef0356&imgtype=0&src=http%3A%2F%2Fimg.web07.cn%2FUpPic%2FPng%2F201405%2F27%2F35604271049401.png",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495558702906&di=e4e26eab5c07f450b291c150b5cca52d&imgtype=0&src=http%3A%2F%2Fwww.cnkang.com%2Fdzjk%2FUploadFiles%2F201503%2F2015032717045249.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495558862584&di=fb42af0a0db87922a11e3c9b6b4dd943&imgtype=0&src=http%3A%2F%2Fpicture.ik123.com%2Fuploads%2Fallimg%2F160929%2F12-160929161S1.jpg"];
    
    UINib *nib = [UINib nibWithNibName:@"CJCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kCJCollectionViewCellId];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
    
}
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CJCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCJCollectionViewCellId forIndexPath:indexPath];
    collectionCell.imageUrl = self.imageArray[indexPath.row];
    return collectionCell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80.0f, 80.0f);
}
    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = self.imageArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        CJImageInfo *photo = [[CJImageInfo alloc] init];
        photo.url = [NSURL URLWithString:[self.imageArray[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]; // 图片路径
        CJCollectionViewCell *iamgeCell = (CJCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        photo.srcImageView = [iamgeCell imageView]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    CJImageBrowser *browser = [[CJImageBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
    @end

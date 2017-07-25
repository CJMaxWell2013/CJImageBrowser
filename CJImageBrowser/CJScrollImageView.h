//
//  CJScrollImageView.h
//  news
//
//  Created by J.Cheng on 16/11/6.
//  Copyright © 2016年 J.Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CJScrollImageViewDelegate;
@class CJImageBrowser, CJImageInfo;
@interface CJScrollImageView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) CJImageInfo *photo;
// 代理
@property (nonatomic, weak) id<CJScrollImageViewDelegate> photoViewDelegate;

@end

@protocol CJScrollImageViewDelegate <NSObject>

- (void)photoViewImageFinishLoad:(CJScrollImageView *)photoView;

- (void)photoViewSingleTap:(CJScrollImageView *)photoView;

- (void)photoViewDidEndZoom:(CJScrollImageView *)photoView;

@end

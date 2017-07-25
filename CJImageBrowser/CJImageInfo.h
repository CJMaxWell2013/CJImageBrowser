//
//  CJImageInfo.h
//  news
//
//  Created by J.Cheng on 16/11/6.
//  Copyright © 2016年 J.Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CJImageInfo : NSObject

/**
 图片的URL
 */
@property (nonatomic, strong) NSURL *url;

/**
 完整的图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 图片来源view
 */
@property (nonatomic, strong) UIImageView *srcImageView;

/**
 占位图片
 */
@property (nonatomic, strong, readonly) UIImage *placeholder;

/**
 截图
 */
@property (nonatomic, strong, readonly) UIImage *capture;

/**
 是不是第一次滑动展示
 */
@property (nonatomic, assign) BOOL firstShow;
/**
 图片是否已经保存到相册
 */
@property (nonatomic, assign) BOOL save;

/**
 图片下标索引
 */
@property (nonatomic, assign) int index;
@end

//
//  CJImageToolbar.h
//  news
//
//  Created by J.Cheng on 16/11/6.
//  Copyright © 2016年 J.Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJImageToolbar : UIView
/**
 所有的图片对象
 */
@property (nonatomic, strong) NSArray *photos;
/**
 当前展示的图片索引
 */
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@end

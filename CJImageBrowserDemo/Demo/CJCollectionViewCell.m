//
//  CJCollectionViewCell.m
//  Demo
//
//  Created by J.Cheng on 2017/5/23.
//  Copyright © 2017年 None. All rights reserved.
//

#import "CJCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation CJCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

@end

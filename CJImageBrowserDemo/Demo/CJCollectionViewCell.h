//
//  CJCollectionViewCell.h
//  Demo
//
//  Created by J.Cheng on 2017/5/23.
//  Copyright © 2017年 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (copy, nonatomic) NSString *imageUrl;
@end

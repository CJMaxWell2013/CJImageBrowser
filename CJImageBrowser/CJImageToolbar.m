//
//  CJImageToolbar.m
//  news
//
//  Created by J.Cheng on 16/11/6.
//  Copyright © 2016年 J.Cheng. All rights reserved.
//

#import "CJImageToolbar.h"
#import "CJImageInfo.h"
#import <CJProgressHUD/SVProgressHUD.h>
@interface CJImageToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
}
@end
@implementation CJImageToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    CGFloat btnWidth = self.bounds.size.height;
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentLeft;
        _indexLabel.frame = CGRectMake(20.0f, 0, 200.0, btnWidth);
        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(self.bounds.size.width - 9.0f - btnWidth, 0, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // 这里不使用mainBundle是为了适配pod 1.x和0.x
    NSBundle *customBd = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[CJImageToolbar class]] pathForResource:@"CJImageBrowser" ofType:@"bundle"]];
    UIImage *normalImage = [[UIImage imageWithContentsOfFile:[customBd pathForResource:@"save_icon@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImage *selectImage = [[UIImage imageWithContentsOfFile:[customBd pathForResource:@"save_icon_select@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    [_saveImageBtn setImage:normalImage forState:UIControlStateNormal];
    [_saveImageBtn setImage:selectImage forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CJImageInfo *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        CJImageInfo *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%zd / %zd", _currentPhotoIndex + 1, _photos.count];
    
    CJImageInfo *photo = _photos[_currentPhotoIndex];
    // 按钮
    _saveImageBtn.enabled = !photo.save;
}


@end

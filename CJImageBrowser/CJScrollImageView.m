//
//  CJScrollImageView.m
//  news
//
//  Created by J.Cheng on 16/11/6.
//  Copyright © 2016年 J.Cheng. All rights reserved.
//

#import "CJScrollImageView.h"
#import "CJImageInfo.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#define kScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
@interface CJScrollImageView ()<UIGestureRecognizerDelegate>
    {
        BOOL _doubleTap;
        UIImageView *_imageView;
    }
    @end
@implementation CJScrollImageView
    
- (id)initWithFrame:(CGRect)frame
    {
        if ((self = [super initWithFrame:frame])) {
            self.clipsToBounds = YES;
            // 图片
            _imageView = [[UIImageView alloc] init];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:_imageView];
            
            // 属性
            self.backgroundColor = [UIColor clearColor];
            self.delegate = self;
            self.showsHorizontalScrollIndicator = NO;
            self.showsVerticalScrollIndicator = NO;
            self.decelerationRate = UIScrollViewDecelerationRateFast;
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            // 监听点击
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            singleTap.delaysTouchesBegan = YES;
            singleTap.numberOfTapsRequired = 1;
            [self addGestureRecognizer:singleTap];
            
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            doubleTap.numberOfTapsRequired = 2;
            [self addGestureRecognizer:doubleTap];
            
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(iconImagMoved:)];
            panGesture.delaysTouchesBegan = YES;
            panGesture.delaysTouchesEnded = YES;
            [_imageView addGestureRecognizer:panGesture];
            _imageView.userInteractionEnabled = YES;
            panGesture.delegate = self;
            
            
        }
        return self;
    }
    
#pragma mark - photoSetter
- (void)setPhoto:(CJImageInfo *)photo {
    _photo = photo;
    
    [self showImage];
}
    
#pragma mark 显示图片
- (void)showImage
    {
        if (_photo.firstShow) { // 首次显示
            _imageView.image = _photo.placeholder; // 占位图片
            _photo.srcImageView.image = nil;
            // 不是gif，就马上开始下载
            if (![_photo.url.absoluteString hasSuffix:@"gif"]) {
                __unsafe_unretained CJScrollImageView *photoView = self;
                __unsafe_unretained CJImageInfo *photo = _photo;
                [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    photo.image = image;
                    
                    // 调整frame参数
                    [photoView adjustFrame];
                }];
            }
        } else {
            [self photoStartLoad];
        }
        
        // 调整frame参数
        [self adjustFrame];
    }
    
#pragma mark 开始加载图片
- (void)photoStartLoad
    {
        if (_photo.image) {
            self.scrollEnabled = YES;
            _imageView.image = _photo.image;
        } else {
            self.scrollEnabled = NO;
            
            __unsafe_unretained CJScrollImageView *photoView = self;
            
            [_imageView sd_setImageWithPreviousCachedImageWithURL:_photo.url placeholderImage:_photo.srcImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [photoView photoDidFinishLoadWithImage:image];
            }];
        }
    }
    
#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
    {
        if (image) {
            self.scrollEnabled = YES;
            _photo.image = image;
            if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
                [self.photoViewDelegate photoViewImageFinishLoad:self];
            }
        } else {
        }
        
        // 设置缩放比例
        [self adjustFrame];
    }
#pragma mark 调整frame
- (void)adjustFrame
    {
        if (_imageView.image == nil) return;
        
        // 基本尺寸参数
        CGSize boundsSize = self.bounds.size;
        CGFloat boundsWidth = boundsSize.width;
        CGFloat boundsHeight = boundsSize.height;
        
        CGSize imageSize = _imageView.image.size;
        CGFloat imageWidth = imageSize.width;
        CGFloat imageHeight = imageSize.height;
        
        // 设置伸缩比例
        CGFloat minScale = boundsWidth / imageWidth;
        if (minScale > 1) {
            minScale = 1.0;
        }
        CGFloat maxScale = 6.0;
        if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
            maxScale = maxScale / [[UIScreen mainScreen] scale];
        }
        self.maximumZoomScale = maxScale;
        self.minimumZoomScale = minScale;
        self.zoomScale = minScale;
        
        CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
        // 内容尺寸
        self.contentSize = CGSizeMake(0, imageFrame.size.height);
        
        // y值
        if (imageFrame.size.height < boundsHeight) {
            imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
        } else {
            imageFrame.origin.y = 0;
        }
        imageFrame = self.bounds;
        if (_photo.firstShow) { // 第一次显示的图片
            _photo.firstShow = NO; // 已经显示过了
            _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
            
            [UIView animateWithDuration:0.3 animations:^{
                _imageView.frame = imageFrame;
            } completion:^(BOOL finished) {
                // 设置底部的小图片
                _photo.srcImageView.image = _photo.placeholder;
                [self photoStartLoad];
            }];
        } else {
            _imageView.frame = self.bounds;
        }
    }
    
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}
    
#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
    
}
- (void)hide
    {
        if (_doubleTap) return;
        
        // 移除进度条
        //    [_photoLoadingView removeFromSuperview];
        self.contentOffset = CGPointZero;
        
        // 清空底部的小图
        _photo.srcImageView.image = nil;
        
        CGFloat duration = 0.15;
        if (_photo.srcImageView.clipsToBounds) {
            [self performSelector:@selector(reset) withObject:nil afterDelay:duration];
        }
        
        [UIView animateWithDuration:duration + 0.1 animations:^{
            
            if (_photo.srcImageView) {
                _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
            }else{
                
                _imageView.alpha = 0;
            }
            // gif图片仅显示第0张
            if (_imageView.image.images) {
                _imageView.image = _imageView.image.images[0];
            }
            
            // 通知代理
            if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
                [self.photoViewDelegate photoViewSingleTap:self];
            }
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            _photo.srcImageView.image = _photo.placeholder;
            
            // 通知代理
            if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
                [self.photoViewDelegate photoViewDidEndZoom:self];
            }
        }];
    }
    
- (void)reset
    {
        if (_photo.capture) {
            _imageView.image = _photo.capture;
        }
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else if(self.zoomScale >= 1.5f){
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }else{
        [self setZoomScale:2.0 animated:YES];
    }
}
    
- (UIViewController *)cj_findeCurrentViewController {
    
    for (UIView *view = self; view; view = view.superview) {
        
        UIResponder *nextResponder = [view nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)nextResponder;
            
        }
        
    }
    
    return nil;
}
    
- (void)iconImagMoved:(UIPanGestureRecognizer*)gesture{
    
    UIViewController *controller = [self cj_findeCurrentViewController];
    UIView *controlView = controller.view;
    UIView *toolBar = nil;
    for (UIView *subView in controlView.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:@"CJImageToolbar"]) {
            toolBar = subView;
            break;
        }
        
    }
    CGPoint point = [gesture translationInView:self];
    
    CGFloat currentAlpha = 1 - ABS(0.8 * point.y) / 150;
    if (currentAlpha < 0) currentAlpha = 0;
    
    NSLog(@"%f",currentAlpha);
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        break;
        case UIGestureRecognizerStateChanged:
        {
            toolBar.hidden = YES;
            controlView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:currentAlpha];
            self.transform = CGAffineTransformMakeTranslation(0, point.y);
        }
        break;
        case UIGestureRecognizerStateEnded:
        
        {
            
            if((currentAlpha <= 0.5 && point.y < 0 ) || (currentAlpha <= 0.5 && point.y > 0)) {
                CGFloat upDirection = (point.y < 0) ? -1 : 1;
                [UIView animateWithDuration:0.2 animations:^{
                    
                    self.transform = CGAffineTransformMakeTranslation(0, upDirection * kScreenHeight * 0.5);
                    
                    controlView.alpha = 0;
                } completion:^(BOOL finished) {
                    [controlView removeFromSuperview];
                    [controller removeFromParentViewController];
                }];
                
            }else{
                [UIView animateWithDuration:0.1 animations:^{
                    controlView.alpha = 1;
                    self.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    controlView.backgroundColor = [UIColor blackColor];
                    toolBar.hidden = NO;
                }];
                
                
            }
        }
        
        break;
        case UIGestureRecognizerStateCancelled:
        {
            [UIView animateWithDuration:0.1 animations:^{
                controlView.alpha = 1;
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                controlView.backgroundColor = [UIColor blackColor];
                toolBar.hidden = NO;
            }];
            
        }
        break;
        case UIGestureRecognizerStateFailed:
        {
            [UIView animateWithDuration:0.1 animations:^{
                controlView.alpha = 1;
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                controlView.backgroundColor = [UIColor blackColor];
                toolBar.hidden = NO;
            }];
            
        }
        break;
        
        default:
        break;
    }
}
    
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    NSString *gestureClassString = NSStringFromClass(gestureRecognizer.class);
    if ([gestureClassString isEqualToString:@"UIScrollViewPanGestureRecognizer"]) return YES;
    if (![gestureClassString isEqualToString:@"UIPanGestureRecognizer"]) return YES;
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
    CGPoint point =   [panGesture velocityInView:_imageView];
    return (fabs(point.x/point.y) >= 1) ? NO : YES;
}
    
    
    /**
     * /// 此方法未用到
     -(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
     {
     if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UIScrollView")]) {
     if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan) {
     return YES;
     }
     }
     
     return NO;
     }
     */
    
- (void)dealloc
    {
        // 取消请求
        [_imageView sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
    }
    
    
    @end

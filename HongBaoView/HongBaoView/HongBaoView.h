//
//  HongBaoView.h
//  HongBaoView
//
//  Created by LuoWei on 16/1/27.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HongBaoLocationType){
    
    HongBaoLocationType_Left,//左边
    HongBaoLocationType_Center,//中间
    HongBaoLocationType_Right,//右边
    
};//红包位置

@class HongBaoView;
@protocol HongBaoViewDelegate <NSObject>

- (void)hongBaoViewDidTap:(HongBaoView *)view;

@end

@interface HongBaoView : UIImageView<UIGestureRecognizerDelegate>

@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,retain)UIImage *defaultImage;//默认状态图片
@property (nonatomic,assign)HongBaoLocationType locationType;
@property (nonatomic,copy)void (^hongbaoBlock)(NSString *url);
@property (nonatomic,weak)id <HongBaoViewDelegate>delegate;
/**
 *  初始化-1
 *
 *  @param frame
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
 *  初始化-2
 *
 *  @param frame
 *  @param urlStr url链接
 *  @param defaultImg 默认图片
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
                    urlString:(NSString *)urlStr
                   defaultImg:(UIImage *)defaultImg;

/**
 *  显示
 *
 *  @param superView 父视图
 */
- (void)showInView:(UIView *)superView;
@end

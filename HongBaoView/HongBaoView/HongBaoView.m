//
//  HongBaoView.m
//  HongBaoView
//
//  Created by LuoWei on 16/1/27.
//  Copyright © 2016年 qhfax. All rights reserved.


#import "HongBaoView.h"
# define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
# define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@implementation HongBaoView
@synthesize urlString;
@synthesize locationType;
@synthesize defaultImage;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeScaleAspectFit;
    [self addTapGestureRecognizer];
    [self addPanGestureRecognizer];
}
- (instancetype)initWithFrame:(CGRect)frame
                    urlString:(NSString *)urlStr
                   defaultImg:(UIImage *)defaultImg{

    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        self.defaultImage = defaultImg;
        urlString = urlStr;
    }
    return self;
}
/**添加点击手势*/
- (void)addTapGestureRecognizer{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiece:)];
    [tapGesture setDelegate:self];
    [self addGestureRecognizer:tapGesture];
    
}
/**点击手势*/
- (void)tapPiece:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hongBaoViewDidTap:)]) {
        [self.delegate hongBaoViewDidTap:self];
    }
    if (self.hongbaoBlock) {
        self.hongbaoBlock(self.urlString);
    }
}
/**添加拖拽手势*/
- (void)addPanGestureRecognizer{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [self addGestureRecognizer:panGesture];
}
/**滑动手势*/
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer{
    
    //调整锚点
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    UIView *piece = [gestureRecognizer view];
    //获得手势在父视图偏移量
    CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged){
        //在当前的哪个view上发生了这个手势。
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
        self.locationType = HongBaoLocationType_Center;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
    //手势作用结束，判断位置是否需要移动到边界
        [self moveToFinalLocation];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}
/**移动到最终停留位置*/
- (void)moveToFinalLocation{
    float minX = CGRectGetMinX(self.frame);
    float maxX = CGRectGetMaxX(self.frame);
    float midX = (minX + maxX)/2;
    
    float speed = SCREEN_WIDTH/1.0f;
    float animationTime = 0.5;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    if (minX <= 0) {
        //贴到左边
        animationTime = -minX/speed;
        self.locationType = HongBaoLocationType_Left;
    }
    else if (midX <= SCREEN_WIDTH/2){
        //贴到左边
        animationTime = minX/speed;
        self.locationType = HongBaoLocationType_Left;
    }
    else{
        //贴到右边
        animationTime = (SCREEN_WIDTH - maxX)/speed;
        self.locationType = HongBaoLocationType_Right;
    }
    [UIView setAnimationDuration:animationTime];
    [UIView commitAnimations];
}
/**调整锚点*/
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        //设置锚点为当前手势点击的点
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        //根据在view上的位置设置锚点。
        //防止设置完锚点过后，view的位置发生变化，相当于把view的位置重新定位到原来的位置上。
        //设置手势移动的位置，并把view移动到相应的位置
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        piece.center = locationInSuperview;
        
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    switch (self.locationType) {
        case HongBaoLocationType_Left: {
            self.image = [UIImage imageNamed:@"tz_1"];
            break;
        }
        case HongBaoLocationType_Center: {
        //最终不会停留在中间
            break;
        }
        case HongBaoLocationType_Right: {
            self.image = [UIImage imageNamed:@"tz_3"];
            break;
        }
    }
}
# pragma mark------ show method
- (void)showInView:(UIView *)superView{
    
    [superView addSubview:self];
    __weak HongBaoView *weakSelf = self;
    [UIView animateWithDuration:1.3
                          delay:1.0
         usingSpringWithDamping:0.65
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect rect = weakSelf.frame;
                         rect.origin.y = SCREEN_HEIGHT/2 - 50;
                         weakSelf.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         
                         [weakSelf performSelector:@selector(moveToFinalLocation)
                                        withObject:nil
                                        afterDelay:.35f];
                     }];
}
# pragma mark----set/get
- (void)setUrlString:(NSString *)urlStr{
    if (urlStr.length <= 0) {
        return;
    }
    urlString = urlStr;
}
- (void)setDefaultImage:(UIImage *)defaultImg{
    defaultImage = defaultImg;
    self.image = defaultImg;
    CGRect rect = self.frame;
    rect.size.width = defaultImg.size.width;
    rect.size.height = defaultImg.size.height;
    self.frame = rect;
}
- (void)setLocationType:(HongBaoLocationType)locType{

    locationType = locType;
    CGRect pieceRect = self.frame;
    switch (locType) {
        case HongBaoLocationType_Left: {
            pieceRect.origin.x = 0;
            break;
        }
        case HongBaoLocationType_Center: {
            self.image = self.defaultImage;
            break;
        }
        case HongBaoLocationType_Right: {
            pieceRect.origin.x = SCREEN_WIDTH - pieceRect.size.width;
            break;
        }
    }
    self.frame = pieceRect;
}
@end

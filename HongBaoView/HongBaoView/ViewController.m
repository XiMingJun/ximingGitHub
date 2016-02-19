//
//  ViewController.m
//  HongBaoView
//
//  Created by LuoWei on 16/1/27.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import "ViewController.h"
#import "HongBaoView.h"
@interface ViewController ()<HongBaoViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIImage *defaultImg = [UIImage imageNamed:@"tz_2"];
    HongBaoView *view = [[HongBaoView alloc] initWithFrame:CGRectMake(20, 50,defaultImg.size.width,defaultImg.size.height)];
    view.tag = 101;
    view.defaultImage = defaultImg;
    view.delegate = self;
    [view showInView:self.view];
}
# pragma mark----HongBaoDelegate
- (void)hongBaoViewDidTap:(HongBaoView *)view{

    NSLog(@"--->>点击");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

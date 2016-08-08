//
//  BaseViewController.m
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "BaseViewController.h"
@class ThemeManager;
@class ThemButton;
@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ThemeImage *bgImageView = [[ThemeImage alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName =@"bg_detail.jpg";
    
    [self.view insertSubview:bgImageView atIndex:0];
    [self createBackButton];
}
-(void)createBackButton{
    
    
    if (self.navigationController.viewControllers.count>=2 ) {
        ThemButton *backButton = [ThemButton buttonWithType:UIButtonTypeCustom];
        
        backButton.frame= CGRectMake(0, 0, 64, 44);
        backButton.backgroundImageName=@"titlebar_button_back_9";
        [backButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
        
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem = item;
        
    }
    
    
}
-(void)backView{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

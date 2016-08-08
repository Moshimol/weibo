//
//  RightViewController.m
//  weibo
//
//  Created by lushitong on 16/8/1.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "RightViewController.h"
#import "ThemButton.h"
#import "UIViewExt.h"
#import "BaseNavigationController.h"
#import "SendWeiboViewController.h"
#import "UIViewController+MMDrawerController.h"
@class ThemButton;
@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ThemeImage *bgImageView = [[ThemeImage alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName =@"mask_bg.jpg";
    
    [self.view insertSubview:bgImageView atIndex:0];
    [self createButtons];
}
-(void)createButtons{
    
    CGFloat buttonWidth = 50;
    CGFloat space =15;
    for (int i = 0; i<5; i++) {
        CGRect frame = CGRectMake(space, (space+buttonWidth)*i, buttonWidth, buttonWidth);
        ThemButton *button = [ThemButton buttonWithType:UIButtonTypeCustom];
        
        button.backgroundImageName = [NSString stringWithFormat:@"newbar_icon_%i",i+1];
        button.frame = frame;
        button.tag = i;
        [button addTarget:self action:@selector(sendWeiboAction:) forControlEvents:UIControlEventTouchUpInside];
        //        button.backgroundColor = [UIColor redColor];
        [self.view addSubview:button];
    }
    
    //map
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(space, 0, buttonWidth, buttonWidth);
    [mapButton setImage:[UIImage imageNamed:@"btn_map_location"] forState:UIControlStateNormal];
    [self.view addSubview:mapButton];
    
    //二维码
    UIButton *erweimaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    erweimaButton.frame = CGRectMake(space, 0, buttonWidth, buttonWidth);
    [erweimaButton setImage:[UIImage imageNamed:@"qr_btn"] forState:UIControlStateNormal];
    [self.view addSubview:erweimaButton];
    
    
    mapButton.bottom = kScreenHeight-64 -space;
    erweimaButton.bottom=mapButton.top;
}

-(void)sendWeiboAction:(UIButton *)button{
    
    if (button.tag == 0) {
        NSLog(@"点击了第一个");
        SendWeiboViewController *sendVC = [[SendWeiboViewController alloc]init];
        BaseNavigationController *naVC = [[BaseNavigationController alloc]initWithRootViewController:sendVC];
        [self presentViewController:naVC animated:YES completion:^{
            MMDrawerController *MMD = [self mm_drawerController];
            [MMD closeDrawerAnimated:YES completion:^(BOOL finished) {
                
            }];
            
        }];
        
    }
    if (button.tag == 1) {
        //调用相机
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

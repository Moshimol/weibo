//
//  BaseNavigationController.m
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "BaseNavigationController.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.设置背景图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changedTheme) name:kThemeChangeNoticficationName object:nil];
    [self changedTheme];
    // 手机版本的判断
    
    //    CGFloat systemVersion =[[UIDevice currentDevice].systemVersion floatValue];
    //    if (kSystemVersion>=7.0) {
    //        
    //        
    //        ThemeImage *bgImage = [[ThemeImage alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 64)];
    //        bgImage.imageName=@"mask_titlebar@64";
    //        
    //        UIImage *image =[self getImageFromView:bgImage];
    //        
    //        
    //        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //        
    //        NSLog(@"%lf",kSystemVersion);
    //        
    //        
    //    }else{
    //        
    //        
    //        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"Skins/bluemoon/mask_titlebar"] forBarMetrics:UIBarMetricsDefault];
    //        
    //        
    //        
    //    }
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],
                                 
                                 
                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                 };
    
    
    self.navigationBar.titleTextAttributes =attributes;
    
    self.navigationBar.translucent = NO;
    [self changedTheme];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
-(void)changedTheme{
    
    
    
    
    
    NSString *imageName;
    if (kSystemVersion>=7) {
        imageName=@"mask_titlebar64";
    }
    else{
        imageName=@"mask_titlebar";
    }
    UIImage *image = [[ThemeManager shareManager]themeImageWithName:imageName];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
}

/**
 *  设置状态栏颜色
 *
 *  @return 返回颜色
 */

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  MainTabBarController.m
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "MainTabBarController.h"
#import "ThemeManager.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController
{
    ThemeImage *_arrowImageView;
}

#pragma - mark 初始化
-(instancetype)init{
    
    self =[ super init];
    if (self) {
        [self createSubViewController];
        [self customTabBar];
    }
    
    return  self;
    
}
//创建子控制器
-(void)createSubViewController{
    
    NSArray *storyboardNames = @[@"Home",
                                 @"Message",
                                 @"Discover",
                                 @"Profile",
                                 @"More"
                                 ];
    
    
    NSMutableArray *mArray = [[NSMutableArray alloc]init] ;
    
    for (NSString *sbName in storyboardNames) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]];
        
        
        UINavigationController *navi = [storyboard instantiateInitialViewController];
        [mArray addObject:navi];
        
    }
    self.viewControllers = [mArray copy];
    
    
    
}
//自定义标签栏
-(void)customTabBar{
    
    ThemeImage *bgimageView = [[ThemeImage alloc] initWithFrame:CGRectMake(0, -5, self.tabBar.frame.size.width, 54)];
    //设置图片名
    bgimageView.imageName = @"mask_navbar";
    
    [self.tabBar insertSubview:bgimageView atIndex:0];
    
    //    self.tabBar.backgroundImage = [UIImage imageNamed:@"Skins/cat/mask_navbar"];
    
    
    for (UIView *subView in self.tabBar.subviews) {
        Class buttonClass = NSClassFromString(@"UITabBarButton");
        if ([subView isKindOfClass:buttonClass]) {
            [subView removeFromSuperview];
        }
        
    }
    
    CGFloat Buttonwidth = kScreenwidth / 5;
    //自定义按钮
    for (int i = 0; i<5; i++) {
        
        //        NSString *imageName = [NSString stringWithFormat:@"Skins/bluemoon/home_tab_icon_%i.png",i+1];
        ThemButton *button = [ThemButton buttonWithType:UIButtonTypeCustom];
        
        button.frame =CGRectMake(Buttonwidth*i, 0, Buttonwidth, 49);
        
        NSString *imageName = [NSString stringWithFormat:@"home_tab_icon_%i.png",i+1];
        
        button.imageName = imageName;
        
        [self.tabBar addSubview:button];
        button.tag= i;
        [button addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //进行选中
    _arrowImageView = [[ThemeImage alloc]initWithFrame:CGRectMake(0, 0, Buttonwidth, 49)];
    
    _arrowImageView.imageName=@"home_bottom_tab_arrow";
    //    = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Skins/bluemoon/home_bottom_tab_arrow"]];
    //    _arrowImageView.frame = CGRectMake(0, 0, Buttonwidth, 49);
    [self.tabBar  insertSubview:_arrowImageView atIndex:1];
    
    self.tabBar.shadowImage = [[UIImage alloc]init];
    
}
-(void)tabBarButtonAction:(UIButton *) button{
    
    self.selectedIndex = button.tag;
    [UIView animateWithDuration:0.25 animations:^{
        _arrowImageView.center = button.center;
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

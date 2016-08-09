//
//  AppDelegate.m
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//


#import "AppDelegate.h"
#import "BaseViewController.h"
#import "MainTabBarController.h"
@class ThemeManager;
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "BaseNavigationController.h"
@class MMDrawerController;
@class LeftViewController;
@class RightViewController;
#define kWeiboAuthDataKey @"kWeiboAuthDataKey"
@interface AppDelegate ()<SinaWeiboDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window  = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
    [self.window makeKeyAndVisible];
    
    
    MainTabBarController *tab  = [[MainTabBarController alloc]init];
    LeftViewController *leftVC =[[LeftViewController alloc]init];
    RightViewController *rightVC = [[RightViewController alloc]init];
    
    
    
    
    BaseNavigationController *leftNavi = [[BaseNavigationController alloc]initWithRootViewController:leftVC];
    BaseNavigationController *rightNavi = [[BaseNavigationController alloc]initWithRootViewController:rightVC];
    
    MMDrawerController *mmd = [[MMDrawerController alloc]initWithCenterViewController:tab leftDrawerViewController:leftNavi rightDrawerViewController:rightNavi];
    
    mmd.maximumLeftDrawerWidth=180;
    mmd.maximumRightDrawerWidth=80;
    
    [mmd setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmd setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    
    [mmd setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMExampleDrawerVisualStateManager *manage = [MMExampleDrawerVisualStateManager sharedManager];
        
        MMDrawerControllerDrawerVisualStateBlock block = [manage drawerVisualStateBlockForDrawerSide:drawerSide];
        
        if (block) {
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    
    
    self.window.rootViewController = mmd;
    
    
    
    
    
    
    
    
    _sinaWeibo = [[SinaWeibo alloc]initWithAppKey:kAppkey
                                        appSecret:KAppSerect
                                   appRedirectURI:@"http://www.cnblogs.com/Moshimol/"
                                      andDelegate:self];
    BOOL auther = [self readAuthData];
    if (auther==NO) {
        [self.sinaWeibo logIn];
    }
    else{
        
        NSLog(@"已经登录了微博%@",self.sinaWeibo.accessToken);
    }
    
    
    
    return YES;
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    
    NSLog(@"登录 成功%@",sinaweibo.accessToken);
    [self saveAuthData];
}
//注销
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    
    
    NSLog(@"注销成功");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWeiboAuthDataKey];
}


- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error{
    
    [self.sinaWeibo logOut];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWeiboAuthDataKey];
    [self.sinaWeibo logIn];
    
}

-(void)saveAuthData{
    
    NSString *token = _sinaWeibo.accessToken;
    
    NSString *uid =_sinaWeibo.userID;
    //认证的期限 长期不适用 会导致token失效
    NSDate *date = _sinaWeibo.expirationDate;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = @{@"accessToken":token,
                          @"uid":uid,
                          @"expirationDate":date
                          
                          };
    [userDef setObject:dic forKey:kWeiboAuthDataKey];
    [userDef synchronize];
    
}

//判断是不是登陆过
-(BOOL)readAuthData{
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDef objectForKey:kWeiboAuthDataKey];
    
    if (dic==nil) {
        return NO;
    }
    //读取成功保存数据
    
    NSString *token = dic[@"accessToken"];
    
    NSString *uid =dic[@"uid"];
    NSDate *date = dic[@"expirationDate"];
    
    if (token == nil || uid == nil||date==nil) {
        NSLog(@"你读取的有问题");
    }
    _sinaWeibo.accessToken = token;
    _sinaWeibo.userID=uid;
    _sinaWeibo.expirationDate = date;
    
    return YES;
    
}
//登出微博
-(void)logoutWeibo{
    
    [_sinaWeibo logOut];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

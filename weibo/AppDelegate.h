//
//  AppDelegate.h
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//微博对象
@property (nonatomic,strong) SinaWeibo *sinaWeibo;
-(void)logoutWeibo;


@end


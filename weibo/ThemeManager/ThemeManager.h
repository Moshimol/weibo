//
//  ThemeManager.h
//  weibo
//
//  Created by lushitong on 16/7/30.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "ThemeImage.h"
#import "ThemButton.h"
#import "ThemeLabel.h"
@interface ThemeManager : NSObject

@property (nonatomic, copy) NSDictionary *allThemes;    //所有的可用主题
@property (nonatomic,copy) NSString *currentThemeName;
@property (nonatomic, copy) NSDictionary *colorConfig;

+(ThemeManager*) shareManager;

-(UIImage *)themeImageWithName:(NSString *)imageName;
-(UIColor *)setColorWithName:(NSString *)colorName;
@end

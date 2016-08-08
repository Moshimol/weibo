//
//  ThemeManager.m
//  weibo
//
//  Created by lushitong on 16/7/30.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "ThemeManager.h"
#define kCurrenThemeNameKey @"kCurrenThemeNameKey"
@implementation ThemeManager

#pragma -mark 单例类的创建
+(ThemeManager*) shareManager{
    
    static ThemeManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager==nil) {
            manager= [[super allocWithZone:nil]init];
            
            
        }
    });
    
    return manager;
}
-(instancetype)init{
    
    self = [super init];
    if (self) {
        _currentThemeName=[[NSUserDefaults standardUserDefaults]objectForKey:kCurrenThemeNameKey];
        if (_currentThemeName==nil) {
            _currentThemeName=@"猫爷";
        }
        
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
        _allThemes =[[NSDictionary alloc]initWithContentsOfFile:filePath];
        [self loadColorConfigFile];
        
        
        
        
    }
    return self;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    return [self shareManager];
}
-(id)copy{
    
    return self;
}
#pragma -mark 发送通知

-(void)setCurrentThemeName:(NSString *)currentThemeName{
    
    if (!_allThemes[currentThemeName]) {
        return;
    }
    
    
    if (![_currentThemeName isEqualToString:currentThemeName]) {
        _currentThemeName = [currentThemeName copy];
        /**
         *  发送通知
         */
        [self loadColorConfigFile];
        [[NSNotificationCenter defaultCenter]postNotificationName:kThemeChangeNoticficationName object:nil];
        
        //主题保存本地文件
        [[NSUserDefaults standardUserDefaults]setObject:_currentThemeName forKey:kCurrenThemeNameKey];
        
    }
    
    
    
}
#pragma -mark 获取图片
-(UIImage *)themeImageWithName:(NSString *)imageName{
    
    NSString *name = [NSString stringWithFormat:@"%@/%@",_allThemes[_currentThemeName],imageName];
    
    UIImage *image = [UIImage imageNamed:name];
    return image;
    
}
-(void)loadColorConfigFile{
    
    NSString *bundlePath = [[NSBundle mainBundle]resourcePath];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/config.plist",bundlePath,_allThemes[_currentThemeName]];
    
    NSLog(@"%@",filePath);
    
    _colorConfig = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    //    NSLog(@"%@",_colorConfig);
    
}
-(UIColor *)setColorWithName:(NSString *)colorName{
    
    
    NSDictionary *colorDic = _colorConfig[colorName];
    if (colorDic==nil) {
        return [UIColor blackColor];
        
    }
    
    CGFloat red = [colorDic[@"R"]doubleValue];
    CGFloat green = [colorDic[@"G"]doubleValue];
    CGFloat blue = [colorDic[@"B"]doubleValue];
    
    UIColor *color = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
    
    
    return color;
}

@end

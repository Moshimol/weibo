//
//  ThemButton.m
//  weibo
//
//  Created by lushitong on 16/7/30.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "ThemButton.h"

@implementation ThemButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themChange) name:kThemeChangeNoticficationName object:nil];
    }
    return self;
}
-(void)awakeFromNib{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themChange) name:kThemeChangeNoticficationName object:nil];
    
}
-(void)themChange{
    
    ThemeManager *manager = [ThemeManager shareManager];
    
    UIImage *image =[manager themeImageWithName:_imageName];
    UIImage *bgImage=[manager themeImageWithName:_backgroundImageName];
    
    
    [self setImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    
}
-(void)setBackgroundImageName:(NSString *)backgroundImageName{
    
    _backgroundImageName= [backgroundImageName copy];
    [self themChange];
}
-(void)setImageName:(NSString *)imageName{
    
    _imageName = [imageName copy];
    [self themChange];
    
}
@end

//
//  ThemeLabel.m
//  weibo
//
//  Created by lushitong on 16/8/1.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel
-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(colorChange) name:kThemeChangeNoticficationName object:nil];
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)awakeFromNib{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(colorChange) name:kThemeChangeNoticficationName object:nil];
}

-(void)setColorName:(NSString *)colorName{
    
    _colorName =colorName;
    [self colorChange];
    
}

-(void)colorChange{
    
    UIColor *color = [[ThemeManager shareManager]setColorWithName:_colorName];
    
    
    self.textColor = color;
}
@end

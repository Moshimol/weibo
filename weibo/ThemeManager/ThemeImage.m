//
//  ThemeImage.m
//  weibo
//
//  Created by lushitong on 16/7/30.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "ThemeImage.h"

@implementation ThemeImage

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
        self.leftCapWidth= 0;
        self.topCapHeight = 0;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themChange) name:kThemeChangeNoticficationName object:nil];
    }
    return self;
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)awakeFromNib{
    self.leftCapWidth= 0;
    self.topCapHeight = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themChange) name:kThemeChangeNoticficationName object:nil];
    
}
-(void)setImageName:(NSString *)imageName{
    
    _imageName = [imageName copy];
    [self themChange];
}


-(void)themChange {
    
    //获取当前视图，在当前主题下的图片
    // Skins/主题文件夹/图片名
    
    //获取manager对象
    ThemeManager *manager = [ThemeManager shareManager];
    
    //从管理器中，获取相对应的图片
    UIImage *image  =  [manager themeImageWithName:self.imageName];
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    self.image =image;
    
}
-(void)setLeftCapWidth:(CGFloat)leftCapWidth{
    
    _leftCapWidth = leftCapWidth;
    [self themChange];
}
-(void)setTopCapHeight:(CGFloat)topCapHeight{
    
    _topCapHeight  = topCapHeight;
    [self themChange];
}

@end

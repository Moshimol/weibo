//
//  WeiboCellLauout.h
//  weibo
//
//  Created by lushitong on 16/8/3.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeiboModel;


#define CellTopViewheight 60
#define SpaceWidth 10
#define ImageViewWidth 200
#define ImageViewSpace 5
@interface WeiboCellLauout : NSObject
//数据
@property (nonatomic,strong)  WeiboModel *weibo;
+(instancetype)layoutWithWeiboModel:(WeiboModel*)weibo;

@property(nonatomic,assign,readonly) CGRect weiboTextFrame;
@property(nonatomic,assign,readonly) CGRect weiboimageFrame;

@property(nonatomic,assign,readonly) CGRect weiboReTextFrame;

@property(nonatomic,assign,readonly) CGRect reWeiboBGimageFrame;


/*
 九张图片
 
 */
@property(nonatomic,strong,readonly) NSArray *imageFrameArray;

-(CGFloat)cellHeight;
@end

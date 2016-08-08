//
//  WeiboModel.h
//  weibo
//
//  Created by lushitong on 16/8/2.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface WeiboModel : NSObject
//返回值字段	字段类型	字段说明
//created_at	string	微博创建时间
//id	int64	微博ID
//mid	int64	微博MID
//idstr	string	字符串型的微博ID
//text	string	微博信息内容
//source	string	微博来源
//favorited	boolean	是否已收藏，true：是，false：否
//truncated	boolean	是否被截断，true：是，false：否
//in_reply_to_status_id	string	（暂未支持）回复ID
//in_reply_to_user_id	string	（暂未支持）回复人UID
//in_reply_to_screen_name	string	（暂未支持）回复人昵称
//thumbnail_pic	string	缩略图片地址，没有时不返回此字段
//bmiddle_pic	string	中等尺寸图片地址，没有时不返回此字段
//original_pic	string	原始图片地址，没有时不返回此字段
//geo	object	地理信息字段 详细
//user	object	微博作者的用户信息字段 详细
//retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
//reposts_count	int	转发数
//comments_count	int	评论数
//attitudes_count	int	表态数
@property (nonatomic,copy) NSString *created_at;//微博创建时间

@property (nonatomic,assign) NSInteger *weiboID;//微博ID
@property (nonatomic,assign) NSInteger *mid;//微博MID
@property (nonatomic,assign) Boolean *favorited;//是否已收藏，true：是，false：否


@property (nonatomic,copy) NSString *idstr;//字符串型的微博ID
@property (nonatomic,copy) NSString *text;//微博信息内容
@property (nonatomic,copy) NSString *source;//微博来源

@property (assign, nonatomic)   NSInteger   reposts_count;     //转发数
@property (assign, nonatomic)   NSInteger   comments_count;    //评论数
@property (assign, nonatomic)   NSInteger   attitudes_count;   //点赞数

@property (nonatomic,copy) NSString *in_reply_to_status_id;//
@property (nonatomic,copy) NSString *in_reply_to_user_id;
@property (nonatomic,copy) NSString *in_reply_to_screen_name;
@property (copy, nonatomic)     NSURL       *thumbnail_pic;     //缩略图片地址
@property (copy, nonatomic)     NSURL       *bmiddle_pic;       //中等尺寸图片地址
@property (copy, nonatomic)     NSURL       *original_pic;      //原始图片地址
@property (nonatomic,copy) NSDictionary *geo;//地理信息字段 详细

@property (copy, nonatomic)     NSArray     *pic_urls;
@property (nonatomic,strong) UserModel *user;//用户
@property (strong, nonatomic)   WeiboModel  *retweeted_status; //被转发的微博

//@property (copy, nonatomic)     NSString    *created_at;        //发布时间
//@property (copy, nonatomic)     NSString    *idStr;             //微博编号
//@property (copy, nonatomic)     NSString    *text;              //微博文本
//@property (assign, nonatomic)   NSInteger   reposts_count;     //转发数
//@property (assign, nonatomic)   NSInteger   comments_count;    //评论数
//@property (assign, nonatomic)   NSInteger   attitudes_count;   //点赞数
//@property (strong, nonatomic)   UserModel   *user;              //发微博的用户
//@property (strong, nonatomic)   WeiboModel  *retweeted_status;  //被转发的微博
//@property (copy, nonatomic)     NSString    *thumbnailImage;    //缩略图片地址
//@property (copy, nonatomic)     NSString    *bmiddlelImage;     //中等尺寸图片地址
//@property (copy, nonatomic)     NSString    *originalImage;     //原始图片地址
//@property (copy, nonatomic)     NSArray     *pic_urls;          //多图地址


@end

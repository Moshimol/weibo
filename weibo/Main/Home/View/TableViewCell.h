//
//  TableViewCell.h
//  weibo
//
//  Created by lushitong on 16/8/2.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeLabel.h"
#import "WXLabel.h"
@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *usericon;
@property (weak, nonatomic) IBOutlet ThemeLabel *userName;
@property (weak, nonatomic) IBOutlet ThemeLabel *timeLable;

@property (weak, nonatomic) IBOutlet ThemeLabel *scoreLabel;

@property (strong, nonatomic) UIImageView *weiboImageView;

@property(strong,nonatomic) WXLabel *weiboTextLabel;


/**
 *  转发微博的变量设置
 */
@property (strong, nonatomic) WXLabel *reWeiboTextlabel; //转发微博的正文
@property (strong, nonatomic) ThemeImage *reWeiboBGImageView;   //转发微博的背景
@property (strong, nonatomic) UIImageView *reWeiboImageView; //转发微博里的图片
@property (nonatomic, strong) WeiboModel *weibo;
//九个图片
@property (nonatomic, strong, readonly) NSArray *imageFrameArray;
@property (strong, nonatomic) NSArray *imagesArray;         //九个图片的数据
@end

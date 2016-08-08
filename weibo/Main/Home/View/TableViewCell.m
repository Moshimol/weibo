//
//  TableViewCell.m
//  weibo
//
//  Created by lushitong on 16/8/2.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "TableViewCell.h"
#import "WeiboCellLauout.h"
#import "RegexKitLite.h"
#import "WXLabel.h"
#import "WeiboViewController.h"
#import "WXPhotoBrowser.h"
@class CTTextStyleModel;
@class WeiboCellLauout;
@interface TableViewCell ()  <WXLabelDelegate,PhotoBrowerDelegate>
{
    
}
@end
@implementation TableViewCell{
    
    CGRect *_heightlal;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self setFontColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themChange) name:kThemeChangeNoticficationName object:nil];
    
    [self themChange];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)themChange{
    
    ThemeManager *manage = [ThemeManager shareManager];
    self.weiboTextLabel.textColor = [manage setColorWithName:kHomeWeiboTextColor];
    self.reWeiboTextlabel.textColor = [manage setColorWithName:kHomeReWeiboTextColor];
    
}
-(void)setFontColor{
    _userName.colorName=kHomeUserNameTextColor;
    _timeLable.colorName=kHomeTimeLabelTextColor;
    _scoreLabel.colorName=kHomeTimeLabelTextColor;
    //    _weiboTextLabel.colorName=kHomeWeiboTextColor;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setWeibo:(WeiboModel *)weibo{
    _weibo=weibo;
    _userName.text = _weibo.user.name;
    
    _timeLable.text =_weibo.created_at;
    _scoreLabel.text = weibo.source;
    //    NSLog(@"%@",_timeLable.text);
    [_usericon sd_setImageWithURL:_weibo.user.profile_image_url];
    
    // 对字符进行匹配
    if (_weibo.source.length != 0) {
        NSArray *array1 = [_weibo.source componentsSeparatedByString:@">"];
        NSString *subString = [array1 objectAtIndex:1];
        NSArray *array2 = [subString componentsSeparatedByString:@"<"];
        NSString *source = array2.firstObject;
        
        _scoreLabel.text = [NSString stringWithFormat:@"来自:%@", source];
        _scoreLabel.hidden = NO;
    } else {
        _scoreLabel.hidden = YES;
    }
    
    
    
    NSString *timeString = [NSString stringWithFormat:@"E M d HH:mm:ss Z yyyy"];
    NSDateFormatter *timeDate = [[NSDateFormatter alloc]init];
    
    [timeDate setDateFormat:timeString];
    [timeDate setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [timeDate dateFromString:_weibo.created_at];
    
    NSTimeInterval sceond = -[date timeIntervalSinceNow];
    
    
    NSTimeInterval min = sceond/60;
    NSTimeInterval hour =min/60;
    NSTimeInterval day = hour/60;
    
    NSString *nowtimeString = nil;
    if (sceond<60) {
        
        nowtimeString =@"刚刚";
    }
    else if(min<60){
        nowtimeString  = [NSString stringWithFormat:@"%li分钟前",(NSInteger)min];
        
    }else if (hour<24)
    {
        nowtimeString  = [NSString stringWithFormat:@"%li小时前",(NSInteger)hour];
    }else if (day<7){
        nowtimeString  = [NSString stringWithFormat:@"%li天之前",(NSInteger)day];
        
    }else {
        [timeDate setDateFormat:@"MM月d号 HH:mm"];
        [timeDate setLocale:[NSLocale currentLocale]];
        nowtimeString = [timeDate stringFromDate:date];
    }
    
    _timeLable.text = nowtimeString;
    
    //-------------------------------布局对象的建立-------------------------------
    WeiboCellLauout *layout = [WeiboCellLauout layoutWithWeiboModel:_weibo];
    
    //-------------------------------微博正文-------------------------------
    
    
    
    self.weiboTextLabel.text = weibo.text;
    
    //-------------------------------自己实现图文混排列-------------------------------
    
    
    
    //-------------------------------实现混排，但是找不到-------------------------------
    /* NSString *regist = @"(#[^#]+#)|(@[\\w-]{4,30})|(http(s)?://([a-zA-Z0-9._-]+(/)?)+)";
     
     
     if (_weibo.text) {
     NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regist options:NSRegularExpressionCaseInsensitive error:nil];
     
     NSArray *array = [regular matchesInString:_weibo.text options:NSMatchingReportProgress range:NSMakeRange(0, _weibo.text.length)];
     
     NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:_weibo.text];
     
     for (NSTextCheckingResult *result in array) {
     
     //检索出的字符串所在的位置
     NSRange range = result.range;
     NSLog(@"range = %@", NSStringFromRange(range));
     
     //获取检索出来的字符串
     NSString *subString = [_weibo.text substringWithRange:range];
     NSLog(@"subString = %@", subString);
     
     
     ThemeManager *manage  = [ThemeManager shareManager];
     [attri addAttribute:NSForegroundColorAttributeName value:[manage setColorWithName:kHomeTimeLabelTextColor] range:range];
     self.weiboTextLabel.attributedText =attri;
     }
     //        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
     self.weiboTextLabel.attributedText = attri;
     
     
     }*/
    
    self.weiboTextLabel.frame = layout.weiboTextFrame;
    //------------------------微博图片------------------------
    //注意使用点语法进行调用 不然会出现图片加载错误
    //判断微博 是否有图片
    
    //------------------------微博图片------------------------
    
    if (_weibo.retweeted_status.bmiddle_pic) {
        
        //        for (UIImageView *iv in _imagesArray) {
        //            iv.frame = CGRectZero;
        //            NSLog(@"转发有图片");
        //        }
        for (int i = 0; i<9; i++) {
            //取出ImageView
            UIImageView *iv = self.imagesArray[i];
            //设置frame
            NSValue *value = layout.imageFrameArray[i];
            CGRect frame = [value CGRectValue];
            iv.frame = frame;
            if (i < _weibo.retweeted_status.pic_urls.count) {
                
                //设置内容
                NSURL *url = [NSURL URLWithString:_weibo.retweeted_status.pic_urls[i][@"thumbnail_pic"]];
                
                [iv sd_setImageWithURL:url];
            }
            
            
        }
        
        
        
    } else if (_weibo.bmiddle_pic) {
        
        for (int i = 0; i < 9; i++) {
            //取出ImageView
            UIImageView *iv = self.imagesArray[i];
            //设置frame
            NSValue *value = layout.imageFrameArray[i];
            CGRect frame = [value CGRectValue];
            iv.frame = frame;
            if (i < _weibo.pic_urls.count) {
                
                //设置内容
                NSURL *url = [NSURL URLWithString:_weibo.pic_urls[i][@"thumbnail_pic"]];
                
                [iv sd_setImageWithURL:url];
            }
            
        }
    } else {
        for (UIImageView *iv in _imagesArray) {
            iv.frame = CGRectZero;
        }
    }
    //-------------------------------转发微博的正文-------------------------------
    self.reWeiboTextlabel.text = _weibo.retweeted_status.text;
    
    
    /* if (_reWeiboTextlabel.text) {
     NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regist options:NSRegularExpressionCaseInsensitive error:nil];
     
     NSArray *array = [regular matchesInString:_reWeiboTextlabel.text options:NSMatchingReportProgress range:NSMakeRange(0, _reWeiboTextlabel.text.length)];
     
     NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:_reWeiboTextlabel.text];
     
     for (NSTextCheckingResult *result in array) {
     
     //检索出的字符串所在的位置
     NSRange range = result.range;
     NSLog(@"range = %@", NSStringFromRange(range));
     
     //获取检索出来的字符串
     NSString *subString = [_reWeiboTextlabel.text substringWithRange:range];
     NSLog(@"subString = %@", subString);
     
     
     ThemeManager *manage  = [ThemeManager shareManager];
     [attri addAttribute:NSForegroundColorAttributeName value:[manage setColorWithName:kHomeTimeLabelTextColor] range:range];
     self.weiboTextLabel.attributedText =attri;
     }
     
     
     
     }
     */
    
    
    
    self.reWeiboTextlabel.frame = layout.weiboReTextFrame;
    //-------------------------------转发微博的背景图片-------------------------------
    //    self.reWeiboBGImageView.backgroundColor = [UIColor redColor];
    self.reWeiboBGImageView.frame = layout.reWeiboBGimageFrame;
    //-------------------------------转发微博里面的内容-------------------------------
    
    
}
- (NSArray *)imagesArray {
    if (_imagesArray == nil) {
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 9; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:imageView];
            [mArray addObject:imageView];
            
            imageView.backgroundColor = [UIColor orangeColor];
            //-------------------------------给图片添加点击事件-------------------------------
            UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewAction:)];
            
            
            tap.numberOfTapsRequired= 1;
            tap.numberOfTouchesRequired=1;
            [imageView addGestureRecognizer:tap];
            
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            
        }
        
        _imagesArray = [mArray copy];
    }
    
    return _imagesArray;
}
#pragma -mark - 打来显示视图的显示
-(void)tapImageViewAction:(UITapGestureRecognizer *)tap{
    
    UIImageView *imageView = (UIImageView *)tap.view;
    
    
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:imageView.tag delegate:self];
    
    //    NSLog(@"TAG = %li",imageView.tag);
}
#pragma mark 实现代理的两个方法
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    
    if (_weibo.retweeted_status.pic_urls.count > 0) {
        //转发微博中的图片
        return _weibo.retweeted_status.pic_urls.count;
    } else {
        //原微博中的图片
        return _weibo.pic_urls.count;
    }
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    WXPhoto *photo = [[WXPhoto alloc]init];
    
    NSString *imageUrlString = nil;
    if (_weibo.retweeted_status.pic_urls.count > 0) {
        //转发微博中的图片
        NSDictionary *dic= _weibo.retweeted_status.pic_urls[index];
        imageUrlString= dic[@"thumbnail_pic"];
    } else {
        //原微博中的图片
        NSDictionary *dic= _weibo.pic_urls[index];
        imageUrlString= dic[@"thumbnail_pic"];
    }
    imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    photo.url  = [NSURL URLWithString:imageUrlString];
    photo.srcImageView = _imagesArray[index];
    return photo;
    
}
#pragma -mark  - 转发微博的图片以及文字
-(WXLabel *)reWeiboTextlabel{
    
    if (_reWeiboTextlabel  == nil) {
        _reWeiboTextlabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        
        _reWeiboTextlabel.font = kReWeiboTextFont;
        _reWeiboTextlabel.numberOfLines = 0;
        _reWeiboTextlabel.wxLabelDelegate=self;
        _reWeiboTextlabel.linespace = 3;
        [self.contentView addSubview:_reWeiboTextlabel];
    }
    return _reWeiboTextlabel;
}
-(ThemeImage *)reWeiboBGImageView{
    
    
    
    if (_reWeiboBGImageView==nil) {
        _reWeiboBGImageView = [[ThemeImage alloc]initWithFrame:CGRectZero];
        _reWeiboBGImageView.imageName =@"timeline_rt_border_selected_9.png";
        _reWeiboBGImageView.topCapHeight = 20;
        _reWeiboBGImageView.leftCapWidth = 27;
        [self.contentView insertSubview:_reWeiboBGImageView atIndex:0];
    }
    
    return _reWeiboBGImageView;
    
}

#pragma mark 创建下面的图片

- (UIImageView *)weiboImageView {
    if (_weiboImageView == nil) {
        _weiboImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_weiboImageView];
        
    }
    
    return _weiboImageView;
}

#pragma mark 懒加载创建子视图
//懒加载模式 创建子视图

- (WXLabel *)weiboTextLabel {
    if (_weiboTextLabel == nil) {
        //创建对象
        _weiboTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _weiboTextLabel.font = kWeiboTextFont;
        //行数
        //        _weiboTextLabel.numberOfLines = 0;
        
        //添加代理
        _weiboTextLabel.wxLabelDelegate = self;
        //设置行间距
        _weiboTextLabel.linespace = 3;
        
        
        //添加视图
        [self.contentView addSubview:_weiboTextLabel];
        
    }
    
    return _weiboTextLabel;
}
#pragma mark - WXLabelDelegate的实现

//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@[\\w-]{2,30}";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#[^#]+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}
//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    return [[ThemeManager  shareManager] setColorWithName:kLinkColor];
    
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    
    return [UIColor redColor];
    
}
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    
    
    if ([context isMatchedByRegex:regex2]) {
        //-------------------------------进行跳转-------------------------------
        WeiboViewController *web = [[WeiboViewController alloc]initWithURL:[NSURL URLWithString:context]];
        web.hidesBottomBarWhenPushed = YES;
        UIResponder *nextresponder = self.nextResponder;
        while (nextresponder) {
            if ([nextresponder isKindOfClass:[UINavigationController class]]) {
                
                
                UINavigationController *nav = (UINavigationController *)nextresponder;
                
                [nav pushViewController:web animated:YES];
                break;
            }
            else{
                
                nextresponder= nextresponder.nextResponder;
            }
        }
        
        
    }
    
}
@end

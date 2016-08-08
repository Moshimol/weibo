//
//  WeiboCellLauout.m
//  weibo
//
//  Created by lushitong on 16/8/3.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "WeiboCellLauout.h"
#import "WXLabel.h"
@interface WeiboCellLauout(){
    CGFloat _cellHeight;
}
@end
@implementation WeiboCellLauout
+(instancetype)layoutWithWeiboModel:(WeiboModel *)weibo{
    
    WeiboCellLauout *layout = [[WeiboCellLauout alloc]init];
    if (layout) {
        layout.weibo = weibo;
        
    }
    return layout;
}

-(void)setWeibo:(WeiboModel *)weibo{
    
    if (_weibo == weibo) {
        return;
    }
    _weibo= weibo;
    
    //-------------------------------计算Frame-------------------------------
    _cellHeight = 0;
    _cellHeight +=CellTopViewheight;
    _cellHeight +=SpaceWidth;
    //-------------------------------微博正文-------------------------------
    NSDictionary *attributes=@{NSFontAttributeName:kWeiboTextFont};
    
    //    CGRect rect = [_weibo.text boundingRectWithSize:CGSizeMake(kScreenwidth-20, 1000)
    //                                            options:NSStringDrawingUsesLineFragmentOrigin
    //                                         attributes:attributes
    //                                            context:nil ];
    //    
    //    CGFloat weiboTextHeight = rect.size.height;
    
    
    //    CGFloat weiboTextHeight = [WXLabel getTextHeight:kWeiboTextFont.pointSize width:kScreenwidth - 2 * SpaceWidth text:_weibo.text linespace:3];
    
    
    CGFloat weiboTextHeight = [WXLabel getTextHeight:kWeiboTextFont.pointSize width:kScreenwidth -2*SpaceWidth text:_weibo.text lineSpace:3];
    weiboTextHeight+=2;
    _weiboTextFrame = CGRectMake(SpaceWidth, CellTopViewheight+SpaceWidth, kScreenwidth - 2*SpaceWidth, weiboTextHeight);
    _cellHeight += weiboTextHeight;
    _cellHeight += SpaceWidth;
    
    
    //-------------------------------计算转发微博的大小-------------------------------
    if (_weibo.retweeted_status) {
        
        attributes=@{NSFontAttributeName:kReWeiboTextFont};
        //        
        //        CGFloat reWeiboTextHeight = [WXLabel getTextHeight:kReWeiboTextFont.pointSize
        //                                                     width:kScreenwidth - 4 * SpaceWidth
        //                                                      text:_weibo.retweeted_status.text
        //                                                 linespace:3];
        CGFloat reweiboTextHeight = [WXLabel getTextHeight:kReWeiboTextFont.pointSize width:kScreenwidth - 4*SpaceWidth text:_weibo.retweeted_status.text lineSpace:3];
        
        reweiboTextHeight+=2;
        
        _weiboReTextFrame = CGRectMake(2*SpaceWidth, _cellHeight, kScreenwidth - 4*SpaceWidth, reweiboTextHeight-SpaceWidth);
        
        _cellHeight += reweiboTextHeight;
        _cellHeight += SpaceWidth;
        
        
        //-------------------------------背景的图片-------------------------------
        _reWeiboBGimageFrame =CGRectMake(SpaceWidth, _weiboReTextFrame.origin.y - SpaceWidth, kScreenwidth - 2*SpaceWidth, 2*SpaceWidth + _weiboReTextFrame.size.height);
        _cellHeight += SpaceWidth;
        
        if (_weibo.retweeted_status.pic_urls) {
            //            NSLog(@"有转发微博 而且有图片");
            //            NSLog(@"%@",_weibo.retweeted_status.pic_urls);
            //-------------------------------转发的微博存在 而且也有图片-------------------------------
            CGFloat imageHeight = [self layoutNineImageViewFrameWithImageCount:_weibo.retweeted_status.pic_urls.count viewWidth:kScreenwidth - 4*SpaceWidth top:(CGRectGetMaxY(_weiboReTextFrame)+SpaceWidth)];
            
            _reWeiboBGimageFrame =CGRectMake(SpaceWidth, _weiboReTextFrame.origin.y - SpaceWidth, kScreenwidth - 2*SpaceWidth, 3*SpaceWidth + _weiboReTextFrame.size.height+imageHeight);
            
            _cellHeight += imageHeight;
            _cellHeight += SpaceWidth;
        }
        else{
            _weiboimageFrame =CGRectZero;
        }
        
        
    }else{
        //-------------------------------没有转发微博-------------------------------
        _weiboReTextFrame =CGRectZero;
        _reWeiboBGimageFrame=CGRectZero;
        
        if (_weibo.pic_urls.count>0) {
            CGFloat imageHeight = [self layoutNineImageViewFrameWithImageCount:_weibo.pic_urls.count viewWidth:(kScreenwidth - 2*SpaceWidth) top:(CGRectGetMaxY(_weiboTextFrame)+SpaceWidth)];
            _cellHeight += imageHeight;
            _cellHeight +=SpaceWidth;
        }
        else{
            
            _imageFrameArray = nil;
        }
        
    }
    
    
}
-(CGFloat)cellHeight{
    
    return _cellHeight;
}
/**
 *  布局的九宫格
 *
 *  @param imageCount 图片的数量
 *  @param viweWidth  整个视图的总宽度
 *  @param top        顶部图片的y值
 *
 *  @return 视图的总高度，计算单元格的y值
 */
-(CGFloat)layoutNineImageViewFrameWithImageCount:(NSInteger)imageCount
                                       viewWidth:(CGFloat)viewWidth
                                             top:(CGFloat)top{
    
    
    if (imageCount > 9 || imageCount<=0) {
        _imageFrameArray = nil;
        return 0;
        
    }
    CGFloat viewHeight;
    CGFloat imageWidth;
    NSInteger numberOfColum = 2;
    if (imageCount == 1) {
        numberOfColum=1;
        imageWidth =viewWidth;
        viewHeight =viewWidth;
    }else if (imageCount==2){
        
        imageWidth = (viewWidth -ImageViewSpace)/2;
        viewHeight = imageWidth;
    }else if (imageCount==4){
        imageWidth = (viewWidth -ImageViewSpace)/2;
        viewHeight = viewWidth;
    } else {
        //三列
        imageWidth = (viewWidth - 2 * ImageViewSpace) / 3;
        numberOfColum = 3;
        if (imageCount == 3) {
            //一行
            viewHeight = imageWidth;
        } else if (imageCount <= 6) {
            //两行
            viewHeight = imageWidth * 2 + ImageViewSpace;
        } else {
            //三行
            viewHeight = viewWidth;
        }
    }
    //布局视图
    //1.初始化Array
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    
    //2.循环创建frame
    for (int i = 0; i < 9; i++) {
        
        //如果循环次数大于了图片数量
        if (i >= imageCount) {
            //添加一个空的frame 到数组中去，表示此视图不需要显示
            CGRect frame = CGRectZero;
            [mArray addObject:[NSValue valueWithCGRect:frame]];
        } else {
            //计算当前视图，是第几行第几列
            NSInteger row = i / numberOfColum;
            NSInteger column = i % numberOfColum;
            //计算视图的frame
            //x = 列号 * (图片宽度 ＋ 空隙宽度) + leftSpace
            //y = 行号 * (图片宽度 ＋ 空隙宽度) + top
            CGFloat width = imageWidth + ImageViewSpace;
            CGFloat left = (kScreenwidth - viewWidth) / 2;
            CGRect frame = CGRectMake(column * width + left, row * width + top, imageWidth, imageWidth);
            
            [mArray addObject:[NSValue valueWithCGRect:frame]];
        }
        
        
        
    }
    //3.包装成NSValue 添加到数组中
    _imageFrameArray = [mArray copy];
    
    return viewHeight;
}

@end

//
//  EmoticonInputView.m
//  weibo
//
//  Created by lushitong on 16/8/10.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "EmoticonInputView.h"
#import "YYModel.h"
#import "Emoticon.h"
#import "EmoticonView.h"

@implementation EmoticonInputView

- (instancetype)initWithFrame:(CGRect)frame {
    //强制修改高度
    frame.size.height = kEmoticonInputViewHeight;
    //原点位置设置为0
    frame.origin = CGPointZero;
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        [self loadData];
        
        [self createScrollView];
        [self createPageView];
        
    }
    
    return self;
}
#pragma -mark 创建底部pageViw
-(void)createPageView{
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kPageControllerHeight)];
    [_scrollView addSubview:page];
    
}
//读取表情数据
- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    //遍历和数据解析
    for (NSDictionary *dic in array) {
        Emoticon *e = [Emoticon yy_modelWithJSON:dic];
        
        [mArray addObject:e];
    }
    
    _emoticonsArray = [mArray copy];
    
}


//创建滑动视图
- (void)createScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrollViewHeight)];
    [self addSubview:_scrollView];
    
    //设置滑动视图
    //分页滑动
    _scrollView.pagingEnabled = YES;
    //隐藏滑动条
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    
    //分配表情
    //总页数
    
    NSInteger pageCount = (_emoticonsArray.count - 1) / 32 + 1;
    NSLog(@"pageCount = %li", pageCount);
    for (int i = 0; i < pageCount; i++) {
        //第i页 (i * 32) - ((i + 1) * - 1)
        //0-31
        //32-63
        EmoticonView *emoticonView = [[EmoticonView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScrollViewHeight)];
        
        //表情数组分割
        NSRange range = NSMakeRange(i * 32, 32);
        //判断是否超出范围
        if (range.location + range.length > _emoticonsArray.count) {
            //调整分割的长度
            range.length = _emoticonsArray.count - range.location;
        }
        NSArray *subarray = [_emoticonsArray subarrayWithRange:range];
        
        //设置每一页所显示的表情
        emoticonView.emoticonsArray = subarray;
        
        [_scrollView addSubview:emoticonView];
        
        
    }
    
    //设置滑动范围
    _scrollView.contentSize = CGSizeMake(pageCount * kScreenWidth, 0);
    
    
}




@end

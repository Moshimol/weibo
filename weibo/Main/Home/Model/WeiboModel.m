//
//  WeiboModel.m
//  weibo
//
//  Created by lushitong on 16/8/2.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"
@implementation WeiboModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    //获取字符串
    NSString *weiboText = [self.text copy];
    
    //字符串内容替换
    //  [兔子]  --> <image url = '001.png'>
    //1.使用正则表达式，查找表情字符串
    NSString *regex = @"\\[\\w+\\]";
    NSArray *array = [weiboText componentsMatchedByRegex:regex];
    
    //2.到plist文件中，查找表情是否存在
    //读取Plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    for (NSString *str in array) {
        //使用谓词，来查找
        NSString *s = [NSString stringWithFormat:@"chs='%@'", str];
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:s];
        //谓词过滤
        NSArray *result = [emoticons filteredArrayUsingPredicate:pre];
        
        //获取过滤结果
        NSDictionary *dic = [result firstObject];
        
        if (dic == nil) {
            //表情在列表中不存在，则忽略此表情
            continue;
        }
        
        //3.如果表情存在，则获取表情文件名，按照格式替换
        NSString *imageName = dic[@"png"];
        //替换后的字符串
        NSString *imageString = [NSString stringWithFormat:@"<image url = '%@'>", imageName];
        //替换字符串
        weiboText = [weiboText stringByReplacingOccurrencesOfString:str withString:imageString];
        NSLog(@"替换成功 %@", str);
    }
    
    
    
    
    //重新设置text
    self.text = [weiboText copy];
    
    
    return YES;
}

@end

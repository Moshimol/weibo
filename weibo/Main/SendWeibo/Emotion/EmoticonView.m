//
//  EmoticonView.m
//  weibo
//
//  Created by lushitong on 16/8/10.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "EmoticonView.h"
#import "EmoticonInputView.h"
#import "Emoticon.h"

@implementation EmoticonView


- (void)drawRect:(CGRect)rect {
    
    //_emoticonsArray
    if (_emoticonsArray == nil || _emoticonsArray.count == 0) {
        return;
    }
    
    //4行 8列
    //i表示第几行 j表示第几列
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 8; j++) {
            
            NSInteger index = i * 8 + j;
            if (index >= _emoticonsArray.count) {
                //表情绘制完毕
                return;
            }
            //计算图像绘制的frame
            CGRect rect = CGRectMake(j * kEmoticonWidth + 5, i * kEmoticonWidth + 5, kEmoticonWidth - 10, kEmoticonWidth - 10);
            //获取表情对象
            Emoticon *emoticon = _emoticonsArray[index];
            //获取图片
            UIImage *image = [emoticon emoticonImage];
            //绘制图片
            [image drawInRect:rect];
        }
    }
    
    
}

- (void)setEmoticonsArray:(NSArray *)emoticonsArray {
    //改变数组内容  重新绘制
    if (_emoticonsArray != emoticonsArray && emoticonsArray.count > 0 && emoticonsArray.count <= 32) {
        _emoticonsArray = [emoticonsArray copy];
        
        //刷新界面
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取手指触摸位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //根据手指位置，判断表情
    int i = point.y / kEmoticonWidth;
    int j = point.x / kEmoticonWidth;
    NSInteger index = i * 8 + j;
    
    //    NSLog(@"%li", index);
    
    //获取表情
    if (index < _emoticonsArray.count) {
        Emoticon *e = _emoticonsArray[index];
        NSLog(@"%@", e.chs);
        
        //-------------------------------发送通知，把点击的文字显示上去-------------------------------
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kdidTextWeibo object:self userInfo:@{@"chs":e.chs}];
        
    }
    
}


@end

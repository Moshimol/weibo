//
//  WeiboViewController.h
//  weibo
//
//  Created by lushitong on 16/8/6.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "BaseViewController.h"

@interface WeiboViewController : BaseViewController
@property (nonatomic,strong) NSURL *url;



-(instancetype)initWithURL:(NSURL *)url;
@end

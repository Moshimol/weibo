//
//  LocationViewController.h
//  weibo
//
//  Created by lushitong on 16/8/8.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^LocationResultBlock)(NSDictionary *result);
@interface LocationViewController : BaseViewController



@property (nonatomic, copy) LocationResultBlock block;

- (void)addLocationResultBlock:(LocationResultBlock)block;

@end

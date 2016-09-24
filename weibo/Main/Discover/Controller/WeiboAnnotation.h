//
//  WeiboAnnotation.h
//  weibo
//
//  Created by lushitong on 16/8/10.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"
@interface WeiboAnnotation : NSObject<MKAnnotation>
//表示标注视图，在地图中显示的位置
//这个属性，一般不会手动 读取，而是在MapView中，自动读取这个属性来设置标注视图的位置
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

//可选的
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

//微博对象
@property (nonatomic, strong, nullable) WeiboModel *weiboModel;



@end

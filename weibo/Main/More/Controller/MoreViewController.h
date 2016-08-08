//
//  MoreViewController.h
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UITableViewController
@property (weak, nonatomic) IBOutlet ThemeImage *icon1;
@property (weak, nonatomic) IBOutlet ThemeImage *icon2;
@property (weak, nonatomic) IBOutlet ThemeImage *icon3;
@property (weak, nonatomic) IBOutlet ThemeImage *icon4;

@property (weak, nonatomic) IBOutlet ThemeLabel *label1;

@property (weak, nonatomic) IBOutlet ThemeLabel *lable2;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *lable3;
@property (weak, nonatomic) IBOutlet ThemeLabel *lable4;
@property (weak, nonatomic) IBOutlet ThemeLabel *lable5;
@property (weak, nonatomic) IBOutlet ThemeLabel *lable6;

@end

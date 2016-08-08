//
//  WeiboViewController.m
//  weibo
//
//  Created by lushitong on 16/8/6.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "WeiboViewController.h"

@interface WeiboViewController ()

@end

@implementation WeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, kScreenheight-64)];
    //
    NSURL *u = self.url;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:u];
    
    [webView loadRequest:request];
    
    
    [self.view addSubview:webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWithURL:(NSURL *)url{
    
    self  = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}
@end

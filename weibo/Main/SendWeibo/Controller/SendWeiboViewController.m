//
//  SendWeiboViewController.m
//  weibo
//
//  Created by lushitong on 16/8/8.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "ThemButton.h"
#import "AppDelegate.h"
#import "LocationViewController.h"
@class ThemButton;
#define kToolViewHeight 40
#define kSendWeiboAPI @"statuses/update.json"
#define kSendWeiboPhotoApi @"statuses/upload.json"
@interface SendWeiboViewController ()<SinaWeiboRequestDelegate>{
    
    UITextView *_inputTextView; //输入框
    UIView *_toolView;          //工具视图
}

@end

@implementation SendWeiboViewController
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.s
    self.title=@"发送微博";
    [self createNavigationBarButton];
    [self creatrInputView];
    [self createToolView];
    
    
}

- (void)creatrInputView {
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - kToolViewHeight)];
    //    _inputTextView.backgroundColor = [UIColor orangeColor];
    _inputTextView.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:_inputTextView];
    
    //监听键盘的改变
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [center addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)createToolView {
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolViewHeight)];
    _toolView.top = _inputTextView.bottom;
    NSArray *imageArray= @[@"compose_toolbar_1.png",
                           @"compose_toolbar_3.png",
                           @"compose_toolbar_4.png",
                           @"compose_toolbar_5.png",
                           @"compose_toolbar_6.png",
                           
                           ];
    //    [_toolView addSubview:button];
    for (int i = 0; i<5; i++) {
        ThemButton *button  =[ThemButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(i*kScreenWidth/5,0 , kScreenWidth/5, kToolViewHeight);
        button.imageName = imageArray[i];
        [_toolView addSubview:button];
        button.tag = i;
        
        [button addTarget:self action:@selector(toolBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self.view addSubview:_toolView];
    
}
#pragma -mark 点击位置进入位置选择界面
- (void)toolBarButtonAction:(UIButton *)button {
    if (button.tag == 4) {
        //打开定位界面
        LocationViewController *locaiton = [[LocationViewController alloc] init];
        
        [self.navigationController pushViewController:locaiton animated:YES];
        
    }
}

#pragma -mark 键盘发生改变调用的事件
- (void)keyboardFrameChanged:(NSNotification *)notification {
    
    //获取键盘的状态
    //键盘改变后的结束值
    NSValue *value = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    
    //根据键盘的位置，来改变视图的位置
    _inputTextView.height = kScreenHeight - 64 - kToolViewHeight - keyboardFrame.size.height;
    //工具栏
    _toolView.top = _inputTextView.bottom;
    
}

- (void)keyboardHide:(NSNotification *)notification {
    
    _inputTextView.height = kScreenHeight - 64 - kToolViewHeight;
    _toolView.top = _inputTextView.bottom;
    
}
#pragma -mark 创建底部视图上的按钮

-(void)createNavigationBarButton{
    
    ThemButton *leftButton = [ThemButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame  = CGRectMake(0, 0, 64, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.backgroundImageName = @"titlebar_button_9";
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    //右边
    ThemButton *rightButton = [ThemButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame  = CGRectMake(0, 0, 64, 44);
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    rightButton.backgroundImageName = @"titlebar_button_9";
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark 发送按钮和取消按钮的创建
-(void)leftButtonAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightButtonAction{
    NSString *text  = [_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"没有微博正文" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    SinaWeibo *wb  = kSinaWeiboObject;
    
    NSDictionary *params = @{@"status":text};
    
    [wb requestWithURL:kSendWeiboAPI params: [params mutableCopy] httpMethod:@"POST" delegate:self];
    
}
- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse  *respon = (NSHTTPURLResponse *)response;
    
    if (respon.statusCode == 200) {
        NSLog(@"发送成功");
        _inputTextView.text = nil;
        //发送通知
        
        [_inputTextView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
            NSNotification *notice = [NSNotification notificationWithName:kdidSendWeibo object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }];
        
        
        
    }
    
}

@end

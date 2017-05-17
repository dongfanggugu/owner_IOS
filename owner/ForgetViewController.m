//
//  ForgetViewController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()

@property (strong, nonatomic) UITextField *textField;

@end

@implementation ForgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"忘记密码"];
    [self initView];
}


- (void)initView
{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(16, 90, self.screenWidth - 32, 35)];
    _textField.font = [UIFont systemFontOfSize:13];
    _textField.keyboardType = UIKeyboardTypePhonePad;
    
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 35)];
    
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 5;
    
    _textField.layer.borderWidth = 1;
    _textField.layer.borderColor = [Utils getColorByRGB:@"#E1E1E1"].CGColor;
    
    _textField.placeholder = @"请输入您注册时的手机号码";
    
    [self.view addSubview:_textField];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setTitle:@"忘记密码" forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [btn setBackgroundColor:[Utils getColorByRGB:TITLE_COLOR]];
    
    btn.center = CGPointMake(self.screenWidth / 2, 155);
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    
    [btn addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)forget
{
    NSString *tel = _textField.text;
    
    if (0 == tel.length) {
        [HUDClass showHUDWithText:@"请正确输入您注册的手机号码"];
        
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"tel"] = tel;
    
    [[HttpClient shareClient] post:URL_PWD_FORGET parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [HUDClass showHUDWithText:@"密码重置成功,请及时检查您的短信通知"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}



@end

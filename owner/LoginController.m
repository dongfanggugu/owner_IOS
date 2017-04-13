//
//  LoginController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/6.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginController.h"
#import "JPUSHService.h"

@interface LoginController()

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UITextField *tfUser;

@property (weak, nonatomic) IBOutlet UITextField *tfPwd;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)initView
{
    _tfUser.leftViewMode = UITextFieldViewModeAlways;
    _tfUser.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, _tfUser.frame.size.height)];
    
    _tfUser.layer.borderWidth = 1;
    _tfUser.layer.borderColor = [UIColor whiteColor].CGColor;
    _tfUser.layer.masksToBounds = YES;
    _tfUser.layer.cornerRadius = 5;
    
    
    _tfPwd.leftViewMode = UITextFieldViewModeAlways;
    _tfPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, _tfPwd.frame.size.height)];
    
    _tfPwd.layer.borderWidth = 1;
    _tfPwd.layer.borderColor = [UIColor whiteColor].CGColor;
    _tfPwd.layer.masksToBounds = YES;
    _tfPwd.layer.cornerRadius = 5;
    
    _btnLogin.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = 18;
    
    NSString *userName = [[Config shareConfig] getUserName];
    if (userName.length > 0)
    {
        _tfUser.text = userName;
    }
    
    [_btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnRegister addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
}

- (void)login
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tel"] = _tfUser.text;
    params[@"password"] = [Utils md5:_tfPwd.text];
    
    
    [[HttpClient shareClient] view:self.view post:@"smallOwnerLogin" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *head = [responseObject objectForKey:@"head"];
        NSDictionary *body = [responseObject objectForKey:@"body"];
        
        [[Config shareConfig] setToken:[head objectForKey:@"accessToken"]];
        [[Config shareConfig] setBranchAddress:[body objectForKey:@"address"]];
        [[Config shareConfig] setLat:[[body objectForKey:@"lat"] floatValue]];
        [[Config shareConfig] setLng:[[body objectForKey:@"lng"] floatValue]];
        [[Config shareConfig] setName:[body objectForKey:@"name"]];
        [[Config shareConfig] setUserId:[body objectForKey:@"userId"]];
        [[Config shareConfig] setSex:[body objectForKey:@"sex"]];
        [[Config shareConfig] setTel:[body objectForKey:@"tel"]];
        [[Config shareConfig] setUserName:[body objectForKey:@"userName"]];
        [[Config shareConfig] setBranchName:[body objectForKey:@"cellName"]];
        [[Config shareConfig] setBrand:[body objectForKey:@"brand"]];
        [[Config shareConfig] setLiftType:[body objectForKey:@"model"]];
        
        [self registerJpush];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
    
}

- (void)registerUser
{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"register_controller"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}


- (void)registerJpush
{
    NSLog(@"registerJpush");
    [JPUSHService setTags:nil alias:[[Config shareConfig] getToken] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"zhenhao---rescode: %d, tags: %@, alias: %@", iResCode, iTags , iAlias);
        
        if (0 == iResCode)
        {
            NSLog(@"zhenhao:jpush register successfully!");
        }
        else
        {
            NSString *err = [NSString stringWithFormat:@"%d:注册消息服务器失败，请重新再试", iResCode];
            NSLog(@"zhenhao:%@", err);
            
        }
    }];
}

@end

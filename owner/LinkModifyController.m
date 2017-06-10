//
//  LinkModifyController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/19.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "LinkModifyController.h"

@interface LinkModifyController ()

@property (strong, nonatomic) UITextField *tfName;

@property (strong, nonatomic) UITextField *tfTel;

@end

@implementation LinkModifyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"联系人修改"];
    [self initView];
}


- (void)initView
{
    _tfName = [[UITextField alloc] initWithFrame:CGRectMake(8, 70, self.screenWidth - 16, 30)];
    _tfName.leftViewMode = UITextFieldViewModeAlways;

    _tfName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];

    NSString *linkName = [Config shareConfig].linkName;

    _tfName.text = 0 == linkName.length ? [Config shareConfig].getName : linkName;

    _tfName.font = [UIFont systemFontOfSize:13];

    _tfName.layer.masksToBounds = YES;
    _tfName.layer.cornerRadius = 5;

    _tfName.layer.borderWidth = 1;
    _tfName.layer.borderColor = [Utils getColorByRGB:@"#cccccc"].CGColor;

    [self.view addSubview:_tfName];


    _tfTel = [[UITextField alloc] initWithFrame:CGRectMake(8, 110, self.screenWidth - 16, 30)];
    _tfTel.leftViewMode = UITextFieldViewModeAlways;

    _tfTel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];

    NSString *linkTel = [Config shareConfig].linkTel;

    _tfTel.text = 0 == linkTel.length ? [[Config shareConfig] getTel] : linkTel;

    _tfTel.keyboardType = UIKeyboardTypePhonePad;

    _tfTel.font = [UIFont systemFontOfSize:13];

    _tfTel.layer.masksToBounds = YES;
    _tfTel.layer.cornerRadius = 5;

    _tfTel.layer.borderWidth = 1;
    _tfTel.layer.borderColor = [Utils getColorByRGB:@"#cccccc"].CGColor;

    [self.view addSubview:_tfTel];


    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    btn.titleLabel.font = [UIFont systemFontOfSize:13];

    btn.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];

    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;

    btn.center = CGPointMake(self.screenWidth / 2, 180);

    [self.view addSubview:btn];

    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];

}


- (void)submit
{
    NSString *name = _tfName.text;
    NSString *tel = _tfTel.text;

    if (0 == name.length || 0 == tel.length)
    {
        [HUDClass showHUDWithText:@"请正确填写联系人信息"];
        return;
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];


    params[@"contacts"] = name;
    params[@"contactsTel"] = tel;

    params[@"lat"] = [NSNumber numberWithFloat:0];
    params[@"lng"] = [NSNumber numberWithFloat:0];


    __weak typeof(self) weakSelf = self;

    [[HttpClient shareClient] post:URL_PERSON_MODIFY parameters:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               [Config shareConfig].linkName = name;
                               [Config shareConfig].linkTel = tel;
                               [HUDClass showHUDWithText:@"联系人修改成功"];
                               if (_delegate && [_delegate respondsToSelector:@selector(onModifyComplete:tel:)])
                               {
                                   [_delegate onModifyComplete:name tel:tel];

                               }
                               [weakSelf.navigationController popViewControllerAnimated:YES];

                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {

            }];
}

@end

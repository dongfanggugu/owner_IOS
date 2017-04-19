//
//  PersonModifyController.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/24.
//
//

#import <Foundation/Foundation.h>
#import "PersonModifyController.h"
#import "DownPicker.h"
#import "Utils.h"
#import "HttpClient.h"
#import "BrandListResponse.h"
#import "ListDialogView.h"


@interface PersonModifyController()<ListDialogViewDelegate>

@property (strong, nonatomic) NSString *enterType;

@property (weak, nonatomic) IBOutlet UITextField *textFieldContent;

@property (strong, nonatomic) DownPicker *downPicker;

@property (strong, nonatomic) UILabel *lbBrand;

@end


@implementation PersonModifyController

@synthesize enterType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleRight];
    [self initView];
}

/**
 *  初始化视图
 */
- (void)initView
{
    
    if ([enterType isEqualToString:@"brand"])
    {
        [self setTitleString:@"电梯品牌"];
        
        [_textFieldContent removeFromSuperview];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(15, 70, 5, 28)];
        leftView.backgroundColor = [Utils getColorByRGB:@"#EFEFF4"];
        [self.view addSubview:leftView];
        
        _lbBrand = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, self.view.frame.size.width - 40, 28)];
        
        _lbBrand.backgroundColor = [Utils getColorByRGB:@"#EFEFF4"];
        
        _lbBrand.font = [UIFont systemFontOfSize:14];
        
        _lbBrand.text = [[Config shareConfig] getBrand];
        
        
        _lbBrand.userInteractionEnabled = YES;
        
        [_lbBrand addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selBrand)]];
        
        [self.view addSubview:_lbBrand];
    }
    else
    {
        //设置左右边框，看起来美观
        UIView *padView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        self.textFieldContent.leftView = padView;
        self.textFieldContent.leftViewMode = UITextFieldViewModeAlways;
        
        self.textFieldContent.rightView = padView;
        self.textFieldContent.rightViewMode = UITextFieldViewModeAlways;
        
        if ([enterType isEqualToString:@"name"])
        {
            [self setTitleString:@"姓名"];
            self.textFieldContent.text = [[Config shareConfig] getName];
            
        }
        else if ([enterType isEqualToString:@"branch_name"])
        {
            [self setTitleString:@"小区名称"];
            _textFieldContent.text = [[Config shareConfig] getBranchName];
        }
        
        else if ([enterType isEqualToString:@"model"])
        {
            [self setTitleString:@"电梯型号"];
            _textFieldContent.text = [[Config shareConfig] getLiftType];
        }
    }
}

/**
 *  设置标题
 *
 *  @param title <#title description#>
 */
- (void)setTitleString:(NSString *)title {
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelTitle.text = title;
    labelTitle.font = [UIFont fontWithName:@"System" size:17];
    labelTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:labelTitle];
}

/**
 *  设置标题栏右侧
 */
- (void)setTitleRight {
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSubmit];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  提交到服务器
 */
- (void)submit {
    
    if ([enterType isEqualToString:@"brand"])
    {
        NSString *content = _lbBrand.text;
        
        if (0 == content.length)
        {
            [HUDClass showHUDWithText:@"输入不能为空,请重新输入!"];
            return;
        }
        
        [self submitKey:@"brand" value:content];
    }
    else
    {
        NSString *content = self.textFieldContent.text;
        if (0 == content.length)
        {
            [HUDClass showHUDWithText:@"输入不能为空,请重新输入!"];
            return;
        }
        
        
        if ([enterType isEqualToString:@"name"])
        {
            [self submitKey:@"name" value:content];
        }
        else if ([enterType isEqualToString:@"branch_name"])
        {
            [self submitKey:@"cellName" value:content];
        }
        
        else if ([enterType isEqualToString:@"model"])
        {
            [self submitKey:@"model" value:content];
        }
    }
}

- (void)selBrand
{
    [[HttpClient shareClient] post:URL_LIFT_BRAND parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        BrandListResponse *response = [[BrandListResponse alloc] initWithDictionary:responseObject];
        [self showBrandList:[response getBrandList]];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

- (void)showBrandList:(NSArray<ElevatorBrandInfo *> *)arrayBrand
{
    ListDialogView *dialog = [ListDialogView viewFromNib];
    dialog.delegate = self;
    [dialog setArrayData:arrayBrand];
    [self.view addSubview:dialog];
}

- (void)submitKey:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:value forKey:key];
    
    params[@"lat"] = [NSNumber numberWithFloat:0];
    params[@"lng"] = [NSNumber numberWithFloat:0];

    
    __weak PersonModifyController *weakSelf = self;
    
    [[HttpClient shareClient] post:URL_PERSON_MODIFY parameters:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        //更新本地存储的个人信息
        
        if ([key isEqualToString:@"name"])
        {
            [[Config shareConfig] setName:value];
        }
        else if ([key isEqualToString:@"cellName"])
        {
            [[Config shareConfig] setBranchName:value];

        }
        else if ([key isEqualToString:@"brand"])
        {
             [[Config shareConfig] setBrand:value];
        }
        else if ([key isEqualToString:@"model"])
        {
            [[Config shareConfig] setLiftType:value];
        }
       
        [HUDClass showHUDWithText:@"修改成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

#pragma mark - ListDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    _lbBrand.text = content;
}

@end

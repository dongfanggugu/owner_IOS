//
//  EnsuranceMainController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "EnsuranceMainController.h"
#import "KeyValueCell.h"
#import "KeyEditCell.h"
#import "EnsuranceController.h"

@interface EnsuranceMainController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) KeyEditCell *nameCell;

@property (weak, nonatomic) KeyEditCell *telCell;

@property (weak, nonatomic) KeyEditCell *addCell;

@end

@implementation EnsuranceMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"一元大保障"];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_custom_service"]];
    [self initView];
}

- (void)onClickNavRight
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", Custom_Service]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:webView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64) style:UITableViewStylePlain];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    [self.view addSubview:_tableView];


    //headview
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];

    _tableView.tableHeaderView = headView;

    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];

    iv.image = [UIImage imageNamed:@"icon_ensurance"];

    [headView addSubview:iv];

    //footview
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 150)];

    _tableView.tableFooterView = footView;

    UIButton *btnDetail = [[UIButton alloc] initWithFrame:CGRectMake(4, 0, 80, 30)];
    [btnDetail setTitle:@"查看保险单" forState:UIControlStateNormal];
    [btnDetail.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnDetail setTitleColor:[Utils getColorByRGB:TITLE_COLOR] forState:UIControlStateNormal];

    [btnDetail addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnDetail];


    UIButton *btnEnsure = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [btnEnsure setTitle:@"我要保障全家安全" forState:UIControlStateNormal];
    [btnEnsure.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnEnsure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEnsure setBackgroundColor:[Utils getColorByRGB:TITLE_COLOR]];
    btnEnsure.layer.masksToBounds = YES;
    btnEnsure.layer.cornerRadius = 15;
    btnEnsure.center = CGPointMake(self.screenWidth / 2, 80);

    [btnEnsure addTarget:self action:@selector(clickEnsure) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnEnsure];
}

- (void)clickDetail
{
    EnsuranceController *controller = [[EnsuranceController alloc] init];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickEnsure
{
    NSString *name = nil;

    NSString *tel = nil;


    if (!self.login)
    {
        name = _nameCell.tfValue.text;

        tel = _telCell.tfValue.text;

    }
    else
    {
        name = [[Config shareConfig] getName];

        tel = [[Config shareConfig] getTel];
    }

    if (0 == name.length)
    {
        [HUDClass showHUDWithText:@"请先填写您的姓名"];
        return;

    }
    else if (0 == tel.length)
    {
        [HUDClass showHUDWithText:@"请填写您的联系方式"];
        return;

    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    param[@"name"] = name;

    param[@"tel"] = tel;

    __weak typeof(self) weakSelf = self;
    [[HttpClient shareClient] post:@"addGuarantee" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = @"已经提交您的申请,请等待相关人员联系您!";
        [weakSelf showMsgAlert:msg];
    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 2;

    }
    else
    {
        return 1;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.login)
    {

        KeyValueCell *cell = [KeyValueCell cellFromNib];
        cell.lbValue.textAlignment = NSTextAlignmentRight;

        if (0 == indexPath.section && 0 == indexPath.row)
        {
            cell.lbKey.text = @"姓名";
            cell.lbValue.text = [[Config shareConfig] getName];

        }
        else if (0 == indexPath.section && 1 == indexPath.row)
        {
            cell.lbKey.text = @"联系方式";
            cell.lbValue.text = [[Config shareConfig] getTel];

        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else
    {
        if (0 == indexPath.section && 0 == indexPath.row)
        {

            if (_nameCell)
            {
                return _nameCell;

            }
            else
            {
                KeyEditCell *cell = [KeyEditCell cellFromNib];
                _nameCell = cell;
                cell.lbKey.text = @"姓名";
                cell.tfValue.placeholder = @"请填写姓名";

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }
        }
        else if (0 == indexPath.section && 1 == indexPath.row)
        {

            if (_telCell)
            {
                return _telCell;

            }
            else
            {
                KeyEditCell *cell = [KeyEditCell cellFromNib];
                _telCell = cell;

                cell.lbKey.text = @"联系方式";
                cell.tfValue.placeholder = @"请填写联系方式";

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [KeyValueCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


@end

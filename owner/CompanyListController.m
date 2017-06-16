//
//  CompanyListController.m
//  owner
//
//  Created by 长浩 张 on 2017/6/2.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "CompanyListController.h"
#import "CompanyInfoCell.h"
#import "KnowledgeDetailController.h"

@interface CompanyListController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation CompanyListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保公司选择"];

    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayBranch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompanyInfoCell identifier]];

    if (!cell)
    {
        cell = [CompanyInfoCell cellFromNib];
    }

    NSDictionary *info = self.arrayBranch[indexPath.row];

    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    cell.lbContent.text =  info[@"name"];

    __weak typeof(self) weakSelf = self;

    [cell setOnClickDetail:^{
        KnowledgeDetailController *controller = [[KnowledgeDetailController alloc] init];

        controller.knTitle = info[@"name"];
        controller.content = info[@"companyDetail"];

        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CompanyInfoCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(onChoose:name:)])
    {
        [_delegate onChoose:indexPath.row name:self.arrayBranch[indexPath.row][@"name"]];
    }

    [self.navigationController popViewControllerAnimated:YES];
}


@end

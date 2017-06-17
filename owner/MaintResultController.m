//
//  MaintResultController.m
//  owner
//
//  Created by changhaozhang on 2017/6/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintResultController.h"
#import "MaintResultView.h"

@interface MaintResultController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MaintResultController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保结果"];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    tableView.delegate = self;
    tableView.dataSource = self;

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];

    //加载结果页面
    MaintResultView *resultView = [MaintResultView viewFromNib];

    resultView.tvContent.text = self.maintContent;

    if (_urlBefore.length)
    {
        [resultView.ivBefore setImageWithURL:[NSURL URLWithString:self.urlBefore]];
    }

    if (_urlAfter.length)
    {
        [resultView.ivAfter setImageWithURL:[NSURL URLWithString:self.urlAfter]];
    }

    tableView.tableHeaderView = resultView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end

//
//  RepairCheckController.m
//  owner
//
//  Created by changhaozhang on 2017/6/5.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairCheckController.h"
#import "CheckResultView.h"

@interface RepairCheckController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation RepairCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"检测结果"];

    [self initView];
}

- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    CheckResultView *resultView = [CheckResultView viewFromNib];
    resultView.tvContent.text = self.chcekResult;

    _tableView.tableHeaderView = resultView;

    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end

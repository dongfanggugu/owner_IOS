//
//  ExtraServiceController.m
//  owner
//
//  Created by 长浩 张 on 2017/5/4.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ExtraServiceController.h"
#import "MainOrderInfoView.h"

@interface ExtraServiceController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ExtraServiceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"增值服务"];
    [self initView];
}


- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        MainOrderInfoView *view = [MainOrderInfoView viewFromNib];
        
        CGRect frame = CGRectMake(0, 0, self.screenWidth, 190);
        
        view.frame = frame;
        
        view.tag = 1001;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
        [cell.contentView addSubview:view];
    }
    
    MainOrderInfoView *view = [cell.contentView viewWithTag:1001];
    
    view.lbName.text = @"智能管家";
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}
@end

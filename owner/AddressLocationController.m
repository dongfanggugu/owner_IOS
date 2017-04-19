//
//  AddressLocationController.m
//  owner
//
//  Created by 长浩 张 on 2017/4/19.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "AddressLocationController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "KeyValueCell.h"
#import "ContentCell.h"

@interface AddressLocationController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,
                                        BMKPoiSearchDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation AddressLocationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"地址选择"];
    [self initView];
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)initView
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, 60)];
    
    searchBar.delegate = self;
    
    [self.view addSubview:searchBar];
    
    [self initTableView];
    
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 124, self.screenWidth, self.screenHeight - 124)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView =[[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

- (void)initData
{
    _dataArray = [NSMutableArray array];
}

- (void)poiSearch:(NSString *)keyword
{
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    
    poiSearch.delegate = self;
    
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
    option.city = @"北京";
    option.keyword = keyword;
    option.pageCapacity = 50;
    
    
    BOOL result = [poiSearch poiSearchInCity:option];
    if (!result) {
        [HUDClass showHUDWithText:@"查询失败,请稍后再试!"];
    }
}

#pragma mark -- BMKSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{

    if (errorCode == BMK_SEARCH_NO_ERROR) {
        [_dataArray removeAllObjects];
        
        [_dataArray addObjectsFromArray:poiResult.poiInfoList];
        
        [_tableView reloadData];
        
    } else {
        [_dataArray removeAllObjects];
                
        [_tableView reloadData];

    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (0 == searchText.length) {
        return;
    }

    [self poiSearch:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContentCell identifier]];
    
    if (!cell) {
        cell = [ContentCell cellFromNib];
    }
    
    BMKPoiInfo *info = _dataArray[indexPath.row];
    
    cell.lbContent.text = info.name;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info = _dataArray[indexPath.row];
    
    return [ContentCell cellHeight:info.name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(onChooseAddress:Lat:lng:)]) {
        BMKPoiInfo *info = _dataArray[indexPath.row];
        [_delegate onChooseAddress:info.name Lat:info.pt.latitude lng:info.pt.longitude];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

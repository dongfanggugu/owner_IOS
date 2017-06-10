//
//  PersonalCenter.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/22.
//
//

#import <Foundation/Foundation.h>
#import "PersonalCenterController.h"
#import "Utils.h"
#import "FileUtils.h"
#import "HttpClient.h"
#import "AddressViewController.h"
#import "PersonHeaderView.h"
#import "AppDelegate.h"


#define ICON_PATH @"/tmp/person/"

#pragma mark -InfoCell

@interface InfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewInfoIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@property (weak, nonatomic) IBOutlet UIView *bagView;

@end


@implementation InfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _bagView.layer.masksToBounds = YES;
    _bagView.layer.cornerRadius = 5;
}

@end


#pragma mark - PersonalCenterController

@interface PersonalCenterController () <UITableViewDelegate, UITableViewDataSource, PersonHeaderDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPersonIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelSex;

@property (weak, nonatomic) IBOutlet UILabel *labelAge;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIButton *btnLogOff;

@property (strong, nonatomic) PersonHeaderView *personHeader;

@end

@implementation PersonalCenterController

@synthesize btnLogOff;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavTitle:@"个人中心"];

    [self addHeaderView];
    [self addFootView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

/**
 *  跳转到基本信息页面
 */
- (void)showBasicInfo
{
    UIViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"basicInfo"];

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:destinationVC animated:YES];
}

- (void)addHeaderView
{
    _personHeader = [PersonHeaderView viewFromNib];
    _personHeader.delegate = self;
    _personHeader.name.text = [[Config shareConfig] getUserName];
    _tableView.tableHeaderView = _personHeader;
}

/**
 *  在下面添加退出登录按钮
 */
- (void)addFootView
{

    btnLogOff = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLogOff.layer.masksToBounds = YES;
    btnLogOff.layer.cornerRadius = 5;

    //设置文字和文字颜色
    [btnLogOff setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnLogOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    //设置frame
    btnLogOff.frame = CGRectMake(0, 0, 50, 70);
    btnLogOff.translatesAutoresizingMaskIntoConstraints = NO;

    //设置背景色
    self.btnLogOff.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];

    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 100)];


    [parentView addSubview:btnLogOff];
    parentView.backgroundColor = [UIColor clearColor];

    NSDictionary *views = NSDictionaryOfVariableBindings(btnLogOff);

    //设置button高度40
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btnLogOff(40)]"
                                                                       options:0 metrics:nil views:views]];

    //设置button距离上边框60
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[btnLogOff]"
                                                                       options:0 metrics:nil views:views]];



    //设置button距离左右边框都是20
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnLogOff]-20-|"
                                                                       options:0 metrics:nil views:views]];

    self.tableView.tableFooterView = parentView;

    [btnLogOff addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  退出登录
 */
- (void)logout
{

    //注销
    [[HttpClient shareClient] post:@"smallOwnerLogout" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        [[Config shareConfig] setUserId:@""];
        [self.navigationController popViewControllerAnimated:YES];
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        delegate.window.rootViewController = [board instantiateViewControllerWithIdentifier:@"main_tab_bar_controller"];

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];

}


#pragma -mark -Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];

    if (0 == section)
    {


        cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_account"];
        // cell.labelInfo.text = [[Config shareConfig] getBranchName];
        cell.keyLabel.text = @"我的账户";
        cell.selectionStyle = UITableViewCellEditingStyleNone;

    }
    else if (1 == section)
    {


        cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_branch"];
        cell.keyLabel.text = @"小区地址";
        cell.labelInfo.text = [[Config shareConfig] getBranchAddress];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    else if (2 == section)
    {
        cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_settings"];
        cell.keyLabel.text = @"设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //松手后颜色回复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    //NSInteger row = indexPath.row;

    if (0 == section)
    {
        [HUDClass showHUDWithText:@"功能开发中"];
    }
    else if (1 == section)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"pro_location_controller"];

        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (2 == section)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"settings_controller"];

        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 20;
}


#pragma mark - deal with the icon image


- (void)downloadIconByUrlString:(NSString *)urlString dirPath:(NSString *)dirPath fileName:(NSString *)fileName
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {

        if (data.length > 0 && nil == connectionError)
        {
            [FileUtils writeFile:data Path:dirPath fileName:fileName];
            [self performSelectorOnMainThread:@selector(setPersonIcon:) withObject:urlString waitUntilDone:NO];

        }
        else if (connectionError != nil)
        {
            NSLog(@"download picture error = %@", connectionError);
        }
    }];
}


- (void)setPersonIcon:(NSString *)urlString
{

    NSLog(@"picture url:%@", urlString);

    if (0 == urlString.length)
    {
        return;
    }
    NSString *dirPath = [NSHomeDirectory() stringByAppendingString:ICON_PATH];
    NSString *fileName = [FileUtils getFileNameFromUrlString:urlString];
    NSString *filePath = [dirPath stringByAppendingString:fileName];

    if ([FileUtils existInFilePath:filePath])
    {

        UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
        _personHeader.image.image = icon;
    }
    else
    {
        [self downloadIconByUrlString:urlString dirPath:dirPath fileName:fileName];
    }

}

- (void)setTitleString:(NSString *)title
{
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelTitle.text = title;
    labelTitle.font = [UIFont fontWithName:@"System" size:17];
    labelTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:labelTitle];
}

- (void)backToMainPage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- PersonHeaderDelegate

- (void)onClickIcon
{
    [self showBasicInfo];
}

@end

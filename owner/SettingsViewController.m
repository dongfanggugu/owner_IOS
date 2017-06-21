//
//  SettingsViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/6.
//
//

#import <Foundation/Foundation.h>
#import "SettingsViewController.h"
#import "Utils.h"

#pragma mark -- SettingsCell

@interface SettingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SettingsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

#pragma mark -- SettingsViewController

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"设置"];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


/**
 *  检测是否需要升级
 */
- (void)checkUpdate
{
    NSMutableDictionary *head = [NSMutableDictionary dictionary];
    [head setObject:@"3" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];

    [[HttpClient shareClient] post:URL_VERSION_CHECK head:head body:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSInteger remoteVersion = [[responseObject[@"body"] objectForKey:@"appVersion"] integerValue];

                               NSLog(@"remote version:%ld", remoteVersion);

                               NSInteger local = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
                               NSLog(@"local version:%ld", local);

                               if (remoteVersion > local)
                               {
                                   [self performSelectorOnMainThread:@selector(alertUpdate) withObject:nil waitUntilDone:NO];
                               }
                               else
                               {
                                   [self performSelectorOnMainThread:@selector(alertNoUpdate) withObject:nil waitUntilDone:NO];
                               }

                           } failure:^(NSURLSessionDataTask *task, NSError *errr) {

            }];
}

/**
 *  提示进行升级
 */
- (void)alertUpdate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新的版本可用,请进行升级" delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"升级", nil];
    [alert show];
}

- (void)alertNoUpdate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前已经是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settings_cell"];

    NSInteger row = indexPath.row;

    if (0 == row)
    {
        cell.label.text = @"修改密码";

    }
    else if (1 == row)
    {
        cell.label.text = @"检查更新";

    }
    else if (2 == row)
    {
        cell.label.text = @"关于";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (0 == row)
    {

        if (!self.login)
        {
            [HUDClass showHUDWithText:@"需要登录才能修改密码"];
            return;
        }
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"PasswordPage"];

        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (1 == row)
    {
        [self checkUpdate];

    }
    else if (2 == row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"settings_about"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/liftowner"]];
    }
}

@end

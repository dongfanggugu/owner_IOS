//
//  PersonBasicInfoController.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/23.
//
//

#import <Foundation/Foundation.h>
#import "PersonBasicInfoController.h"
#import "FileUtils.h"
#import "ImageUtils.h"
#import "HttpClient.h"
#import "JPUSHService.h"
#import "LinkModifyController.h"
#import "HouseManagerController.h"


#define ICON_PATH @"/tmp/person/"
#define ICON_TEMP @"person_temp.jpg"


#pragma mark - IconCell

@interface IconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@end

@implementation IconCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    _imageViewIcon.layer.masksToBounds = YES;
    _imageViewIcon.layer.cornerRadius = 25;

    _imageViewIcon.layer.borderWidth = 1;
    _imageViewIcon.layer.borderColor = [Utils getColorByRGB:TITLE_COLOR].CGColor;

}

@end


#pragma mark - TextCell

@interface TextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@end

@implementation TextCell


@end

#pragma mark - PersonBasicInfoController

@interface PersonBasicInfoController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIActionSheet *actionSheet;

@end


@implementation PersonBasicInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"基本资料"];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)initView
{
    //self.tableView.bounces = NO;
}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 1;
    }
    else if (1 == section)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (0 == indexPath.section)
    {
        IconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconCell"];
        cell.lbName.text = @"头像";

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if (1 == indexPath.section)
    {
        NSInteger row = indexPath.row;
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];


        if (0 == row)
        {
            cell.labelTitle.text = @"电话";
            cell.labelContent.text = [[Config shareConfig] getTel];
            cell.labelContent.textAlignment = NSTextAlignmentRight;

            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        else if (1 == row)
        {
            cell.labelTitle.text = @"姓名";
            cell.labelContent.text = [[Config shareConfig] getName];
            cell.labelContent.textAlignment = NSTextAlignmentRight;

        }
        else if (2 == row)
        {
            cell.labelTitle.text = @"别墅管理";
            cell.labelContent.text = [[Config shareConfig] getBranchAddress];
            cell.labelContent.textAlignment = NSTextAlignmentRight;
        }

        return cell;

    }
    else
    {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        cell.labelTitle.text = @"退出";

        return cell;
    }
}


/**
 *  设置tableview 行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return 66;
    }

    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (1 == section)
    {
        NSInteger row = indexPath.row;

        if (0 == row)
        {
            return;

        }
        else if (1 == row)
        {
            UIViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ModifyDetail"];

            [destinationVC setValue:@"name" forKey:@"enterType"];

            destinationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:destinationVC animated:YES];

        }
        else if (2 == row)
        {
            HouseManagerController *controller = [[HouseManagerController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:controller animated:YES];
        }

    }
    else if (2 == indexPath.section)
    {
        [self unregisterJpush];
        [self logout];
    }
}


/**
 *  退出登录
 */
- (void)logout
{

    //注销
    [[HttpClient shareClient] post:@"smallOwnerLogout" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        [[Config shareConfig] setUserId:@""];
        [[Config shareConfig] setToken:@""];
        [self.navigationController popViewControllerAnimated:YES];

    }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

    }];

}

- (void)unregisterJpush
{
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"zhenhao---rescode: %d, tags: %@, alias: %@", iResCode, iTags, iAlias);

        if (0 == iResCode)
        {
            NSLog(@"zhenhao:jpush unregister successfully!");

        }
        else
        {
            NSString *err = [NSString stringWithFormat:@"%d:注销消息服务器失败，请重新再试", iResCode];
            NSLog(@"zhenhao:%@", err);

        }
    }];
}

#pragma mark - deal with icon image

/**
 *  设置图片
 *
 */
- (void)setPersonIcon:(UIImageView *)imageView
{

//    if (0 == [User sharedUser].picUrl.length) {
//        return;
//    }
//    NSString *dirPath = [NSHomeDirectory() stringByAppendingString:ICON_PATH];
//    NSString *fileName = [FileUtils getFileNameFromUrlString:[User sharedUser].picUrl];
//    NSString *filePath = [dirPath stringByAppendingString:fileName];
//    
//    if ([FileUtils existInFilePath:filePath]) {
//        
//        UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
//        imageView.image = icon;
//    }
}

#pragma mark -- take the photo

/**
 *  选择拍照或者选取图片
 */
- (void)showMenu
{

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄", @"选取", nil];
    [self.actionSheet showInView:self.view];
}

/**
 *  ActionSheet按钮
 *
 *  @param actionSheet <#actionSheet description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == self.actionSheet.cancelButtonIndex)
    {
    }

    switch (buttonIndex)
    {
        case 0:
            [self takePhoto];
            break;

        case 1:
            [self pickPhoto];
            break;
    }
}

/**
 *  拍摄照片
 */
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;

        //设置拍照后的图片可以编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self showViewController:picker sender:self];
    }
}

/**
 *  从本地选取照片
 */
- (void)pickPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;

    //设置选择后的图片可以编辑
    picker.allowsEditing = YES;

    [self showViewController:picker sender:self];
}

/**
 *  当选择一张图片后调用此方法
 *
 *  @param picker <#picker description#>
 *  @param info   <#info description#>
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{


    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //选择的是图片
    if ([type isEqualToString:@"public.image"])
    {

        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];

        CGSize size = CGSizeMake(120, 120);

        image = [ImageUtils imageWithImage:image scaledToSize:size];

        //将图片转换为 NSData
        NSData *data;

        data = UIImageJPEGRepresentation(image, 0.5);


        //将图片保存为person_temp.jpg
        NSString *dirPath = [NSHomeDirectory() stringByAppendingString:ICON_PATH];


        [FileUtils writeFile:data Path:dirPath fileName:ICON_TEMP];


        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];

        //上传图片
        NSString *filePath = [dirPath stringByAppendingString:ICON_TEMP];
        NSString *base64String = [ImageUtils image2Base64From:filePath];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:base64String forKey:@"pic"];

        [[HttpClient shareClient] post:@"updateLoadPic" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

            NSDictionary *responseBody = [responseObject objectForKey:@"body"];
            NSString *iconUrlString = [responseBody objectForKey:@"pic"];
            NSString *fileName = [FileUtils getFileNameFromUrlString:iconUrlString];

            //重命名选择的新图片
            [FileUtils renameFileNameInPath:dirPath oldName:ICON_TEMP toNewName:fileName];

            //更新本地存储的头像url
//            [User sharedUser].picUrl = iconUrlString;
//            [[User sharedUser] setUserInfo];

            //设置页面展示的头像
            IconCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.imageViewIcon.image = image;

        }                      failure:^(NSURLSessionDataTask *task, NSError *errr) {

        }];

    }
}


/**
 *  取消图片选择时调用
 *
 *  @param picker <#picker description#>
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  HelpController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/6.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpController.h"
#import "HelpContentController.h"

#pragma mark - HelpCell

@interface HelpCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbIndex;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@end

@implementation HelpCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _lbIndex.layer.masksToBounds = YES;
    _lbIndex.layer.cornerRadius = 15;
}

@end

#pragma mark - HelpController

@interface HelpController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayInfo;


@end

@implementation HelpController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"帮助中心"];
    [self initData];
    [self initView];
}
- (void)initData
{
    _arrayInfo = [NSMutableArray array];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"title"] = @"乘坐电梯的注意事项";
    dic1[@"content"] = @" \
    1、注意不要猛烈碰撞电梯门?\n \
    2、搬运物品时应特别注意，不要碰刮轿厢门或壁板?\n \
    3、搬运重量大的物件，注意不要超载，并应把物件均匀放置在轿厢内?\n \
    4、只按必要的按钮，不要用坚硬的东西去敲打按钮?\n \
    5、紧急呼唤按钮是电梯在非正常运行时才使用，请不要乱按?\n \
    6、禁止小孩在电梯口周围玩耍，小孩应有大人带领搭乘电梯?\n \
    7、注意不要超载，超载是，轿厢内警报蜂鸣器会鸣响，乘客减少至允许载重时，蜂鸣器停 \
    止鸣响，自动关门?\n \
    8、禁止乱动电梯厅门和轿门?\n \
    9、禁止乱动电梯消防开关和轿内开关?\n \
    10、禁止在轿厢内吸烟?\n \
    11、禁止破坏行为，如乱涂乱画?\n \
    12、乘客不要在轿厢内打闹、跳动，这会导致事故发生?\n \
    13、乘客乘坐电梯遇困时，应保持冷静，不要乱动，按紧呼按钮和大声呼叫等方式通知别人营救?\n \
    14、当停电、火灾、地震时，不要乘坐电梯?\n \
    15、遇到电梯状态异常（如：运行晃动剧烈、电梯内无照明、电梯门打开不动等），请不要 \
    乘坐电梯，并及时通知电梯管理人员?";
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    dic2[@"title"] = @"电梯的正确使用方法";
    
    dic2[@"content"] = @"\
    1、呼叫电梯时，乘客仅需要按所去方向的呼叫按钮，请勿同时将上行和下行方向按钮都按亮，以免造\
    成无用的轿厢停靠，降低大楼电梯的总输送效率。同时这样也是为了避免安全装置错误动作，造成乘客被困\
    在轿厢内，影响电梯正常运行。\n \
    2、电梯门开启时，一定不要将手放在门板上，防止门板缩回时挤伤手指，电梯门关闭时，切勿将手搭\
    在门的边缘，以免影响关门动作甚至挤伤手指。带小孩时，应当用手拉紧或抱住小孩乘坐电梯。\n \
    3、乘坐电梯时应与电梯门保持一定距离，为了安全起见，因为在电梯运行时，电梯门与井道相连，相\
    对速度非常快，电梯门万一失灵，在门附近的乘客会相当危险。\n \
    4、不要在电梯里蹦跳。电梯轿厢上设置了很多安全保护开关。如果在轿厢内蹦跳，轿厢就会严重倾斜 \
    ，有可能导致保护开关动作，使电梯进入保护状态。这种情况一旦发生，电梯会紧急停车，造成乘梯人员被 \
    困。\n \
    5、进门时很多人习惯用身体挡门，虽然没有危险，但如果你按的时间太长了，电梯控制部分会认为电\
    梯已经出了故障。有可能会报警，甚至停下来。所以比较得体的做法，就是你进去以后，按着开门按钮\
    特别需要提醒的是，有的人整个站在电梯门处，挡着电梯门，这样是很危险的。因为电梯里面是安全的\
    ，外面也是安全的。但是你站在这两个空间交界的地方，假如说这个时候出现了，大家俗话叫做开门走车的\
    情况，这个人就会受到剪切。所以这是一个非常危险的位置，不应该在这个交界的地方停留。\n \
    6、有些单位用一台货梯作为客梯用是不允许。\
    货梯和客梯的区别就是它的装潢，或者它的舒适感要差一些。振动和噪音的指标没有提出特殊的要求。\
    另外有一种货梯，是绝对不能作客梯用的，就是超面积的。因为有时候工厂里做的这种产品比较轻，它希望 \
    轿厢做得大一点，那么经过有关部门批准，这个轿厢面积比标准的要大。如果说这种货梯作客梯用时，就会 \
    出现超载。";
    
    [_arrayInfo addObject:dic1];
    [_arrayInfo addObject:dic2];
}

- (void)initView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"help_cell"];
    
    if (!cell)
    {
        cell = [[HelpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"help_cell"];
    }
    
    NSDictionary *info = _arrayInfo[indexPath.row];
    
    NSString *index = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.lbIndex.text = index;
    cell.lbContent.text = [info objectForKey:@"title"];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HelpContentController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"help_content_controller"];
    
    NSDictionary *info = _arrayInfo[indexPath.row];
    controller.pageTitle = [info objectForKey:@"title"];
    controller.content = [info objectForKey:@"content"];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

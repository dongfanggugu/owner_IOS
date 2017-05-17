//
//  NetConstant.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef NetConstant_h
#define NetConstant_h

#define URL_LOGIN @"login"

#define URL_EVALUATE @"editRepairBySmallOwner"

//小业主获取已经完成的维修单
#define URL_FINISHED_REPAIR @"getRepairBySmallOwnerComplete"

//个人信息修改
#define URL_PERSON_MODIFY @"editSmallOwner"

//获取维保类型列表
#define URL_MAIN_TYPE @"getMainttypeList"

//获取电梯品牌信息
#define URL_LIFT_BRAND @"getBrandInfo"

//获取短信验证码
#define URL_SMS_CODE @"getSMSCode"

//添加维保订单
#define URL_MAIN_ADD @"addMaintOrder"

//获取故障类型
#define URL_FAULT_LIST @"getRepairTypeList"

//别墅业主添加快修订单
#define URL_REPAIR_ADD @"addRepairOrder"

//获取维修订单列表
#define URL_REPAIR_LIST @"getRepairOrderListNotCompleteByOwner"

//获取维保订单列表
#define URL_MAIN_LIST @"getMaintOrderListByOwner"

//获取服务的任务单
#define URL_MAIN_TASK @"getMaintOrderProcessListByOrder"

//获取快修订单的任务单
#define URL_REPAIR_TASK @"getRepairOrderProcessListByOrder"

//快修提交评价
#define URL_REPAIR_EVALUATE @"saveRepairOrderEvaluate"

//确认维保订单任务
#define URL_CONFIRM_MAIN_TASK @"saveMaintOrderProcessConfirm"

//维保任务单提交评价
#define URL_MAIN_TASK_EVALUATE @"saveMaintOrderProcessEvaluate"

//检测版本更新
#define URL_VERSION_CHECK @"checkVersion"

//增值服务添加订单
#define URL_EXTRA_ADD @"addIncrement"

//获取用户订购的增值服务
#define URL_GET_EXTRA @"getIncrementListByOwner"

//忘记密码
#define URL_PWD_FORGET @"pwdForget"

#endif /* NetConstant_h */

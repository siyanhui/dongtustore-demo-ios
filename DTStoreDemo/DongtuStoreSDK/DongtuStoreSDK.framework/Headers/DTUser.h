//
//  DTUser.h
//  DongTuAPIPlus
//
//  Created by Isan Hu on 2018/8/1.
//  Copyright © 2018 Isan Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTUser : NSObject


/**
 用户id
 */
@property (nullable, nonatomic, retain) NSString *userId;


/**
 用户名
 */
@property (nullable, nonatomic, retain) NSString *name;

/**
 电话
 */
@property (nullable, nonatomic, retain) NSString *phone;

/**
 邮件
 */
@property (nullable, nonatomic, retain) NSString *email;

/**
 地址
 */
@property (nullable, nonatomic, retain) NSString *address;

/**
 用户性别  1：男，2：女
 */
@property (nonatomic) NSInteger gender;

/**
 其他信息
 */
@property (nullable, nonatomic, retain) NSDictionary *otherInfo;

@end

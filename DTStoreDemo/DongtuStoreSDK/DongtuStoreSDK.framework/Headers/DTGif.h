//
//  MMCPicture.h
//  CoreLib
//
//  Created by Tender on 16/10/14.
//  Copyright © 2016年 siyanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 动图模型类
 */
@interface DTGif : NSObject

/**
 图片id
 */
@property (nonatomic, strong) NSString *imageId;

/**
 图片名称
 */
@property (nonatomic, strong) NSString *text;

/**
 图片缩略图地址
 */
@property (nonatomic, strong) NSString *thumbImage;

/**
 图片缩略图地址  动图
 */
@property (nonatomic, strong) NSString *gifThumbImage;

/**
 *  图片地址
 *  可能是GIF、PNG、JPG格式
 */
@property (nonatomic, strong) NSString *mainImage;

/**
 *  图片尺寸（pix）
 */
@property (nonatomic, assign) CGSize size;

/**
 *  是否是动态图片
 */
@property (nonatomic, assign) BOOL isAnimated;

/**
 *  是否是可看性动图
 */
@property (nonatomic, assign) BOOL isTmpAdGif;

@end

//
//  DTImageView.h
//  DongTuAPIPlusKit
//
//  Created by Isan Hu on 2018/8/2.
//  Copyright © 2018 Isan Hu. All rights reserved.
//

#ifndef DTImageView_h
#define DTImageView_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DTImageView: UIView

/**
 设置DTImageView的image
 */
@property (nonatomic, strong, nullable) UIImage *image;

/**
 设置DTImageView加载图片失败后显示的图片
 */
@property (nonatomic, strong, nullable) UIImage *errorImage;


/**
 计算DTImageView尺寸

 @param size 图片尺寸
 @param mSize DTImageView控件最大尺寸
 @return DTImageView尺寸
 */
+ (CGSize)sizeForImageSize:(CGSize)size imgMaxSize: (CGSize)mSize;

/**
 设置Gif图片数据函数

 @param urlString 图片url
 @param gifId 图片id
 */
- (void)setImageWithDTUrl:(NSString * _Nonnull)urlString gifId:(NSString * _Nonnull)gifId;

/**
 设置Gif图片数据函数

 @param urlString 图片url
 @param gifId 图片id
 @param handler 处理成功回调
 */
- (void)setImageWithDTUrl:(NSString * _Nonnull)urlString gifId:(NSString * _Nonnull)gifId completHandler:(void (^_Nullable)(BOOL success))handler;


/**
 设置表情包中表情数据函数

 @param emojiCode 表情code
 */
- (void)setImageWithEmojiCode:(NSString * _Nonnull)emojiCode;


/**
 设置表情包中表情数据函数

 @param emojiCode 表情code
 @param handler 处理成功回调
 */
- (void)setImageWithEmojiCode:(NSString * _Nonnull)emojiCode completHandler:(void (^_Nullable)(BOOL success))handler;

/**
 DTImageView 重用
 */
- (void)prepareForReuse;
@end

#endif /* DTImageView_h */


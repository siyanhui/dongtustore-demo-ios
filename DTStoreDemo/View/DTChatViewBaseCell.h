//
//  MMChatViewBaseCell.h
//  IMDemo
//
//  Created by isan on 16/4/21.
//  Copyright © 2016年 siyanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChatMessage.h"
#import <DongtuStoreSDK/DongtuStoreSDK.h>



#define TEXT_MESG_TYPE @"txt_msgType"  //key for text message
#define TEXT_MESG_FACE_TYPE @"facetype" //key for big emoji type
#define TEXT_MESG_EMOJI_TYPE @"emojitype" //key for photo-text message
#define TEXT_MESG_WEB_TYPE @"webtype" //key for web sticker message
#define TEXT_MESG_DATA @"msg_data"  //key for ext data of message

#define WEBSTICKER_IS_GIF @"is_gif"  //key for web sticker is gif or not
#define WEBSTICKER_ID @"data_id"  //key for web sticker id
#define WEBSTICKER_URL @"sticker_url"  //key for web sticker url
#define WEBSTICKER_HEIGHT @"h"  //key for web sticker height
#define WEBSTICKER_WIDTH @"w"  //key for web sticker width



#define BUBBLE_MAX_WIDTH ([[UIScreen mainScreen] bounds].size.width * 0.65)
#define TEXT_MESSAGEFONT_SIZE 17
#define CONTENT_TOP_MARGIN 6
#define CONTENT_BOTTOM_MARGIN 6
#define CONTENT_LEFT_MARGIN 6
#define CONTENT_RIGHT_MARGIN 14

@protocol RCMessageCellDelegate;

@interface DTChatViewBaseCell : UITableViewCell

@property(strong, nonatomic) UIImageView *avatarView;
@property(strong, nonatomic) UIView *messageView;
@property(strong, nonatomic) UIImageView *messageBubbleView;

@property(strong, nonatomic) ChatMessage *messageModel;
@property(nonatomic) CGSize bubbleSize;
@property(nonatomic) CGSize imageSize;

@property(nonatomic, weak) id<RCMessageCellDelegate> delegate;

- (void)setView;
- (void)set:(ChatMessage *)messageData;
+ (CGFloat)cellHeightFor:(ChatMessage *)message;
+ (CGSize)textContentSize:(NSString *)content;

@end

@protocol RCMessageCellDelegate <NSObject>

@optional

/*!
 the delegate method handles `tap` of message cell
 */
- (void)didTapChatViewCell:(ChatMessage *)messageModel;

/**
 *  the delegate method handles `long press` of message cell
 *
 *  @param messageModel message model
 *  @param view         the view that holds the message
 */
- (void)didLongPressChatViewCell:(ChatMessage *)messageModel inView:(UIView *)view;

/**
 *  the delegate method handles `tap` of url in message cell
 *
 *  @param url   the url string
 */
- (void)didTapUrlInMessageCell:(NSString *)url;

/**
 *  the delegate method handles `tap` of phone number in message cell
 *
 *  @param phoneNumber    phone number
 */
- (void)didTapPhoneNumberInMessageCell:(NSString *) phoneNumber;
@end

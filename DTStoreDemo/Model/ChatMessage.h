//
//  MMMessage.h
//  IMDemo
//
//  Created by isan on 16/4/21.
//  Copyright © 2016年 siyanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MMMessageType) {
    /*!
     Text message or photo-text message
     */
    MMMessageTypeText = 1,
    
    /*!
     big emoji message
     */
    MMMessageTypeBigEmoji = 2,
    
    /*!
     web sticker message
     */
    MMMessageTypeWebSticker = 3,
    
};

@interface ChatMessage : NSObject

@property(nonatomic, assign) MMMessageType messageType;

@property(nonatomic) CGSize imageSize;
/**
 *  text content of message
 */
@property(nonatomic, strong) NSString *messageContent;
/**
 *  the ext of message
 */
@property(nonatomic, strong) NSDictionary *messageExtraInfo;


/**
 *  initialize message Model
 *
 *  @param messageType      the type of message
 *  @param messageContent   the text content of mesage
 *  @param messageExtraInfo the ext of message
 *
 *  @return message Model
 */
- (id)initWithMessageType:(MMMessageType)messageType messageContent:(NSString *)messageContent messageExtraInfo:(NSDictionary *)messageExtraInfo;

@end

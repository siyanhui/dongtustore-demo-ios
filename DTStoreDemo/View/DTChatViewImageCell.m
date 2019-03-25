//
//  MMChatViewImageCell.m
//  IMDemo
//
//  Created by isan on 16/4/21.
//  Copyright © 2016年 siyanhui. All rights reserved.
//

#import "DTChatViewImageCell.h"
#import "UIImage+GIF.h"

@implementation DTChatViewImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    
    return self;
}

- (void)setView {
    [super setView];
    _pictureView = [[DTImageView alloc] initWithFrame:CGRectZero];
    _pictureView.layer.cornerRadius = 2.0f;
    _pictureView.layer.masksToBounds = YES;
    [self.messageView addSubview:_pictureView];
    
    self.messageBubbleView.hidden = true;
}

- (void)set:(ChatMessage *)messageData {
    [super set:messageData];
    
    self.pictureView.image = [UIImage imageNamed:@"mm_emoji_loading"];
    UIImage *errorImage = [UIImage imageNamed:@"mm_emoji_error"];
    self.pictureView.errorImage = errorImage;
    //Integrate BQMM
    NSDictionary *extDic = messageData.messageExtraInfo;
    if (messageData.messageType == MMMessageTypeBigEmoji) {
        if (extDic != nil && [extDic[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_FACE_TYPE]) {
            NSArray *codes = nil;
            if (extDic[TEXT_MESG_DATA]) {
                codes = @[extDic[TEXT_MESG_DATA][0][0]];
            }
            if (codes.count > 0) {
                NSString *emojiCode = codes.firstObject;
                if (emojiCode != nil && emojiCode.length > 0) {
                    [self.pictureView setImageWithEmojiCode:emojiCode];
                }else {
                    self.pictureView.image = errorImage;
                }
            }else {
                self.pictureView.image = errorImage;
            }
        }
    }else{
        if (extDic != nil && [extDic[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
            NSDictionary *msgData = extDic[TEXT_MESG_DATA];
            NSString *webStickerUrl = msgData[WEBSTICKER_URL];
            NSString *gifId = msgData[WEBSTICKER_ID];
            [_pictureView setImageWithDTUrl:webStickerUrl gifId:gifId];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize messageSize = self.messageView.frame.size;
    CGSize size = self.messageModel.imageSize;
    self.pictureView.frame = CGRectMake(messageSize.width - size.width - CONTENT_RIGHT_MARGIN, (messageSize.height - size.height) / 2, size.width, size.height);
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [_pictureView prepareForReuse];
}



@end

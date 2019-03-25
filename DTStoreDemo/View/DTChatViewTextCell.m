//
//  MMChatViewTextCell.m
//  IMDemo
//
//  Created by isan on 16/4/21.
//  Copyright © 2016年 siyanhui. All rights reserved.
//

#import "DTChatViewTextCell.h"

@implementation DTChatViewTextCell

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
    _textMessageView = [[UITextView alloc] init];
    _textMessageView.backgroundColor = [UIColor clearColor];
    _textMessageView.textContainerInset = UIEdgeInsetsZero;
    _textMessageView.textColor = [UIColor blackColor];
    _textMessageView.font = [UIFont systemFontOfSize:TEXT_MESSAGEFONT_SIZE];
    _textMessageView.editable = false;
    _textMessageView.selectable = false;
    _textMessageView.scrollEnabled = false;
    [self.messageView addSubview:_textMessageView];
}

- (void)set:(ChatMessage *)messageData {
    //Integrate BQMM
    [super set:messageData];
    _textMessageView.text = messageData.messageContent;
}

+ (CGSize)textContentSize:(NSString *)content {
    
    UITextView *_textMessageView = [[UITextView alloc] init];
    _textMessageView.textContainerInset = UIEdgeInsetsZero;
    _textMessageView.text = content;
    _textMessageView.font = [UIFont systemFontOfSize:TEXT_MESSAGEFONT_SIZE];
    CGFloat maxWidth = BUBBLE_MAX_WIDTH - (CONTENT_RIGHT_MARGIN + CONTENT_LEFT_MARGIN);
    return [_textMessageView sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize messageSize = self.messageView.frame.size;
    CGSize size = CGSizeZero;
    //Integrate BQMM
    size = [DTChatViewBaseCell textContentSize:self.messageModel.messageContent];
    _textMessageView.frame = CGRectMake(messageSize.width - size.width - CONTENT_RIGHT_MARGIN, CONTENT_TOP_MARGIN, size.width, size.height);
}

-(void)prepareForReuse {
    [super prepareForReuse];
}

@end

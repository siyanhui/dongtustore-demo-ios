//
//  StoreDemoViewController.h
//  DTStoreDemo
//
//  Created by Isan Hu on 2019/5/8.
//  Copyright © 2019 siyanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTInputToolBarView.h"
#import "DTChatViewBaseCell.h"
#import "ChatMessage.h"

@interface StoreDemoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RCMessageCellDelegate, MMInputToolBarViewDelegate>

@property(strong, nonatomic) UITableView *messagesTableView;
@property(strong, nonatomic) DTInputToolBarView *inputToolBar;
@property(strong, nonatomic) UILabel *messageLabel;

@end


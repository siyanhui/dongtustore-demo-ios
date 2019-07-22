//
//  StoreDemoViewController.m
//  DTStoreDemo
//
//  Created by Isan Hu on 2019/5/8.
//  Copyright © 2019 siyanhui. All rights reserved.
//
#import "StoreDemoViewController.h"
#import "DTChatViewTextCell.h"
#import "DTChatViewImageCell.h"
#import "ChatMessage.h"
#import <DongtuStoreSDK/DongtuStoreSDK.h>
#import "Masonry.h"
#import "MBProgressHUD.h"
@interface StoreDemoViewController (){
    NSMutableArray *_messagesArray;
    ChatMessage *_longPressSelectedModel;
    UIMenuController *_menuController;
    BOOL _isFirstLayOut;
}

@end

@implementation StoreDemoViewController

- (void)viewWillAppear:(BOOL)animated {
    //menu
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide) name:UIMenuControllerWillHideMenuNotification object:nil];
    [DongtuStore sharedInstance].delegate = _inputToolBar; //set SDK delegate
}

- (void)menuDidHide {
    [[UIMenuController sharedMenuController] setMenuItems:nil];
    _inputToolBar.inputTextView.disableActionMenu = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DongtuStore sharedInstance].delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _isFirstLayOut = true;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissKeyboard)]];
    _messagesTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _messagesTableView.backgroundColor = [UIColor whiteColor];
    _messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messagesTableView.delegate = self;
    _messagesTableView.dataSource = self;
    _messagesTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _messagesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [self.view addSubview:_messagesTableView];
    
    _inputToolBar = [[DTInputToolBarView alloc] initWithFrame:CGRectZero];
    _inputToolBar.delegate = self;
    [self.view addSubview:_inputToolBar];
    
    _messagesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [[DongtuStore sharedInstance] shouldShowSearchPopupAboveView:_inputToolBar withInput:_inputToolBar.inputTextView];
    
    
    //    UIView *testView = [[UIView alloc] init];
    //    testView.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:testView];
    //    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
    ////        make.centerX.equalTo(self.view.mas_centerX);
    ////        make.centerY.equalTo(self.view.mas_centerY);
    ////        make.width.equalTo(@50);
    ////        make.height.equalTo(@50);
    //
    //        make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
    //    }];
    
    UIButton *testButton = [[UIButton alloc] init];
    testButton.backgroundColor = [UIColor blueColor];
    [testButton setTitle:@"切换用户" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
        make.top.equalTo(self.view).offset(120);
    }];
    
}

- (void)testButtonClicked {
    DTUser *user = [[DTUser alloc] init];
    user.name = @"username11";
    user.userId = @"3333333311";
    user.email = @"user@gmail11.com";
    user.otherInfo = @{@"region":@"China1"};
    user.gender = 1;
    [[DongtuStore sharedInstance] setUser:user];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if(_isFirstLayOut) {
        CGSize viewSize = self.view.frame.size;
        _inputToolBar.frame = CGRectMake(0, viewSize.height - INPUT_TOOL_BAR_HEIGHT, viewSize.width, INPUT_TOOL_BAR_HEIGHT);
        
        _messagesTableView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height - INPUT_TOOL_BAR_HEIGHT);
        _messageLabel.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
        _isFirstLayOut = false;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)layoutViewsWithKeyboardFrame:(CGRect)keyboardFrame {
    CGRect toolBarFrame = self.inputToolBar.frame;
    toolBarFrame.origin.y = keyboardFrame.origin.y - toolBarFrame.size.height;
    self.inputToolBar.frame = toolBarFrame;
    
    CGRect tableviewFrame = self.messagesTableView.frame;
    tableviewFrame.size.height = toolBarFrame.origin.y;
    self.messagesTableView.frame = tableviewFrame;
    
    [self scrollViewToBottom];
}

- (void)tapToDismissKeyboard {
    [[DongtuStore sharedInstance] switchToDefaultKeyboard];
    _inputToolBar.emojiButton.selected = false;
    [self.view endEditing:true];
}

- (void)scrollViewToBottom {
    NSUInteger finalRow = MAX(0, [self.messagesTableView numberOfRowsInSection:0] - 1);
    if (0 == finalRow) {
        return;
    }
    NSIndexPath *finalIndexPath = [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.messagesTableView scrollToRowAtIndexPath:finalIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMessage *message = (ChatMessage *)_messagesArray[indexPath.row];
    return [DTChatViewBaseCell cellHeightFor:message];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMessage *message = (ChatMessage *)_messagesArray[indexPath.row];
    return [DTChatViewBaseCell cellHeightFor:message];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatMessage *message = (ChatMessage *)_messagesArray[indexPath.row];
    NSString *reuseId = @"";
    
    DTChatViewBaseCell *cell = nil;
    switch (message.messageType) {
        case MMMessageTypeText:
        {
            reuseId = @"textMessage";
            cell = (DTChatViewTextCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
            if(cell == nil) {
                cell = [[DTChatViewTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            
        }
            break;
            
        case MMMessageTypeBigEmoji:
        {
            reuseId = @"bigEmojiMessage";
            cell = (DTChatViewImageCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
            if(cell == nil) {
                cell = [[DTChatViewImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
        }
            break;
            
        case MMMessageTypeWebSticker:
        {
            reuseId = @"webStickerMessage";
            cell = (DTChatViewImageCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
            if(cell == nil) {
                cell = [[DTChatViewImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
        }
            break;
    }
    
    cell.delegate = self;
    [cell set:message];
    return cell;
}

#pragma mark <MMInputToolBarViewDelegate>
- (void)didSelectGif:(DTGif *)gif {
    [self didSendGifMessage:gif];
    self.inputToolBar.inputTextView.text = @"";
}

- (void)keyboardWillShowWithFrame:(CGRect)keyboardFrame {
    [self layoutViewsWithKeyboardFrame:keyboardFrame];
}

- (void)didTouchEmojiButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        //attatch emoji keyboard
        [[DongtuStore sharedInstance] attachEmotionKeyboardToInput:_inputToolBar.inputTextView];
        
    }else{
        [[DongtuStore sharedInstance] switchToDefaultKeyboard];
    }
    [_inputToolBar.inputTextView becomeFirstResponder];
}

-(void)didSendGifMessage:(DTGif *)gif {
    NSString *sendStr = [@"[" stringByAppendingFormat:@"%@]", gif.text];
    NSDictionary *msgData = @{WEBSTICKER_URL: gif.mainImage, WEBSTICKER_IS_GIF: (gif.isAnimated ? @"1" : @"0"), WEBSTICKER_ID: gif.imageId,WEBSTICKER_WIDTH: @((float)gif.size.width), WEBSTICKER_HEIGHT: @((float)gif.size.height)};
    NSDictionary *extDic = @{TEXT_MESG_TYPE:TEXT_MESG_WEB_TYPE,
                             TEXT_MESG_DATA:msgData
                             };
    
    ChatMessage *message = [[ChatMessage alloc] initWithMessageType:MMMessageTypeWebSticker messageContent:sendStr messageExtraInfo:extDic];
    [self appendAndDisplayMessage:message];
    
    self.inputToolBar.inputTextView.text = @"";
}

- (void)didSendMMFace:(DTEmoji *)emoji {
    NSString *sendStr = [@"[" stringByAppendingFormat:@"%@]", emoji.emojiName];
    NSDictionary *extDic = @{TEXT_MESG_TYPE:TEXT_MESG_FACE_TYPE,
                             TEXT_MESG_DATA:@[@[emoji.emojiCode, @(2)]]};
    ChatMessage *message = [[ChatMessage alloc] initWithMessageType:MMMessageTypeBigEmoji messageContent:sendStr messageExtraInfo:extDic];
    [self appendAndDisplayMessage:message];
}

- (void)didTouchKeyboardReturnKey:(UITextView *)inputView {
    ChatMessage *message = [[ChatMessage alloc] initWithMessageType:MMMessageTypeText messageContent:inputView.text messageExtraInfo:nil];
    [self appendAndDisplayMessage:message];
}

- (void)toolbarHeightDidChangedTo:(CGFloat)height {
    CGRect tableViewFrame = _messagesTableView.frame;
    CGRect toolBarFrame = _inputToolBar.frame;
    
    toolBarFrame.origin.y = CGRectGetMaxY(_inputToolBar.frame) - height;
    toolBarFrame.size.height = height;
    tableViewFrame.size.height = toolBarFrame.origin.y;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_inputToolBar.frame = toolBarFrame;
        self->_messagesTableView.frame = tableViewFrame;
    } completion:^(BOOL finished) {
        
    }];
    [self scrollViewToBottom];
}

#pragma mark -- private
- (void)appendAndDisplayMessage:(ChatMessage *)message {
    if (!message) {
        return;
    }
    [_messagesArray addObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_messagesArray.count - 1 inSection:0];
    if ([self.messagesTableView numberOfRowsInSection:0] != _messagesArray.count - 1) {
        NSLog(@"Error, datasource and tableview are inconsistent!!");
        [self.messagesTableView reloadData];
        return;
    }
    [self.messagesTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self scrollViewToBottom];
}

//Integrate BQMM
#pragma mark RCMessageCellDelegate
- (void)didTapChatViewCell:(ChatMessage *)messageModel {
    
}

- (void)didLongPressChatViewCell:(ChatMessage *)messageModel inView:(UIView *)view {
    _inputToolBar.inputTextView.disableActionMenu = YES;

    _longPressSelectedModel = messageModel;

    CGRect rect = [self.view convertRect:view.frame fromView:view.superview];

    _menuController = [UIMenuController sharedMenuController];
    UIMenuItem *copyItem = [[UIMenuItem alloc]
                            initWithTitle:@"Copy"
                            action:@selector(onCopyMessage)];

    NSString *title;
    NSDictionary *extDic = messageModel.messageExtraInfo;
    if (messageModel.messageType == MMMessageTypeBigEmoji) {
        NSArray *codes = nil;
        if (extDic[TEXT_MESG_DATA]) {
            codes = @[extDic[TEXT_MESG_DATA][0][0]];
        }
        if (codes.count > 0) {
            NSString *emojiCode = codes.firstObject;
            if (emojiCode != nil && emojiCode.length > 0) {
                if([[DongtuStore sharedInstance] hasCollectedDTEmojiWithEmojiCode:emojiCode]) {
                    title = @"取消收藏";
                }else{
                    title = @"收藏";
                }
            }
        }
    } else if(messageModel.messageType == MMMessageTypeWebSticker) {
        NSDictionary *msgData = extDic[TEXT_MESG_DATA];
        NSString *gifUrl = msgData[WEBSTICKER_URL];
        NSString *gifId = msgData[WEBSTICKER_ID];
        if (gifId && gifUrl && gifId.length > 0 && gifUrl.length > 0) {
            if([[DongtuStore sharedInstance] hasCollectedDTGifWithGifUrl:gifUrl andGifId:gifId]) {
                title = @"取消收藏";
            }else{
                title = @"收藏";
            }
        }
    }

    [_menuController setMenuItems:nil];
    if (title) {
        UIMenuItem *collectItem = [[UIMenuItem alloc]
                                   initWithTitle:title
                                   action:@selector(onCollectEmoji)];
        [_menuController setMenuItems:@[ copyItem, collectItem ]];
    }else{
        [_menuController setMenuItems:@[ copyItem ]];
    }
    [_menuController setTargetRect:rect inView:self.view];
    [_menuController setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)onCopyMessage {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _longPressSelectedModel.messageContent;
}

- (void)onCollectEmoji {
    NSDictionary *extDic = _longPressSelectedModel.messageExtraInfo;
    if (_longPressSelectedModel.messageType == MMMessageTypeBigEmoji) {
        NSArray *codes = nil;
        if (extDic[TEXT_MESG_DATA]) {
            codes = @[extDic[TEXT_MESG_DATA][0][0]];
        }
        if (codes && codes.count > 0) {
            NSString *emojiCode = codes.firstObject;
            if (emojiCode != nil && emojiCode.length > 0) {
                if([[DongtuStore sharedInstance] hasCollectedDTEmojiWithEmojiCode:emojiCode]) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[DongtuStore sharedInstance] uncollectDTEmojiWithEmojiCode:emojiCode completionHandler:^(BOOL result, DTError * _Nullable error) {
                        if (result) {
                            hud.label.text = @"取消收藏成功";
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [hud hideAnimated:YES];
                            });
                        }else{
                            hud.label.text = error.errorMessage;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [hud hideAnimated:YES];
                            });
                        }
                    }];
                }else{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[DongtuStore sharedInstance] collectDTEmojiWithEmojiCode:emojiCode completionHandler:^(BOOL result, DTError * _Nullable error) {
                        if (result) {
                            hud.label.text = @"收藏成功";
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [hud hideAnimated:YES];
                            });
                        }else{
                            hud.label.text = error.errorMessage;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [hud hideAnimated:YES];
                            });
                        }
                    }];
                }
            }
        }
    }else if(_longPressSelectedModel.messageType == MMMessageTypeWebSticker) {
        NSDictionary *msgData = extDic[TEXT_MESG_DATA];
        NSString *gifUrl = msgData[WEBSTICKER_URL];
        NSString *gifId = msgData[WEBSTICKER_ID];
        if (gifId && gifUrl && gifId.length > 0 && gifUrl.length > 0) {
            if([[DongtuStore sharedInstance] hasCollectedDTGifWithGifUrl:gifUrl andGifId:gifId]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[DongtuStore sharedInstance] uncollectDTGifWithGifUrl:gifUrl andGifId:gifId completionHandler:^(BOOL result, DTError * _Nullable error) {
                    if (result) {
                        hud.label.text = @"取消收藏成功";
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [hud hideAnimated:YES];
                        });
                    }else{
                        hud.label.text = error.errorMessage;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [hud hideAnimated:YES];
                        });
                    }
                }];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[DongtuStore sharedInstance] collectDTGifWithGifUrl:gifUrl andGifId:gifId completionHandler:^(BOOL result, DTError * _Nullable error) {
                    if (result) {
                        hud.label.text = @"收藏成功";
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [hud hideAnimated:YES];
                        });
                    }else{
                        hud.label.text = error.errorMessage;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [hud hideAnimated:YES];
                        });
                    }
                }];
            }
        }
    }
}

- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)didTapUrlInMessageCell:(NSString *)url {
    NSURL *stringUrl = [[NSURL alloc] initWithString:url];
    [[UIApplication sharedApplication] openURL:stringUrl];
}
@end


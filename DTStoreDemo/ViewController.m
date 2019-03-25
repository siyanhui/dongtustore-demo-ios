//
//  ViewController.m
//  DTStoreDemo
//
//  Created by Isan Hu on 2019/3/1.
//  Copyright © 2019 siyanhui. All rights reserved.
//

#import "ViewController.h"
#import "DTChatViewTextCell.h"
#import "DTChatViewImageCell.h"
#import "ChatMessage.h"
#import <DongtuStoreSDK/DongtuStoreSDK.h>

@interface ViewController (){
    NSMutableArray *_messagesArray;
    ChatMessage *_longPressSelectedModel;
    UIMenuController *_menuController;
    BOOL _isFirstLayOut;
}

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    //menu
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide) name:UIMenuControllerWillHideMenuNotification object:nil];
    [DongTuStore sharedInstance].delegate = _inputToolBar; //set SDK delegate
}

- (void)menuDidHide {
    [[UIMenuController sharedMenuController] setMenuItems:nil];
    _inputToolBar.inputTextView.disableActionMenu = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DongTuStore sharedInstance].delegate = nil;
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
    
    [[DongTuStore sharedInstance] shouldShowSearchPopupAboveView:_inputToolBar withInput:_inputToolBar.inputTextView];
    
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
    [[DongTuStore sharedInstance] switchToDefaultKeyboard];
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
        [[DongTuStore sharedInstance] attachEmotionKeyboardToInput:_inputToolBar.inputTextView];
        
    }else{
        [[DongTuStore sharedInstance] switchToDefaultKeyboard];
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
    [_menuController setMenuItems:nil];
    [_menuController setMenuItems:@[ copyItem ]];
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

- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)didTapUrlInMessageCell:(NSString *)url {
    NSURL *stringUrl = [[NSURL alloc] initWithString:url];
    [[UIApplication sharedApplication] openURL:stringUrl];
}
@end

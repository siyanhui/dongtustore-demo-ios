# dongtustore-demo-ios
动图宇宙-表情云SDK接入Demo

#  动图宇宙商店SDK接入说明

接入**SDK**，有以下必要步骤：

1. 下载与安装
2. 获取必要的接入信息  
3. 开始集成  

## 第一步：下载与安装

### 手动导入SDK

下载当前最新版本，解压缩后获得： `DongtuStoreSDK`， 其中包含SDK和库文件`DongtuStoreSDK.framework`及所需的资源文件`DongtuStoreSDK.bundle`


### 添加系统库依赖

您除了在工程中导入 SDK 之外，还需要添加libsqlite3.0.tbd。
在build setting中添加 Other Linker Flags: -Objc


## 第二步：获取必要的接入信息

开发者将应用与SDK进行对接时,必要接入信息如下:

* `appId` - 应用的App ID
* `appSecret` - 应用的App Secret

如您暂未获得以上接入信息，可以在此[申请](http://www.biaoqingsdk.com/register.html)


## 第三步：开始集成

### 0. 注册AppId&AppSecret、设置SDK语言和区域

在 `AppDelegate` 的 `-application:didFinishLaunchingWithOptions:` 中添加：

```objectivec
// 初始化SDK
[[DongtuStore sharedInstance] setAppId:@"your app id" secret:@"your secret"];
//设置SDK语言和区域
[DongtuStore sharedInstance].sdkLanguage = DTLanguageChinese;
[DongtuStore sharedInstance].sdkRegion = DTRegionChina;
```

### 1. 通过 `DongtuStore` 提供的接口查看 SDK 版本、设置用户

- 查看 SDK 版本

```objectivec
/**
获取 SDK 的版本的方法

@return SDK 的版本
*/
+ (NSString *)version;
```

- 设置用户

说明：可设置用户id、姓名、电话、邮箱、地址、性别及其他信息

```objectivec
/**
设置app本地用户信息

@param user 用户信息构造的DTUser对象 (详见DTUser.h)
*/
+(void)setUser:(DTUser *)user;
```

### 3. 使用联想功能、表情键盘和GIF搜索模块

#### 设置SDK代理 
使用联想功能、表情键盘和GIF搜索模块前需要设置代理，以接收SDK的事件
```objectivec
[DongtuStore sharedInstance].delegate = self;
```

#### 配置联想功能

调用联想接口，SDK会根据input中的内容实时的联想出表情，并显示在attachedView上方。
```objectivec 
/**
 *  @param attachedView  联想UI放置在配置的attachedView上面
 *  @param input         联想根据配置的input输入框中的内容获取表情
 */
- (void)shouldShowSearchPopupAboveView:(nonnull UIView *)attachedView
                             withInput:(nonnull UIResponder <UITextInput> *)input;
```

#### 触发表情键盘显示

需要使用SDK的表情键盘时，可通过下方代码来调起。
```objectivec 
if (!_inputTextView.isFirstResponder) {
    [_inputTextView becomeFirstResponder];
}
[[DongtuStore sharedInstance] attachEmotionKeyboardToInput:_inputTextView];
```

#### 由表情键盘切换为普通键盘
```objectivec 
if (!_inputTextView.isFirstResponder) {
    [_inputTextView becomeFirstResponder];
}
[[DongtuStore sharedInstance] switchToDefaultKeyboard];
```

#### 触发GIF搜索
需要搜素gif图片时，点击表情键盘底栏的Gif图标触发GIF搜索，然后在弹出的view中进行操作。

#### 实现SDK代理方法
```objectivec 
//点击了表情键盘中的表情图片代理
//可以在该代理方法中拿到点击的表情对象
- (void)didSelectEmoji:(DTEmoji *)emoji
{

}

//点击了联想UI和GIF UI中的表情图片代理
//可以在该代理方法中拿到点击的表情对象
- (void)didSelectGif:(DTGif *)gif {
    
}

//点击表情键盘上发送按钮的代理
- (void)didSendWithInput:(UIResponder<UITextInput> *)input
{

}

//点击输入框的代理（这个代理方法的触发意味着键盘从表情键盘切换回了系统键盘）
- (void)tapOverlay
{

}

```


### 4. 表情显示：通过`DTImageView`展示 `DTGif` 及 `DTEmoji`

#### 展示 `DTGif`
```objectivec
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
```

#### 展示 `DTEmoji`
```objectivec
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

```

### 5. IM 消息发送、接收并解析展示示例 （以环信为例）

发送`DTGIf`消息

```objectivec
-(void)sendGifMessage:(DTGif *)gif {
    //1.DTGif的text字段作为发送的文字内容
    NSString *sendStr = [@"[" stringByAppendingFormat:@"%@]", gif.text];

    //2.构造消息的扩展信息
    NSDictionary *msgData = @{@"sticker_url": gif.mainImage,                //图片url
                              @"is_gif": (gif.isAnimated ? @"1" : @"0"),    //图片是否是动图
                              @"data_id": gif.imageId,                      //图片id
                              @"w": @((float)gif.size.width),               //图片宽度
                              @"h": @((float)gif.size.height)};             //图片高度

    NSDictionary *extDic = @{@"txt_msgType":TEXT_MESG_WEB_TYPE,             //配置自定义消息类型
                             @"msg_data":msgData};                          //消息扩展

    //3.构造消息
    EMMessage *message = [EaseSDKHelper sendTextMessage:sendStr
                        to:self.conversation.conversationId
                        messageType:[self _messageTypeFromConversationType]
                        messageExt:extDic];
    
    //4.发送消息
    [self _sendMessage:message];
}

```

发送`DTEmoji`消息

```objectivec
-(void)sendMMFaceMessage:(DTEmoji *)emoji
{
    //1.DTEmoji的emojiName字段作为发送的文字内容
    NSString *sendStr = [NSString stringWithFormat:@"[%@]", emoji.emojiName];

    //2.构造消息的扩展信息
    NSDictionary *extDic = @{
        @"txt_msgType":@"facetype",                             //配置自定义消息类型
        @"msg_data":@[@[emoji.emojiCode, @(2)]]};     //消息扩展

    
    //3.构造消息
    EMMessage *message = [EaseSDKHelper sendTextMessage:sendStr
                        to:self.conversation.conversationId
                        messageType:[self _messageTypeFromConversationType]
                        messageExt:extDic];
    
    //4.发送消息
    [self _sendMessage:message];
}
```

解析`DTGif`消息 & 展示 `DTGif`消息
  
```objectivec
//1.解析消息扩展，提取图片url和id
NSDictionary *extDic = messageModel.ext;
if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString:@"webtype"]) {
    NSDictionary *msgData = extDic[@"msg_data"];
    if (msgData) {
        NSString *gifUrl = msgData[@"sticker_url"];
        NSString *gifId = msgData[@"data_id"];
        float height = [msgData[@"h"] floatValue];
        float width = [msgData[@"w"] floatValue];
    }
}

//2.展示

//计算图片展示size
CGSize imageSize = [DTImageView sizeForImageSize:CGSizeMake(width, height)               
                                      imgMaxSize:CGSizeMake(200, 150)];


//3.展示消息
imageView = [[DTImageView alloc] init];
[imageView setImageWithDTUrl:gifUrl gifId:gifId];
```

解析`DTEmoji`消息 & 展示 `DTEmoji`消息
  
```objectivec
//1.解析消息扩展，提取图片的code
NSDictionary *extDic = messageModel.ext;
if (extDic != nil && [extDic[@"txt_msgType"] isEqualToString:@"facetype"]) {
    NSString *emojiCode = nil;
    if (extDic[@"msg_data"]) {
        emojiCode = extDic[@"msg_data"][0][0];
    }
}

//2.展示

//计算图片展示size
CGSize imageSize = [DTImageView sizeForImageSize:CGSizeMake(120, 120) imgMaxSize:CGSizeMake(120, 120)];

//3.展示消息
imageView = [[DTImageView alloc] init];
[imageView setImageWithEmojiCode:emojiCode];

```

### 6. UI定制
SDK通过DTStoreTheme提供一定程度的UI定制。具体参考类说明DTStoreTheme。
创建一个DTStoreTheme对象，设置相关属性， 然后[[DongtuStore sharedInstance] setTheme:]即可修改SDK UI的样式

### 7. 清除缓存
调用clearCache方法清除缓存，此操作会删除所有临时的表情缓存，已下载的表情包不会被删除。

```objectivec
[[DongtuStore sharedInstance] clearCache]
```



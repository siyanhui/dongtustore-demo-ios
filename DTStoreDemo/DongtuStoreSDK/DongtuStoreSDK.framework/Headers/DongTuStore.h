//
//  DongTuStore.h
//  DongtuSDK
//
//  Created by Isan Hu on 2019/2/24.
//  Copyright © 2019 Isan Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTStoreTheme.h"
#import "DTEmoji.h"
#import "DTGif.h"
#import "DTUser.h"

/**
 sdk region
 */
typedef enum
{
    DTRegionChina   = 0,
    DTRegionOther   = 1,
} DTRegion;

/**
 sdk language
 */
typedef enum
{
    DTLanguageChinese,
    DTLanguageEnglish,
} DTLanguage;

/**
 the type of emoji that to be fetched
 */
typedef enum
{
    DTFetchTypeSmall    = 1 << 0,
    DTFetchTypeBig      = 1 << 1,
    DTFetchTypeAll      = 1 << 2
} DTFetchType;

/**
 DongtuStore Delegate
 */
@protocol DongtuStoreDelegate <NSObject>

@required
/**
 handle the click of gif in the gif keyboard and gif popupview
 */
- (void)didSelectGif:(DTGif *)gif;

/**
 *  the delegate method handles the selection of big emoji in the keyboard
 *
 *  @param emoji      big emoji model
 */
- (void)didSelectEmoji:(nonnull DTEmoji *)emoji;

/**
 *  the delegate method handles the click of `send` button in the small emoji keyboard
 *
 *  @param input   the input control e.g. UITextView, UITextField...
 */
- (void)didSendWithInput:(nonnull UIResponder<UITextInput> *)input;

/**
 *  the delegate method called when user click the input control, at that point the keyboard has been
 switched to default, you can set the status of the control that controls the status of keyboard if necessary
 */
- (void)tapOverlay;
@end


@interface DongtuStore : NSObject

/**
 *  SDK region  default:DTRegionChina
 */
@property (nonatomic) DTRegion sdkRegion;

/**
 *  SDK language  default:DTLanguageChinese
 */
@property (nonatomic) DTLanguage sdkLanguage;

/**
 *  the delegate is the main data source of SDK
 */
@property (nonatomic, weak, nullable) id<DongtuStoreDelegate> delegate;

/**
 *  DongTuStore Singleton
 */
+ (nonnull instancetype)sharedInstance;

/**
 *  initialize SDK
 *  Apply for appId and secret： http://open.biaoqingmm.com/open/register/index.html
 *  @param appId  the unique app id that assigned to your app
 *  @param secret the unique app secret that assigned to your app
 */
- (void)setAppId:(nonnull NSString *)appId
          secret:(nonnull NSString *)secret;

/**
 *  get the current version of SDK
 *
 *  @return the current version of SDK
 */
- (nonnull NSString *)version;

/**
 set user infomation
 */
- (void)setUser:(DTUser *)user;


/**
 *  set the skin of SDK
 *
 *  @param theme  the DTStoreTheme Object for SDK, please check out DTStoreTheme.h for detail
 */
- (void)setTheme:(nonnull DTStoreTheme *)theme;

/**
 *  set the default emoji group
 *
 *  @param emojiArray the unicode emoji array
 */
- (void)setDefaultEmojiArray:(nonnull NSArray<NSString *> *)emojiArray;

/**
 *  switch to default keyboard
 */
- (void)switchToDefaultKeyboard;

/**
 *  switch to emoji keyboard
 *
 *  @param input the input control
 */
- (void)attachEmotionKeyboardToInput:(nonnull UIResponder<UITextInput> *)input;

/**
 *  trigger the function of `popup` (as user typing SDK try to find the emojis that matching the content that user inputs)
 
 *  @param attachedView a view that the prompts show right above
 *  @param input       input control
 */
- (void)shouldShowSearchPopupAboveView:(nonnull UIView *)attachedView
                             withInput:(nonnull UIResponder <UITextInput> *)input;

/**
 dismiss `popup`
 */
- (void)dismissSearchPopup;

/**
 * Enabled means Keyboard will show Unicode Emoji Tap; Default is Enabled
 *  @param enable       enable
 */
- (void)setUnicodeEmojiTabEnabled: (BOOL)enable;

/**
 *  fetch emojis according to emoji type and emoji code
 *
 *  @param fetchType         emoji type
 *  @param emojiCodes        a collection of emoji code
 *  @param completionHandler complition handler  emojis: a collection of MMEmoji or error object
 */
- (void)fetchEmojisByType:(DTFetchType)fetchType
                    codes:(nonnull NSArray *)emojiCodes
        completionHandler:(void (^ __nullable )(NSArray * __nullable emojis))completionHandler;

/**
 *  clear cache
 */
- (void)clearCache;


@end

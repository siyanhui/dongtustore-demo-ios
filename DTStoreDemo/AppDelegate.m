//
//  AppDelegate.m
//  DTStoreDemo
//
//  Created by Isan Hu on 2019/3/1.
//  Copyright © 2019 siyanhui. All rights reserved.
//

#import "AppDelegate.h"
#import <DongtuStoreSDK/DongtuStoreSDK.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIColor *navBarTintColor = [UIColor colorWithRed:24.0/255.0
                                               green:180.0/255.0
                                                blue:237.0/255.0
                                               alpha:1.0];
    [[UINavigationBar appearance] setBarTintColor:navBarTintColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    nav.navigationBar.barTintColor = [UIColor colorWithRed:27.0 / 255 green:130.0 / 255 blue:210.0 / 255 alpha:1.0];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    nav.navigationBar.titleTextAttributes = attributes;
    
    [self initSDK];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)initSDK {
    NSString *appId = @"";
    NSString *secret = @"";
    [[DongTuStore sharedInstance] setAppId:appId secret:secret];
    [DongTuStore sharedInstance].sdkLanguage = DTLanguageChinese;
    [DongTuStore sharedInstance].sdkRegion = DTRegionOther;
    
    DTUser *user = [[DTUser alloc] init];
    user.name = @"username";
    user.userId = @"33333333";
    user.email = @"user@gmail.com";
    user.otherInfo = @{@"region":@"China"};
    [[DongTuStore sharedInstance] setUser:user];
}

@end

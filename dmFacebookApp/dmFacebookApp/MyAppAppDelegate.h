//
//  MyAppAppDelegate.h
//  dmFacebookApp
//
//  Created by Saquib Waheed on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mViewController.h"
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const sessionStateChangedNotification;


@interface MyAppAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) UITabBarController* tabController;

@property (strong, nonatomic) mViewController* mainViewController;

-(void) showLoginView;

- (void) openSession;

@end

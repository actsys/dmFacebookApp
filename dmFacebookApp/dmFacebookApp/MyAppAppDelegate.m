//
//  MyAppAppDelegate.m
//  dmFacebookApp
//
//  Created by Saquib Waheed on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyAppAppDelegate.h"
#import "LoginViewController.h"

NSString *const sessionStateChangedNotification=@"com.company.dmFacebookApp:sessionStateChangedNotification";

@implementation MyAppAppDelegate


@synthesize window = _window;
@synthesize navController=_navController;
@synthesize tabController;
@synthesize mainViewController=_mainViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    
    self.mainViewController=[[mViewController alloc]initWithNibName:@"mViewController" bundle:nil ];
    
    self.navController=[[UINavigationController alloc]initWithRootViewController:self.mainViewController];
    
    self.window.rootViewController=self.navController;
    
    [self.window makeKeyAndVisible];
  
    if ([[FBSession activeSession]state]==FBSessionStateCreatedTokenLoaded) {
        
        [self openSession];
        
    } else {
          [self showLoginView];
    }
    
// Override point for customization after application launch.
    return YES;
}

- (void) showLoginView{

    UIViewController* topViewController=[self.navController topViewController];
    
    UIViewController* modalViewController=[topViewController modalViewController];
    
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        
        LoginViewController* loginView=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [topViewController presentModalViewController:loginView animated:NO];
        
    } else {
        
        LoginViewController* loginView=(LoginViewController*) modalViewController;
        [loginView loginFailed];
        
    }
    
   
}


- (void) sessionStateChanged:(FBSession*)session
                       state:(FBSessionState)state
                       error: (NSError*) error{
    
    switch (state) {
        case FBSessionStateOpen:{
        
            UIViewController* topViewController=[self.navController topViewController];
            
            if ([[topViewController modalViewController]isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            } 
        }
            break;
        
            case FBSessionStateClosed:
            case FBSessionStateClosedLoginFailed:
            
                [self.navController popToRootViewControllerAnimated:NO];
            
            [[FBSession activeSession]closeAndClearTokenInformation];
            [self showLoginView];
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:sessionStateChangedNotification object:session];
    
    if (error) {
        
        UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    

}

- (void) openSession
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"read_stream",@"user_likes", nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error){
        [self sessionStateChanged:session state:state error:error];
    }];
}

- (BOOL)application: (UIApplication*) application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSession activeSession]handleOpenURL:url];
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [[FBSession activeSession]handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end

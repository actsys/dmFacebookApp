//
//  mViewController.h
//  dmFacebookApp
//
//  Created by Saquib Waheed on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

@interface mViewController : UIViewController

@property (strong, nonatomic) IBOutlet FBProfilePictureView* userProfileImage;

@property (strong, nonatomic) IBOutlet UILabel* userNameLabel;

@property (strong, nonatomic) IBOutlet UITableView* mainTableView;

@property (strong, nonatomic) NSArray* dataInfo;

@property (strong, nonatomic) NSArray* dataInfo1;

//@property (strong, nonatomic) FBViewController

@end

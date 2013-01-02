//
//  LoginViewController.h
//  dmFacebookApp
//
//  Created by Saquib Waheed on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong,nonatomic) IBOutlet UIActivityIndicatorView* spinner;

- (IBAction)performLogin:(id)sender;

- (void) loginFailed;

@end

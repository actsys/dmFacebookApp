//
//  emailViewController.h
//  dmFacebookApp
//
//  Created by Saquib Waheed on 12/24/12.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface emailViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)sendEmail:(id)sender;

@property (strong, nonatomic) NSArray* dataHolder;

@end

//
//  UserInfoController.m
//  dmFacebookApp
//
//  Created by Saquib Waheed on 12/31/12.
//
//

#import "UserInfoController.h"
#import "mViewController.h"

@interface UserInfoController ()

@end

@implementation UserInfoController

@synthesize userInfoTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self populateUserInfo];
    // Do any additional setup after loading the view from its nib.
}

- (void) populateUserInfo
{
    if ([[FBSession activeSession]isOpen ]) {
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection* connection,
                                                id<FBGraphUser> user,
                                                NSError* error) {
        
            if (!error) {
                NSString* userInfo=@"";
                
                userInfo = [userInfo
                            stringByAppendingString:
                            [NSString stringWithFormat:@"Name: %@\n\n",
                             user.name]];
                
                userInfo = [userInfo
                            stringByAppendingString:
                            [NSString stringWithFormat:@"Birthday: %@\n\n",
                             user.birthday]];
                
                userInfo = [userInfo
                           stringByAppendingString:
                           [NSString stringWithFormat:@"Location: %@\n\n",
                            [user.location objectForKey:@"name"]]];
                
//                userInfo = [userInfo
//                            stringByAppendingString:
//                            [NSString stringWithFormat:@"Locale: %@\n\n",
//                             [user objectForKey:@"locale"]]];
                
                if ([user objectForKey:@"languages"]) {
                    NSArray *languages = [user objectForKey:@"languages"];
                    NSMutableArray *languageNames = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [languages count]; i++) {
                        [languageNames addObject:[[languages
                                                   objectAtIndex:i]
                                                  objectForKey:@"name"]];
                    }
//                    userInfo = [userInfo
//                                 stringByAppendingString:
//                                 [NSString stringWithFormat:@"Languages: %@\n\n",
//                                  languageNames]];
                }

                self.userInfoTextView.text=userInfo;
            }
        
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  emailViewController.m
//  dmFacebookApp
//
//  Created by Saquib Waheed on 12/24/12.
//
//

#import "emailViewController.h"
#import "fViewController.h"
#import "mViewController.h"

@interface emailViewController ()

@end

@implementation emailViewController

@synthesize dataHolder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) showHomeView
{
    //    mViewController* mView=[[mViewController alloc]initWithNibName:@"mlViewController" bundle:nil];
    //    [self.navigationController pushViewController:mView animated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void) showFriendsView
{
    fViewController* friendsView=[[fViewController alloc]initWithStyle:UITableViewStylePlain];
    
    friendsView.tableData=dataHolder;
    
    [self.navigationController pushViewController:friendsView animated:NO];
    
    
}



- (void) loadToolBar
{
    //self.navigationController.toolbarHidden=NO;
    
    UIBarButtonItem* flexibleSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(showHomeView)];
    
    
    UIBarButtonItem* item1=[[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(showHomeView)];
    
    UIBarButtonItem* item2=[[UIBarButtonItem alloc]initWithTitle:@"Friends" style:UIBarButtonItemStylePlain target:self action:@selector(showFriendsView)];
    
    UIBarButtonItem* item3=[[UIBarButtonItem alloc]initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    NSArray* items=[NSArray arrayWithObjects:flexibleSpace, item1,flexibleSpace, item2,flexibleSpace, item3,flexibleSpace, nil];
    
    self.toolbarItems=items;
    
    
}

- (void) fql:(NSString*)query
{
    if ([[FBSession activeSession]isOpen ]) {
        NSDictionary* param=[NSDictionary dictionaryWithObjectsAndKeys:query,@"q",nil];
        
        [FBRequestConnection startWithGraphPath:@"/fql" parameters:param HTTPMethod:@"GET" completionHandler:^(FBRequestConnection* connection,
                                                                                                               id result,
                                                                                                               NSError* error){
            if (error) {
                NSLog(@"Error: %@",[error localizedDescription]);
            } else {
                NSLog(@"Result: %@", result);
                dataHolder=[result objectForKey:@"data"];
            }
        }];        
    }
}

- (IBAction)sendEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        NSString *emailTitle = @"";
        
        NSString *messageBody = @"";
        
        NSArray *toRecipents = [NSArray arrayWithObject:@""];
        
        MFMailComposeViewController* mailView=[[MFMailComposeViewController alloc]init];
        mailView.mailComposeDelegate=self;
        [mailView setSubject:emailTitle];
        [mailView setMessageBody:messageBody isHTML:NO];
        [mailView setToRecipients:toRecipents];
        
        [self presentViewController:mailView animated:YES completion:NULL];

    } else {
        
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Failure"
                                                    message:@"Your Device"
                                                   delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [alert show];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Cancelled");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) logoutButtonWasPressed:(id)sender
{
    [[FBSession activeSession]closeAndClearTokenInformation];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonWasPressed:)];

    
    [self loadToolBar];
    self.title=@"Email";
    
    NSString* qry=@"SELECT uid, name, pic_square FROM user where uid in (SELECT uid2 FROM friend where uid1=me())";
    [self fql:qry];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

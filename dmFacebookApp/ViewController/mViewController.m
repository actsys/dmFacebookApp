//
//  mViewController.m
//  dmFacebookApp
//
//  Created by Saquib Waheed on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mViewController.h"
#import "MyAppAppDelegate.h"
#import "fViewController.h"
#import "emailViewController.h"
#import "StatusViewController.h"
#import "UserInfoController.h"
#import "ActivityIndicator.h"

@interface mViewController()

<UITableViewDataSource, UITableViewDelegate>

@end

@implementation mViewController

@synthesize dataInfo;
@synthesize dataInfo1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) logoutButtonWasPressed:(id)sender
{
    [[FBSession activeSession]closeAndClearTokenInformation];
}

- (void) populateUserDetails
{
    //NSString* qry=@"SELECT uid, name, pic_square FROM user where uid in (SELECT uid2 FROM friend where uid1=me())";
    
    if ([[FBSession activeSession]isOpen]) {
        [[FBRequest requestForMe]startWithCompletionHandler:
        ^(FBRequestConnection* conn,
          NSDictionary<FBGraphUser>* user,
          NSError* error){
            if (!error) {
                self.userNameLabel.text=user.name;
                self.userProfileImage.profileID=user.id;
                //[self fql:qry];
                self.userProfileImage.layer.cornerRadius = 10.0f;
                
            }
        }];
    }
}


- (void) sessionStateChanged: (NSNotification*) notification
{
    [self populateUserDetails];
}

- (void) fql:(NSString*)query
{
    if ([[FBSession activeSession]isOpen ]) {
        
//        NSString* query=@"{"
//        @"'friends':'SELECT uid,name,pic_square FROM user where uid IN (SELECT uid2 FROM friend where uid1=me())',"
//        @"'status':'Select message from status where uid in(SELECT uid from #friends)',"
//        @"}";
        
        NSDictionary* param=[NSDictionary dictionaryWithObjectsAndKeys:query,@"q",nil];
        
        [FBRequestConnection startWithGraphPath:@"/fql" parameters:param HTTPMethod:@"GET" completionHandler:^(FBRequestConnection* connection,
                                                                                                               id result,
                                                                                                               NSError* error){
            if (error) {
                NSLog(@"Error: %@",[error localizedDescription]);
            } else {
                NSLog(@"Result: %@", result);
                dataInfo=[result objectForKey:@"data"];
            }
        }];

    }
}

- (void) fql1:(NSString*)query
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
                dataInfo1=[result objectForKey:@"data"];
            }
        }];
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier=@"cell";
    
    UITableViewCell* cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"Status";
            break;
            
        case 1:
            cell.textLabel.text=@"Messege";
            break;
            
        case 2:
            cell.textLabel.text=@"Info";
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            
            [self showStatusList];
            
            break;
        
        case 1:
            
            break;
            
        case 2:
            
            [self showUserInfo];
            
            break;
            
        default:
            break;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void) showStatusList
{
    //NSString* qry=@"SELECT  message from status where uid=me() ";
   // [self fql:qry];
    
    StatusViewController* statusView=[[StatusViewController alloc]initWithStyle:UITableViewStylePlain];
    statusView.statusList=dataInfo1;
    
    [self.navigationController pushViewController:statusView animated:NO];
    
}

- (void) showUserInfo
{
    UserInfoController* userInfo=[[UserInfoController alloc] initWithNibName:@"UserInfoController" bundle:nil];
    [self.navigationController pushViewController:userInfo animated:NO];
}

- (void) showFriendsView
{
    ActivityIndicator* actInd=[[ActivityIndicator alloc]initWithNibName:@"ActivityIndicator" bundle:nil];
    [self.navigationController pushViewController:actInd animated:NO];
    
    fViewController* friendsView=[[fViewController alloc]initWithStyle:UITableViewStylePlain];
    
    friendsView.tableData=dataInfo;
    
    [self.navigationController pushViewController:friendsView animated:NO];
    
    //[self.navigationController po];
}

- (void) showEmailView
{
    emailViewController* emailView=[[emailViewController alloc]initWithNibName:@"emailViewController" bundle:nil];
    [self.navigationController pushViewController:emailView animated:NO];
}

- (void) loadToolBar
{
     self.navigationController.toolbarHidden=NO;
    
    UIBarButtonItem* flexibleSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    UIBarButtonItem* item1=[[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem* item2=[[UIBarButtonItem alloc]initWithTitle:@"Friends" style:UIBarButtonItemStylePlain target:self action:@selector(showFriendsView)];
    
    UIBarButtonItem* item3=[[UIBarButtonItem alloc]initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(showEmailView)];
    
    
    NSArray* items=[NSArray arrayWithObjects:flexibleSpace, item1,flexibleSpace, item2,flexibleSpace, item3,flexibleSpace, nil];
    
    self.toolbarItems=items;

}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonWasPressed:)];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sessionStateChanged:) name:sessionStateChangedNotification object:nil];
    
    [self loadToolBar];
    
        
    self.title=@"Hello Facebook";
    
    if ([[FBSession activeSession]isOpen]) {
        [self populateUserDetails];
        }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[FBSession activeSession]isOpen]) {
//        [self populateUserDetails];
        
        NSString* qry=@"SELECT uid, name, pic_square FROM user where uid in (SELECT uid2 FROM friend where uid1=me())";
        [self fql:qry];
        
        NSString* qry1=@"SELECT  message from status where uid=me() ";
        [self fql1:qry1];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

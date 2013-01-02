//
//  fViewController.m
//  dmFacebookApp
//
//  Created by Saquib Waheed on 12/26/12.
//
//

#import "fViewController.h"
#import "mViewController.h"
#import "emailViewController.h"


@interface fViewController ()

<UITableViewDataSource, UITableViewDelegate>

@end

@implementation fViewController

@synthesize tableData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title=@"Friends";
    
    //[self fql];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonWasPressed:)];
    
    [self loadToolBar];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
// Return the number of rows in the section.
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.tableData objectAtIndex:indexPath.row]
                           objectForKey:@"name"];
    UIImage *image = [UIImage imageWithData:
                      [NSData dataWithContentsOfURL:
                       [NSURL URLWithString:
                        [[self.tableData objectAtIndex:indexPath.row]
                         objectForKey:@"pic_square"]]]];
    cell.imageView.image = image;
    
    return cell;
}

- (void) logoutButtonWasPressed:(id)sender

{
    [[FBSession activeSession]closeAndClearTokenInformation];
}

- (void) showEmailView
{
    emailViewController* emailView=[[emailViewController alloc]initWithNibName:@"emailViewController" bundle:nil];
    [self.navigationController pushViewController:emailView animated:NO];
}

- (void) showHomeView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}



- (void) loadToolBar
{
    //self.navigationController.toolbarHidden=NO;
    
    UIBarButtonItem* flexibleSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    UIBarButtonItem* item1=[[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(showHomeView)];
    
    UIBarButtonItem* item2=[[UIBarButtonItem alloc]initWithTitle:@"Friends" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem* item3=[[UIBarButtonItem alloc]initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(showEmailView)];
    
    
    NSArray* items=[NSArray arrayWithObjects:flexibleSpace, item1,flexibleSpace, item2,flexibleSpace, item3,flexibleSpace, nil];
    
    self.toolbarItems=items;
    
}

- (void) fql
{
    if ([[FBSession activeSession]isOpen ]) {
        NSString* query=@"SELECT uid, name, pic_square FROM user where uid in"
        @"(SELECT uid2 FROM friend where uid1=me() limit 5)";
        
        NSDictionary* param=[NSDictionary dictionaryWithObjectsAndKeys:query,@"q",nil];
        
        [FBRequestConnection startWithGraphPath:@"/fql" parameters:param HTTPMethod:@"GET" completionHandler:^(FBRequestConnection* connection,
                                                                                                               id result,
                                                                                                               NSError* error){
            if (error) {
                NSLog(@"Error: %@",[error localizedDescription]);
            } else {
                NSLog(@"Result: %@", result);
                
                tableData=(NSArray*) [result objectForKey:@"data"];
                
                
            }
        }];
        
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

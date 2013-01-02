//
//  ActivityIndicator.m
//  dmFacebookApp
//
//  Created by Saquib Waheed on 1/2/13.
//
//

#import "ActivityIndicator.h"

@interface ActivityIndicator ()

@end

@implementation ActivityIndicator

@synthesize activityIndicator;

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
    
    [self.activityIndicator startAnimating];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    [self.activityIndicator stopAnimating];
}

@end

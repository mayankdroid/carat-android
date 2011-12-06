//
//  HogReportViewController.m
//  Carat
//
//  Created by Adam Oliner on 10/6/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import "HogReportViewController.h"
#import "ReportItemCell.h"
#import "HogDetailViewController.h"
#import "FlurryAnalytics.h"

@implementation HogReportViewController

@synthesize hogTable = _hogTable;
@synthesize lastUpdatedString = _lastUpdatedString;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        self.title = @"Hog Report";
        self.tabBarItem.image = [UIImage imageNamed:@"hog"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfAppNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ReportViewCell";
    
    ReportItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReportItemCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (ReportItemCell *)currentObject;
                break;
            }
        }
    }
    
    // Set up the cell...
    NSString *appName = [listOfAppNames objectAtIndex:indexPath.row];
    cell.appName.text = appName;
    cell.appIcon.image = [UIImage imageNamed:[appName stringByAppendingString:@".png"]];
    cell.appScore.progress = [[listOfAppScores objectAtIndex:indexPath.row] floatValue];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Energy Hogs";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"'Updated:' yyyy-MM-dd, hh:mm:ss"];
    lastUpdatedString = [dateFormatter stringFromDate:[NSDate date]];
    return lastUpdatedString;
}

// loads the selected detail view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportItemCell *selectedCell = (ReportItemCell *)[tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setSelected:NO animated:YES];
    
    HogDetailViewController *dvController = [[HogDetailViewController alloc] initWithNibName:@"HogDetailView" bundle:nil];
    dvController.appName = selectedCell.appName;
    [FlurryAnalytics logEvent:@"selectedHogDetail"
               withParameters:[NSDictionary dictionaryWithObjectsAndKeys:dvController.appName, @"App Name", nil]];
    [self.navigationController pushViewController:dvController animated:YES];
    [dvController release];
    dvController = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // TODO: remove DUMMY DATA
    //Initialize the arrays.
    listOfAppNames = [[NSMutableArray alloc] init];
    listOfAppScores = [[NSMutableArray alloc] init];
    
    //Add items
    [listOfAppNames addObject:@"Camera+"];
    [listOfAppNames addObject:@"Fruit Ninja"];
    [listOfAppNames addObject:@"Skype"];
    [listOfAppNames addObject:@"Words With Friends HD"];
    [listOfAppNames addObject:@"Twitter"];
    [listOfAppNames addObject:@"Cut the Rope"];
    [listOfAppNames addObject:@"Angry Birds"];
    [listOfAppNames addObject:@"Shazam"];
    
    [listOfAppScores addObject:[NSNumber numberWithFloat:0.9f]];
    [listOfAppScores addObject:[NSNumber numberWithFloat:0.86f]];
    [listOfAppScores addObject:[NSNumber numberWithFloat:0.85f]];
    [listOfAppScores addObject:[NSNumber numberWithFloat:0.79f]];
    [listOfAppScores addObject:[NSNumber numberWithFloat:0.4f]];
    [listOfAppScores addObject:[NSNumber numberWithFloat:0.38f]];
    [listOfAppScores addObject:[NSNumber numberWithFloat:0.29f]];
    [listOfAppScores addObject:[NSNumber numberWithFloat:0.01f]];
    
    //Setup the navigation
    self.navigationItem.title = @"Energy Hogs";
}

- (void)viewDidUnload
{
    [hogTable release];
    [self setHogTable:nil];
    [lastUpdatedString release];
    [self setLastUpdatedString:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)dealloc {
    [hogTable release];
    [lastUpdatedString release];
    [listOfAppNames release];
    [listOfAppScores release];
    [dateFormatter release];
    [super dealloc];
}
@end
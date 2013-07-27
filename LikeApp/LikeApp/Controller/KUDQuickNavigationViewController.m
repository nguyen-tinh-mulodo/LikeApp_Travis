//
//  KUDQuickNavigationViewController.m
//  LikeApp
//
//  Created by Nhat Huy on 6/27/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDQuickNavigationViewController.h"
#import "KUDMyPageViewController.h"
#import "KUDMainViewController.h"
#import "KUDCameraRollViewController.h"
#import "KUDLoginViewController.h"
#import "KUDSettingViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface KUDQuickNavigationViewController ()

@property (strong,nonatomic) NSArray *arrayOfTableData;

@end

@implementation KUDQuickNavigationViewController

@synthesize arrayOfTableData, viewController, weakSelf;

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
    
    arrayOfTableData = [[NSArray alloc] initWithObjects:@"Home", @"My Page", @"Photos", @"Camera", @"Setting", @"Log out", nil];
    [self.tableView setFrame:CGRectMake(0, 100, 180, 264)];
    
    // Set tableview can't scroll
    [self.tableView setScrollEnabled:NO];
    
    // Hidden seperator line
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    // Set tableView can draw shadow
    [self.tableView setClipsToBounds:NO];
	
    // Set shadow for table view
    [self.tableView.layer setShadowOpacity:0.6];
    [self.tableView.layer setShadowColor:[UIColor darkTextColor].CGColor];
    [self.tableView.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.tableView.layer setShadowRadius:1];
    
    // Performance for shadow
    [self.view.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.view.bounds] CGPath]];

}

- (void)viewDidAppear:(BOOL)animated {
    
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
    return [arrayOfTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger row = [indexPath row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [arrayOfTableData objectAtIndex:row] ];
    [cell.textLabel setFont:[UIFont fontWithName:@"GillSans-Light" size:18]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setIndentationLevel:2];
    return cell;
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
    
    // Get the correct ViewController in storyboard identify by StoryboardID
    switch ([indexPath row]) {
        case 0: {
            // Go to Home Page ViewController
            if (![weakSelf isKindOfClass:[KUDMainViewController class]]) {
                
                // Go to Home Page
                [viewController popToRootViewControllerAnimated:YES];
            } else {
                
            }
                
            break;
        }
            
           
        case 1: {
            // Go to MyPage ViewController
            if (![weakSelf isKindOfClass:[KUDMyPageViewController class]]) {
                
                // Go to MyPage immediately
                [self goToMyPage];
            } else {
                
            }
            break;
        }
            
        case 2: {
            // Go to Library Photo ViewController
            if (![weakSelf isKindOfClass:[KUDMyPageViewController class]]) {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                KUDCameraRollViewController *cameraRollView = [storyboard instantiateViewControllerWithIdentifier:@"Photos"];
                [weakSelf presentViewController:cameraRollView animated:YES completion:nil];

            } else {
                
                KUDMyPageViewController *myPageViewController = weakSelf;
                [myPageViewController pushToCameraRollView:nil];
            }
            break;
        }
            
        case 3: {
            // Go to Camera ViewController
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            KUDCameraRollViewController *cameraRollView = [storyboard instantiateViewControllerWithIdentifier:@"Photos"];
            [weakSelf presentViewController:cameraRollView animated:YES completion:nil];
            [cameraRollView takePhoto];
            break;
        }
            
        case 4: {
            // Go to Setting ViewController
           
            KUDSettingViewController *settingViewController = [[KUDSettingViewController alloc] initWithNibName:@"KUDSettingViewController" bundle:nil];
            [viewController pushViewController:settingViewController animated:YES];
            break;
        }
            
        case 5: {
            // Go to Login ViewController
            
            // Check whether self is HomePage
            if (![weakSelf isKindOfClass:[KUDMainViewController class]]) {
                
                // Go to Home Page then Logout
                [viewController popToRootViewControllerAnimated:YES];
                KUDMainViewController __weak *mainView = viewController.viewControllers[0];
                [mainView logout:nil];
                
            } else {
                
                // Logout immediately
                KUDMainViewController *mainView = weakSelf;
                [mainView logout:nil];
            }
            break;
        }
            
            
        default:
            break;
    }
    
}

- (KUDMyPageViewController *)goToMyPage {
    
    // Go to MyPage ViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    KUDMyPageViewController *myPageViewController = [storyboard instantiateViewControllerWithIdentifier:@"MyPage"];
    [viewController pushViewController:myPageViewController animated:YES];
    return myPageViewController;
}

- (KUDMainViewController *)goToHomePage {
    // First go to Home Page ViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    KUDMainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"Home"];
    [viewController pushViewController:mainViewController animated:YES];
    
    return mainViewController;
}

@end

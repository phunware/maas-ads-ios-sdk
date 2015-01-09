//
//  MaaSAdvertisingNativeExampleViewController.h
//  PWAds-iOS-Sample
//
//  Created by Carl Zornes on 12/17/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

#import "MaaSAdvertisingNativeExampleViewController.h"
#import "MaaSAdvertisingAppDelegate.h"

#define ZONE_ID @"64477" // for example use only, don't use this zone in your app!
@interface MaaSAdvertisingNativeExampleViewController ()

@end

@implementation MaaSAdvertisingNativeExampleViewController

@synthesize pwNativeManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Fire the ad request
    [self requestNativeAds];
    
    // Initialize table data
    offices = [[NSArray alloc] initWithObjects:@"Austin", @"Miami", @"Rockville", @"New York", @"Chicago", @"Newport Beach", @"San Diego", nil];
}

- (void)requestNativeAds {
    pwNativeManager = [[PWAdsNativeAdManager alloc] init];
    pwNativeManager.delegate = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"test", @"mode", // enable test mode to test native ads in your app
                            nil];
    
    PWAdsRequest *request = [PWAdsRequest requestWithAdZone:ZONE_ID andCustomParameters:params];
    [pwNativeManager getAdsForRequest:request withRequestedNumberOfAds:1];
}

#pragma mark -
#pragma mark UITableViewDelegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(didGetAd) {
        //Since we are adding one native ad to the end of the list, increase the count by 1.
        return [offices count]+1;
    } else {
        return [offices count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *nativeTableCell = @"NativeTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nativeTableCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nativeTableCell];
    }
    
    NSIndexPath *newIP = [NSIndexPath indexPathForItem:7 inSection:0];
    if([indexPath isEqual:newIP] && didGetAd) {
        
        //We are now at the correct row. If there is a native ad in the array, then show it.
        if([pwNativeManager.allNativeAds count] > 0) {
            PWAdsNativeAd *newAd = [pwNativeManager.allNativeAds objectAtIndex:0];
            cell.textLabel.text = newAd.adTitle;
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.text = @"ADVERTISEMENT";
            if(newAd.adIconURL) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:newAd.adIconURL]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        cell.imageView.image = [UIImage imageWithData:imageData];
                        [cell setNeedsLayout];
                    });
                });
            }
            [pwNativeManager logNativeAdImpression:newAd];
        }
    } else {
        cell.imageView.image = [UIImage imageNamed:@"pw.jpg"];
        cell.textLabel.text = [offices objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *newIP = [NSIndexPath indexPathForItem:7 inSection:0];
    if([indexPath isEqual:newIP] && didGetAd) {
        //We are now at row containing the native ad. If there is an ad here, then allow it to click through.
        if([pwNativeManager.allNativeAds count] > 0) {
            [pwNativeManager nativeAdWasTouched:[pwNativeManager.allNativeAds objectAtIndex:0]];
        }
    } else {
        currentIndexPath = indexPath;
        NSString *msg = [NSString stringWithFormat:@"Welcome to %@!", [offices objectAtIndex:indexPath.row]];
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:msg
                                                         message:@"Open in Maps?"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles: @"OK", nil];
        [alert show];
    }
    
    // Deselect the row after selection
    NSIndexPath *selection = [tableView indexPathForSelectedRow];
    if (selection) {
        [tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString *addressString = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", [offices objectAtIndex:currentIndexPath.row]];
        addressString = [addressString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSURL *url = [NSURL URLWithString:addressString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark -
#pragma mark PWAdsNativeAdDelegate methods

- (void)pwNativeAdManagerWillLoadAd:(PWAdsNativeAdManager *)nativeAdManager {
    NSLog(@"Native Ad Manager is about to check server for ad...");
}

- (void)pwNativeAdManagerDidLoad:(PWAdsNativeAdManager *)nativeAdManager {
    NSLog(@"Native Ad Manager has loaded %lu ad(s).", (unsigned long)[nativeAdManager.allNativeAds count]);
    didGetAd = TRUE;
    // Reload table data to incorporate the native ad
    [customTable reloadData];
}

- (void)pwNativeAdManager:(PWAdsNativeAdManager *)nativeAdManager didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Native Ad Manager failed to load with the following error: %@", error.localizedDescription);
    didGetAd = FALSE;
    [customTable reloadData];
}

- (BOOL)pwNativeAdManagerActionShouldBegin:(PWAdsNativeAdManager *)nativeAdManager willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Native Ad was tapped, your UI will be covered up. %@", (willLeave ? @" !!LEAVING APP!!" : @""));
    // minimise app footprint for a better ad experience.
    // e.g. pause game, duck music, pause network access, reduce memory footprint, etc...
    return YES;
}

- (void)pwNativeAdManagerActionWillFinish:(PWAdsNativeAdManager *)nativeAdManager {
    NSLog(@"Native Ad is about to be dismissed, get ready!");
}

- (void)pwNativeAdManagerActionDidFinish:(PWAdsNativeAdManager *)nativeAdManager {
    NSLog(@"Native Ad is done covering your app, back to normal!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
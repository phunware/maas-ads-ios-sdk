//
//  DetailViewController.h
//  PWAdvertisingQA
//
//  Created by Hari Kunwar on 4/15/16.
//  Copyright © 2016 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdUnit;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) AdUnit *adObject;
@property (strong, nonatomic) id detailItem;

@end


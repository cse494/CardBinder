//
//  BinderCardDetailViewController.h
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BinderCardModel.h"
#import "BinderBuyCardViewController.h"

@interface BinderCardDetailViewController : UIViewController

@property(strong, nonatomic) BinderCardModel *cardDetail;

//links to each of the labels for card detail
-(IBAction)AddToTrade:(id)sender;
@property(strong,nonatomic) IBOutlet UITextField *cardQuantityToAdd;
@property(nonatomic, strong) NSMutableArray *arrayTrade;
@property(nonatomic) double cardPrice;

@property(strong, nonatomic) IBOutlet UILabel *averagePrice;
@property(strong, nonatomic) IBOutlet UILabel *maxPrice;
@property(strong, nonatomic) IBOutlet UILabel *minPrice;
@property(strong, nonatomic) IBOutlet UILabel *recentPrice;
@property(strong, nonatomic) IBOutlet UILabel *cardName;
@property(strong, nonatomic) IBOutlet UILabel *cardRarity;
@property(strong, nonatomic) IBOutlet UILabel *cardSet;
@property(strong, nonatomic) IBOutlet UILabel *cardText;
@property(weak, nonatomic) IBOutlet UIImageView *cardImage;

- (IBAction)alertFeatures;
//todo for future
//add property for buy it now button
//will link to ebay web and troll n toad web depending on button
//users can surf web normally and buy items

@end



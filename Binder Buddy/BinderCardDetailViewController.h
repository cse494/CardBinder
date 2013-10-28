//
//  BinderCardDetailViewController.h
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BinderCardModel.h"

@interface BinderCardDetailViewController : UIViewController

@property(strong, nonatomic) BinderCardModel * cardDetail;

//links to each of the labels for card detail
@property(strong, nonatomic) IBOutlet UILabel *averagePrice;
@property(strong, nonatomic) IBOutlet UILabel *maxPrice;
@property(strong, nonatomic) IBOutlet UILabel *minPrice;
@property(strong, nonatomic) IBOutlet UILabel *recentPrice;
@property(strong, nonatomic) IBOutlet UILabel *cardName;
@property(strong, nonatomic) IBOutlet UILabel *cardRarity;
@property(strong, nonatomic) IBOutlet UILabel *cardSet;
@property(strong, nonatomic) IBOutlet UILabel *cardText;
@property(strong, nonatomic) IBOutlet UIImageView *cardImage;

//todo for future
//add property for buy it now button
//will link to ebay web and troll n toad web depending on button
//users can surf web normally and buy items

@end

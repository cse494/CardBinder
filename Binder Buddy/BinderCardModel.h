//
//  BinderCardModel.h
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinderCardModel : NSObject

//model for card data for ebay and Troll and toad data
//currently only ebay implemented
//this data is used to populate the card detail page
@property(nonatomic, strong) NSString *cardPrice;
@property(nonatomic, strong) NSString *cardName;
@property(nonatomic, strong) NSString *cardRarity;
@property(nonatomic, strong) NSURL *cardImageURL;
@property(nonatomic, strong) UIImage *cardImage;
@property(nonatomic, strong) NSString *cardSet;
@property(nonatomic,strong) NSString *cardQuantity;

@end

//
//  BinderCardModel.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "BinderCardModel.h"

@implementation BinderCardModel

@synthesize cardPrice = _cardPrice;
@synthesize cardName = _cardName;
@synthesize cardRarity = _cardRarity;
@synthesize cardImageURL = _cardImageURL;
@synthesize cardImage = _cardImage;
@synthesize cardSet = _cardSet;
@synthesize cardQuantity = _cardQuantity;

//
-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])){
        self.cardPrice = [aDecoder decodeObjectForKey:@"CardPrice"];
        self.cardName = [aDecoder decodeObjectForKey:@"CardName"];
        self.cardRarity = [aDecoder decodeObjectForKey:@"CardRarity"];
        self.cardImageURL = [aDecoder decodeObjectForKey:@"CardImageURL"];
        self.cardImage = [aDecoder decodeObjectForKey:@"CardImage"];
        self.cardSet = [aDecoder decodeObjectForKey:@"CardSet"];
        self.cardQuantity = [aDecoder decodeObjectForKey:@"CardQuantity"];
    }
    
    return self;
}

//
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cardPrice forKey:@"CardPrice"];
    [aCoder encodeObject:self.cardName forKey:@"CardName"];
    [aCoder encodeObject:self.cardRarity forKey:@"CardRarity"];
    [aCoder encodeObject:self.cardImageURL forKey:@"CardImageURL"];
    [aCoder encodeObject:self.cardImage forKey:@"CardImage"];
    [aCoder encodeObject:self.cardSet forKey:@"CardSet"];
    [aCoder encodeObject:self.cardQuantity forKey:@"CardQuantity"];
}

@end

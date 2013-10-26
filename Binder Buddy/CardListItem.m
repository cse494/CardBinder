//
//  CardListItem.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/24/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "CardListItem.h"

@implementation CardListItem

@synthesize text = _text;

//
-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])){
        self.text = [aDecoder decodeObjectForKey:@"Text"];
    }
    
    return self;
}

//
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
}

@end

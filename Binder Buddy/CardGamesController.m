//
//  CardGamesController.m
//  Binder Buddy
//
//  Created by afammart on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "CardGamesController.h"

@implementation CardGamesController

-(id)init
{
    self = [super init];
    
    if(self)
    {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"CardGames" ofType:@"plist"];
        self.cardGames = [NSMutableArray arrayWithContentsOfFile:filepath];
    }
    
    return self;
}

static CardGamesController *theCardGames = nil;

+(CardGamesController*)getCardGames
{
    if(theCardGames == nil)
    {
        theCardGames = [[CardGamesController alloc] init];
    }
    
    return theCardGames;
}
@end

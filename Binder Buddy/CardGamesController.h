//
//  CardGamesController.h
//  Binder Buddy
//
//  Created by afammart on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardGamesController : NSObject

@property (nonatomic, strong) NSMutableArray *cardGames;
@property (nonatomic, strong) NSString *currentGame;

+(CardGamesController *)getCardGames;

@end

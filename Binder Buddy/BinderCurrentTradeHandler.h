//
//  BinderCurrentTradeHandler.h
//  Binder Buddy
//
//  Created by James Rodriguez on 12/4/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinderCurrentTradeHandler : NSObject{
    NSMutableArray *currentTrade;
}

@property(nonatomic, retain) NSMutableArray *currentTrade;

+(BinderCurrentTradeHandler *)sharedTrade;

@end

//
//  BinderCurrentTradeHandler.m
//  Binder Buddy
//
//  Created by James Rodriguez on 12/4/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "BinderCurrentTradeHandler.h"

static BinderCurrentTradeHandler *sharedTrade = nil;

@implementation BinderCurrentTradeHandler

@synthesize currentTrade;

#pragma mark -
#pragma mark Singleton Methods
+ (BinderCurrentTradeHandler *)sharedTrade {
    if(sharedTrade == nil){
        sharedTrade = [[super allocWithZone:NULL] init];
    }
    return sharedTrade;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedTrade] retain];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return NSUIntegerMax;
}
- (void)release {
    //do nothing
}
- (id)autorelease {
    return self;
}

@end

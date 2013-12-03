//
//  BinderBuyCardViewController.h
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BinderBuyCardViewController : UIViewController

@property (weak, nonatomic) IBOutlet  UIWebView *ebayPage;
@property(nonatomic, strong) NSString *cardName;
@property(nonatomic, strong) NSString *cardSet;

@end

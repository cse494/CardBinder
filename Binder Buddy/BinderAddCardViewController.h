//
//  BinderAddCardViewController.h
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BinderCardModel.h"
@class BinderAddCardViewController;


@protocol BinderAddCardViewControllerDelegate <NSObject>

-(void)BinderAddCardViewControllerDidCancel:(BinderAddCardViewController *)controller;

//not sure what the issue is with this portion 
-(void)BinderAddCardViewController:(BinderAddCardViewController *)controller didFinishAddingItem:(BinderCardModel *)item;

@end

//links to text input fields
@interface BinderAddCardViewController : UIViewController;
-(IBAction)Cancel:(id)sender;
-(IBAction)Save:(id)sender;
@property (nonatomic, strong) IBOutlet UITextField *addCardNameText;
@property (nonatomic, strong) IBOutlet UITextField *addCardSetText;
@property (nonatomic, strong) IBOutlet UITextField *addCardRarityText;
@property (nonatomic, strong) IBOutlet UITextField *addCardQuantityText;
@property (nonatomic, weak) id<BinderAddCardViewControllerDelegate> delegate;

@end

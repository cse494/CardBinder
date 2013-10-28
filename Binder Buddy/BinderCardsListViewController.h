//
//  BinderCardsListViewController.h
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BinderCardModel.h"
#import "BinderAddCardViewController.h"
#import "CardGamesController.h"

@interface BinderCardsListViewController : UITableViewController <BinderAddCardViewControllerDelegate>

-(IBAction)addCard:(id)sender;

@property(nonatomic, strong) IBOutlet UITableView *myTableView;
@property(nonatomic, strong) NSMutableArray *arrayBinder;
@end

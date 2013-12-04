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
#import "BinderCardDetailViewController.h"
#import "CardGamesController.h"
#import "BinderViewController.h"

@interface BinderCardsListViewController : UITableViewController <BinderAddCardViewControllerDelegate>

-(IBAction)addCard:(id)sender;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic, strong) IBOutlet UITableView *myTableView;
@property(nonatomic, strong) NSMutableArray *arrayBinder;
@property(nonatomic, strong) NSMutableArray *arrayEbay;
//@property(nonatomic, strong) UILongPressGestureRecognizer *lpgr;
@end

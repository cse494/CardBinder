//
//  BinderCardDetailViewController.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "BinderCardDetailViewController.h"

@interface BinderCardDetailViewController ()
-(void)configureView;
@end

@implementation BinderCardDetailViewController

#pragma mark - Managing the card item

//checks if card detail is the same item if not repopulate with new data
-(void)setCardDetail:(id)newCardDetail{
    if(_cardDetail != newCardDetail)
    {
        _cardDetail = newCardDetail;
        [self configureView];
    }
}

//takes the card information stored in cardDetail and sets the labels
//todo function to calculate the differing prices, and using trollandtoad api
//for card text
-(void)configureView{
    //update the card detail interface with the card item
    
    if(self.cardDetail){
        //self.cardImage.image = self.cardDetail.cardImage;
        self.cardName.text = self.cardDetail.cardName;
        self.cardRarity.text = self.cardDetail.cardRarity;
        self.cardSet.text = self.cardDetail.cardSet;
        //self.cardText.text = self.cardDetail.cardText;
        //self.averagePrice.text = self.cardDetail.averagePrice;
        //self.maxPrice.text = self.cardDetail.maxPrice;
        //self.minPrice.text = self.cardDetail.minPrice;
        //self.recentPrice.text = self.cardDetail.recentPrice;
        
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//load initial view upon loading view
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

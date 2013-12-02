//
//  BinderBuyCardViewController.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//


//todo set the website correctly for the item they are viewing for either ebay or tcgplayer
//depending on which button they press allow users to surf site normally for purchases

#import "BinderBuyCardViewController.h"

@interface BinderBuyCardViewController ()

@end

@implementation BinderBuyCardViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*pass in search parameters and build url string similar to checking the card prices*/
    NSString *fullURL = @"http://ebay.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_ebayPage loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

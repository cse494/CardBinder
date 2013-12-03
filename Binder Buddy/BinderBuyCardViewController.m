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
    //configure the spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];

    
    NSString *query = [NSString stringWithFormat:@"http://ebay.com/sch/-lot -x2 -x3 -grabbab -collection -binder -playset %@ %@", _cardName, _cardSet];
    
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:query];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_ebayPage loadRequest:requestObj];
    
    [spinner performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

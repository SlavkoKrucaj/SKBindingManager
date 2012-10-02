//
//  TestViewController.m
//  SKBindingManager
//
//  Created by Slavko Krucaj on 2.10.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import "TestViewController.h"
#import "ComplexViewController.h"
#import "SimpleExampleViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)trySimpleDemo:(id)sender {
    [self.navigationController pushViewController:[[SimpleExampleViewController alloc] init] animated:YES];
}

- (IBAction)tryComplexDemo:(id)sender {
    [self.navigationController pushViewController:[[ComplexViewController alloc] init] animated:YES];
}

@end

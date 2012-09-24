//
//  ViewController.m
//  SKBindingManager
//
//  Created by Slavko Krucaj on 22.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "SKBindingManager.h"

@interface ViewController ()
@property (nonatomic, retain) IBOutlet UITextView *textField1;
@property (nonatomic, retain) IBOutlet UITextView *textField2;

@property (nonatomic, retain) IBOutlet UILabel *label;

@property (nonatomic, retain) SKBindingManager *manager;

@end

@implementation ViewController

@synthesize textField1, textField2, manager, label;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = nil;
    
//    self.textField1 = [[UITextField alloc] init];
//    self.textField2 = [[UITextField alloc] init];
    self.manager = [[SKBindingManager alloc] init];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"name.textFieldText" forKey:kBindingOptionBindId];
    
    [dictionary setObject:self.textField1 forKey:kBindingOptionFromObject];
    [dictionary setObject:self.textField2 forKey:kBindingOptionToObject];
    
    [dictionary setObject:kTextFieldObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:kTextFieldObservableProperty forKey:kBindingOptionToKeyPath];
    
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary];
    
    NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionary];
    [dictionary1 setObject:@"name.label" forKey:kBindingOptionBindId];
    
    [dictionary1 setObject:self.textField1 forKey:kBindingOptionFromObject];
    [dictionary1 setObject:self.label forKey:kBindingOptionToObject];
    
    [dictionary1 setObject:kTextFieldObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary1 setObject:kTextFieldObservableProperty forKey:kBindingOptionToKeyPath];
    
    [dictionary1 setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary1];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

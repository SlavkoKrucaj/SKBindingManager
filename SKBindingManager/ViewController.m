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

@property (nonatomic, retain) IBOutlet UISwitch *uiSwitch;
@property (nonatomic, retain) IBOutlet UIStepper *stepper;
@property (nonatomic, retain) IBOutlet UISlider *slider;

@property (nonatomic, retain) SKBindingManager *manager;

@end

@implementation ViewController

@synthesize textField1, textField2, manager, label, uiSwitch, stepper, slider;

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
    [dictionary setObject:self.label forKey:kBindingOptionToObject];
    
    [dictionary setObject:kBindingTextViewObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:kBindingTextViewObservableProperty forKey:kBindingOptionToKeyPath];
    
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    
//    SKTransformationBlock blockOp = ^(id value) { return @"1"; };
//    [dictionary setObject:blockOp forKey:kBindingForwardTransformation];
    
    [self.manager bind:dictionary];
    
//    NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionary];
//    [dictionary1 setObject:@"name.label" forKey:kBindingOptionBindId];
//    
//    [dictionary1 setObject:self.uiSwitch forKey:kBindingOptionFromObject];
//    [dictionary1 setObject:self.label forKey:kBindingOptionToObject];
//    
//    [dictionary1 setObject:kBindingSwitchObservableProperty forKey:kBindingOptionFromKeyPath];
//    [dictionary1 setObject:kBindingLabelObservableProperty forKey:kBindingOptionToKeyPath];
//    
//    SKTransformationBlock blockOp1 = ^(id value) { return [(NSNumber *)value stringValue]; };
//    [dictionary1 setObject:blockOp1 forKey:kBindingForwardTransformation];
//    
//    SKTransformationBlock blockOp2 = ^(id value) {
//        BOOL val = [(NSString *)value intValue] != 0; 
//        return [NSNumber numberWithBool:val]; 
//    };
//    [dictionary1 setObject:blockOp2 forKey:kBindingBackwardTransformation];
//        
//    [dictionary1 setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
//    
//    [self.manager bind:dictionary1];
    
    NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionary];
    [dictionary1 setObject:@"name.label" forKey:kBindingOptionBindId];
    
    [dictionary1 setObject:self.stepper forKey:kBindingOptionFromObject];
    [dictionary1 setObject:self.slider forKey:kBindingOptionToObject];
    
    [dictionary1 setObject:kBindingStepperObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary1 setObject:kBindingSliderObservableProperty forKey:kBindingOptionToKeyPath];
    
//    SKTransformationBlock blockOp1 = ^(id value) { return [(NSNumber *)value stringValue]; };
//    [dictionary1 setObject:blockOp1 forKey:kBindingForwardTransformation];
        
    [dictionary1 setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary1];
    
    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionary];
    [dictionary2 setObject:@"name.bla" forKey:kBindingOptionBindId];
    
    [dictionary2 setObject:self.stepper forKey:kBindingOptionFromObject];
    [dictionary2 setObject:self.label forKey:kBindingOptionToObject];
    
    [dictionary2 setObject:kBindingStepperObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary2 setObject:kBindingLabelObservableProperty forKey:kBindingOptionToKeyPath];
    
    SKTransformationBlock blockOp3 = ^(id value) { return [(NSNumber *)value stringValue]; };
    [dictionary2 setObject:blockOp3 forKey:kBindingForwardTransformation];
    
    [dictionary2 setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary2];
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

//
//  TestViewController.m
//  SKBindingManager
//
//  Created by Slavko Krucaj on 26.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import "TestViewController.h"
#import "SKTableView.h"

#import "SKBindingManager.h"

@interface TestViewController ()
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIStepper *stepper;
@property (nonatomic, retain) IBOutlet UISwitch *switchControl;
@property (nonatomic, retain) IBOutlet SKTableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UITextField *boolTextField;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UISlider *slider;

@property (nonatomic, retain) SKBindingManager *manager;
@end

@implementation TestViewController

@synthesize label;
@synthesize stepper;
@synthesize switchControl;
@synthesize tableView;
@synthesize textField;
@synthesize textView;
@synthesize slider;
@synthesize boolTextField;

@synthesize manager;

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
    
    [self.tableView initialize];
    self.manager = [[SKBindingManager alloc] init];
    self.manager.delegate = self;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"stepper.label" forKey:kBindingOptionBindId];
    [dictionary setObject:self.slider forKey:kBindingOptionFromObject];
    [dictionary setObject:self.label forKey:kBindingOptionToObject];
    [dictionary setObject:kBindingStepperObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:kBindingLabelObservableProperty forKey:kBindingOptionToKeyPath];
    SKTransformationBlock blockOp1 = ^(id value) { 
        int a = [(NSNumber *)value intValue]; 
        return [[NSNumber numberWithInt:a] stringValue];
    };
    
    [dictionary setObject:blockOp1 forKey:kBindingOptionForwardTransformation];    
    [dictionary setObject:[NSNumber numberWithBool:NO] forKey:kBindingOptionTwoWayBinding];
    [self.manager bind:dictionary];

    dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"stepper.slider" forKey:kBindingOptionBindId];
    [dictionary setObject:self.stepper forKey:kBindingOptionFromObject];
    [dictionary setObject:self.slider forKey:kBindingOptionToObject];
    [dictionary setObject:kBindingStepperObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:kBindingSliderObservableProperty forKey:kBindingOptionToKeyPath];
    SKTransformationBlock blockOp2 = ^(id value) { 
        return [(NSNumber *)value stringValue]; 
    };
    
    [dictionary setObject:blockOp2 forKey:kBindingOptionForwardTransformation];
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    [self.manager bind:dictionary];
    
    
    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionary];
    [dictionary2 setObject:@"stepper.tableView" forKey:kBindingOptionBindId];
    [dictionary2 setObject:self.stepper forKey:kBindingOptionFromObject];
    [dictionary2 setObject:self.tableView forKey:kBindingOptionToObject];
    [dictionary2 setObject:kBindingStepperObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary2 setObject:@"observableProperty" forKey:kBindingOptionToKeyPath];
    
    SKTransformationBlock blockOp3 = ^(id value) { 
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:((NSNumber *)value).intValue inSection:0] 
                                    animated:YES 
                              scrollPosition:UITableViewScrollPositionMiddle]; return value;
    };

    [dictionary2 setObject:blockOp3 forKey:kBindingOptionForwardTransformation];
    [dictionary2 setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    [self.manager bind:dictionary2];
    
    dictionary2 = [NSMutableDictionary dictionary];
    [dictionary2 setObject:@"textField.textView" forKey:kBindingOptionBindId];
    [dictionary2 setObject:self.textView forKey:kBindingOptionFromObject];
    [dictionary2 setObject:self.textField forKey:kBindingOptionToObject];
    [dictionary2 setObject:kBindingTextViewObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary2 setObject:kBindingTextViewObservableProperty forKey:kBindingOptionToKeyPath];
    [dictionary2 setObject:blockOp3 forKey:kBindingOptionForwardTransformation];
    [dictionary2 setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    [self.manager bind:dictionary2];
    
    NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionary];
    [dictionary1 setObject:@"switch.textField" forKey:kBindingOptionBindId];
    
    [dictionary1 setObject:self.switchControl forKey:kBindingOptionFromObject];
    [dictionary1 setObject:self.boolTextField forKey:kBindingOptionToObject];
    
    [dictionary1 setObject:kBindingSwitchObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary1 setObject:kBindingLabelObservableProperty forKey:kBindingOptionToKeyPath];
    
    SKTransformationBlock blockOp4 = ^(id value) { 
        return [(NSNumber *)value stringValue]; 
    };
    [dictionary1 setObject:blockOp4 forKey:kBindingOptionForwardTransformation];
    
    SKTransformationBlock blockOp5 = ^(id value) {
        BOOL val = [(NSString *)value intValue] != 0; 
        return [NSNumber numberWithBool:val]; 
    };
    [dictionary1 setObject:blockOp5 forKey:kBindingOptionBackwardTransformation];
    [dictionary1 setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary1];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - binding delegate

- (void)bindedObject:(id)object changedKeyPath:(NSString *)keyPath {
    NSLog(@"Promijenio sam objekt %@.%@",[object class], keyPath);
}
@end

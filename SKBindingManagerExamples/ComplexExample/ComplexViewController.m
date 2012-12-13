//
//  TestViewController.m
//  SKBindingManager
//
//  Created by Slavko Krucaj on 26.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import "ComplexViewController.h"
#import "SKTableView.h"
#import "SKPickerView.h"

#import "SKBindingManager.h"

@interface ComplexViewController ()
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIStepper *stepper;
@property (nonatomic, retain) IBOutlet UISwitch *switchControl;
@property (nonatomic, retain) IBOutlet SKTableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UITextField *boolTextField;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet SKPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UISlider *slider;

@property (nonatomic, retain) SKBindingManager *manager;
@end

@implementation ComplexViewController

@synthesize label;
@synthesize stepper;
@synthesize switchControl;
@synthesize tableView;
@synthesize textField;
@synthesize textView;
@synthesize slider;
@synthesize boolTextField;
@synthesize pickerView;

@synthesize manager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)bindStepperAndLabel {
    
    SKTransformationBlock blockOp1 = ^(id value, id toObject) { 
        int a = [(NSNumber *)value intValue]; 
        return [[NSNumber numberWithInt:a] stringValue];
    };

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:@"stepper.label"                  forKey:BindingId];
    [dictionary setObject:self.slider                       forKey:BindingFrom];
    [dictionary setObject:self.label                        forKey:BindingTo];
    [dictionary setObject:BindingPropertyStepper            forKey:BindingFromKeyPath];
    [dictionary setObject:BindingPropertyLabel              forKey:BindingToKeyPath];
    [dictionary setObject:blockOp1                          forKey:BindingForwardTransformation];
    [dictionary setObject:[NSNumber numberWithBool:NO]      forKey:BindingTwoWayBinding];

    [self.manager bind:dictionary];
}

- (void)bindStepperAndSlider {
    
    SKTransformationBlock blockOp2 = ^(id value, id toObject) { 
        return [(NSNumber *)value stringValue]; 
    };

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:@"stepper.slider"                     forKey:BindingId];
    [dictionary setObject:self.stepper                          forKey:BindingFrom];
    [dictionary setObject:self.slider                           forKey:BindingTo];
    [dictionary setObject:BindingPropertyStepper                forKey:BindingFromKeyPath];
    [dictionary setObject:BindingPropertySlider                 forKey:BindingToKeyPath];
    [dictionary setObject:blockOp2                              forKey:BindingForwardTransformation];
    [dictionary setObject:[NSNumber numberWithBool:YES]         forKey:BindingTwoWayBinding];
    [self.manager bind:dictionary];
}

- (void)bindStepperAndTableView {
    
    SKTransformationBlock blockOp3 = ^(id value, id toObject) { 
        NSIndexPath *path = [NSIndexPath indexPathForRow:[(NSNumber *)value intValue] inSection:0];
        [self.tableView selectRowAtIndexPath:path
                                    animated:YES 
                              scrollPosition:UITableViewScrollPositionMiddle]; return path;
    };
    
    SKTransformationBlock blockOp31 = ^(id value, id toObject) { 
        NSNumber *row = [NSNumber numberWithInt:[(NSIndexPath *)value row]];
        return row;
    };

    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionary];
    
    [dictionary2 setObject:@"stepper.tableView"                 forKey:BindingId];
    [dictionary2 setObject:self.stepper                         forKey:BindingFrom];
    [dictionary2 setObject:self.tableView                       forKey:BindingTo];
    [dictionary2 setObject:BindingPropertyStepper    forKey:BindingFromKeyPath];
    [dictionary2 setObject:@"observableProperty"                forKey:BindingToKeyPath];
    [dictionary2 setObject:blockOp3                             forKey:BindingForwardTransformation];
    [dictionary2 setObject:blockOp31                            forKey:BindingBackwardTransformation];
    [dictionary2 setObject:[NSNumber numberWithBool:YES]        forKey:BindingTwoWayBinding];
    
    [self.manager bind:dictionary2];
}

- (void)bindSliderAndPickerView {
    
    SKTransformationBlock blockOp6 = ^(id value, id toObject) { 
        [self.pickerView selectRow:[(NSNumber *)value intValue] inComponent:0 animated:YES];
        return value;
    };

    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionary];
    
    [dictionary2 setObject:@"slider.pickerView"                 forKey:BindingId];
    [dictionary2 setObject:self.slider                          forKey:BindingFrom];
    [dictionary2 setObject:self.pickerView                      forKey:BindingTo];
    [dictionary2 setObject:BindingPropertyStepper    forKey:BindingFromKeyPath];
    [dictionary2 setObject:@"observableProperty"                forKey:BindingToKeyPath];
    [dictionary2 setObject:blockOp6                             forKey:BindingForwardTransformation];
    [dictionary2 setObject:[NSNumber numberWithBool:YES]        forKey:BindingTwoWayBinding];
    
    [self.manager bind:dictionary2];
    
}

- (void)bindTextFieldAndTextView {
    
    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionary];
    
    [dictionary2 setObject:@"textField.textView"                forKey:BindingId];
    [dictionary2 setObject:self.textView                        forKey:BindingFrom];
    [dictionary2 setObject:self.textField                       forKey:BindingTo];
    [dictionary2 setObject:BindingPropertyTextView   forKey:BindingFromKeyPath];
    [dictionary2 setObject:BindingPropertyTextView   forKey:BindingToKeyPath];
    [dictionary2 setObject:[NSNumber numberWithBool:YES]        forKey:BindingTwoWayBinding];
    
    [self.manager bind:dictionary2];

}

- (void)bindSwitchAndTextField {
    SKTransformationBlock blockOp4 = ^(id value, id toObject) { 
        return [(NSNumber *)value stringValue]; 
    };
    
    SKTransformationBlock blockOp5 = ^(id value, id toObject) {
        BOOL val = [(NSString *)value intValue] != 0; 
        return [NSNumber numberWithBool:val]; 
    };

    NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionary];
    
    [dictionary1 setObject:@"switch.textField"              forKey:BindingId];
    [dictionary1 setObject:self.switchControl               forKey:BindingFrom];
    [dictionary1 setObject:self.boolTextField               forKey:BindingTo];
    [dictionary1 setObject:BindingPropertySwitch            forKey:BindingFromKeyPath];
    [dictionary1 setObject:BindingPropertyLabel             forKey:BindingToKeyPath];
    [dictionary1 setObject:blockOp4                         forKey:BindingForwardTransformation];    
    [dictionary1 setObject:blockOp5                         forKey:BindingBackwardTransformation];
    [dictionary1 setObject:[NSNumber numberWithBool:YES]    forKey:BindingTwoWayBinding];
    
    [self.manager bind:dictionary1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.manager = [[SKBindingManager alloc] init];
    self.manager.delegate = self;
    
    [self bindStepperAndLabel];
    [self bindStepperAndSlider];
    [self bindStepperAndTableView];
    [self bindSliderAndPickerView];

    [self bindTextFieldAndTextView];
    
    [self bindSwitchAndTextField];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.label = nil;
    self.stepper = nil;
    self.switchControl = nil;
    self.tableView = nil;
    self.textField = nil;
    self.boolTextField = nil;
    self.textView = nil;
    self.pickerView = nil;
    self.slider = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - binding delegate

- (void)bindedObject:(id)object changedKeyPath:(NSString *)keyPath {
    NSLog(@"Promijenio sam objekt %@.%@",[object class], keyPath);
}

#pragma mark - delegates

- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
    [_textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end

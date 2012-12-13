//
//  SimpleExampleViewController.m
//  SKBindingManager
//
//  Created by Slavko Krucaj on 2.10.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import "SimpleExampleViewController.h"

#import "SKBindingManager.h"
#import "Person.h"

@interface SimpleExampleViewController ()
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *labelModelName;
@property (nonatomic, retain) SKBindingManager *bindingManager;
@property (nonatomic, retain) Person *person;
@end

@implementation SimpleExampleViewController

@synthesize textField;
@synthesize labelModelName;
@synthesize bindingManager;
@synthesize person;

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

    self.bindingManager = [[SKBindingManager alloc] init];
    self.bindingManager.delegate = self;
    
	self.person = [[Person alloc] init];
    
    //create binding options dictionary which contains all properties needed for binding
    NSMutableDictionary *bindingOptions = [NSMutableDictionary dictionary];
    
	//set binding id for this connection
    [bindingOptions setObject:@"name.textFieldText" forKey:BindingId];
    
    //set object and propety - from 
    [bindingOptions setObject:self.person forKey:BindingFrom];
    [bindingOptions setObject:@"name" forKey:BindingFromKeyPath];

    //set object and property - to
    [bindingOptions setObject:self.textField forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyTextView forKey:BindingToKeyPath];
    
    SKTransformationBlock transformation = ^(id value, id toObject) { 
        NSString *name = (NSString *)value;
        return [name stringByAppendingString:@"12345"];
    };
    
    //set transformation as backward because it goes from 'to object' to 'from object'
    [bindingOptions setObject:transformation forKey:BindingBackwardTransformation];
    
    //specify if you want two-way or one-way binding
    [bindingOptions setObject:[NSNumber numberWithBool:YES] forKey:BindingTwoWayBinding];
    
    //add binding
    [self.bindingManager bind:bindingOptions];
}

- (void)bindedObject:(id)object changedKeyPath:(NSString *)keyPath {
    if ([object isEqual:self.textField]) {
        NSLog(@"Text field has been changed");
    } else {
        NSLog(@"Persons name has been changed");
    }
    
    NSLog(@"TextField.text = %@ and Person.name = %@", self.textField.text, self.person.name);
    
    self.labelModelName.text = self.person.name;
}

- (IBAction)changeValueDirectlyInModel:(id)sender {
    self.person.name = @"Button changed me";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textField = nil;
    self.labelModelName = nil;
}


@end

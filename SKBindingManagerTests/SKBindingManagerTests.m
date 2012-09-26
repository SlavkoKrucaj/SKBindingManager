//
//  SKBindingManagerTests.m
//  SKBindingManagerTests
//
//  Created by Slavko Krucaj on 22.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import "SKBindingManagerTests.h"

#import "DemoModel.h"
#import "SKBindingManager.h"

@interface SKBindingManagerTests()
@property (nonatomic, retain) SKBindingManager *manager;
@property (nonatomic, retain) DemoModel *model;

@property (nonatomic, retain) UITextField *textField1;
@property (nonatomic, retain) UITextField *textField2;
@end

@implementation SKBindingManagerTests

@synthesize manager, model;
@synthesize textField1, textField2;

- (void)setUpOneWay {
    
    [self.manager removeAllBindings];
    self.manager = nil;
    self.model = nil;
    
    self.model = [[DemoModel alloc] init];
    self.manager = [[SKBindingManager alloc] init];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"name.textFieldText" forKey:kBindingOptionBindId];
    
    [dictionary setObject:self.model forKey:kBindingOptionFromObject];
    [dictionary setObject:self.model forKey:kBindingOptionToObject];
    
    [dictionary setObject:@"title" forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:@"text" forKey:kBindingOptionToKeyPath];
    
    [dictionary setObject:[NSNumber numberWithBool:NO] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary];
}

- (void)setupTwoWay {
    
    [self.manager removeAllBindings];
    self.manager = nil;
    self.model = nil;
    
    self.model = [[DemoModel alloc] init];
    self.manager = [[SKBindingManager alloc] init];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"name.textFieldText" forKey:kBindingOptionBindId];
    
    [dictionary setObject:self.model forKey:kBindingOptionFromObject];
    [dictionary setObject:self.model forKey:kBindingOptionToObject];
    
    [dictionary setObject:@"title" forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:@"text" forKey:kBindingOptionToKeyPath];
    
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary];
}

- (void)setupOnewayTF {
    [self.manager removeAllBindings];
    self.manager = nil;
    self.model = nil;
    
    self.model = [[DemoModel alloc] init];
    self.textField1 = [[UITextField alloc] init];
    self.manager = [[SKBindingManager alloc] init];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"name.textFieldText" forKey:kBindingOptionBindId];
    
    [dictionary setObject:self.model forKey:kBindingOptionFromObject];
    [dictionary setObject:self.textField1 forKey:kBindingOptionToObject];
    
    [dictionary setObject:@"title" forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:kBindingTextViewObservableProperty forKey:kBindingOptionToKeyPath];
    
    [dictionary setObject:[NSNumber numberWithBool:NO] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary];
}

- (void)setupTwoWayTF {
    [self.manager removeAllBindings];
    self.manager = nil;
    self.model = nil;
    
    self.model = [[DemoModel alloc] init];
    self.textField1 = [[UITextField alloc] init];
    self.manager = [[SKBindingManager alloc] init];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"name.textFieldText" forKey:kBindingOptionBindId];
    
    [dictionary setObject:self.model forKey:kBindingOptionFromObject];
    [dictionary setObject:self.textField1 forKey:kBindingOptionToObject];
    
    [dictionary setObject:@"title" forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:kBindingTextViewObservableProperty forKey:kBindingOptionToKeyPath];
    
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary];
}

- (void)setupTF1toTF2OneWay {
    [self.manager removeAllBindings];
    self.manager = nil;

    self.textField1 = [[UITextField alloc] init];
    self.textField2 = [[UITextField alloc] init];
    self.manager = [[SKBindingManager alloc] init];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"name.textFieldText" forKey:kBindingOptionBindId];
    
    [dictionary setObject:self.textField1 forKey:kBindingOptionFromObject];
    [dictionary setObject:self.textField2 forKey:kBindingOptionToObject];
    
    [dictionary setObject:kBindingTextViewObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:kBindingTextViewObservableProperty forKey:kBindingOptionToKeyPath];
    
    [dictionary setObject:[NSNumber numberWithBool:NO] forKey:kBindingOptionTwoWayBinding];
    
    [self.manager bind:dictionary];
}

- (void)setupTF1toTF2TwoWay {
    [self.manager removeAllBindings];
    self.manager = nil;
    
    self.textField1 = [[UITextField alloc] init];
    self.textField2 = [[UITextField alloc] init];
    self.manager = [[SKBindingManager alloc] init];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"name.textFieldText" forKey:kBindingOptionBindId];
    
    [dictionary setObject:self.textField1 forKey:kBindingOptionFromObject];
    [dictionary setObject:self.textField2 forKey:kBindingOptionToObject];
    
    [dictionary setObject:kBindingTextViewObservableProperty forKey:kBindingOptionFromKeyPath];
    [dictionary setObject:kBindingTextViewObservableProperty forKey:kBindingOptionToKeyPath];
    
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:kBindingOptionTwoWayBinding];

    [self.manager bind:dictionary];
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    [self.manager removeAllBindings];
    self.manager = nil;
    self.model = nil;
    
    [super tearDown];
}

- (void)testOneWay {
    
    [self setUpOneWay];
    
    STAssertNotNil(self.manager,@"Manager ne smije biti nil");
    STAssertNotNil(self.model,@"Model ne smije biti nil");
    
    self.model.title = @"Slavko";
    STAssertTrueNoThrow([self.model.title isEqualToString:@"Slavko"],@"Title nije slavko");
    STAssertTrueNoThrow([self.model.title isEqualToString:self.model.text],@"Nisu jednaki");
    
    self.model.text = @"Nisam";
    STAssertTrueNoThrow([self.model.title isEqualToString:@"Slavko"],@"Title nije slavko");
    STAssertTrueNoThrow([self.model.text isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow(![self.model.title isEqualToString:self.model.text],@"Jednaki su a ne bi trebali biti");
    
}

- (void)testTwoWay {
    
    [self setupTwoWay];
    
    STAssertNotNil(self.manager,@"Manager ne smije biti nil");
    STAssertNotNil(self.model,@"Model ne smije biti nil");
    
    self.model.title = @"Slavko";
    STAssertTrueNoThrow([self.model.title isEqualToString:@"Slavko"],@"Title nije slavko");
    STAssertTrueNoThrow([self.model.title isEqualToString:self.model.text],@"Nisu jednaki");
    
    self.model.text = @"Nisam";
    STAssertTrueNoThrow([self.model.title isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow([self.model.text isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow([self.model.title isEqualToString:self.model.text],@"Nisu jednaki a trebali bi biti");
    
}

- (void)testOneWayTextField {
    [self setupOnewayTF];
    
    STAssertNotNil(self.manager,@"Manager ne smije biti nil");
    STAssertNotNil(self.model,@"Model ne smije biti nil");
    STAssertNotNil(self.textField1,@"TF1 ne smije biti nil");
    
    self.model.title = @"Slavko";
    STAssertTrueNoThrow([self.model.title isEqualToString:@"Slavko"],@"Title nije slavko");
    STAssertTrueNoThrow([self.model.title isEqualToString:self.textField1.text],@"Nisu jednaki");
    
    self.textField1.text = @"Nisam";
    STAssertTrueNoThrow(![self.model.title isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow([self.textField1.text isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow(![self.model.title isEqualToString:self.textField1.text],@"Jednaki su a ne bi trebali biti");

}

- (void)testTwoWayTextField {
    [self setupTwoWayTF];
    
    STAssertNotNil(self.manager,@"Manager ne smije biti nil");
    STAssertNotNil(self.model,@"Model ne smije biti nil");
    STAssertNotNil(self.textField1,@"TF1 ne smije biti nil");
    
    self.model.title = @"Slavko";
    STAssertTrueNoThrow([self.model.title isEqualToString:@"Slavko"],@"Title nije slavko");
    STAssertTrueNoThrow([self.model.title isEqualToString:self.textField1.text],@"Nisu jednaki");
    
    self.textField1.text = @"Nisam";
    STAssertTrueNoThrow([self.model.title isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow([self.textField1.text isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow([self.model.title isEqualToString:self.textField1.text],@"Nisu jednaki a trebali bi biti");
    
}

- (void)testTF1toTF2OneWay {
    [self setupTF1toTF2OneWay];
    
    STAssertNotNil(self.manager,@"Manager ne smije biti nil");
    STAssertNotNil(self.textField2,@"TF2 ne smije biti nil");
    STAssertNotNil(self.textField1,@"TF1 ne smije biti nil");
    
    self.textField1.text = @"Slavko";
    STAssertTrueNoThrow([self.textField1.text isEqualToString:@"Slavko"],@"Title nije slavko");
    STAssertTrueNoThrow([self.textField2.text isEqualToString:self.textField1.text],@"Nisu jednaki");
    
    self.textField2.text = @"Nisam";
    STAssertTrueNoThrow([self.textField2.text isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow(![self.textField1.text isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow(![self.textField2.text isEqualToString:self.textField1.text],@"Jednaki su a ne bi trebali biti");
}

- (void)testTF1toTF2TwoWay {
    [self setupTF1toTF2TwoWay];
    
    STAssertNotNil(self.manager,@"Manager ne smije biti nil");
    STAssertNotNil(self.textField2,@"TF2 ne smije biti nil");
    STAssertNotNil(self.textField1,@"TF1 ne smije biti nil");
    
    self.textField1.text = @"Slavko";
    STAssertTrueNoThrow([self.textField1.text isEqualToString:@"Slavko"],@"Title nije slavko");
    STAssertTrueNoThrow([self.textField2.text isEqualToString:self.textField1.text],@"Nisu jednaki");
    
    self.textField2.text = @"Nisam";
    STAssertTrueNoThrow([self.textField2.text isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow([self.textField1.text isEqualToString:@"Nisam"],@"Title nije Nisam");
    STAssertTrueNoThrow([self.textField2.text isEqualToString:self.textField1.text],@"Jednaki su a ne bi trebali biti");
}

- (void)testCycles {

}

@end

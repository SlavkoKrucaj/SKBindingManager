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
@end

@implementation SKBindingManagerTests

@synthesize manager, model;

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
    STAssertTrueNoThrow([self.model.title isEqualToString:self.model.text],@"Jednaki su a ne bi trebali biti");
    
}

@end

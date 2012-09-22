//
//  SKBindingManager.m
//  BindableTableViewProject
//
//  Created by Slavko Krucaj on 21.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import "SKBindingManager.h"

@interface SKVertex : NSObject
@property (nonatomic, assign) id obj;
@property (nonatomic, assign) NSString *keyPath;
@end

@implementation SKVertex : NSObject
@synthesize obj;
@synthesize keyPath;

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[SKVertex class]]) return NO;
    
    return (obj == ((SKVertex *)object).obj && [keyPath isEqualToString:((SKVertex *)object).keyPath]);
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger hash = 1;
    hash = prime * hash + [[self obj] hash];
    hash += prime * hash + [[self keyPath] hash];
    return hash;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"obj = %@, keyPath = %@", NSStringFromClass([obj class]),keyPath];
}
@end

@interface SKBinding : NSObject

@property (nonatomic, retain) NSString *bindId;
@property (nonatomic, retain) id fromObject;
@property (nonatomic, retain) id toObject;
@property (nonatomic, retain) NSString *fromKeyPath;
@property (nonatomic, retain) NSString *toKeyPath;
@property (nonatomic, assign) BOOL active;

@end

@implementation SKBinding

@synthesize bindId;
@synthesize fromObject;
@synthesize toObject;
@synthesize fromKeyPath;
@synthesize toKeyPath;
@synthesize active;

- (NSString *)description {
    return [NSString stringWithFormat:@"bindId = %@, fromObject = %@, toObject = %@, fromKeyPath = %@, toKeyPath = %@, active = %d\n",bindId, NSStringFromClass([fromObject class]), NSStringFromClass([toObject class]), fromKeyPath, toKeyPath, active];
}

@end

@interface SKBindingManager()
@property (nonatomic, retain) NSMutableArray *bindings;
@end

@implementation SKBindingManager

@synthesize bindings;

- (id)init {
    self = [super init];
    if (self) {
        self.bindings = [NSMutableArray array];
    }
    return self;
}

- (BOOL)checkForCyclesInGraph {
//    NSMutableSet *set = [NSMutableSet set];
//    
//    for (SKBinding *binding in self.bindings) {
//        SKVertex *vertex1 = [[SKVertex alloc] init];
//        vertex1.obj = binding.fromObject;
//        vertex1.keyPath = binding.fromKeyPath;
//        
//        SKVertex *vertex2 = [[SKVertex alloc] init];
//        vertex2.obj = binding.toObject;
//        vertex2.keyPath = binding.toKeyPath;
//        
//        [set addObject:vertex1];
//        [set addObject:vertex2];
//    }
//    
//    
//    for (SKVertex *vertex in set) {
//        NSMutableSet *visited = [NSMutableSet setWithObject:vertex];
//        //nadi sve vertexe u koje se moze prijeci
//    }
    
    
    return NO;
}

- (BOOL)bindIdExists:(NSString *)bindId {
    for (SKBinding *binding in self.bindings) {
        if ([bindId isEqualToString:binding.bindId]) return YES;
    }
    return NO;
}

- (SKBinding *)bindingFromObject:(id)object andKeyPath:(NSString *)keyPath inContext:(NSString *)context {
    for (SKBinding *binding in self.bindings) {

        if ([binding.bindId isEqualToString:context] && 
            [binding.fromKeyPath isEqualToString:keyPath] &&
            binding.fromObject == object && binding.active) 

            return binding;
    
    }

    return nil;
}

- (void)deactivateConnection:(NSString *)bindId {
    for (SKBinding *binding in self.bindings) {
        
        if ([binding.bindId isEqualToString:bindId]) {
            
            binding.active = NO;
            
            [binding.fromObject removeObserver:self 
                                    forKeyPath:binding.fromKeyPath 
                                       context:(void*)bindId];
            
            if ([binding.fromObject isKindOfClass:[UIView class]] && 
                [binding.fromObject respondsToSelector:@selector(removeTarget:action:forControlEvents:)]) {
                
                [binding.fromObject removeTarget:self action:@selector(changeInUIKitOccurred:) forControlEvents:UIControlEventEditingChanged];
            }
            
        }
    
    }
}

- (void)activateConnection:(NSString *)bindId {
    for (SKBinding *binding in self.bindings) {
        
        if ([binding.bindId isEqualToString:bindId]) {
            
            binding.active = YES;

            [binding.fromObject addObserver:self 
                                 forKeyPath:binding.fromKeyPath 
                                    options:(NSKeyValueObservingOptionNew) 
                                    context:(void*)bindId];

            if ([binding.fromObject isKindOfClass:[UIView class]] && 
                [binding.fromObject respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
                
                [binding.fromObject addTarget:self action:@selector(changeInUIKitOccurred:) forControlEvents:UIControlEventEditingChanged];
            
            }
            
        }
        
    }
}

- (void)setupBindingForUIKitWithBinding:(SKBinding *)binding {
    
    if (![binding.fromObject respondsToSelector:@selector(addTarget:action:forControlEvents:)])
        return;

    if ([binding.fromObject isKindOfClass:[UITextField class]] ||
        [binding.fromObject isKindOfClass:[UITextView class]]) {
        
        [binding.fromObject addTarget:self action:@selector(changeInUIKitOccurred:) forControlEvents:UIControlEventEditingChanged];
    
    } 
}

- (void)changeInUIKitOccurred:(id)sender {
    
    id value = nil;
    if ([sender isKindOfClass:[UITextField class]]) value = [(UITextField *)sender text];
    else if ([sender isKindOfClass:[UILabel class]]) value = [(UILabel *)sender text];
    else if ([sender isKindOfClass:[UITextView class]]) value = [(UITextView *)sender text];
    
    for (SKBinding *binding in self.bindings) {
        if (binding.fromObject == sender) {

            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"kind", value, @"new", nil];
            [self observeValueForKeyPath:binding.fromKeyPath ofObject:sender change:dict context:(void *)binding.bindId];

        }
    }
}

- (BOOL)bind:(NSDictionary *)bindingOptions {
    
    BOOL twoWayBinding = [[bindingOptions objectForKey:kBindingOptionTwoWayBinding] boolValue];
    NSString *bindId = [bindingOptions objectForKey:kBindingOptionBindId];
    
    NSAssert(![self bindIdExists:bindId], @"Binding with id=%@, already exists", bindId);
    
    SKBinding *binding = [[SKBinding alloc] init];
    SKBinding *backwardBinding = nil;
    
    binding.bindId = [bindingOptions objectForKey:kBindingOptionBindId];
    
    binding.fromObject = [bindingOptions objectForKey:kBindingOptionFromObject];
    binding.toObject = [bindingOptions objectForKey:kBindingOptionToObject];
    
    binding.fromKeyPath = [bindingOptions objectForKey:kBindingOptionFromKeyPath];
    binding.toKeyPath = [bindingOptions objectForKey:kBindingOptionToKeyPath];
    
    binding.active = YES;
    
    BOOL equal = binding.fromObject == binding.toObject && [binding.fromKeyPath isEqualToString:binding.toKeyPath];
    NSAssert(!equal,@"You can not bind to same object");
    
    [self.bindings addObject:binding];
    
    if (twoWayBinding) {
        backwardBinding = [[SKBinding alloc] init];
        backwardBinding.bindId = [bindingOptions objectForKey:kBindingOptionBindId];
        
        backwardBinding.fromObject = [bindingOptions objectForKey:kBindingOptionToObject];
        backwardBinding.toObject = [bindingOptions objectForKey:kBindingOptionFromObject];

        backwardBinding.fromKeyPath = [bindingOptions objectForKey:kBindingOptionToKeyPath];
        backwardBinding.toKeyPath = [bindingOptions objectForKey:kBindingOptionFromKeyPath];
        
        backwardBinding.active = YES;
        
        [self.bindings addObject:backwardBinding];
    }
    
    NSAssert(![self checkForCyclesInGraph],@"Cycles in binding graph lead to erratic behavior so it's not allowed");
    
    [binding.fromObject addObserver:self
                            forKeyPath:binding.fromKeyPath
                               options:(NSKeyValueObservingOptionNew)
                               context:(void *)binding.bindId];
    
    if ([binding.fromObject isKindOfClass:[UIView class]]) {
        [self setupBindingForUIKitWithBinding:binding];
    }

    if (twoWayBinding) {
    
        [backwardBinding.fromObject addObserver:self
                             forKeyPath:backwardBinding.fromKeyPath
                                options:(NSKeyValueObservingOptionNew)
                                context:(void *)binding.bindId];

        if ([backwardBinding.fromObject isKindOfClass:[UIView class]]) {
            [self setupBindingForUIKitWithBinding:backwardBinding];
        }
    }
    
    //observe za from - za initial stanje
    //observe za to - za initial stanje
    
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    NSString *bindId = (__bridge NSString *)context;
    
    SKBinding *binding = [self bindingFromObject:object andKeyPath:keyPath inContext:bindId];
    NSAssert(binding,@"Internal inconsistency, no binding with id %@", bindId);

    [self deactivateConnection:bindId];
    
    id newValue = [change valueForKey:NSKeyValueChangeNewKey];
    [binding.toObject setValue:newValue forKey:binding.toKeyPath];
    
    [self activateConnection:bindId];
    
}

- (BOOL)unbind:(NSDictionary *)bindingOptions {
    return YES;
}

- (void)removeAllBindings {
    for (SKBinding *binding in self.bindings) {
        if (binding.active) {
            [binding.fromObject removeObserver:self 
                                    forKeyPath:binding.fromKeyPath 
                                       context:(void*)binding.bindId];
            
            if ([binding.fromObject isKindOfClass:[UIView class]] && 
                [binding.fromObject respondsToSelector:@selector(removeTarget:action:forControlEvents:)]) {
                
                [binding.fromObject removeTarget:self action:@selector(changeInUIKitOccurred:) forControlEvents:UIControlEventEditingChanged];
            }
        }
    }
    [self.bindings removeAllObjects];
}

@end

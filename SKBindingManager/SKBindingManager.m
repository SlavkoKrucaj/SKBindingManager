//
//  SKBindingManager.m
//  BindableTableViewProject
//
//  Created by Slavko Krucaj on 21.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import "SKBindingManager.h"

NSString *const BindingFrom = @"fromObject";
NSString *const BindingTo = @"toObject";
NSString *const BindingFromKeyPath = @"fromKeyPath";
NSString *const BindingToKeyPath = @"toKeyPath";
NSString *const BindingId = @"bindId";
NSString *const BindingTwoWayBinding = @"twoWay";
NSString *const BindingForwardTransformation = @"forwardTransformation";
NSString *const BindingBackwardTransformation = @"backwardTransformation";
NSString *const BindingInitialValue = @"initialValue";

NSString *const BindingPropertyLabel = @"text";
NSString *const BindingPropertyTextField = @"text";
NSString *const BindingPropertyTextView = @"text";
NSString *const BindingPropertySwitch = @"on";
NSString *const BindingPropertyStepper = @"value";
NSString *const BindingPropertySlider = @"value";

NSString *const BindingInitialValueFrom = @"initialFrom";
NSString *const BindingInitialValueTo = @"initialTo";

@interface SKVertex : NSObject
@property id obj;
@property NSString *keyPath;
@property NSMutableArray *adjacentVertices;
@end

@implementation SKVertex : NSObject

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[SKVertex class]]) return NO;
    
    return (self.obj == ((SKVertex *)object).obj && [self.keyPath isEqualToString:((SKVertex *)object).keyPath]);
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger hash = 1;
    hash = prime * hash + [[self obj] hash];
    hash += prime * hash + [[self keyPath] hash];
    return hash;
}

- (id)copyWithZone:(NSZone *)zone
{
    SKVertex *copy = [[[self class] allocWithZone:zone] init];
    copy.obj = nil; [copy setObj:[self obj]];
    copy.keyPath = nil; [copy setKeyPath:[self keyPath]];
    copy.adjacentVertices = nil; [copy setAdjacentVertices:[self adjacentVertices]];

    return copy;
}
@end

@interface SKBinding : NSObject

@property (strong) NSString *bindId;
@property (strong) id fromObject;
@property (strong) id toObject;
@property (strong) NSString *fromKeyPath;
@property (strong) NSString *toKeyPath;
@property BOOL active;
@property (strong) SKTransformationBlock transformation;

@end

@implementation SKBinding
@end

@interface SKBindingManager()
@property NSMutableArray *bindings;
@end

@implementation SKBindingManager

- (id)init {
    self = [super init];
    if (self) {
        self.bindings = [NSMutableArray array];
    }
    return self;
}

-(BOOL)checkVertices:(NSMutableArray *)unvisited fromVertex:(NSNumber *)indexOfVertex withVisited:(NSMutableArray *)visitedVertices {
    
    if ([visitedVertices containsObject:indexOfVertex]) {
        if ([visitedVertices indexOfObject:indexOfVertex] < visitedVertices.count - 2) {
            NSLog(@"Cycle detected -> ");
            for (NSNumber *cycleIndex in visitedVertices) {
                SKVertex *cycleVertex = [unvisited objectAtIndex:cycleIndex.intValue];
                NSLog(@"object: %@, keypath: %@",cycleVertex.obj, cycleVertex.keyPath);
            }
            SKVertex *cycleVertex = [unvisited objectAtIndex:indexOfVertex.intValue];
            NSLog(@"object: %@, keypath: %@",cycleVertex.obj, cycleVertex.keyPath);
            NSLog(@"##################");
            return YES;
        
        }
        else {
            return NO;
        }
    }
    
    [visitedVertices addObject:indexOfVertex];
    SKVertex *vertex = [unvisited objectAtIndex:indexOfVertex.intValue];

    if (vertex.adjacentVertices.count == 0) {
        return NO;
    }
    
    for (NSNumber *vertexIndex in vertex.adjacentVertices) {
        
        BOOL hasCycle = [self checkVertices:unvisited 
                                 fromVertex:vertexIndex 
                                withVisited:[visitedVertices mutableCopy]];

        if (hasCycle) return YES;
    }
    
    return NO;
    
}

- (BOOL)checkForCyclesInGraph {
    
    NSMutableArray *vertices = [NSMutableArray array];
    
    for (SKBinding *binding in self.bindings) {
        SKVertex *vertex1 = [[SKVertex alloc] init];
        vertex1.obj = binding.fromObject;
        vertex1.keyPath = binding.fromKeyPath;
        vertex1.adjacentVertices = [NSMutableArray array];
        
        SKVertex *vertex2 = [[SKVertex alloc] init];
        vertex2.obj = binding.toObject;
        vertex2.keyPath = binding.toKeyPath;
        vertex2.adjacentVertices = [NSMutableArray array];
        
        if (![vertices containsObject:vertex1]) [vertices addObject:vertex1];
        if (![vertices containsObject:vertex2]) [vertices addObject:vertex2];
        
        vertex1 = [vertices objectAtIndex:[vertices indexOfObject:vertex1]];
        [vertex1.adjacentVertices addObject:[NSNumber numberWithInt:[vertices indexOfObject:vertex2]]];
    }

    
    for (int i=0;i<vertices.count;i++) {
        BOOL hasCycle = [self checkVertices:[vertices mutableCopy] fromVertex:[NSNumber numberWithInt:i] withVisited:[NSMutableArray array]];
        if (hasCycle) return YES;
    }

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
            
            if ([binding.fromObject isKindOfClass:[UIView class]]) {
                [self deactivateBindingForUIKit:binding];
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

            if ([binding.fromObject isKindOfClass:[UIView class]]) {
                [self setupBindingForUIKitWithBinding:binding];
            }
            
        }
        
    }
}

- (void)deactivateBindingForUIKit:(SKBinding *)binding {
    
    if ([binding.fromObject isKindOfClass:[UILabel class]]) return;
    
    if ([binding.fromObject isKindOfClass:[UITextField class]]) {
        
        [binding.fromObject removeTarget:self action:@selector(changeInUIKitOccurred:) forControlEvents:UIControlEventEditingChanged];
    
    } else if ([binding.fromObject isKindOfClass:[UITextView class]]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:binding.fromObject];
        
    } else if ([binding.fromObject isKindOfClass:[UISwitch class]] ||
               [binding.fromObject isKindOfClass:[UIStepper class]] ||
               [binding.fromObject isKindOfClass:[UISlider class]]) {
    
        [binding.fromObject removeTarget:self action:@selector(changeInUIKitOccurred:) forControlEvents:UIControlEventValueChanged];
        
    }
}

- (void)setupBindingForUIKitWithBinding:(SKBinding *)binding {
    
    if ([binding.fromObject isKindOfClass:[UILabel class]]) return;
    
    if ([binding.fromObject isKindOfClass:[UITextField class]]) {
        
        [binding.fromObject addTarget:self action:@selector(changeInUIKitOccurred:) forControlEvents:UIControlEventEditingChanged];
        
    } else if ([binding.fromObject isKindOfClass:[UITextView class]]) {
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:binding.fromObject];
        
    } else if ([binding.fromObject isKindOfClass:[UISwitch class]] ||
               [binding.fromObject isKindOfClass:[UIStepper class]] ||
               [binding.fromObject isKindOfClass:[UISlider class]]) {
    
        [binding.fromObject addTarget:self action:@selector(changeInUIKitOccurred:) forControlEvents:UIControlEventValueChanged];

    }
}

- (void)changeInUIKitOccurred:(id)sender {
    
    id value = nil;
    if ([sender isKindOfClass:[UITextField class]]) value = [(UITextField *)sender text];
    else if ([sender isKindOfClass:[UILabel class]]) value = [(UILabel *)sender text];
    else if ([sender isKindOfClass:[UISwitch class]]) value = [NSNumber numberWithBool:[(UISwitch *)sender isOn]];
    else if ([sender isKindOfClass:[UIStepper class]]) value = [NSNumber numberWithDouble:[(UIStepper *)sender value]];
    else if ([sender isKindOfClass:[UISlider class]]) value = [NSNumber numberWithDouble:[(UISlider *)sender value]];

    for (SKBinding *binding in self.bindings) {
        if (binding.fromObject == sender) {

            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"kind", value, @"new", nil];
            [self observeValueForKeyPath:binding.fromKeyPath ofObject:sender change:dict context:(void *)binding.bindId];

        }
    }
}

- (BOOL)bind:(NSDictionary *)bindingOptions {
    
    BOOL twoWayBinding = [[bindingOptions objectForKey:BindingTwoWayBinding] boolValue];
    NSString *bindId = [bindingOptions objectForKey:BindingId];
    
    NSAssert(![self bindIdExists:bindId], @"Binding with id=%@, already exists", bindId);
    
    SKBinding *binding = [[SKBinding alloc] init];
    SKBinding *backwardBinding = nil;
    
    binding.bindId = [bindingOptions objectForKey:BindingId];
    
    binding.fromObject = [bindingOptions objectForKey:BindingFrom];
    binding.toObject = [bindingOptions objectForKey:BindingTo];
    
    binding.fromKeyPath = [bindingOptions objectForKey:BindingFromKeyPath];
    binding.toKeyPath = [bindingOptions objectForKey:BindingToKeyPath];
    
    binding.transformation = [bindingOptions objectForKey:BindingForwardTransformation];
    
    binding.active = YES;
    
    BOOL equal = binding.fromObject == binding.toObject && [binding.fromKeyPath isEqualToString:binding.toKeyPath];
    NSAssert(!equal,@"You can not bind to same object");
    
    [self.bindings addObject:binding];
    
    if (twoWayBinding) {
        backwardBinding = [[SKBinding alloc] init];
        backwardBinding.bindId = [bindingOptions objectForKey:BindingId];
        
        backwardBinding.fromObject = [bindingOptions objectForKey:BindingTo];
        backwardBinding.toObject = [bindingOptions objectForKey:BindingFrom];

        backwardBinding.fromKeyPath = [bindingOptions objectForKey:BindingToKeyPath];
        backwardBinding.toKeyPath = [bindingOptions objectForKey:BindingFromKeyPath];
        
        backwardBinding.transformation = [bindingOptions objectForKey:BindingBackwardTransformation];
        
        backwardBinding.active = YES;
        
        [self.bindings addObject:backwardBinding];
    }
    
    NSAssert(![self checkForCyclesInGraph],@"Cycles in binding graph lead to erratic behavior so it's not allowed");
    
    [binding.fromObject addObserver:self
                            forKeyPath:binding.fromKeyPath
                               options:(NSKeyValueObservingOptionNew)
                               context:(void *)binding.bindId];
    
    
    if ([binding.fromObject isKindOfClass:[UIView class]] &&
        ![binding.fromObject conformsToProtocol:@protocol(SKBindingProtocol)]) {
        
        [self setupBindingForUIKitWithBinding:binding];
    
    }

    if (twoWayBinding) {
    
        [backwardBinding.fromObject addObserver:self
                             forKeyPath:backwardBinding.fromKeyPath
                                options:(NSKeyValueObservingOptionNew)
                                context:(void *)binding.bindId];

        if ([backwardBinding.fromObject isKindOfClass:[UIView class]] &&
            ![backwardBinding.fromObject conformsToProtocol:@protocol(SKBindingProtocol)]) {
            
            [self setupBindingForUIKitWithBinding:backwardBinding];
        
        }
    }
    
    if ([[bindingOptions objectForKey:BindingInitialValue] isEqualToString:BindingInitialValueFrom] ||
        ![bindingOptions objectForKey:BindingInitialValue]) {
    
        id value = [binding.fromObject valueForKeyPath:binding.fromKeyPath];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"kind", value, @"new", nil];
        [self observeValueForKeyPath:binding.fromKeyPath ofObject:binding.fromObject change:dict context:(void *)binding.bindId];
        
    } else if ([[bindingOptions objectForKey:BindingInitialValue] isEqualToString:BindingInitialValueTo]){
    
        id value = [binding.toObject valueForKeyPath:binding.toKeyPath];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"kind", value, @"new", nil];
        [self observeValueForKeyPath:binding.toKeyPath ofObject:binding.toObject change:dict context:(void *)binding.bindId];
        
    }
    
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    NSString *bindId = (__bridge NSString *)context;
    
    SKBinding *binding = [self bindingFromObject:object andKeyPath:keyPath inContext:bindId];
    NSAssert(binding,@"Internal inconsistency, no binding with id %@", bindId);

    [self deactivateConnection:bindId];
    
    id newValue = [change valueForKey:NSKeyValueChangeNewKey];
    if (binding.transformation) {
        newValue = binding.transformation(newValue, binding.toObject);
    }
    [binding.toObject setValue:newValue forKey:binding.toKeyPath];
    
    [self activateConnection:bindId];
    
    if ([self.delegate respondsToSelector:@selector(bindedObject:changedKeyPath:)]) {
        [self.delegate bindedObject:binding.toObject changedKeyPath:binding.toKeyPath];
    }
    
}

- (void)removeAllBindings {
    for (SKBinding *binding in self.bindings) {
        if (binding.active) {
            [self deactivateConnection:binding.bindId];
        }
    }
    [self.bindings removeAllObjects];
}

- (void)textViewDidChange:(NSNotification *)notification {
    UITextView *textView = (UITextView *)notification.object;
    id value = textView.text;
    
    for (SKBinding *binding in self.bindings) {
        if (binding.fromObject == textView) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"kind", value, @"new", nil];
            [self observeValueForKeyPath:binding.fromKeyPath ofObject:textView change:dict context:(void *)binding.bindId];
            
        }
    }
}

- (void)activateAllBindings {
    for (SKBinding *binding in self.bindings) {
            
        binding.active = YES;
        
        [binding.fromObject addObserver:self
                             forKeyPath:binding.fromKeyPath
                                options:(NSKeyValueObservingOptionNew)
                                context:(void*)binding.bindId];
        
        if ([binding.fromObject isKindOfClass:[UIView class]]) {
            [self setupBindingForUIKitWithBinding:binding];
        }
        
    }
}

- (void)deactivateAllBindings {
    for (SKBinding *binding in self.bindings) {
            
        binding.active = NO;
        
        [binding.fromObject removeObserver:self
                                forKeyPath:binding.fromKeyPath
                                   context:(void*)binding.bindId];
        
        if ([binding.fromObject isKindOfClass:[UIView class]]) {
            [self deactivateBindingForUIKit:binding];
        }
        
    }
}

@end

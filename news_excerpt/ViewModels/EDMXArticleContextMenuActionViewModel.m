//
//  EDMXArticleContextMenuActionViewModel.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 01/08/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXArticleContextMenuActionViewModel.h"
#import "MTLManagedObjectAdapter.h"

@implementation EDMXArticleContextMenuActionViewModel

- (void)action {
    if (self.inProgress) {
        return;
    }    
    self.inProgress = YES;
    @weakify(self);
    [NSFetchedResultsController deleteCacheWithName:nil];
    [self.actionSignal subscribeNext:^(id response) {
        @strongify(self);
        [self updateModel:response];
    } error:^(NSError *error) {
        @strongify(self);
        [self completeAction];
    } completed:^{
        @strongify(self);
        [self completeAction];
    }];
}

- (void)completeAction {
    self.inProgress = NO;
    if (self.delegate) {
        [self.delegate actionCompleted:self];
    }
}

- (RACSignal *)actionSignal {
    return [RACSignal empty];
}

- (void)updateModel:(id)actionValue {
    NSManagedObjectContext *context = self.persistenceController.managedObjectContext;
    NSError *error = nil;
    [MTLManagedObjectAdapter managedObjectFromModel:self.model
                               insertingIntoContext:context
                                              error:&error];
    [context performBlockAndWait:^{
        if ([context hasChanges]) {
            NSError *error = nil;
            [context save:&error];
            NSAssert(error == nil, @"%@ saveResult failed with error: %@", self, error);
        }
    }];
}

@end

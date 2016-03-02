//
//  EDMXFavoriteCategoryActionViewModel.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 01/08/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXFavoriteCategoryActionViewModel.h"
#import "EDMXCategory.h"
#import "EDMXFavoritizationsClient.h"
#import "EDMXFavoritization.h"

@interface EDMXFavoriteCategoryActionViewModel()

@property (nonatomic, strong, readwrite) EDMXCategory *model;
@property (nonatomic, strong) EDMXFavoritizationsClient *favoritizationsClient;

@end

@implementation EDMXFavoriteCategoryActionViewModel

- (EDMXFavoritizationsClient *)favoritizationsClient
{
    return _favoritizationsClient ? _favoritizationsClient : (_favoritizationsClient = [[EDMXFavoritizationsClient alloc] initWithManagedObjectContext:self.persistenceController.managedObjectContext                                                                                                                                sessionConfiguration:nil]);
}

- (NSString *)actionTitle {
    return self.model.name;
}

- (NSString *)iconImageName {
    return self.inProgress ? nil : (self.model.isFavorited ? @"category_heart_pressed" : @"category_heart");
}

- (id)initWithCategory:(EDMXCategory *)category {
    self = [super init];
    if (self) {
        self.model = category;
    }
    return self;
}

- (RACSignal *)actionSignal {
    return self.model.isFavorited
        ? [self.favoritizationsClient destroyFavoritizationForCategory:self.model]
        : [self.favoritizationsClient createFavoritizationForCategory:self.model];
}

- (void)updateModel:(id)actionValue {
    self.model.favoritizationId = [[actionValue result] isKindOfClass:[EDMXFavoritization class]] ? [[actionValue result] remoteId] : nil;
    [super updateModel:actionValue];
    NSManagedObject *mob = [MTLManagedObjectAdapter managedObjectFromModel:self.model
                                                      insertingIntoContext:self.persistenceController.managedObjectContext
                                                                     error:nil];
    [[((NSSet *)[mob valueForKey:@"articles"]) allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj willChangeValueForKey:@"categories"];
        [obj didChangeValueForKey:@"categories"];
    }];
}

@end

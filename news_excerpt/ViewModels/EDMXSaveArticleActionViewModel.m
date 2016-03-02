//
//  EDMXSaveArticleActionViewModel.m
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 01/08/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "EDMXSaveArticleActionViewModel.h"
#import "EDMXArticle.h"
#import "EDMXFavoritizationsClient.h"
#import "EDMXFavoritization.h"

@interface EDMXSaveArticleActionViewModel()

@property (nonatomic, strong, readwrite) EDMXArticle *model;
@property (nonatomic, strong) EDMXFavoritizationsClient *favoritizationsClient;

@end

@implementation EDMXSaveArticleActionViewModel

- (EDMXFavoritizationsClient *)favoritizationsClient
{
    return _favoritizationsClient ? _favoritizationsClient : (_favoritizationsClient = [[EDMXFavoritizationsClient alloc] initWithManagedObjectContext:self.persistenceController.managedObjectContext                                                                                                                                sessionConfiguration:nil]);
}

- (BOOL)isSaved {
    return self.model.isSaved;
}

- (NSString *)actionTitle {
    return [self isSaved] ? @"Remove this article" : @"Save this article";
}

- (NSString *)iconImageName {
    return self.inProgress ? nil : (self.model.isSaved ? @"unsave_minus_icon" : @"save_plus_icon");
}

- (id)initWithArticle:(EDMXArticle *)article {
    self = [super init];
    if (self) {
        self.model = article;
    }
    return self;
}

- (RACSignal *)actionSignal {
    return self.model.isSaved
        ? [self.favoritizationsClient destroyFavoritizationForArticle:self.model]
        : [self.favoritizationsClient createFavoritizationForArticle:self.model];
}

- (void)updateModel:(id)actionValue {
    self.model.favoritizationId = [[actionValue result] isKindOfClass:[EDMXFavoritization class]] ? [[actionValue result] remoteId] : nil;
    [super updateModel:actionValue];
}

- (void)completeAction {
    [super completeAction];
    
    if ([self.delegate respondsToSelector:@selector(saveActionCompleted:)])
        [self.delegate saveActionCompleted:[self isSaved]];
}

@end

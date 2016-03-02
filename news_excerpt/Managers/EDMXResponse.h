//
//  EDMXResponse.h
//  Firstfestival
//
//  Created by Alexander Petropavlovsky on 30/07/14.
//  Copyright (c) 2014 Smart Cloud, Inc. All rights reserved.
//

#import "OVCResponse.h"

@interface EDMXResponse : OVCResponse

+ (id)transformJSONObject:(id)JSONObject;

@end

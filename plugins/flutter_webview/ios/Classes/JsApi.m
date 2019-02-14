#import "JsApi.h"

@implementation JsEApi

- (id) syn:(id) arg
{
    return arg;
}

- (void) asyn: (id) arg :(void (^)( id _Nullable result,BOOL complete))completionHandler
{
    completionHandler(arg,YES);
}

@end
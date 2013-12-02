#import "ApplicationMods.h"

@implementation ApplicationMods

+ (NSArray*) compiledMods
{
	NSMutableArray *modules = [NSMutableArray array];
	[modules addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"tiextension",@"name",@"nigam.ashish.extension",@"moduleid",@"0.1",@"version",@"0c5d64d8-5bb4-4c3e-b0eb-758a34d8c07f",@"guid",@"",@"licensekey",nil]];
	return modules;
}

@end
/**
 * This is a generated file. Do not edit or your changes will be lost
 */
#import "ComAshishSocketmoduleModuleAssets.h"

extern NSData* filterDataInRange(NSData* thedata, NSRange range);

@implementation ComAshishSocketmoduleModuleAssets

- (NSData*) moduleAsset
{
	

	return nil;
}

- (NSData*) resolveModuleAsset:(NSString*)path
{
		static UInt8 data[] = {
		0xa1,0xb7,0x8e,0x1b,0xff,0x64,0x4a,0xf2,0xa7,0x81,0xf0,0xd1,0x24,0x91,0x36,0x1a,0xa1,0xb7,0x8e,0x1b
		,0xff,0x64,0x4a,0xf2,0xa7,0x81,0xf0,0xd1,0x24,0x91,0x36,0x1a,0xa1,0xb7,0x8e,0x1b,0xff,0x64,0x4a,0xf2
		,0xa7,0x81,0xf0,0xd1,0x24,0x91,0x36,0x1a,0xf4,0xa8,0x9c,0xd5,0xa1,0xc6,0xe1,0x62,0x39,0xad,0x17,0x61
		,0x1b,0xda,0x3e,0x47,0x43,0xd8,0xff,0x43,0xfd,0x84,0xae,0xf9,0x38,0xe5,0xda,0xcd,0xb0,0xdf,0xcb,0xdf	};
	static NSRange ranges[] = {
		{0,16},
		{16,16},
		{32,16}
	};
	static NSDictionary *map = nil;
	if (map == nil) {
		map = [[NSDictionary alloc] initWithObjectsAndKeys:
		[NSNumber numberWithInteger:0], @"/Users/ashishn/Documents/Appcelerator_Studio_Workspace/SocketModule/assets/now.js",
		[NSNumber numberWithInteger:1], @"/Users/ashishn/Documents/Appcelerator_Studio_Workspace/SocketModule/assets/now_original_client.js",
		[NSNumber numberWithInteger:2], @"/Users/ashishn/Documents/Appcelerator_Studio_Workspace/SocketModule/assets/socket.io.js",
		nil];
	}


	NSNumber *index = [map objectForKey:path];
		if (index == nil) {
			return nil;
		}
		return filterDataInRange([NSData dataWithBytesNoCopy:data length:sizeof(data) freeWhenDone:NO], ranges[index.integerValue]);
}

@end

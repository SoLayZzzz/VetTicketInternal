#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@import GoogleMaps;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSString *mapsApiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GMSApiKey"];
  if (mapsApiKey != nil && mapsApiKey.length > 0) {
    [GMSServices provideAPIKey:mapsApiKey];
  }
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

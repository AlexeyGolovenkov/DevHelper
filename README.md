[![codebeat badge](https://codebeat.co/badges/220442c0-eb9a-4369-a387-2e611ae90f00)](https://codebeat.co/projects/github-com-alexeygolovenkov-devhelper-master)
# DevHelper
Small extension for Xcode editor

I love small inconspicuous tools that always are at my hands. So this project is a set of such tools that make my code editing a bit faster and comfort. I recommend to specify a hot key for most of these gears and try to use them in your daily practice.

## Installation
Clone the project, open it in Xcode and set your dev team for DevHelper and DevHelperContainer targets, then Product -> Archive. Then, in Organizer, choose "Export..." and "Export as macOS-application". As soon as app is run it install the extension. The extension may have to be enabled from your system preferences, in the Extensions-pane. The extension will be activated after Xcode restart.

## Usage
DevHelper is a native Xcode editor extension. You can find it in the bottom of Editor menu in code editing mode. Also you can set hot keys for the items you plan to use often. Open Xcode preferences, navigate to Key Bindings pane and type devhelper in search. Then double click on the right side of the window in front of the item you want to bind to keyboard and just press a key combination. Done!

## Tools description
### Sort and Uniq
The full analogue of sort|uniq command of *nix console. Sorts selected lines and removes duplicates. Very useful to cleanup imports in Obj-C code. Select your import list and choose Editor -> DevHelper -> Sort and Uniq.
Before:
```Obj-C
#import "EventsBatch.h"
#import "PortalManager.h"
#import "AnalyticEventsManager.h"
#import "HTTPClient.h"
#import <Foundation/Foundation.h>
#import "PortalManager.h"
#import "EventsBatch.h"
```

After
```Obj-C
#import "AnalyticEventsManager.h"
#import "EventsBatch.h"
#import "HTTPClient.h"
#import "PortalManager.h"
#import <Foundation/Foundation.h>
```

### Copy Line Above
Copies a previous line to current cursor position. Coping is started from the column where cursor is placed. Useful for number of similar lines of code. Good example - parsing of JSON or NSCoding protocol implementing

### Comment out
Add /\* before and \*/ after selected text. Selection is extended by inserted symbols. If selection is empty, just adds symbols at cursor position and move the cursor between.

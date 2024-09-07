# Arcadia App

## App Architecture

The app is written using SwiftUI and is designed to be as simple to use as possible.
It is also meant to be transparent and give the users full control over their files: when installed it will create an Arcadia folder inside the documents folder, which will contain a folder for:

- Games
- Saves
- States
- Images
- Cores

In these folders, there is a folder for each core, and inside those you'll find all the relevant files.
The cores folder is not currently used, but if you're an advanced user here you can put optional BIOS files supported by the cores used.
The app relies on the fact that each file type for the same game has the same name, for example game.gb expects to find a game.jpg for cover, game.srm for save, and so on, which means that if you rename a file outside of the app, you should make sure to rename every file the game relies on.

### Game library

The game library is basically a window over the Games/Selected Core/ folder in your filesystem, with the exception that it shows only the files that the current core can load.
Also when importing a new game, you can only select game files that are compatible with the currently selected core.
The lightbulb icon is used to access the recommendation view, which will compare the files in your library with the files in the internal database and give you a list of 10 games that are most similar to what you have in your library (using genre and description as a similarity measure).

### Interface

The interface is rather simple and uses mostly default SwiftUI components with not many modifications.
The game controls part is designed to be unobtrusive and give space to the game itself, and it is built dynamically based on the "controller parts" defined by the game type.
To put it simply, ArcadiaButtonLayout takes as input a list of ArcadiaButtonLayoutElements (start, select, dpad, etc) and build the interface based on the input list.

### Cloud Sync

The first version of cloud sync that I tested was to simply use the iCloud Directory as a main storage directory, which worked great because everything is taken care of by iOS, but it had a major flaw: iOS and macOS automatically decide the availability of the files in iCloud, downloading them when needed and offloading them when not needed, which means that in most cases the actual game file would be offloaded to the cloud.
Now, most of the supported systems game files are pretty small and they are downloaded basically instantaneously, but playing would be basically impossible when no internet is available.
The solution currently implemented, uses the iCloud drive folder as a backup, following these steps:

- when iCloud sync is turned on, all local files are copied to the iCloud drive folder
- each new file or new file action (rename, deletion, etc) is done locally and in the iCloud drive folder
- periodically the systems compares the local files with the iCloud files:
  - if the local filesystem has file A and iCloud filesystem has file A: the most recent version will be kept
  - if the local filesystem has file A and iCloud filesystem does not have file A: file will be deleted from the local filesystem (this can happen only when the file is deleted from another device or renamed)
  - if the local filesystem does not have file A and iCloud filesystem has file A: file will be downloaded from iCloud drive to the local filesystem

When turning off iCloud Sync, all files from iCloud will be downloaded to the local filesystem.

This approach ensures that the local filesystem always has a copy of the file that can be accessed even without internet.

### Adding new cores

To add support for a new core, a new case has to be added to the ArcadiaGameType enum, and after filling all the properties the app will include the new core

## Roadmap

Here is a list of planned features and known bugs.

### Planned features

- [ ] Save export capability
- [ ] Game controller navigation inside menus
- [ ] Import save files
- [ ] List edit mode to edit multiple files together
- [ ] Quick actions from the app icon to open directly a specific system
- [ ] Programmable combo buttons 
- [ ] Accessibility feature that describes the current frame
- [ ] Possibility to open rom directly from other apps
- [ ] Game icon should be system cartridge icon
- [ ] Possibility to turn off sound

### Known bugs

- [ ] games list appears higher and then shifts lower
- [ ] when opening the app for the first time, sounds from other apps (music, etc) stops

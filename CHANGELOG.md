# 1.2

## Cores
- Sega Genesis

## Features
- Added the possibility to hide buttons
- Added an Advanced DPad option with diagonal movements
- Added the possibility to open game files from the Files app or from the share sheet, to import them directly into the game library
- Added the possibility to pull to refresh the game collection

## Improvements
- Updated button spacing

## Localization
- Added Italian localization

## Accessibility
- Improved accessibility

## Bug fixes
- Fixed screenshot feature not working on some cores
- Removed the export save button from swiping on the game list. The button was not triggering anything, the function will come but as of right now you can find all the save files in the storage folder (you can access it from the Files app or from Arcadia's storage settings)
- Fixed iCloud Sync being triggered also when not enabled in some cases
- Fixed renaming being prevented on some cases when iCloud Sync is enabled
- Cloud Sync button is now disabled if Cloud Sync is disabled

## Internals
- Code refactoring to help in interface modifications
- Code refactoring for file management
- Minor adjustments in SNES core compilation

# 1.1

## Cores
- NeoGeo Pocket (Color)
- Sega MS - SG1000
- Sega Game Gear

## Features
- Added a share screenshot button in the overlay menu
- Added a save screenshot button in the overlay menu
- Added a game recommendation page, that will suggest you other game that you might like based on the metadata of your game library

## Improvements
- Improved the iCloud Sync logic to only copy the data from the cloud, rather than using it as a source directly. This translates in better performances and less possibility to launch a game that is not actually downloaded (if you had no data for example)

## Bug fixes
- Changed Atari 7800 icon to the Atari 7800 controller

# 1.0

Initial release


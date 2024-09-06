# Arcadia

Arcadia is a frontend to the Libretro API, compatible with iOS and macOS.
The aim for this project is to make retro gaming available to everyone, so it is designed to be simple and accessible.
This means that, while I chose to implement the Libretro API, it will probably never support all Libretro Cores (BIOS requirements are a no go for example), or all Libretro functions.
It is an ongoing project.

## Architecture

The main pillar of Arcadia is the ArcadiaCoreProtocol, which is where I implemented all the Libretro API code, with a default implementation.
Each core then simply has to adopt the ArcadiaCoreProtocol and provide an implementation for the interface functions (such as retro_run, etc); all the other methods will be executed using the default implementation in ArcadiaCoreProtocol, which will call the core implementation of the interface functions.
This is a complicated way to say that adopting a new core is very simple, just get it to compile as a framework, adopt the ArcadiaCoreProtocol and you're good to go.

## App

The app is written using SwiftUI and default UI components. The rendering of the frames uses Metal for efficiency.

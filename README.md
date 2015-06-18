# Playlist to Mixcloud

A Ruby shell script which automates most of the work of uploading a playlist to [Mixcloud](http://www.mixcloud.com).

It takes a `.m3u` playlist file, merges all audio files in it to a single `.mp3` file, and creates a timestamped tracklist text file, which can be copy-pasted into Mixcloud's "Tracklist & Timestamp" section.

## Requirements

* Ruby
* [VLC](http://www.videolan.org/) - a free and open source cross-platform multimedia player and framework.
* [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) - a command-line application for reading, writing and editing meta information. On OS X you can install it with Homebrew: `brew install exiftool`.

## Usage

First, edit the script and update the paths to your VLC and exiftool applications.

Then, run the following command:

`ruby mixcloud.rb -p playlist.m3u -a audio.mp3 -t tracklist.txt`

This will use `playlist.m3u` to create the merged audio file `audio.mp3` and the tracklist file `tracklist.txt`.

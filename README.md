# Playlist to Mixcloud

A Ruby shell script which automates most of the work of uploading a playlist to [Mixcloud](http://www.mixcloud.com).

It takes a `.m3u` playlist file, merges all audio files in it to a single `.mp3` file, and creates timestamped tracklist files, which can be uploaded to MixCloud as part of the music uploading process.

#### NOTE:

There are two tracklist files in two different formats that are generated.

The first ends with `.txt` and is the old-style format which content needs to be copy-pasted into the Upload page's "Tracklist & Timestamp" section.

The second newer format is `.cue`, which MixCloud now supports, and is **the recommended** file to use, instead of the `.txt` one. Still, if this doesn't work, you can try the old-style file instead.

## Requirements

* Ruby
* [VLC](http://www.videolan.org/) - a free and open source cross-platform multimedia player and framework.
* [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) - a command-line application for reading, writing and editing meta information. On OS X you can install it with Homebrew: `brew install exiftool`.

## Usage

First, edit the script and update the paths to your VLC and exiftool applications.

Then, run the following command:

`ruby mixcloud.rb -p playlist.m3u -a audio.mp3 -t tracklist.txt`

This will use `playlist.m3u` to create the merged audio file `audio.mp3` and the tracklist file `tracklist.txt`.

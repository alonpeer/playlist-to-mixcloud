require 'optparse'
require 'rubygems'
require 'json'
require 'pathname'

vlc = "/Applications/VLC.app/Contents/MacOS/VLC"
exiftool = "/usr/local/bin/exiftool"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby mixcloud.rb [options]"

  opts.on('-pMANDATORY', '--playlist FILENAME', 'Path to playlist input file (currently supporting .m3u)') { |v| options[:playlist] = v }
  opts.on('-aMANDATORY', '--audio FILENAME', 'Path to audio output file, including .mp3 extension') { |v| options[:audio] = v }
  opts.on('-tMANDATORY', '--tracklist FILENAME', 'Path to tracklist output file, no extension') { |v| options[:mixcloud] = v }
end.parse!

puts "--------------------------------------------------------------"
puts "| Running VLC to create a single MP3 file from your playlist |"
puts "--------------------------------------------------------------"
puts ""

`#{vlc} --audio-filter normvol -I dummy #{options[:playlist]} --sout "#transcode{acodec=mp3,ab=192,channels=2}:std{access=file,mux=raw,dst=#{options[:audio]}}" --sout-keep --play-and-exit`

puts ""
puts "--------"
puts "| DONE |"
puts "--------"

puts ""
puts "---------------------------------------"
puts "| Creating the MixCloud playlist file |"
puts "---------------------------------------"
puts ""

audio_file_path = Pathname.new(options[:audio])
playlist_m3u = []
playlist_cue = ["FILE \"#{audio_file_path.basename}\" MP3"]
current_time = 0.0
track_index = 1

File.open(options[:playlist]).each_line do |path|
  path = path.strip
  if (path.length > 0 && path[0] != '#')
    puts "Analyzing #{path} ..."

    metadata = JSON.parse(`#{exiftool} -Artist -Title -Duration# -j "#{path}"`)
    artist = metadata[0]["Artist"]
    title = metadata[0]["Title"]
    start_time_m3u = Time.at(current_time.round).utc.strftime("%H:%M:%S")
    start_time_cue = Time.at(current_time.round).utc.strftime("%M:%S:00")

    playlist_m3u.push("#{artist} - #{title} - #{start_time_m3u}")

    playlist_cue.push("  TRACK #{'%02i' % track_index} AUDIO")
    playlist_cue.push("    TITLE \"#{title}\"")
    playlist_cue.push("    PERFORMER \"#{artist}\"")
    playlist_cue.push("    INDEX 01 #{start_time_cue}")

    current_time += metadata[0]["Duration"]
    track_index += 1
  end
end

File.write("#{options[:mixcloud]}.txt", playlist_m3u.join("\n"))
File.write("#{options[:mixcloud]}.cue", playlist_cue.join("\n"))

puts ""
puts "--------"
puts "| DONE |"
puts "--------"

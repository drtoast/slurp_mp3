# About

Just a simple script to download any new songs from your favorite MP3 blogs, once per hour.

# Setup
    
Replace "username" with your username in com.drtoast.slurp_mp3.plist, then:

    cp com.drtoast.slurp_mp3.plist ~/Library/LaunchAgents
    mkdir ~/Music/slurp_mp3
    cp get.rb ~/Music/slurp_mp3
    cd ~/Music/mp3_blogs
    sqlite3 mp3s.db
    sqlite> create table files(site varchar(255), filename varchar(255), created_at datetime);

# Usage

Start:

    launchctl load ~/Library/LaunchAgents/com.drtoast.slurp_mp3.plist
    
Verify:

    launchctl list | grep drtoast

Stop:
    
    launchctl remove com.drtoast.slurp_mp3

# Todo

Add a bundler Gemfile, config file, and setup script

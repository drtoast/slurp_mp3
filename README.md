# About

Just a simple script to download any new songs from your favorite MP3 blogs, once per hour, whenever you're online. Uses a sqlite3 database to keep track of what was downloaded and when, and runs in the background using Mac OS X's launchd.

# Setup

First:

    cd ~/Music
    git clone git://github.com/drtoast/slurp_mp3.git
    cd slurp_mp3

Then in com.drtoast.slurp_mp3.plist, replace "username" with your username, and update blog list as desired, then:

    mv com.drtoast.slurp_mp3.plist ~/Library/LaunchAgents
    sqlite3 mp3s.db
    sqlite> create table files(site varchar(255), filename varchar(255), created_at datetime);
    sqlite> .quit

# Usage

Start:

    launchctl load ~/Library/LaunchAgents/com.drtoast.slurp_mp3.plist
    
Verify:

    launchctl list | grep drtoast

Stop:
    
    launchctl remove com.drtoast.slurp_mp3

# Todo

Add a bundler Gemfile, config file, and setup script

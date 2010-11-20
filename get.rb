#!/usr/bin/ruby

require 'rubygems'
require 'hpricot'
require 'fileutils'
require 'net/http'
require 'sqlite3'
require 'cgi'

class Downloader
  
  ROOT = File.dirname(__FILE__)
  
  def initialize
    @db = SQLite3::Database.new(File.join(ROOT,'mp3s.db'))
  end

  def get_mp3s(site)
  
    FileUtils.mkdir_p("#{ROOT}/downloads/#{site}/")
    
    uri = "http://#{site}"
    get_index uri

    if (@doc)
      mp3s = @doc.search("a[@href$='.mp3']")
      mp3s.each do |i|
        
        href = i.attributes["href"]
        file = File.basename(href)
        
        unless get_existing(site, file)
          # get the file
          log "grabbing #{href}"
          response = Net::HTTP.get_response(URI.parse(href.gsub(/ /,'%20')))
          case response
          when Net::HTTPSuccess
            save_new(site, file, response)
          else
            log "ERROR: #{response.class.name}"
          end
          @db.execute("INSERT INTO files VALUES(?,?,?)", site, file, Time.now)
        end
      end
    end
  end

  def log(msg)
    puts msg
    File.open("#{ROOT}/log.txt", "a") do |f|
      f << [Time.now, msg].join("\t") << "\n"
    end
  end

  def get_index(uri)
    log "checking #{uri}"
    response = Net::HTTP.get_response(URI.parse(uri))
    case response
    when Net::HTTPRedirection
      get_mp3s(response['location'])
    when Net::HTTPSuccess
      @doc = Hpricot(response.body)
    else
      result = response.class.to_s
      log "ERROR: #{result}"
    end
  end

  def get_existing(site, file)
    @db.get_first_row("select * from files where site = ? AND filename = ?", site, file)
  end

  def save_new(site, file, response)
    File.open("#{ROOT}/downloads/#{site}/#{CGI::unescape(file)}", "w") do |mp3|
      mp3 << response.body
    end
  end
  
end

d = Downloader.new

ARGV.each do |site|
  d.get_mp3s(site)
end

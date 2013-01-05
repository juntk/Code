# encoding: utf-8
require 'rubygems'
require 'fssm'
require 'diff/lcs'

class Io
    def self.fRead(path)
        p path
        f = File.open(path, 'r')
        body = f.read()
        f.close()
        return body.split("\n")
    end
end

class Kyoko
    def self.say(message)
        tmp = message.split(" ",2)
        date = tmp[0]
        tmp = tmp[1].split(":",2)
        name = tmp[0]
        body = tmp[1]
        if body != nil and name.split(" ").size == 1 then
            if body =~ /^[0-9A-Za-z!-\/:-@\[-`{-~ ]+$/ then
                cmd = "say -v Vicki '#{name} san, #{body}'"
            else
                cmd = "say -v kyoko '#{name}さん、#{body}'"
            end
            system(cmd)
        end
    end
end

class KyokoSay
    def initialize
        @defaultTranscripts = "#{File.expand_path("~")}/Documents/LimeChat Transcripts/"
        channel = ARGV[0]
        if channel == nil then
            dir = nil
        else
            dir = @defaultTranscripts + channel
        end
        @pathDir, @pathLog = selectLog(dir)
        watch()
    end
    def selectLog(dir=nil)
        if dir == nil or dir == '' then
            require 'tk'
            window = TkRoot.new {
                title 'KyokoSay'
                withdraw
            }
            dir = window.chooseDirectory('initialdir'=>@defaultTranscripts,'mustexist'=>'1','parent'=>window)
        end
        pattern = "#{dir}/#{Time.now.strftime("%Y-%m-%d")}*"
        log = ''
        Dir.glob(pattern) do |f|
            log = f
        end
        return dir+'/',log
    end
    def watch
        prevLog = Io.fRead(@pathLog)
        FSSM.monitor(File.dirname(@pathLog)) do
            update do |basedir, filename|
                p basedir, filename
                currLog = Io.fRead("#{basedir}/#{filename}")
                diffs = Diff::LCS.sdiff(prevLog, currLog)
                diffs.each do |diff|
                    if diff.action == '+' or diff.action == '!' then
                        message = diff.new_element
                        Kyoko.say(message)
                    end
                end
                prevLog = currLog
            end
            create do |basedir, filename|
                p basedir, filename
                @pathLog = "#{basedir}/#{filename}"
                p @pathLog
                prevLog = []
                currLog = Io.fRead(@pathLog)
                diffs = Diff::LCS.sdiff(prevLog, currLog)
                diffs.each do |diff|
                    if diff.action == '+' or diff.action == '!' then
                        message = diff.new_element
                        Kyoko.say(message)
                    end
                end
                prevLog = currLog
            end
        end
    end
end

KyokoSay.new

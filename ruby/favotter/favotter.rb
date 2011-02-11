#!ruby

# libnotify_bin が必要です。
# apt-get install libnotify_bin

require 'rubygems'
require 'hpricot'
require 'open-uri'

class Favotter
    def initialize
        @favotter_uri = 'http://favotter.net/'
        @save_dir = '/home/ats/ruby/favotter/'
        @hpricot = Hpricot(open(@favotter_uri).read)
    end
    def get
        array = []
        (@hpricot/'div.entry').each do |elem|
            # つぶやき毎にハッシュに格納
            hash = {}
            # つぶやきID取得
            hash[:entry_id] = elem['id']
            # ユーザーアイコン取得
            hash[:user_icon] = (elem/'img.user_icon').first['src']
            # つぶやき取得
            hash[:status_text] = (elem/'span.status_text').first.inner_text
            # ユーザーID取得
            elem_info_user = (elem/'div.info'/'strong'/'a').first
            hash[:user_id] = elem_info_user['title']
            hash[:user_home] = elem_info_user['href']
            hash[:user_name] = (elem/'div.info'/'strong').first.inner_text.gsub(/\n.*\/|\n.*/,'')
            array << hash
        end
        return array
    end
    def save_file(url)
        dirname = @save_dir + "ico/"
        filename = dirname + File.basename(url)
        if not File.exist?(dirname) then Dir.mkdir(dirname) end
        open(filename,'wb') do |file|
            open(url) do |data|
                file.write(data.read)
            end
        end
        return filename
    end
    def show_notify(array)
        # ubuntu ポップアップ通知
        # libnotify_bin が必要です。
        # apt-get install libnotify_bin
        array.each do |hash|
            title = hash[:user_id] + '/' + hash[:user_name]
            body = hash[:status_text]
            filename = save_file(hash[:user_icon])
            system('notify-send -i ' + filename + ' "' + title + '" "' + body + '"')
            print 'notify-send:', hash[:entry_id]
            puts
            p $?
        end
        puts 'complete'
    end
    def write_log(array)
        body = ''
        array.each do |hash|
            body += hash[:entry_id] + "\n"
        end
        filename = @save_dir + 'log.txt'
        f = open(filename, 'w')
        f.write(body)
        f.close
    end
    def read_log
        filename = @save_dir + 'log.txt'
        array = []
        # ファイル存在しなければ空配列を返す
        if not File.exists?(filename) then return array end
        # ただの読み込み
        f = open(filename, 'r')
        f.each do |line|
                array << line.chomp
        end
        f.close
        return array
    end
    def diff(old, new)
        # 差分チェック
        # oldはentry_idだけの配列
        # newはFavotter#getで取ってきたhash
        old = read_log()
        result = []
        new.each do |hash|
            flg = true
            old.each do |old_e_id|
                # 新しく取得したデータならresultにhashを格納
                if hash[:entry_id] == old_e_id then
                    flg = false
                end
            end
            if flg then result << hash end
        end
        return result
    end
end

def start
    puts 'get'
    fav = Favotter.new
    new_data = fav.get
    old_data = fav.read_log

    diff_data = fav.diff(old_data, new_data)

    fav.show_notify(diff_data)

    fav.write_log(new_data)
end

while true do
    start
    # 30分毎
    sleep(1800)
end

exit

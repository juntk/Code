require 'rubygems'
require 'sqlite3'

class Controller
    def initialize()
        sqlitePath = "db/sqlite3/crawl.pixiv"
        @db = SQLite3::Database.new(sqlitePath)
    end
    def setRank(illustId, title, tag, url, imgs, bookmark)
        old = getRankByIllustId(illustId)
        if old.length > 0 then
            if old[0][3].match(tag) == nil then
                tag += old[0][3] + ','
            else
                tag = old[0][3]
            end
            sql = "update rank set title=?, tag=?, url=?, imgs=?, bookmark=? where illustId=?;"
            @db.execute(sql, title, tag, url, imgs, bookmark, illustId)
        else
            sql = "insert into rank (illustId, title, tag, url, imgs, bookmark) values (?,?,?,?,?,?);"
            @db.execute(sql, illustId, title, tag+',', url, imgs, bookmark)
        end
    end
    def getRank(offset=0,count=20)
        sql = "select * from rank limit ? offset ?;"
        raw = @db.execute(sql, count, offset)
        return raw
    end
    def getRankByIllustId(illustId)
        sql = "select * from rank where illustId = ?;"
        raw = @db.execute(sql, illustId)
        return raw
    end
    def getRankByTag(tag, offset=0, count=20)
        sql = "select * from rank where tag like '%"+tag+"%' order by bookmark desc limit "+count.to_s+" offset "+offset.to_s+";"
        raw = @db.execute(sql)
        return raw
    end
end

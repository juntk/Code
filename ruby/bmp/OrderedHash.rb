class OrderedHash
  def initialize
    # キーの順番を保持する配列をつくる
    @index = []
    # キーとバリューを結びつけて保存するハッシュをつくる
    @element = {}
  end
  
  # キーを指定してバリューを取得する
  def [](key)
    @element[key]
  end
  
  # ハッシュに要素を追加する
  def []=(key, value)
    @element[key] = value
    unless @index.include?(key)
      @index << key
    end
  end
  
  # キーに対する関連を取り除く。取り除かれた値を返す
  def delete(key)
    @index.delete(key)
    @element.delete(key)
  end
  
  # すべてのキーの配列を返す
  def keys
    @index.dup
  end
  
  # すべてのバリューの配列を返す
  def values
    @index.map{|key| @element[key]}
  end
  
  # each でハッシュに入れた順番に処理する
  def each
    @index.each do |key|
      yield([key, self[key]])
    end
    self
  end
end

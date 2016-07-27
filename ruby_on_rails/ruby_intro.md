# NCTU+ Rails入門課程 - 2016-07-16
- Lecturer: 曾亮齊(Henry Tseng)
- Email：lctseng.nctuplus@cs.nctu.edu.tw
- 部分教材 Credit to: 5xRuby.tw
- 本講義連結：https://url.fit/ZGLGT

---

# 本次大綱
- [Ruby for Rails](#ruby-for-rails)
  - [常數與變數](#常數與變數)
  - [字串](#字串與符號)
  - [條件式](#條件式)
  - [正規表達式](#正規表達式)
  - [集合](#集合)
  - [迴圈與迭代](#迴圈與迭代)
  - [方法](#方法)
  - [區塊](#區塊)
  - [物件導向程式設計](#物件導向程式設計)

# Ruby for Rails
## 簡介
- Ruby其實非常龐大，並不會在這裡介紹所有的Ruby知識
- 對於入門Rails，先夠用就好
- 練習Ruby的最佳工具之一：irb
  - 互動式的輸入指令，就像rails c那樣
  - 更好的替代方案：pry
    - 安裝：`gem install pry`
    - PLUS上已經有安裝了
- 如何在vim內直接執行我的.rb檔案？
  - 指令模式中輸入：`:!ruby %`
  - 記得先存檔`:w`
- 在Ruby的世界中，所有東西都是物件
  - 可以對他們呼叫方法
  - 例如 `1.class`，可以看到1這個物件所屬的類別
  - 每個物件都可以呼叫"object_id"來看看自己的物件編號
  - 不同編號就是不同的物件
- 注意，Rails並不是一種程式語言，Ruby才是
- [入門手冊](http://guides.ruby.tw/ruby/index.html)
- [Coding Style](https://github.com/cookpad/styleguide/blob/master/ruby.en.md)

## 常數與變數
- 常見資料型態
  - 空值(nil)
  - 布林值(true、false)
  - 整數(可擴展至無限位元數)
  - 浮點數(雙精確度)
  - 字串(動態長度)
  - 陣列(動態長度)
  - 雜湊(類似C++的unordered_map，或者是python的dict)
- 區域變數(local variables)，由a-z和_開頭，以及中文字等寬字元
```
my_name = "lctseng"
age = 18
學校 = "交大"
```
- 常數(Constant)，大寫字母開頭
```
BOOK = "ruby book"
User = "hello, user"
```
- 常數不常
```
Age = 18
Age = 19 # Warning but not error
```
- assignment
  - 變數交換(swap)
  ```
  a = 1
  b = 2
  a, b = b, a # a變成2，b變成1
  ```
  - 多重賦值
  ```
  x, y, z = [1, 2, 3]
  ```
- 全域變數
  - 以`$`開頭，在整個專案中都可以使用的變數
  - 難以管理，非必要請不要使用
  - 若全域變數沒有宣告，使用時會自動擁有預設值：`nil`
    - 常數、區域變數則會噴error
    - 也因此，可能會發生`$foobar`打成`$fobar`而引發的的蠢BUG
  - Ruby內建中有些許全域變數，之後若需要使用到會再介紹

## 字串與符號
- 字串處理是Ruby中的強項
- 字串是可修改的(mutable)，不像python那樣字串是常數
  - 因此使用太多字串在Ruby內會讓效能變差
- 字串表達法
  - 有跳脫(例如`\n`會被解釋成換行，需用`\\`來表達`\`這個字元本身)
    - "字串內容"
    - %Q{字串內容}
```
pry(main)> print "\n"

=> nil
```
  - 無跳脫(寫甚麼就是甚麼)
    - '字串內容'
    - %q{字串內容}
```
# '\n' => "\\n"
[26] pry(main)> print '\n'
\n=> nil
```
- 字串操作
  - 字串相加：`a+b`，回傳連接後的新字串，原先兩個字串都不改變
  - 字串重複：`"foo"*3`，原先的字串不改變
  - 串接字串，將原本的字串加長，但不產生新字串
    - 與字串相加的差異：效能更佳，不必產生新的字串物件
    - 用法：`<<`或`concat`
    ```
    a = "foo"
    b = "bar"
    a << b
    # 或 a.concat(b)
    ```
    - 雖然也可以用 a = a + b (簡寫為a += b)，但是效能相對差，應避免使用
      - 產生新物件，又把原本的物件free掉，是浪費效能的作法(稍後會示範)
- 字串安插
  - 能將變數插入在字串中，類似sprintf，但是沒有format的效果
  ```
  name = "lctseng"
  age = 18
  puts "hi, I'm #{name}, and I am #{age} years old"
  ```
- 字串format
  - 如果想進行C那樣的printf或sprintf，Ruby也是支援的
  ```
  foo = 123
  bar = 0.1
  printf("%05d %.3f",foo,bar)
  result = sprintf("%05d %.3f",foo,bar)
  ```
  - sprintf好像很好用，可是每次要打這個function name就覺得麻煩
    - 偷懶點
    ```
    foo = 123
    bar = 0.1
    # 只有一個變數要format的情況
    "%05d" % foo
    # 有兩個以上，要用陣列的寫法
    "%05d %3f" % [foo,bar]
    ```
- 字串其他功能
  - 反轉(reverse)
  - 局部擷取(sub string)
  ```
  a  = "abcdef"
  a[3,2] #=> "de"
  ```
  - 局部替換(使用[]，跟C一樣，但是可以替換成一個子字串)
  ```
  a = "foo"
  a[1] = "bar"
  p a #=> fbaro
  ```
- 符號
  - 跟字串類似，但卻是不可變動的
  - 效能非常好，如同操作一般整數一樣，但是沒有字串操作
  - 用途：用來識別，替某些東西取不會變動的名字
  - 用法：以冒號(:)開頭，而非使用引號
  ```
  s = :this_is_a_symbol
  ```
  - 以上的表示法無法在symbol內包含空白，如果要用任何字元組成symbol，就回到類似字串的寫法，但是加上冒號
  ```
  s = :"this is a symbol with any characters, like colon :"
  ```
  - 同樣內容的symbol，在ruby內只換產生一個object_id
    - 反觀字串，即使內容一樣，每次的object_id都不同
    - 因此盡量避免在迴圈中使用字串常數，否則請盡量使用Symbol
    - 如何檢視字串浪費？
      - 使用gem：`allocation_stats`，限制：需要Ruby版本2.1以上，PLUS主機不適用
        - 查看Ruby版本：`ruby -v`
        - 若使用VM，Ruby版本會是2.3，就可以使用這個gem
      - 安裝：`gem install allocation_stats`
      - 執行一段浪費的code：
      ```
      require 'allocation_stats'

      def process
        5.times do
          "lctseng" # 甚麼事情都沒做！
        end
      end

      stats = AllocationStats.trace { process }
      puts stats.allocations(alias_paths: true).to_text

      ```
      - 記憶體結果：
      ```
      sourcefile  sourceline  class_path  method_id  memsize  class
      ----------  ----------  ----------  ---------  -------  ------
      hello.rb             5              process         40  String
      hello.rb             5              process         40  String
      hello.rb             5              process         40  String
      hello.rb             5              process         40  String
      hello.rb             5              process         40  String
      ```
      - 換成Symbol
      ```
      def process
        5.times do
          :"lctseng" # 在前面加上「:」就成了Symbol
        end
      end
      ```
      - 結果：甚麼都沒有，因為Symbol被當作常數處理，沒有動態allocate
    - 字串使用`+=`造成浪費的例子
      - 使用`+=`
      ```
      def process
        a = "foo"
        b = "bar"
        a += b
      end
      ```
      - 結果
      ```
      sourcefile  sourceline  class_path  method_id  memsize  class
      ----------  ----------  ----------  ---------  -------  ------
      hello.rb             6              process         40  String
      hello.rb             5              process         40  String
      hello.rb             4              process         40  String
      ```
      - 使用`<<`
      ```
      def process
        a = "foo"
        b = "bar"
        a << b
      end
      ```
      - 結果
      ```
      sourcefile  sourceline  class_path  method_id  memsize  class
      ----------  ----------  ----------  ---------  -------  ------
      hello.rb             5              process         40  String
      hello.rb             4              process         40  String
      ```
  - Symbol出現的地方：在model 裡面
  ```
  has_many :posts
  ```
  - Symbol與字串間的轉換
  ```
  foo = "string"
  bar = "symbol"
  foo.to_sym
  bar.to_s
  ```

## 條件式
- if-else，基本上與C類似，但有些許差異
```
if 條件1
  內容1
elsif 條件2
  內容2
elsif 條件3
  內容3
else
  內容4
end
```
- 條件可以不需要小括號，內容也不需要大括號，不依賴縮排，結尾需要用end
- 條件可以用否定(!)，且(&&)，或(||)串接
- unless：if的相反，當條件不成立才去執行內容。如果有可以用unless的情況，請盡量使用(但也別刻意)
```
# 如果遇到
if !條件
  內容
end
# 最好換成
unless 條件
  內容
end
```
- 如果內容只有單行，則條件可以塞在該行後面
```
if a > 5
  var = "Hello"
end
# 可以寫為
var = "Hello" if a > 5
```
- 還可以把if-else的結果當作assign變數的值
```
a = 5
b = 10
c = if a > b
      "A > B"
    else
      "A <= b"
    end
puts c #=> "A<=B"

```
- if-else其實也可以硬縮成一行，此時需要搭配then
```
c = if a > b then "A > B" else "A <= b" end
```
- case-when
  - 相當於C的switch-case
  - 沒有fall-through (不需要break)
  - case：C的switch
  - when：C的case
  - else：C的default
  - 可以判斷數字、字串、符號
  - 例如
  ```
  var = gets
  case var
  when "foo"
    內容
  when "bar"
    內容
  when "aaa","bbb"
    內容
  else
    內容
  end
  ```
  - 一樣可以當作變數assign的值
  ```
  a = 5
  b = case a
      when 5
       :is_5
      when 10
       :is_10
      else
       :else
      end
  puts b #=> "is_5"
  ```

## 正規表達式
- 主要用處：找出字串中的某些關鍵字
- 由於內容其實非常多，這裡只簡單介紹要如何使用基本款
- 具有特殊意涵的控制字元
  - `[]`：指定的範圍（例如：[a-z] 表示一個在 a 到 z 的範圍內的字母）
  - `\w`：一般字元 (word character)，即 [0-9A-Za-z_]
  - `\W`：非一般字元 (non-word character)
  - `\s`：空白字元 (space character)，即 [ \t\n\r\f]
  - `\S`：非空白字元 (non-space character)
  - `\d`：數字 (digit character)，即 [0-9]
  - `\D`：非數字 (non-digit character)
  - `\b`：退位 (0x08)（僅用於指定的範圍）
  - `\b`：單字邊界（若不是於指定的範圍）
  - `\B`：非單字邊界
  - `*`：前一符號的內容出現 0 或數次。
  - `+`：前一符號的內容出現 1 或數次。
  - `{m,n}`：前一符號的內容，最少出現 m 次，最多出現 n 次。
  - `?`：前一符號的內容最多出現一次，同 {0,1}。
    - 特殊用途：若緊接在`*`與`+`之後，代表lazy match
  - `|`：符合前一個或後一個表示式
  - `()`：分組
- 語法：使用`//`把樣式(pattern)寫在裡面，並搭配`=~`運算子
  - 被`()`指定分組的字串，匹配結果會被儲存在全域變數`$1`、`$2`等位置
- 範例：找出特定子字串
```
a = "hello, lctseng! Your score is 87 today!"
if a =~ /hello, (\w+)! .*score is (\d+)/
  puts "#{$1}-#{$2}" #=> lctseng-87
else # 如果不滿足指定樣式
  puts "Not a valid format!"
end
```
- 範例：找出子字串並取代
```
a = "hello, lctseng! Your score is 87 today!"
if a.sub!(/\d+/,"***SECRET***")
  puts a #=> hello, lctseng! Your score is ***SECRET*** today!
else
  puts "Not found"
end
```
- 範例：尋找樣式出現在字串的位置
```
"aaabc" =~ /abc/ #=> 得到2，代表字串的index = 2之處開始滿足樣式
```
- 把字串轉為正規表達式
```
regex = Regexp.new("some string")
if str =~ regex
  # do something
end
```
- 或者使用字串安插
```
var = "b"
regex = /a#{var}c/
```
- 修飾字
  - 放在正規表達式後方，用來改變匹配時的行為
  - 常用的修飾字：`i`，代表忽略大小寫
  ```
  str = "aBc"
  if str =~ /(abc)/i
    puts $1 #=> "aBc"
  end
  ```
- 線上練習：[Rubular](http://rubular.com/)

## 集合
- Array
  - 表示法：使用中括號
  ```
  friends = ["eddie", "jonh", "mary", "ema"]
  ```
  - 變數本身沒有型態，因此陣列的內容也可以是任意型態，元素間的型態也可以不相同
  ```
  objects = ["string", :symbol, 123, 0.456, true, nil, ["2-dim array",:inner_array], {}]
  ```
  - 存取方法：使用中括號
  ```
  friends = ["eddie", "john", "mary", "ema"]
  first_friend = friends[0]
  last_friend = friends[-1]
  some_friends = friends[0,2] #=> ["eddie", "john"]，從第0個開始數兩個
  some_friends = friends[0..1] #=> ["eddie", "john"]，從第0個到第1個
  some_friends = friends[0...2] #=> ["eddie", "john"]，從第0個到第2個之前
  ```
  - 聽說array out of bound在其他語言會大爆炸，Ruby呢？
    - 沒這回事，只是他會給你nil
    ```
    a = [1,2,3]
    a[10] #=> nil，不會爆炸，但a維持原來的內容

    a[10] = 4 #=> 寫入在長度以外的地方，會自動拉長陣列
    a #=> [1, 2, 3, nil, nil, nil, nil, nil, nil, nil, 4]
    ```
  - 字串陣列
    - 當要寫出一個由字串組成的陣列時，可以使用此簡寫
    - 不包含空白字元的字串
    ```
    %w(hello world lctseng) # 相當於 ['hello', 'world', 'lctseng']
    %W(hello world lctseng) # 相當於 ["hello", "world", "lctseng"]
    ```
  - 符號陣列
    - 類同字串陣列語法，表示不包含空白字元的符號陣列
    ```
    %i(hello world lctseng)
    # 或使用 %I(...)
    ```
- Range
  - 用來表示一個範圍
  ```
  (-3..10) #=> -3, -2, -1, 0, 1, 2, 3 ... 10，包含尾端
  (-3...10) #=> -3, -2, -1, 0, 1, 2, 3 ... 9，不包含尾端
  ```
  - Range轉Array
  ```
  (1..5).to_a #=> [1, 2, 3, 4, 5]
  [*1..5] #=> [1, 2, 3, 4, 5]
  ```
- Hash
  - 許多key-value pair的集合
  - 存取方法：一樣是中括號，只是這次括號內填寫的是key而非第幾個
  - 範例
  ```
  # 用數字當key(類似array)
  h1 = {1 => "data", 2 => 0.123}
  h1[1] #=> "data"
  h1[0] #=> nil，該值沒有設定，就會出現nil
  h1[0] = "Hi" #=> 替key = 0設定新的value為"Hi"

  # 用字串當key
  book = {"title" => "Ruby", "price" => 350}
  book["title"] #=> "Ruby"

  # 用符號當key (Rails常用)
  book = {:title => "Ruby", :price => 350}
  book = {title: "Ruby", price: 350 } # 符號當key的特殊寫法
  book[:title] #=> "Ruby"
  ```
  - 取出所有的key所成的陣列：`hash.keys`
  - 取出所有的value所成的陣列：`hash.values`

## 迴圈與迭代
- 次數.times
  - 做指定次數
  ```
  5.times do
    puts "hello, ruby"
  end
  ```
  - 取出目前是第幾次(從0~次數-1)
  ```
  5.times do |i|
    puts "hello, ruby #{i}"
  end
  ```
- 起點.upto(終點)
  - 類似times，但可以指定數字i的範圍。起點和終點的數字都會包含
  ```
  1.upto(5) do |i|
    puts "hi, ruby #{i}"
  end
  ```
- for迴圈
  - 可以達到累次upto的效果
  ```
  for i in 1..5
    puts "hi, ruby #{i}"
  end
  ```
  - 後面可以接Range代表數字範圍，也可以是陣列
  ```
  friends = ["eddie", "joanne", "john", "mark"]
  for friend in friends
    puts friend
  end
  ```
- while/until迴圈
  - 語法類似if/unless
  ```
  while a > b
    i += 1
  end  

  until a <= b
    i += 1
  end
  ```
  - 也可縮成單行
  ```
  i += 1 while a > b
  i += 1 until a <= b
  ```
- begin-end-while迴圈
  - 類似C的do-while
  - 先做一次迴圈的內容，然後再檢查條件是否滿足
  ```
  begin
    # do something
  end while 條件
  ```
- each
  - Ruby中最常用的寫法，也適用於陣列
  ```
  friends = ["eddie", "joanne", "john", "mark"]
  friends.each do |friend|
    puts friend
  end
  ```
  - 也可以順便把index(第幾個)拿出來
  ```
  friends = ["eddie", "joanne", "john", "mark"]
  friends.each_with_index do |friend, x|
    puts "#{x} #{friend}"
  end
  ```
  - 在view裡面，常常會看到使用迭代(each)的方式
  - 與Hash相關的each
    - 直接使用：分別取得每一對key-value
    ```
    data = { name: "lctseng", age: 18 }
    data.each do |key,value|
      puts key
      puts value
    end
    ```
    -  配合keys/values與陣列的each，對每個key/value做處理
    ```
    data.keys.each do |key|
      # ...
    end
    ```
    - 上述方式有更好的寫法
    ```
    data.each_key do |key|
      # ...
    end
    ```
- 練習：
  - 印出1到100的總和
  ```ruby
  [*1..100].reduce(:+)
  ```
  - 印出1到100中的單數
  ```ruby
  [*1..100].select {|x| x.odd?}.reduce(:+)
  ```
- 還有許多其他的迭代運算
  - map：將內容物一個一個做轉換
  - select：選出滿足條件的內容
  - reject：移除滿足條件的內容
  - reduce：將內容物經過特定運算得出一個單一答案(例如加總)

## 方法
- 呼叫方法
  - 直接呼叫
  ```
  hash = { name: "lctseng", age: 18}
  hash.values # 取得該hash的value所成的陣列：["lctseng", 18]
  ```
  - 呼叫方法的回傳值可以再用來串接下一個方法，甚至包含可以區塊
  ```
  [*1..10].select{|n| n.odd?}.map{|n| n**2}
  ```
- 定義方法
```
def say_hello_to(name)
  puts "hello, #{name}"
end
say_hello_to("lctseng")
# 小括號經常可省略
say_hello_to "lctseng"
```
- 特殊的方法名稱：?與!
  - 可以是方法名稱的一部份，但只能放在最後一個字
  - 以?結尾的方法，通常回傳true或false
  - 以!結尾的方法，通常會在過程中影響原來的值
  - 沒有硬性規定，只是希望大家共同遵守
  - 目的：接近自然語言，更加直覺
  - ?範例
  ```
  def is_adult?(age)
    if age >= 18
      return true
    else
      return false
    end
  end
  if is_adult?(20)
    puts "成年人"
  end
  ```
  - !範例
  ```
  list = [1, 2, 3, 4, 5]
  p list.reverse # [5, 4, 3, 2, 1]
  p list         # [1, 2, 3, 4, 5]，原本的list內容沒有改變

  p list.reverse! # [5, 4, 3, 2, 1]
  p list          # [5, 4, 3, 2, 1]，原本的list遭到修改
  ```
- 回傳值
  - 使用return：如同其他語言
  - 但若沒有return，Ruby會把最後一行執行的指令的值視為回傳值
  ```
  def is_adult?(age)
    if age >= 18
      true
    else
      false
    end
  end
  ```
  - 多重回傳值
  ```
  def function
    return [1,2]
  end
  a, b = function # 方法呼叫，得到a = 1，b = 2

  ```

## 區塊
- 即程式碼區塊，可以把一段的程式碼內容打包起來，丟到別的地方執行
  - 區塊也有參數，也就是`|i|`內的變數
- 平常使用的each即是區塊的應用
- 區塊的兩種寫法 (但沒有硬性規定)
  - 區塊內有多行時，通常使用
  ```
  5.times do |i|
    puts i
    # other stuff...
  end
  ```
  - 若只有單行，通常用
  ```
  5.times { |i|
    puts i
  }
  # 通常縮成
  5.times { |i| puts i } # 習慣上會在兩端加空白
  ```
- 使用區塊：通常在寫某些方法的時候，想把某一段處理交給使用者來決定，就會希望使用者傳區塊
  - 範例
  ```
  def greeting(name)
    yield name
  end
  greeting("lctseng") { |n|
    puts "Hello, #{n}"
  }
  ```
  - 另一個範例：自己寫一個`each`
  ```
  def each(array)
    for item in array
      yield item
    end
  end
  each([1,2,3,4]) do |i|
    p i
  end
  ```
  - 區塊可以有多個參數
  ```
  def greeting(name1,name2)
    yield name1, name2
  end
  greeting("lctseng","alice") { |a,b|
    puts "Hello, #{a} and #{b}"
  }
  ```
- 區域變數Scope
  - 對C/C++來說，區域變數的生存範圍在{}之間，通常是if-else或迴圈內
  - 對Ruby來說，if-else和迴圈並不會影響變數Scope
  ```
  if a > b
    c = true
  else
    c = false
  end
  p c # 變數c在if-else內宣告並初始化，但是離開之後還是可以取用
  ```
  - 但是區塊就不行了，因為區塊並不是當下執行，而是丟到別的地方
  ```
  5.times do |i|
    a = i # 這裡的a只有活在block被執行的當下
  end
  p a # 錯誤：a未定義
  ```
  - 但是區塊卻擁有綁定(binding)的特質
  ```
  a = 1
  5.times do |i|
    a = i # 這裡的a不是新定義的，而是外面的a的reference (類似C++的pass by reference)
  end
  p a # a的值是4，明顯在block執行中，a的值受影響
  ```

## 物件導向程式設計
- Ruby真的是物件導向的程式語言，沒騙你
  - `$Ruby.is_a? (Object) {|oriented| language} #=> true`
- 定義類別：類別的命名必須是常數
```
class Animal
  def eat(food)
    puts "#{food} is Yammy!!"
  end
end
```
- 建構子(constructor)
  - initialize方法
  - 外面呼叫需使用new方法，參數會完整轉給initialize來執行
  ```
  class A
    def initialize(arg)
      puts "Hello, #{arg}"
    end
  end

  obj = A.new("World!")
  ```
- 繼承
  - 子類別擁有父類別的特徵
  ```
  class Cat < Animal
  end
  ```
- 建立類別實體(或稱實例，instance)
```
tommy = Cat.new
tommy.eat "fish" #=> fish is Yammy!
```
- 實體變數(實例變數)：instance variables
  - 即C++的class的member variables
  - 活在每個實體之內
  - 變數開頭有`@`符號
  ```
  @name = "lctseng"
  @age = 18
  ```
  - 在controller中有看到
  ```
  class PostsController < ApplicationController
    def index
      @posts = Post.all # 把結果存成實體變數
    end
  end
  ```
  - 與區域變數的差別
    - 區域變數只存活在當下的method
    - 實體變數的生存範圍是跨method的
    - 區域變數如果未定義就使用，會噴error，但是實體變數未定義，會有預設值nil
      - 因此容易發生因為打錯字，卻因為預設是nil而找不到BUG的情形
- 實體方法
  - 類似C++的member function
  ```
  class Cat
    def sleep
      # ...
    end
  end
  kitty = Cat.new # kitty是Cat類別的實體
  kitty.sleep # sleep是作用在kitty這個實體上的實體方法
  ```
  - self：存取呼叫的物件本身，相當於C++的this
  ```
  class Cat
    def sleep
      # ...
      self.meow # 呼叫自己的meow方法，不過這裡的self.可以省略
    end

    def meow
      # ....
    end
  end
  ```
- 單體方法(Singleton methods)
  - 可以替某一個已經建立出來的類別實體定義方法
  ```
  class SingletonTest
    def size
      25
    end
  end

  test1 = SingletonTest.new
  test2 = SingletonTest.new

  def test2.size
    10
  end

  test1.size #=> 25
  test2.size #=> 10
  ```
- 類別方法
  - 相當於C++的class function(用static定義的function)
  ```
  class Cat
    def self.all
      # ...
    end
  end

  Cat.all # 呼叫Cat這個類別的類別方法
  ```
  - 注意這裡一樣用到了self，但是語意和instance method中的self不同
- 類別變數
  - 相當於C++的class variable(用static定義在類別內的變數)
  - 以`@@`開頭，所有的類別實體都可以存取，共用同一份
  - 類別方法只能存取`@@`變數，而不能存取`@`變數
  ```
  class Cat
    def initialize
      @@count = 0 unless defined? @@count
      @@count += 1
    end

    def self.count
      @@count = 0 unless defined? @@count
      puts "There are #{@@count} cat(s)"
    end
  end

  Cat.count # There are 0 cat(s)
  a = Cat.new
  Cat.count # There are 1 cat(s)
  b = Cat.new
  Cat.count # There are 2 cat(s)
  ```
- 開放類別(Open Class)
  - 可以隨時重新定義已定義的類別的內容
  - 例如：我們替內建類別String增加一點東西
  ```
  class String
    def say_hello
      "hi, I am #{self}"
    end
  end

  puts "lctseng".say_hello #=> hi, I am lctseng
  ```
- private與public
  - 與C++的public/private概念不同
  - private: 實體方法不可以有明確的caller(在Ruby中稱為receiver)
  - 使用public/private
  ```
  class Cat
    public
    # 若省略，預設都是publc

    def public_method_1(arg)
    end

    def public_method_2(arg)
    end

    private
    # 以下的方法都是private

    def private_method_1(arg)
    end

    def private_method_2(arg)
    end
  end
  ```
  - 造成的效果
  ```
  tommy = Cat.new

  tommy.public_method_1("Hello") # OK
  tommy.private_method_1("Hello") # Error!

  class Cat
    def some_method
      private_method_1("Hello") # OK!
      self.private_method_1("Hello") # Error!
    end
  end

  ```
  - 如何繞過這個限制？使用`send`
  ```
  tommy.send(:private_method_1,"Hello") # OK!

  class Cat
    def some_method
      self.send(:private_method_1,"Hello") # OK!
    end
  end
  ```
  - send給自己send
  ```
  tommy.send(:send,:send,:send,:send,:some_method,arg)
  ```
  - private在Rails中使用情境
    - 定義那些不想要成為action的method
    ```
    class SomeController
      def index # 可以成為action
        # do something...
        some_process # 呼叫內部使用的方法
        # do something...
      end

      private

      def some_process # 不可以成為action，無法從routes.rb中指定
        # do something...
      end
    end
    ```
- 模組(Module)
  - 情境：我有一隻貓，我希望這隻貓會飛
  - 可能的答案：建立一個鳥類別，然後叫貓去繼承它！？
  - 正確的方式：建立一個飛行模組，然後裝到貓身上
  ```
  module Flyable
    def fly
      puts "I can fly"
    end
  end

  class Cat
    include Flyable # 引入模組
  end

  kitty = Cat.new
  kitty.fly
  ```
  - 模組的另一個用途：當作命名空間(namespace)
    - 範例
    ```
    class User < ActiveRecord::Base
    end
    ```
    - 這裡的ActiveRecord其實只是一個模組，真正的類別是Base
- 練習
  - 解釋由scaffold產生的controller和view中的每一行在做甚麼
  - 若使用VM虛擬機環境，有一個範例專案放在home目錄：`demo_blog`

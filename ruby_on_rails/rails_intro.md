# NCTU+ Rails入門課程 - 2016-07-30
- Lecturer: 曾亮齊(Henry Tseng)
- Email：
  - lctseng.nctuplus@cs.nctu.edu.tw
  - lctseng@5xruby.tw
- 部分教材 Credit to: 5xRuby.tw
- 本講義連結：https://url.fit/ZtukQ

---

## 本次大綱
- 使用scaffold
- MVC與RESTful
- Rails網站架構
- 使用Rails Console
- Rails慣例
- Gem的使用
  - 美化頁面
  - 資料分頁
- 佈署到Heroku：讓全世界看到你的網站

## 使用scaffold建立一個CRUD網站框架
- 快速的建立第一個Rails應用程式
- CRUD：Create, Read, Update, Delete，也就是對網站物件的操作
- scaffold：Rails用來快速建立網站的工具
- 試著設計一個網頁：
  - 搭建一個可以發文的blog系統
  - 可以給很多使用者(user)註冊
  - 每個作者可以新增、修改或刪除自己的文章(post)
  - 每篇文章可以有很多留言(comment)
- 流程
  1. 尋找一個適合的目錄，並建立Rails專案
    - 這個步驟會在當前目錄建立一個稱為`blog`的資料夾
    裡面就是你的Rails專案
    ```
    rails new blog
    ```
  2. 安裝套件
    - Rails是由許多Ruby gem組成的一個網頁框架
    - 雖然我們建立專案了，但是對於一個網站能正常運作的gem，可能都還沒安裝
    - Rails幫我們產生了一份Gemfile，裡面列了一個基本的網站所需要的gem
    - 一鍵安裝：使用之前提到的bundler
    ```
    bundle install
    ```
    - 權限問題：有時候安裝會遇到缺少系統管理員權限
      - 原因：bundle安裝gem時預設會替所有使用者安裝，這需要管理員權限
      - 可以用以下指令，只替這個專案安裝(而非所有使用者)
      ```
      bundle install --path vendor/bundle
      ```
      - 聽說有一個指令叫做`sudo`，我可不可以用`sudo bundle install`
        - **DON'T DO THAT!!!** 你會毀了這個專案(其他使用者將無法正常bundle install)
        - 血淋淋的例子：nctuplus
          - 對，就是nctuplus，你沒看錯
          - 其他血淋淋事蹟請自行上網Google
        - 如果真的想安裝給所有使用者
          - 仍只需要正常下`bundle install`
          - 系統會在合適的時間提醒你輸入sudo密碼，而不會毀了這個專案
  3. 快速建立使用者(User)
    - 建立之前，要先想好一個user在資料庫中需要怎麼樣的column
      - id：integer，auto increment(自動跳號)，primary key(主鍵)
      - name：string
      - email：string
    - 指令：`rails generate scaffold User name:string email:string`
      - 或者可以簡寫為`rails g scaffold User name email`
    - 這個指令做完之後，這個使用者所需要的MVC全都建立好了
  4. 更新資料庫
    - 使用scaffold建立好MVC之後，他的SQL仍然沒有執行，因此資料庫中還是沒有建立user的table
    - 資料表遷移：把model資訊寫入資料庫
    - 指令：`rake db:migrate`
    - 如果想撤回資料庫修改，可以用：`rake db:rollback`
  5. 啟動server
    - 在你的專案目錄下，執行`rails server`
      - 簡寫為`rails s`
    - 這樣就會預設在3000 port開啟你的程式
    - 如果你是用PLUS主機 (使用虛擬機者不必擔心此問題)
      - PLUS上的3000 port只有一個，大家需要各自換到3000~4000中的port
      - 使用`rails s -p 3087`來切換port
        - 怕重複？大家用自己的學號後三碼加上3000來當作port number
        - 如果還是重複就自己想辦法避開吧
  6. 瀏覽網頁
    - 瀏覽`plus.nctu.edu.tw:3087`
      - 如果是灌在虛擬機或者是Mac本機上，就把前面的網址換成虛擬機IP或者localhost
      - 例如：`localhost:3000` (假設使用預設的3000 port)
    - 應該會看到一個Rails的廣告，這並不是你寫的
    - 如果想看到你剛才建立的使用者系統，請瀏覽`plus.nctu.edu.tw:3087/users`
    - 想看json版？請瀏覽`plus.nctu.edu.tw:3087/users.json`

## MVC概念
- 網頁開發的規範
- Model：定義網站中每個物件的行為
  - 使用者、帳號、二手書資訊、課程資訊都是物件
  - 通常對應到資料庫中的一個table
- View：網站的外觀，即HTML/CSS等等
  - 與原生HTML不同的是，View的內容是可程式化的，根據不同的條件可以產生不同內容
  - 除了HTML，Rails也允許生成其他格式的資料
    - 例如JSON、XML等API server會用到的
- Controller：決定某一個網址路徑要做甚麼事，包含使用者的操作(例如點選按鈕等等)
  - 例如，使用者進入N+首頁之後，要做甚麼事情；使用者按下送出後，要進行甚麼動作等等

## Route: 路徑
- Route：決定網址與Request對應到controller的關係
- 當客戶端使用者(client)使用瀏覽器送出一個需求(Request)的時候，會經過甚麼流程？
  - 一個Request包含了一組網址(URL)與對應的HTTP動詞(Verb)
    - 一般來說，動詞並不會直接在瀏覽器上看到，除非使用**開發者模式**
      - 以chrome為例，按下`F12`之後選擇`Network`標籤，即可檢視接下來的Request網址與動詞
    - 常見的動詞：GET、POST、PUT、PATCH、DELETE
      - GET：用來取得資訊，沒有修改的動作
      - POST：產生新的資料(create new record)
      - PUT & PATCH：更新現有的資料(update record)
      - DELETE：移除資料(delete record)
  - 流程
    1. 瀏覽器送出Request，包含了網址與動詞，進入到Rails應用程式
    2. Rails查詢routes，找出這個Request對應的controller的action是哪一個
    3. 執行相對應的controller action，並與model互動，新增、讀取、更新、刪除資料庫中的資料
    4. 資料處理完後，顯示對應action名稱的view，並將顯示出的HTML傳回給瀏覽器顯示

## RESTful Route
- 檔案位置：`config/routes.rb`
- RESTful是啥？
  - [Wiki傳送門](http://zh.wikipedia.org/wiki/REST)
  - 不同的網址 + 不同的HTTP verb對應到不同的操作
  - 簡單來說，是希望大家遵守的一種規範
- 由於是一套規範，Rails可以很輕鬆的設定
  - 在`config/routes.rb`中的`resources :users`
- 如何看當前網站的所有網址路徑？
  - `rake routes`
- 如果使用`pry`作為`rails c`
  - 可使用`show-routes`快速顯示所有網址路徑
- 路徑說明
  - 直接下`rake routes`或pry的`show-routes`後，可以看到
  ```
     Prefix  Verb    URI Pattern                Controller#Action
      users  GET     /users(.:format)           users#index
             POST    /users(.:format)           users#create
   new_user  GET     /users/new(.:format)       users#new
  edit_user  GET     /users/:id/edit(.:format)  users#edit
       user  GET     /users/:id(.:format)       users#show
             PATCH   /users/:id(.:format)       users#update
             PUT     /users/:id(.:format)       users#update
             DELETE  /users/:id(.:format)       users#destroy
  ```
  - 格式：Prefix、Verb、URI(網址)、Controller#Action
    - Prefix：路徑的變數名稱，把後面的網址(URI)存成變數
      - 變數取用：`Prefix_path`
      - 好處：以後如果要改某一個網址的變數內容，不必每一個用到的地方都改
      - 檢視prefix變數對應到的網址：在`rails c`中使用`app.users_path`
    - Verb：對應到的HTTP動詞
    - URI：對應到的網址
      - `.format`代表要顯示的網頁格式，例如HTML或JSON。省略的話，預設是HTML
      - HTML範例：瀏覽`/users.html`，或者是省略為`/users`
      - JSON範例：瀏覽`/users.json`
    - Controller#Action：該網址&動詞所對應到的controller與action
  - 逐條解釋(順序有調動)
  - `user      GET    /users/:id(.:format)       users#show`
    - 顯示某一個已存在的user
    - 語意
      - 使用動詞GET：代表取得資訊
      - prefix使用單數：因為是取得某 **一個** user
      - 網址中有ID，代表指定該user存在資料庫中的ID
  - `users     GET    /users(.:format)          users#index`
    - 顯示所有user
    - 語意：
      - 使用動詞GET，代表取得資訊
      - 沒有指定id，prefix使用複數名詞，代表沒有特定對象
  - `users     POST   /users(.:format)          users#create`
    - 建立新的user(送出表單到後端)
    - 前半段prefix沒顯示，代表和上一條使用同樣的prefix(因此也是users_path，但動詞不同，不搞混)
    - 語意
      - 使用動詞POST，代表送出資料 (表單的送出按鈕)
      - 由於是新增加的使用者，在執行時尚未加入資料庫，因此也沒有ID可以指定。
      - prefix使用複數：與`user_path`區別。單數用來顯示單一個user
  - `new_user  GET    /users/new(.:format)      users#new`
    - 建立新的user(顯示填資料的表單)
    - 與前者的差異
      - 前者是填完表單後按下送出(Submit)要做的事情
      - 這一個是當你點選"新增user"時，看到可以讓你填資料的那個畫面
    - 語意
      - 使用動詞GET，代表取得資料(取得那一個讓你填資料的表單)
      - 同樣沒有實際存在的user，因此也沒有ID
      - prefix與URI不同了：因為`/users`搭配動詞GET已經被用掉，需要用不同的prefix與URI來區別
      - prefix使用單數：代表新增一個user (編輯一個新的user的資料)
  - `edit_user GET     /users/:id/edit(.:format)  users#edit`
    - 修改user資料(顯示填資料的表單)
    - 類同`users#new`，只是這一次是更改user的資料
    - 語意：
      - 使用動詞GET：僅是取得表單與user的資料
      - 有出現ID：因為是修改某一個已經存在的user資料，故指定其資料庫中的ID
      - prefix使用單數。多使用`edit_`是要跟`users#show`、`users#new`區別
  - `user      PATCH   /users/:id(.:format)       users#update`
    - 送出修改後的user的資料(修改完後送出表單)
    - 類同`users#create`，只是這一次是修改而非新增
    - 語意
      - 使用動詞PATCH：代表修補、更新資料
      - 有出現ID：因為是修改某一個已經存在的user資料
      - prefix使用單數，沒有其他單字(沒有edit)：代表單純對一個user操作
  - `user      PUT     /users/:id(.:format)       users#update`
    - 同前者，只是支援另一個類似用途的HTTP動詞：PUT
    - 兩者對應到同一個action
  - `user      DELETE  /users/:id(.:format)       users#destroy`
    - 刪除某一個已存在的使用者
    - 語意
      - 使用動詞：DELETE，代表刪除
      - 有出現ID：因為是修改某一個已經存在的user資料
      - prefix使用單數：對一個單一的user操作

## 瀏覽網頁架構
- MVC
  - Model (app/models/user.rb)
    - 用來定義使用者物件本身的行為
  - View (app/views/users/index.html.erb，以及其他同個資料夾下的檔案)
    - 不同情況下要用的不同的HTML內容
    - `index.html.erb`：使用者列表
    - `show.html.erb`：顯示單一個使用者詳細資訊
    - `new.html.erb`：新增使用者
    - `edit.html.erb`：編輯使用者
    - `_form.html.erb`：表單，給new和edit共用的
      - 底線開頭為共享頁面，希望可以減少程式碼的重複程度
      - new與edit中出現的`render "form"`即是產生這個共用頁面
  - Controller (app/controllers/users_controller.rb)
    - 包含許多action，例如index、new等等，有些會對應到view的名稱
    - 例如執行完`UsersControllers#index`，就會去產生`users/index.html.erb`
    - 在controller中的instace variables可以沿用到views裡面
      - 例如：
      ```
      <tbody>
        <% @users.each do |user| %>
          <tr>
            <td><%= user.name %></td>
            <td><%= user.email %></td>
            <td><%= link_to 'Show', user %></td>
            <td><%= link_to 'Edit', edit_user_path(user) %></td>
            <td><%= link_to 'Destroy', user, method: :delete, data: { confirm: 'Are you sure?' } %></td>
          </tr>
        <% end %>
      </tbody>
      ```

## Rails專案架構
- app/*
  - models
    - 放置各個model
    - concern資料夾：放置models共用的code
  - views
    - 根據controllers，有各自的資料夾
    - layouts資料夾：放置網頁外型HTML檔案(header，footer等等)
      - 為何使用layouts？
        - 網站中上方的導覽列與底下的版權列通常希望固定
        - 使用者在瀏覽頁面時只會更換網頁中間的內容
      - layout就像是網站的外框樣板，讓許多網頁可以共用，只需要抽換內頁
  - controllers
    - 放置各個controller
    - concern資料夾：放置controllers共用的code
    - 特殊檔案：`application_controller.rb`
      - 所有controller的共同父類別，可放置共用code
      - 寫在這個地方的code，所有controller都可以用的到
  - helpers
    - 給controllers用來include用的
    - 可以放些讓多個controller共用的code
    - 與application_controller不同的地方
      - 可決定哪些controller才能include，哪些不行
      - 寫在helper的方法可以給view呼叫
  - mailer
    - 和寄信有關，之後相關章節會介紹
- lib/*
  - 在這裡的code可以給model/controller共用
  - 需要進行`require "檔案名稱"`
  - 一般來說，用來放些不屬於網站MVC本身的東西
  - 無法直接讓view使用，但可以透過由helper來include對應lib來讓view使用
    - 同時對應的controller也可以使用
  - 修改後，通常需要重啟`rails s`或`rails c`
- logs/*
  - 放記錄檔，一般來說`rails s`執行時噴出來的東西會記錄一份在這裡
  - 開一個termianl window來即時查看log：`tail -f log/development.log`
- config/*
  - 放設定檔
  - 比較常修改到的幾個：
    - `routes.rb`：路徑
    - `database.yml`：資料庫設定
    - `application.rb`：應用程式設定(所有environment都適用)
    - `environments/*`：不同environment的個別設定
    - `initializers/*`：Rails啟動時會執行的程式
- db/*
  - 與資料庫相關的檔案
  - `schema.rb`：當前資料庫的樣式
  - `seeds.rb`：產生測試用的假資料使用
  - `migrate/*`：存放每一次的migration file
    - migration file為資料庫變更的內容
    - 用來記錄你對資料庫做了甚麼修改，例如新增table或增加column
    - 一般來說建立Model時會產生對應的migration file
    - 需要手動執行`rake db:migrate`來更新資料庫
  - `development.sqlite3`：使用SQLite開發時，會出現的資料庫檔案
- Gemfile
  - 指定這一個repo要使用哪一些gem
  - `bundle install`會根據這個檔案做安裝

## 好用的除錯測試工具：Rails Console
- 開啟指令：`rails console`，簡寫為`rails c`
- 可在這邊使用irb，進行互動式的指令操作，測試Rails的相關環境
- 在這裡主要進行model的測試，變更會寫入DB
  - 例如
  ```
  User.create(name: "lctseng", email: "aaa@foo.com")
  ```
- 如果修改了model file，可以直接用`reload!`指令讀取新版本
  - 不必每次有修改model都重開`rails c`
  - 但有些情況即使`reload!`也無法更新，就重開吧
- 內建的`rails c`使用irb，但我們說過我們有更好的工具：`pry`
- 讓`rails c`改用`pry`
  - 修改`Gemfile`，新增：`gem 'pry-rails'`
  - 執行`bundle`
  - 可在`pry`內使用`show-routes`來直接顯示Routes，不用到外面下`rake routes`

## Rails常見慣例
- 若專案名稱為`my_blog`
  - 資料庫名稱通常為：`my_blog_development`、`my_blog_test`、`my_blog_production`
- 若Model的class名稱為`Post`
  - 檔案位置：`app/models/post.rb` (小寫 & 單數)
  - 資料表名稱：`posts` (小寫 & 複數)
- 當我們使用scaffold建立網頁時：
  - 會自動針對MVC產生相對應的檔案，並更新`routes.rb`
  - 這些名稱的命名方式遵守Rails的慣例
- 假設我們用scaffold建立`photo`
  - Controller
    - 檔案：`app/controllers/photos_controller.rb`
    - 類別名稱：`PhotosController`
  - Model
    - 檔案：`app/models/photo.rb`
    - 類別名稱：`Photo`
    - 資料表名稱：`photos`
  - View
    - 檔案：`app/views/photos/*.html.erb`
  - 路徑routes
    - 檔案：`config/routes.rb`
    - 新增路徑：`resources :photos`
    - 會產生8個RESTful的路徑，對應到controller裡面的7個方法(action)
- 當一個使用者(User)有很多貼文(Posts)的時候
  - `posts`表格內應該要有一個`user_id`欄位
  - 在Post的model中：`belongs_to :user` (單數)
  - 在User的model中：`has_many :posts` (複數)

## Gem使用
- Gem：Ruby的擴充插件
  - 就像瀏覽器add-on一樣，用來擴充Ruby或Rails原本的功能
  - 其實Rails本身就是Ruby的gem之一
    - 因此剛裝好全新的電腦要使用Rails，在裝好Ruby之後，第一件事情就是`gem install rails`
  - 安裝gem的方法
    - `gem install 要安裝的套件名稱`
    - 端看系統設定，可能安裝到系統目錄，也可能只替當前使用者安裝
    - 如果要安裝到系統目錄，需要使用`sudo`
      - 例如：`sudo gem install rails`
  - 使用bundler
    - 在Rails裡面，希望統一管理專案用到的所有gem
    - 其他的開發者不必逐一安裝，只要下一個單一的指令就可以安裝所有需要的gem
    - 要使用bundler之前，要先安裝：`gem install bundler` (通常隨著Rails一起安裝)
    - 安裝所需gem的指令：`bundle install`，可簡寫為`bundle`
    - 參照的檔案：`Gemfile`
      - 若需要加入新的gem，只要修改該檔案並加入`gen '需要的gem名稱'`
      - 執行`bundle`，等待安裝完成
    - Remark：bundler權限議題
      - bundler預設安裝到系統路徑，因此會提醒輸入`sudo`密碼
      - **嚴禁** 使用`sudo bundle install`
      - 若只要替當前專案安裝：使用`bundle install --path vendor/bundle`
    - 大部分情況下，安裝完Gem之後都要重啟server

## 美化頁面
- 美化HTML：需要配合CSS與Javascript
  - 在Rails中，CSS可由SCSS取代
    - SCSS又稱SASS
    - 可以在傳統CSS中加入程式的功能，例如變數命名、import等等
    - 相關網站
      - [使用scss來加速寫css吧!](http://blog.visioncan.com/2011/sass-scss-your-css/)
  - 在Rails中，Javascript可由CoffeeScript取代
    - Javascript有太多莫名其妙的地雷
    - CoffeeScript的目的是用類似Ruby或Python的簡潔語法來輕鬆撰寫Javascript
    - 相關網站
      - [CoffeeScript 簡介](http://kaochenlong.com/2011/08/03/coffeescript-introduction/)
      - [CoffeeScript 官方網站(英文)](http://coffeescript.org/)
        - 有線上試玩功能
- 但我們只是工程師，不是設計師
  - 如果你也是設計師，那恭喜你，你實在是太稀有了
- 套版：使用現成的套件：Bootstrap
  - 參考：[Bootstrap中文手冊](https://kkbruce.tw/bs3/)
  - 雖然Bootstrap可以不用套件，直接抓官方網站的CSS/JS來用，但這裏我們使用SASS版本
  - 新增gem至`Gemfile`：`gem 'bootstrap-sass'`
  - 安裝gem：執行`bundle`，重啟Rails
  - 修改CSS檔案，引入bootstrap
    - 位置：`app/assets/stylesheets`
    - 由於要使用SCSS語法而非原生CSS，請把`application.css`改名為`application.css.scss`
    - 在最底下加入：
    ```
    @import "bootstrap-sprockets";
    @import "bootstrap";
    ```
    - 注意！註解是有意義的，請勿隨意移除
      - 例如：`*= require_tree .`代表include當前目錄下所有CSS檔案
  - 修改JS檔案，加入bootstrap的Javascript
    - 位置：`app/assets/javascripts`
    - 將`application.js`改名為`application.js.coffee`來使用CoffeeScript語法
    - 修改原先的內容，改成如下：
    ```
    #= require jquery
    #= require jquery_ujs
    #= require turbolinks
    #= require bootstrap-sprockets
    #= require_tree .
    ```
    - 注意！註解是有意義的，請勿隨意移除
  - 至此，Bootstrap的CSS與Javscript已經被包含在你的專案中了，可以用瀏覽器檢視原始碼查看
    - 可以發現字體已經被換掉了
  - 網站的文字黏在邊邊好醜：加入Bootstrap邊界效果
    - 修改：`app/views/layouts/application.html.erb`
    - 把主要輸入內容用div包起來
    ```
    <div class="container">
      <%= yield %>
    </div>
    ```
    - 重整網頁，就可以看到Bootstrap提供的邊界效果
  - 範例：加入Bootstrap的按鈕效果
    - 修改`app/views/users/_form.html.erb`
    - 在23行處(`f.submit`)後方加入`class: "btn btn-primary"`
    ```
    <%= f.submit class: "btn btn-primary"%>
    ```
    - 重新整理網頁，就可以看到`Create User`與`Update User`按鈕有效果

## 資料分頁
- 練習使用別人的Gem
- 需求
  - 資料可能很多，一次顯示在同一個頁面會很擠。
  - 希望能像Google Search最底下那樣，有資料分頁的功能
- 使用gem：`kaminari`
  - [此Gem的Github連結](https://github.com/amatsuda/kaminari)
  - 基本上用法都是參照Github上的說明
- 套用流程
  1. 修改Gemfile：`gem 'kaminari'`
  2. `bundle`並重啟server
  3. 修改controller：`users_controller`
  ```
  def index
    @users = User.page(params[:page]).per(2) # 每兩筆一頁
  end
  ```
  4. 修改view，新增分頁按鈕：`app/views/users/index.html.erb`
    - 於最底下加入(div只是拿來美化用的，並非必要)
    ```
    <div>
      <%= paginate @users %>
    </div>
    ```
  5. 重新整理網頁，即可看到分頁的效果
  6. 美化分頁效果
    - 預設的分頁連結好醜，我可以自己套Bootstrap嗎？
    - 可以，不過已經有人寫過Gem來做這件事情了
    - 安裝Gem：`kaminari-bootstrap`
    - 重啟server，重整頁面後即可看到美化效果

## 部屬到Heroku
- 現在的網頁只是在本機端開發，做的再厲害也只有自己能看到
- 自架Server與Port Forwarding？
  - 別傻了，不是每個人都是MIS(網路系統管理員)
- Heroku：提供部署Rails應用程式的VPS
  - 付費方案很貴
  - 對於測試與開發用途來看，他提供每月1000小時的執行期間
    - 足以讓一個微小型網站以24/7運行
    - 若沒有綁定信用卡(但不扣款)，則只有550小時左右
    - 免費版特殊限制
      - 若30分鐘未使用，會進入休眠
      - 休眠後的網站在下次瀏覽時會自動喚醒，但需要一段時間
  - 其實一個帳號可以執行多個網站，只是總執行時間加起來不能超過
- 使用Heroku部署的流程
  1. 申請帳號
    - 免費
    - [官方網站連結](https://www.heroku.com/)
    - [檢視當前已部署的應用程式](https://dashboard.heroku.com/)
  2. 安裝Heroku的gem：`gem install heroku`
  3. 建立Heroku應用程式
    - 進入專案目錄
    - 執行：`heroku create APPLICATION_NAME`
      - `APPLICATION_NAME`換成你想要取的名稱，全球唯一
      - 如果沒有輸入名稱，會自動產生中二(誤)的名字
      - 第一次使用時會需要一些時間安裝，並登入Heroku
  4. 設定Heroku使用的Database
    - Heroku不支援SQLite，需自行替換成PostgreySQL
    - 修改`Gemfile`，變更部署到Heroku時的環境(production)
    ```
    group :development, :test do
      gem 'sqlite3'
    end
    group :production do
      gem 'pg'
    end
    ```
    - 雖然說你不會在本機端使用到PostgreySQL，但還是建議你把系統套件裝上
      - 在課程虛擬機(Ubuntu)中使用指令：`sudo apt-get install libpq-dev`
      - 如果沒辦法安裝PostgreySQL的系統套件時
        - 為了避免`bundle`時安裝到無法使用的`pg`，須改用不同的bundle指令
        - 使用`bundle install --without production`來避開安裝`pg`
  5. 初始化Git
    - Heroku使用Git來管理專案
    - 如果你的Rails應用程式還沒使用Git管理，請使用`git init`來初始化
    - 檢查專案目錄下的`.git/config`，補上
    ```
    [remote "heroku"]
          url = https://git.heroku.com/APPLICATION_NAME.git
          fetch = +refs/heads/*:refs/remotes/heroku/*
    ```
  6. 使用Git提交你的更新
    - 更改完後，建立Commit(千萬記得至少要做一次commit!)
    - 之後若有內容修改，也請先進行commit後再push
    - push的指令：`git push heroku master`
    - 範例：
    ```
    git init
    git add .
    git commit -m 'init version'
    ```
  7. 在Heroku上執行`rake db:migrate`
    - Recall：把model的內容真正寫入到資料庫中
    - 如同在本機端需要執行該指令來更新資料庫一樣
    - 使用`heroku run rake db:migrate`來在heroku上執行資料庫更新
    - 如果你非常想要在heroku上的主機執行Shell
      - 使用`heroku run bash`
      - 通常有需要執行複雜指令才會這麼做
  8. 瀏覽你的網站：`https://APPLICATION_NAME.herokuapp.com/users`
    - 等等！CSS/Javascript跑掉了...
    - 修改Gemfile
    ```
    gem 'rails_12factor', group: :production
    ```
    - 執行`bundle`
    - 執行`heroku run rake assets:precompile`
    - 重新`git add .` & `git commit ` & `git push heroku master`
  9. 看應用程式的記錄檔(Log)
    - `heroku logs --tail`
- 實作：把手邊的專案部署到Heroku上
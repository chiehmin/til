# NCTU+ Rails入門課程 - 2016-08-07
- Lecturer: 曾亮齊(Henry Tseng)
- Email：
  - lctseng.nctuplus@cs.nctu.edu.tw
  - lctseng@5xruby.tw
- 部分教材 Credit to: 5xRuby.tw
- 本講義連結：https://url.fit/ZbHP7

---

## 本次大綱
- 在Rails Console下操作Model
- 回顧scaffold
- 手動建立Controller
- Route進階探討
- View的使用
- 手工打造：不依賴scaffold，自己寫MVC
  - 建立MVC
  - 程式碼整理
    - 使用before_action
    - 使用partial
- View的其他議題
  - layout
  - flash message
  - view helper
- 深入理解Model
  - Migration
  - 進階ORM操作
  - Associations
  - Validation
  - Callback


## 在Rails Console下操作Model
- Recall：model是對應資料庫中的物件，幫助我們省去寫SQL的麻煩
- 在Controller中花費不少力氣在操作model
- 先與Model熟悉：在```rails c```中練習對model的CRUD (以User這個class為例)
  - 取得當前所有的User (回傳類似陣列的結構)
  ```ruby
  User.all
  ```
  - 取得第一個與最後一個使用者 (回傳該object。若不存在，則回傳nil)
  ```ruby
  User.first
  User.last
  ```
  - 產生一個新的使用者
    - 有兩種方法，分別是單步驟與雙步驟
    - 單步驟方法：create
    ```ruby
    User.create(name: "user1", email: "5566")
    ```
    - 雙步驟方法：new與save
      - new：就像建立一般Ruby class object一樣
      - save：將建立好的object存進資料庫中
        - 若無save，即使有new，該物件也不會真的寫進資料庫
      -  範例
      ```ruby
      u = User.new(name: "user2")
      u.email = "7788"
      u.save
      ```
      - 好處：可以進行較複雜的資料處理
      - 可以藉由`save`的回傳值來判斷儲存的動作有沒有成功(例如有沒有滿足資料內容驗證)
      ```ruby
      if u.save
        # 顯示成功頁面
      else
        # 顯示失敗頁面
      end
      ```
  - 根據id刪除使用者
    - id：rails會自動替每一個存進資料庫的User產生獨一無二的欄位：id
    - 刪除某一個id為2的使用者
    ```ruby
    User.delete(2)
    ```
    - 之後新創的使用者ID不會再使用2，而會往後增加
  - 根據使用者欄位取得使用者 (回傳該object。若不存在，則回傳nil。若有多筆，回傳第一筆)
    - 可根據id、name等欄位取得使用者
    ```ruby
    User.find(1) # 根據ID搜尋
    User.find_by_id(1) # 同上
    User.find_by_name("user1")
    User.find_by_email("5566")
    ```
    - 另一種寫法：`find_by` (common use)
    ```ruby
    User.find_by(id: 1)
    User.find_by(name: "user1")
    User.find_by(name: "user1", email: "5566") # 同時指定多個條件
    ```
    - 檢查一個物件是不是已存在於資料庫：使用`new_record?`
    ```ruby
    u1 = User.new(name: "user1")
    u1.new_record? #=> true
    u1.save
    u1.new_record? #=> false

    u2 = User.find_by_id(2)
    u2.new_record? #=> false
    ```
  - 更新某一個使用者的資訊
    - 取得某一個User的object後，可在更新資料後使用save來更新資料庫
    ```ruby
    u = User.find_by_id(1)
    u.password = "7788"
    u.save
    ```
    - 直接更新多個欄位的方法：update 或 update_attributes
      - 不需要save，執行完即有save的效果
      - 接受一個hash結構，類似`new`或`create`的時候那樣
      - 回傳true或false：代表是否有成功更新
      - 資料檢查(validation)
      ```ruby
      u.update(name: "new_name")
      u.update_attributes(name: "new_name")
      ```
    - 直接更新單一個欄位的方法：update_attribute (單數)
      - 給定欄位名稱與要更新的數值
      - 回傳true或false：代表是否有成功更新
      - **注意** 這個用法會繞過資料檢查(validation)，如果真的有需求再用這個方法
      ```ruby
      u.update_attribute(:name, "new_name")
      ```
  - 刪除某一個使用者的object
    - 取得某一個User的object後，可使用destroy來將之從資料庫中移除
    ```ruby
    u = User.find_by_nickname("U2")
    u.destroy
    ```
    - 若使用find_by_id，則效果類同於User.delete(id)

## 回顧scaffold
- scaffold可以用來快速產生網站，但業界不常用
- 原因：產生的內容太制式化，不適合實際應用
- 探討：執行scaffold時發生了什麼事？
  - 產生Migration檔案(更新資料庫結構)：`db/migrate/*.rb`
  - 修改路由(Route)：`config/routes.rb`
  - 產生MVC結構
    - Controller：`app/controllers/`
    - Model：`app/models/`
    - View：`app/views/`
  - 產生Assets：`app/assets/`
    - Javascripts (CoffeeScript)
    - Stylesheets (SASS/SCSS)
  - 產生View Helpers：`app/helpers/`
  - 產生測試：`test`(目前用不到)
- 純手工打造：自己打造上述的功能

## 手動建立Controller
- first create new rail project

    ```
    mkdir mytest
    cd mytest
    rails new .  
    bundle install  
    rake db:migrate  
    ```

- 建立(generate)新的controller：`rails g controller StaticPages index about`
  - 產生controller：`app/controllers/static_pages_controller.rb`
  - 產生兩個controller **action**：index和about，但方法為空
  - 產生兩條路徑(route)：`get "static_pages/index"`與`get "static_pages/about"`
    - prefix為`static_pages_index`和`static_pages_about`
    - 這兩個路徑不滿足RESTful，單純只是定義URI+動詞要傳送到哪個action
  - 產生兩個空頁面：`app/views/static_pages/`下的`index.html.erb`與`about.html.erb`
  - 產生stylesheets和javascripts
    - `app/assets/javascripts/static_pages.js.coffee`
    - `app/assets/stylesheets/static_pages.css.scss`
  - 產生view_helper：`app/helpers/static_pages_helper.rb`
  - 產生test_unit：用來做網頁測試的，現在先忽略之
  - Controller的class一定是大寫開頭，因此在generate時使用`staticPages`也沒差
    - 但不能用`staticpages`，Rails會辨認為`Staticpages`而非`StaticPages`
    - Ex: app/views => static_pages folder  
         app/controler => static_pages_controller.rb
    
    In pry
    ```
      "my_static_pages".camelize  => "MyStaticPages"
      "MyStaticPages".underscore  => "my_static_pages"
    ```
- 如果沒有指定要新增的action(只有`rails g controller StaticPages`)
  - 不會更動rotues
  - 只會在views中生成空資料夾：`app/views/static_pages`
- 移除(destory)已存在的controller
  - 把g換成d
  - `rails d controller StaticPages index about`
  - 若有指定要移除的action(即`index`和`about`)，則routes和views都會一併砍
  - action need to be specified, otherwise destroy will fail
- Controller與View
  - 當controller的action執行完後，會執行相對應名稱的view
    - 例如執行完`UsersController#index`之後會顯示`views/users/index.html.erb`
  - 在Controller中建立的實例變數(instance variables)可以在view中使用
- `params`：前一個網頁傳過來的資訊
  - 例如透過GET(寫在網址)或POST(寫在表單)
  - 可以在controller中用`params`這個hash來存取
  - 範例：把params用實例變數存起來，放在view顯示(以剛才的StaicPages為例)
    - 在`static_pages_controller`的`index`中加入
    ```ruby
    def index
      @name = params[:name]
      @email = params[:email]
    end
    ```
    - 修改View：`views/static_pages/index.html.erb`
    ```html
    <p>
      My name is <%= @name %>
    </p>
    <p>
      My email is <%= @email %>
    </p>
    ```
    - 瀏覽`/static_pages/index?name=123&email=456`
    - 可以看到由網址輸入的資料，從網頁中顯示(注意後面的?、=、&)
    - 大部分的網站都有透過這種方式讓使用者輸入資料
      - 例如：`https://www.youtube.com/results?search_query=yee`
  - 還記得用來做分頁的kaminari嗎？要顯示第幾頁的功能就是用params來傳送的
    - `/users?page=2`
    - `@users = User.page(params[:page]).per(2)`
  - 以上範例是使用GET來傳遞params，稍後會介紹如何透過表單來送出POST的params

## Route進階探討
- 指定瀏覽器的Requst(URI+動詞)要對應到哪個controller
- 指定網站根目錄要去的action(app/config/routes.rb)：`root :to => "controller#action"`
- 使用RESTful語法的話，可以快速產生許多條routes，例如`resources :users`
- 但如果不想遵守RESTful，或者是有自訂route需求的時候，可以用以下幾個方式
  - `動詞 "網址"`
    - 例如：`get "static_pages/index"`
    - 沒有指定action與prefix，會從網址名稱去猜
    - 猜測的action：`static_pages#index`
    - 猜測的prefix：`static_pages_index`
  - `動詞 "網址", to: "controller#action"`
    - 例如：`get "static_pages/index", to: "some_controller#my_action"`
    - 指定要對應的action
    - 沒有指定prefix，用網址去猜：`static_pages_index`
  - `動詞 "網址", to: "controller#action", as: "自訂的prefix"`
    - 例如：`get "static_pages/index", to: "some_controller#my_action", as: "custom_prefix"`
    - 完整指定action與prefix
    - 產生的prefix會是：`custom_prefix`，因此要以`custom_prefix_path`來用
- `resources`的延伸應用(注意不是`resource`，兩者不同)
  - 直接使用`resources :user`會預設建立好`UsersController`所使用RESTful的幾條route
    - 包含：`show update index create new edit destroy`
  - 如果想移除掉某一部分，可以用：`except`
    - `resources :users, except: %i(show update)`
  - 如果只想產生某幾條，可以用：`only`
    - `resources :users, only: %i(index create new edit destroy)`
    - 以上兩個範例等價
    - 如果想讓預設RESTful都不產生，直接用空陣列：`only: []`或`only: %i()`
  - 如果想自己定義屬於`UsersController`底下的route，可以用`do-end`
    - 需搭配`collection`或`member`
    - 使用`collection`
      - 用於不指定對象時使用(No Id)，例如index、create
      - 例如：
      ```ruby
      resources :users do
        collection do
          get "my_route"
        end
      end
      ```
      - 產生：`my_route_users GET    /users/my_route(.:format)     users#my_route`
      - 同樣可以搭配`to`和`as`來改變action和prefix
    - 使用`member`
      - 用於需要指定一個對象(Id)的時候，例如show、edit
      - 例如：
      ```ruby
      resources :users do
        member do
          get "my_route"
        end
      end
      ```
      - 產生：`my_route_user GET    /users/:id/my_route(.:format) users#my_route`
    - 當然，`collection`和`member`可以寫在同一個resources底下，每一個也可以有多條route
    ```ruby
    resources :users do
      collection do
        # route 1...
        # route 2...
      end
      member do
        # route 3...
        # route 4...
      end
    end
    ```
- 使用namespace
  - 可以用來替所有網址加上一段前綴名稱
  - 例如：
  ```ruby
  namespace :admin do
    resources :users do
      member do
        get "my_route"
      end
    end
  end
  ```
  - 會產生
  ```
  my_route_admin_user GET    /admin/users/:id/my_route(.:format) admin/users#my_route
          admin_users GET    /admin/users(.:format)              admin/users#index
                      POST   /admin/users(.:format)              admin/users#create
       new_admin_user GET    /admin/users/new(.:format)          admin/users#new
      edit_admin_user GET    /admin/users/:id/edit(.:format)     admin/users#edit
           admin_user GET    /admin/users/:id(.:format)          admin/users#show
                      PATCH  /admin/users/:id(.:format)          admin/users#update
                      PUT    /admin/users/:id(.:format)          admin/users#update
                      DELETE /admin/users/:id(.:format)          admin/users#destroy

  ```
  - Controller需要多找一層資料夾，變成`app/controllers/admin/users_controller.rb`
  - Controler名稱改變，需要加上Module name，變成`Admin::UsersController`
  - Views也換位置了，變成去找`app/views/admin/users/*`
  - 以上的變動達到了用namespace完全隔離的效果
    - 共存的範例：
    ```ruby
    namespace :admin do
      resources :users do
        member do
          get "my_route"
        end
      end
    end

    resources :users do
      member do
        get "my_route"
      end
    end
    ```
    - 結果
    ```
    my_route_admin_user GET    /admin/users/:id/my_route(.:format) admin/users#my_route
            admin_users GET    /admin/users(.:format)              admin/users#index
                        POST   /admin/users(.:format)              admin/users#create
         new_admin_user GET    /admin/users/new(.:format)          admin/users#new
        edit_admin_user GET    /admin/users/:id/edit(.:format)     admin/users#edit
             admin_user GET    /admin/users/:id(.:format)          admin/users#show
                        PATCH  /admin/users/:id(.:format)          admin/users#update
                        PUT    /admin/users/:id(.:format)          admin/users#update
                        DELETE /admin/users/:id(.:format)          admin/users#destroy
          my_route_user GET    /users/:id/my_route(.:format)       users#my_route
                  users GET    /users(.:format)                    users#index
                        POST   /users(.:format)                    users#create
               new_user GET    /users/new(.:format)                users#new
              edit_user GET    /users/:id/edit(.:format)           users#edit
                   user GET    /users/:id(.:format)                users#show
                        PATCH  /users/:id(.:format)                users#update
                        PUT    /users/:id(.:format)                users#update
                        DELETE /users/:id(.:format)                users#destroy

    ```
  You can also divide the it manually(using as to) => hard work
## View的使用
- 副檔名`erb`代表Embedded Ruby，即在HTML中嵌入Ruby語法
- 使用erb
  - 主要的兩種嵌入方式：`<%= 程式碼 %>`與`<% 程式碼 %>`
    - 相同處：都會把裡面的Ruby程式碼執行
    - 相異處：前者的執行結果會顯示在網頁上，後者的不會
    - 範例
    ```html
    <%= @a = 1 %> <br/>
    <% @b = 2 %> <br/>
    <%= "a = #{@a}, b = #{@b}" %>
    ```
    - 結果
    ```
    1 # @a = 1的結果
    (空白行)
    a = 1, b = 2 # 可見@a = 1和@b = 2都有執行，只是@b = 2的結果沒有顯示
    ```
    - 嵌入語法通常可以跨行嵌入，亦即不需要把所有程式碼塞在同一個`<%= %>`或`<% %>`之中
      - 例如if、else、end可以分開成三行
    - 為何需要`<% %>`？
      - 因為有些程式碼我們只需要它的功能，不需要他的回傳結果
      - 例如：if、else、end、each等
      ```html
      <% if 條件 %>
        (HTML...)
        <%= "要顯示的內容" %>
      <% else %>
        (HTML...
        <%= "要顯示的內容" %>
      <% end %>
      ```
  - 在if-else條件中，只有滿足條件的那一方的HTML才會被顯示到畫面上
  ```html
  <% if 條件 %>
    <p>Success!</p>
  <% else %>
    <p>Fail!</p>
  <% end %>
  ```
  - 程式碼重複：包在迴圈中(for、while、each等)的HTML會被重複顯示多次
  ```html
  <% @users.each do |user| %>
    <p> User Name = <%= user.name %> </p>
  <% end %>
  ```

## 手工打造：不依賴scaffold，自己寫MVC
- 目標：建立一個文章(article)管理系統，可以對它做CRUD，以MVC的方式來設計
- 假設文章擁有：title、content、id
- 建MVC架構
  - 首先，來點固定的步驟
    - 產生Controller：`rails g controller articles`
    - 修改route：`resources :articles`
    - 產生model：`rails g model article title:string content:string`
    - 更新資料庫：`rake db:migrate`
  - 到目前為止，我們已經完成路徑設定與controller、model的建立，但內容為空，且沒有View
  - 試著從錯誤中學習：可以先瀏覽看看自己的網站：`/articles`，看看錯誤訊息
    - `Unknown action`：這告訴了我們，Rails找不到controller中對應的action
    - EDD = Error-Driven Development
- 接下來，我們來完成`rake routes`(或者`pry`中的`show-routes`)中的每一條routes
  - 分別為：
    1. index
    2. show
    3. new
    4. create
    5. edit
    6. update
    7. destory
  - 在開始之前，記得先用`rails c`建立一些假資料方便測試
- 第一條：`index`
  - 修改controller，加入index方法
  - 由於index是要顯示所有文章並顯示到view，所以要用實例變數存起來
  ```ruby
  def index
    @articles = Article.all
  end
  ```
  - 再次連連看網頁，看看錯誤訊息是甚麼
    - `Template is missing`：找不到樣板，也就是對應的view(index.html.erb)沒找到
  - 加入`app/views/articles/index.html.erb`，簡單列出所有文章
  ```html
  <h1>Listing Articles</h1>
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Content</th>
      </tr>
    </thead>
    <tbody>
      <% @articles.each do |article| %>                                                                                                    <tr>
          <td><%= article.id %></td>
          <td><%= article.title %></td>
          <td><%= article.content %></td>
        </tr>
      <% end %>
    </tbody>
  </table>
  ```
- 第二條：`show`
  - 用途：顯示某一篇已存在的article的資料
  - 修改controller
  ```ruby
  def show
    @article = Article.find params[:id]
  end
  ```
  - 在`show`這個action中，可以使用`params[:id]`這個欄位來取得當前檢視的article的id
    - `id`哪來的？還記得`routes.rb`中的`/articles/:id(.:format)`嗎？
    - 如果我們要檢視id為1的article，我們會瀏覽`/articles/1`
    - Rails會根據這個資訊幫我們生成`params[:id]`
  - 修改view：`views/articles/show.html.erb`
  ```html
  ID: <%= @article.id %>
  Title: <%= @article.title %>
  Content: <%= @article.content %>
  ```
  - 排版好醜怎麼辦？解決換行問題的方法
    - 手動換行：使用`<br>`標籤來換行
    - 使用`<div>`標籤來包住每一個想成為一行的一群元素
    ```html
    ID: <%= @article.id %><br>
    Title: <%= @article.title %><br>
    Content: <%= @article.content %><br>
    ```
  - 設定連結：`link_to`
    - 目前必須直接輸入網址才能讓我們開啟表單
    - 在Rails中，超連結通常使用`link_to`語法
      - 其實就是產生對應的HTML超連結：`<a>`
    - 基本用法說明：`link_to "說明文字", 某網址的path`
      - 例如：`link_to "Show", article_path(article)`
      - 產生： `<a href="/articles/1">Show</a>`
      - 如果想要加上CSS，可以在後方加入：`class: "btn btn-primary"`等
      - 例如：`link_to "Show", article_path(article), class: "btn btn-primary"`
    - 在`index.html.erb`中設定連結到`show`的畫面
      - 加入`<th>Show</th>`與`<td><%= link_to "Show", article_path(article) %></td>`
      - In pry
      ```
        app.article_path(Article.find(1)) => /articles/1
        app.article_path(1) => /articles/1
        app.article_path  => error
        app.articles_path => /articles
      ```
      - 完整程式碼
      ```html
      <h1>Listing Articles</h1>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Content</th>
            <th>Show</th>
          </tr>
        </thead>
        <tbody>
          <% @articles.each do |article| %>
            <tr>
              <td><%= article.id %></td>
              <td><%= article.title %></td>
              <td><%= article.content %></td>
              <td><%= link_to "Show", article_path(article) %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
      ```
    - 在show頁面加入返回首頁的link_to：`<%= link_to 'Back', articles_path %>`
- 第三條：`new`
  - 用途：顯示新增使用者的表單
  - 修改controller
    - 由於需要新增使用者，必須要讓Rails知道，因此也要用到實例變數
    ```ruby
    def new
      @article = Article.new  # 注意不是create，因為我們還沒有要寫入資料庫
    end
    ```
  - 新增view：new.html.erb
    - 這次我們需要一個表單(form)
    - 在Rails中，有兩種內建的表單表達法：`form_tag`與`form_for`
      - `form_tag`：幾乎是HTML原生的<form>，雖沒有方便的功能，但彈性非常大
      - `form_for`：當你想要填寫的對象是一個`ActiveRecord::Base`(也就是model)時
    - 在這裡我們使用`form_for`當範例
    - 提供瀏覽器填寫文章內容的表單，最後有一個送出(submit)按鈕
    ```html
    <h1>New Article</h1>
    <%= form_for @article do |f| %>
      <%= f.label :title %>
      <%= f.text_field :title %>
      <%= f.label :content %>
      <%= f.text_area :content %>
      <%= f.submit %>
    <% end %>
    ```
    - 有關Rails中，form的各項元件(如button、checkbox等)，可參考[此連結](https://url.fit/ZhHNH)
    - 進入`/articles/new`，即可看到表單
    - 注意：此時我們還沒寫送出表單時的action (即`create`)，因此點送出會出錯
  - 設定連結：`link_to`
    - `link_to "New Article", new_article_path`
    - 將上述的`link_to`加入首頁(index.html.erb)，使得首頁可以連結到`new_article_path`
    - 加入返回按鈕：在`new.html.erb`設定另一個`link_to`連結到index頁面：`articles_path`
  - 修正排版換行問題
    - 例如：
    ```html
    <h1>New Article</h1>
    <%= form_for @article do |f| %>
      <div>
        <%= f.label :title %><br>
        <%= f.text_field :title %>
      </div>
      <div>
        <%= f.label :content %><br>
        <%= f.text_area :content %>
      </div>
      <%= f.submit %><br>
    <% end %>
    <%= link_to 'Cancel', articles_path %>
    - 可以自行套上Bootstrap來達到美化的效果
    ```
- 第四條：`create`
  - 當使用者從new頁面送出表單後，資料回跑到create這個action來
  - 在action中，我們必須進行資料的儲存
    - Recall：在`rails c`中對model的操作
    - 若儲存成功，進入該article的`show`頁面
      - 使用`redirect_to`，相當於使用者直接瀏覽新位置
    - 若儲存失敗，回到原本新增使用者的頁面，並保留原先畫面上的資料
      - 使用`render`，打破action名稱與view名稱的掛勾
      - 因為想要保留畫面上的資料，不希望用`@article = Article.new`蓋掉
      - 因此不能用`redirect_to`
      - `redirect_to` & `render` can use other view, no need the rule of action-mapping-view
      - 簡單比較兩者：
        - `redirect_to`：**重新執行controller action**、重新生成view
          - 因此`@article = Article.new`會蓋掉`@article = Article.new(params[:article])`
        - `render`：只根據當前action的結果，生成指定的view
          - 不會發生蓋掉，因為直接生成view了，不會執行`@article = Article.new`
    - 加入儲存的程式碼
    ```ruby
    def create
      @article = Article.new(params[:article])   #or  @article = Article.create(params[:article])
      if @article.save
        redirect_to article_path(@article)  
      else
        render action: :new
      end
    end
    ```
  - 嘗試瀏覽，但卻發生了：`ActiveModel::ForbiddenAttributesError`
    - 原因：Rails的保護機制，避免網頁攻擊者隨便塞不合法的資料到表單中
      - 這個機制稱為強參數(strong parameter)，可以參考[此網站](http://blog.xdite.net/posts/2012/03/05/github-hacked-rails-security/)
    - Rails需要程式設計師親自指定要寫入資料庫的欄位名稱，沒 **清洗** 過的params，不允許整包寫入
    - 只會發生在 **整包** 寫入的情況，單獨取用params內容是OK的
      - **整包** 的定義：`params[:article]`是一個hash，包含了許多欄位
      - 非整包而是單一筆資料的例子：我們之前曾經直接使用`params[:page]`來取得分頁
    - 解決方案：把`params[:article]`換成`params.require(:article).permit(:title, :content)`
      - `@article = Article.new(params.require(:article).permit(:title, :content))`
    - 好像有點醜，其實我們可以把它放到一個方法中，比較簡潔
    ```ruby
    def create
      @article = Article.new(article_params)
      if @article.save
        redirect_to article_path(@article)
      else
        render action: :new
      end
    end

    private
    def article_params
      params.require(:article).permit(:title, :content)
    end
    ```
    - 注意到那個`private`了嗎？
      - 之前提到，controller內定義的method都會被視為action，可以被`routes.rb`所對應
      - 如果我只想定義controller內部用的method，不想成為可對應的action怎麼辦？
      - 使用`private`關鍵字：使得該關鍵字之後的方法都只能做為內部使用(all the functions below, not only one function the private keyword), only used for function not for action
    - 再次瀏覽，應該可以成功建立article了
  - 注意：目前的`save`不會有失敗的場合，因為沒有定義失敗的條件(例如不能留白等等)
    - 之後做資料驗證時，就會看到`save`失敗的情況
    - 模擬失敗的時候畫面資料是否保留：把`if @article.save`換成`if false`來測試

- 第五條：`edit`
  - 用途：顯示修改使用者的表單
  - 類似new，只是這次是針對一個已存在的使用者
  - 修改controller
  ```ruby
  def edit
    @article = Article.find params[:id]
  end
  ```
  - 新增View：`views/articles/edit.html.erb`
  ```html
  <h1>Edit Article</h1>
  <%= form_for @article do |f| %>
    <%= f.label :title %>
    <%= f.text_field :title %>
    <%= f.label :content %>
    <%= f.text_area :content %>
    <%= f.submit %>
  <% end %>
  ```
  - 假設我們已經有一篇article存在，且id是1
    - 可瀏覽`/articles/1/edit`來顯示編輯該使用者的表單
    - 注意：此時我們還沒寫送出表單時的action (即`update`)，因此點送出會出錯
  - 補完link_to
    - 在`edit.html.erb`中加入回到首頁的連結
    - 在`index.html.erb`中的每一條article都加入編輯按鈕
      - 類同新增`Show`的連結一樣
      - 加入`<th>Edit</th>`與`<td><%= link_to 'Edit', edit_article_path(article) %></td>`
- 第六條：`update`
  - 類同`create`，要寫入資料庫，需要 **清洗** 過params，不能整包寫入
  - 修改controller
  ```ruby
  def update
    @article = Article.find params[:id]
    if @article.update(article_params)
      redirect_to article_path(@article)
    else
      render action: :edit
    end
  end
  ```
- 第七條：`destroy`
  - 用途：刪除指定的文章，刪除完後回到`index`頁面
  - 修改controller
  ```ruby
  def destroy
    @article = Article.find params[:id]
    @article.destroy
    redirect_to articles_path
  end
  ```
  - 修改view：`index.html.erb`，加入刪除的連結
    - `link_to 'Delete', article_path(article), method: :delete`
    - 注意到這裡使用到的`method: :delete`，因為link_to預設動詞是`get`，需要另外更改
- 程式碼整理
  - DRY：Don't Repeat Yourself
  - 完成上述CRUD之後，似乎有不少程式碼重複了，以下將介紹幾個避免重複的方法
  - controller：使用before_action
    - 在controler action的`show`、`edit`、`update`、`destroy`中有重複的code
      - 都需要使用`params[:id]`來尋找特定article
      - `@article = Article.find params[:id]`
    - 土炮解法：自己定義一個action稱為`set_article`，讓大家呼叫
    ```ruby
    def show
      set_article
    end
    def edit
      set_article
    end

    private
    def set_article
      @article = Article.find params[:id]
    end
    ```
      - 缺點：還是必須要在所有用到的action裡面呼叫
    - 使用before_action
      - 顧名思義，就是可以在指定的action前，先行執行某一段程式碼
      - 比起直接使用method的好處：可以簡單快速的指定
      - 用法：`before_action :方法名稱`
        - 這樣可以讓全部action在執行前都套用該方法
        - 但有些時候，我們不需要全部(例如`index`、`new`和`create`不需要)
        - 使用only：指定只有某些action套用
          - `before_action :set_article, only: %i(show edit update destroy)`
        - 使用except: 指定某些action不套用，其他都套用
          - `before_action :set_article, except: %i(index new create)`
          - 以上兩個範例等價
  - view：使用partial (部分樣板)
    - 在`new.html.erb`與`edit.html.erb`中，中間都有一個一模一樣的表單(form)
    - 使用partial：將重複的code獨立出來，讓要使用的地方include
    - 建立partial：
      - 建立新檔案：`views/articles/_form.html.erb`
        - 注意！要被他人共用的partial要用 **底線開頭**
        - 把表單內容貼在裡面
        ```html
        <%= form_for @article do |f| %>
          <%= f.label :title %>
          <%= f.text_field :title %>
          <%= f.label :content %>
          <%= f.text_area :content %>
          <%= f.submit %>
        <% end %>
        ```
      - 在他處引用
        - 修改`new.html.erb`與`edit.html.erb`，移除原本的表單區域
        - 用`<%= render partial: 'form' %>`取代
          - 或者是`<%= render 'form' %>`
          - 注意後面的名字form不需要底線
          - 亦即：partial取為`_my_partial.html.erb`時，要使用`render 'my_partial'`
    - 變數議題
      - 所有從controller來的實例變數(以@開頭)都可以在partial中使用
      - 但區域變數不行
        - 無論是controller中定義的區域變數，還是view內自己定義的，都不能延用到partial
        - 假如需要在partial內使用區域變數，需要明確指定
        ```ruby
        render partial: 'my_partial', locals: { var1: "value1", var2: another_local_var }
        ```
      - 如此一來，在`my_partial`這個樣板中就可以使用var1和var2兩個區域變數
      - 其中一種用途：讓呼叫partial樣板的view，可以給partial不同的變數來達成客製化
        - 例如：呼叫端可以決定partial中要顯示的文字
        ```ruby
        render partial: 'form', locals: { title: 'New Article' }
        render partial: 'form', locals: { title: 'Edit Article' }
        ```
        - 在`_form.html.erb`中
        ```html
        <h1><%= title %></h1>
        ```
      - can also use in the style class

## View的其他議題
- layout
  - 由所有網頁共同外框
  - 通常用於共用的頁首(例如Javascripts外部連結)、頁尾(例如版權聲明)等等
  - 檔案：`views/layouts/application.html.erb`
    - 這是預設的layout，沒特別指定的話，所有的view都會套用這個layout
    - layout中的`<%= yield %> `行會取代成要顯示的view
  - 新增並指定不同的layout
    - 如果想要替網站自訂不同layout，可以自行新增在`views/layouts`資料夾下
    - 例如新增：`views/layouts/my_layout.html.erb`
    - Generally, copy the default layout `views/layouts/application.html.erb` and modify it
    - 在controller指定自己的layout：在controller class的下方加入`layout 'my_layout'`    
    ```ruby
    class ArticlesController < ApplicationController
      layout 'my_layout'
      # Actions ...
    end
    ```
- flash message
  - 當我新增資料成功時，我們希望能告知使用者。而失敗時，也希望告知錯誤訊息
  - flash message：一閃而過的訊息
    - 只會在下一個頁面有效一次的變數，可以把訊息存在這個變數中，當成提醒
    - 重新整理頁面後，flash會消失
    - 我可不可以用params土炮製作？
      - 可以，但很醜，而且重新整理之後錯誤訊息還是存在(不信你試試看以下連結)
      - 例如：E3
      ```
      https://dcpc.nctu.edu.tw/index.aspx?ErrMsg=登入帳號不存在或密碼錯誤`
      ```
  - 使用方法：
    - 使用`flash`這個變數，類似hash操作
    - `flash[key] = value # value通常是字串`
    - 例如：修改controller
    ``` ruby
    def create
      @article = Article.new(article_params)                  
       if @article.save
        flash[:notice] = "Success!"
        redirect_to article_path(@article)
      else
        flash[:error] = "Fail to create!"
        render action: :new
      end
    end
    ```
    - 為了要讓錯誤訊息可以被使用者看到，需要在view內顯示flash
      - 每個頁面都可能共用，因此我們放在layout
      - 修改你當前所使用的layout(`application.html.erb`或`my_layout.html.erb`)
        - 在`yield`的附近加入
        ```html
        <p style="color:green;">
          <%= flash[:notice] %>
        </p>
        <p style="color: red;">
          <%= flash[:error] %>
        </p>
        ```
      - 試著新增article來看成功訊息，或者模擬失敗的情況來看錯誤訊息
      - 重新整理後，`flash`訊息應該就會消失
  - 更快速指定`flash`訊息的方法：合併到`redirect_to`中
    - 剛才的範例可以等價的改成：
    ``` ruby
    def create
      @article = Article.new(article_params)                  
       if @article.save
        redirect_to article_path(@article), notice: "Success!" # 合併!
      else
        flash[:error] = "Fail to create!" # 這邊無法合併，只能照舊
        render action: :new
      end
    end
    ```
- view helper
  - helper用處：希望定義可以在view中呼叫的方法(當然，controller也可以用)
  - 範例：在helper中定義一個時間處理函數，供controller與view使用
  - 先定義helper的內容(`app/helpers/articles_helper.rb`)
  ```ruby
  module ArticlesHelper
    def fmt_time(time)
      time.strftime("%Y年%m月%d日 %H時%M分%S秒")
    end
  end
  ```
  - 在controller中include(`app/controllers/articles_controller.rb`)
  ```ruby
  class ArticlesController < ApplicationController
    include ArticlesHelper
    # Actions ...
  end
  ```
  - 之後便可以在user的controller和view中使用
    - 在controller中使用：使flash message加上時間
    ```ruby
    redirect_to @article, notice: "Article was successfully created at #{fmt_time(Time.now)}."
    redirect_to article_path(@article), notice: "Article was successfully created at #{fmt_time(Time.now)}." # same as the above
    ```
    redirect_to + **object** => will call the action article#show
    - 在view中使用：顯示article建立與更新的時間
    ```html
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Title</th>
          <th>Content</th>
          <th>Created at</th>
          <th>Updated at</th>
          <th>Show</th>
          <th>Edit</th>
          <th>Destory</th>
        </tr>
      </thead>
      <tbody>
        <% @articles.each do |article| %>
          <tr>
            <td><%= article.id %></td>
            <td><%= article.title %></td>
            <td><%= article.content %></td>
            <td><%= fmt_time article.created_at %></td>
            <td><%= fmt_time article.updated_at %></td>
            <td><%= link_to "Show", article_path(article) %></td>
            <td><%= link_to 'Edit', edit_article_path(article) %></td>
            <td><%= link_to 'Delete', article_path(article), method: :delete %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    ```

## 深入理解Model
- Migration：資料表遷移
  - Rails會把你對Model的操作反映到資料庫(database)中的資料表(table)
  - 但前提是你得讓資料庫與Rails中對model的理解一致
  - migration檔案(位於`db/migrate/*`)
    - 記錄了要對資料庫進行甚麼樣的變更
    - 好處：可以進入版本控制系統，讓資料庫的樣式可以隨著Model檔案一起控管
      - 否則，你手動修改資料樣式不透過migration，就無法對資料庫的格式做控管了
    - 基本上你建立新Model的時候，Rails都會幫你產生migration檔案
  - 使用migration
    - 先產生migration檔案：`rails g migration MIGRATION_NAME`
    - 編輯該檔案
    - 套用migration：`rake db:migrate`
  - 範例：替article新增幾個欄位
    - 欄位需求
      - `author`：字串
      - `is_hot`：布林值
      - `view_count`：數字
    - 產生migration檔案(通常名字會取比較易讀)
    ```
    rails g migration add_data_to_article
    ```
    - 以上步驟會產生`db/migrate/20160804141954_add_data_to_article.rb`
      - 檔案名稱前面的時間編號會變動
      - 編輯該檔案，加入新的欄位
      ```
      def change
        add_column :articles, :author, :string
        add_column :articles, :is_hot, :boolean, default: false
        add_column :articles, :view_count, :integer, default: 0
      end
      ```
    - 執行`rake db:migrate`
  - 如果反悔了怎麼辦？使用`rake db:rollback`
    - 可以把上一次的`rake db:migrate`撤銷
    - 可以重新修正`db/migrate/20160804141954_add_data_to_article.rb`
    - 修正完後，再進行`rake db:migrate`
    - 如果想要撤銷n次，可以用：`rake db:rollback STEP=n`
- 進階ORM操作
  - ORM：Object-Relational Mapping
  - 用物件導向的程式碼去操作Relational Database
  - 之前教過的`User.all、User.find_by`都算是
  - 除了之前提到的那些，這邊會額外介紹一些較難但也算常用的一些用法
  - 讀取資料
    - 這些方法大多都可以串著用
    - count
      - 計算找出來的資料有多少筆
      - 例如：`Article.count`
      - 效能高：直接產生特殊的SQL，而非全部撈回來
      - 其他類似的用法：`average`、`sum`、`maximum`、`minimum`
      -  ` Article.sum(:id)`
    - limit
      - 限制找出來的資料筆數上限
      - 例如：`Article.limit(5)`
    - order
      - 指定挑選出來的資料的順序
      - 例如：`Article.all.order(id: :desc, title: :asc)`
    - select
      - 只挑選某一些欄位，降低資料流量
      - 預設的情況下，是所有欄位都撈出來(select * from xxx)
      - 例如：`Article.all.select(:id, :title)`
    - where
      - 可以自行指定搜尋條件
      - will return a array (even if there is only one record)
      - use it when querying many records, `find_by` only return a record
      - 自可以自行用AND、OR等串接搜尋條件
      - 例如：`Article.where("title = 't1' and content = 'content'")`
      - 預防SQL Injection: 可用?來取代欄位
        - 例如：`Article.where("title = ? and content = ?", 't1', 'content')`
    - find_by_sql
      - 最有彈性的用法，自訂SQL來搜尋
      - 例如：`Article.find_by_sql("select title, content from articles order by title desc")`
  - 更新資料
    - update_all
      - 更新撈出來的所有資料的欄位
      - 例如：`Article.where("id > 1").update_all(content: "haha")`
    - increment & decrement
      - 針對數字欄位做增加1或減少1
      - 範例
      ```ruby
      article = Article.first
      article.view_count #=> 0
      article.increment(:view_count)
      article.view_count #=> 1
      article.save # 記得要save，否則更新不會套用到資料庫
      ```
    - toggle
      - 針對布林數值欄位做交換
      ```ruby
      article = Article.first
      article.is_hot #=> false
      article.toggle(:is_hot)
      article.is_hot #=> true
      article.toggle(:is_hot)
      article.is_hot #=> false
      article.save # 記得要save，否則更新不會套用到資料庫
      ```
  - 刪除資料
    - destroy_all
      - 用來移除所有資料，可以設定條件。沒設定條件就是全部移除
      - 範例：移除所有`view_count`小於10的文章
      ```ruby
      Article.destroy_all("view_count < 10")
      ```
  - SQL太複雜不知道怎麼下ORM？直接下SQL
    - 使用`ActiveRecord::Base.connection.execute(sql字串)`
    - 範例：`ActiveRecord::Base.connection.execute("select * from articles")`
  - 使用Scope
    - 有時候某些條件選擇會常常重複利用
    - 例如：想要取出所有被標記為熱門(`is_hot`)的文章
    - 如果有多處需要使用，就要不斷使用`Article.where(is_hot: true)`
    - 方法一：自己定義一個class method，稱為`all_hot`，來快速存取
      - 修改model：`models/article.rb`
      ```ruby
      class Article < ActiveRecord::Base
        def self.all_hot(value)
          where(is_hot: value)
        end
      end       
      ```
      - 之後在controller或`rails c`中，就可以直接使用`Article.all_hot(true)`來存取
        - 取得所有`is_hot`為true：`Article.all_hot(true)`
        - 取得所有`is_hot`為false：`Article.all_hot(false)`
    - 方法二：使用scope
      - 可以達到幾乎一樣的功能，但是語法更簡潔
      - 修改model：`models/article.rb`
      ```ruby
      class Article < ActiveRecord::Base
        scope :all_hot, -> (value) { where(is_hot: value) }
      end
      ```
      - 若不需要參數(例如value)，可以更進一步簡化
      ```ruby
      class Article < ActiveRecord::Base
        scope :all_hot, -> { where(is_hot: true) }
      end
      ```
  - 使用`default_scope`
    - 如果我想要預設讓Rails所有的query都套用上某一個篩選條件怎麼辦？
      - 例如：全部都要照`id`降冪排序(desc)
    - `default_scope`即可達到我們要的效果
    - 例如：預設照`id`降冪排序
    ```ruby
    class Article < ActiveRecord::Base
      default_scope { order(id: :desc) }
    end
    ```
    - 但有些情況下，我們希望解除`default_scope`所帶來的效果
      - 例如：想要捨棄因`default_scope`產生的降冪排序效果，並同時用`view_count`升冪排序
      - 不能只用下列寫法！這會造成兩個排序效果並存
      ```ruby
      Article.order(view_count: :asc)
      ```
        - 結果：造成先以`id`降冪排序，再以`view_count`升冪排序
        - 原因：相當於`Article.order(id: :desc).order(view_count: :asc)`
      - 那我能不能強制再寫一次`id: :asc`把它蓋掉？
        - 例如：`Article.order(id: :asc, view_count: :asc)`
        - 結果：沒用，`default_scope`永遠比較優先
      - 解法：使用`unscoped`：移除所有篩選條件的效果，之後再設定新的篩選條件
      ```ruby
      Article.unscoped.order(view_count: :asc)
      ```
    - 除此之外，`default_scope`有一個令人討厭的副作用
      - `default_scope`會影響model產生的行為
      - 這也是Rails開發者圈 **不建議** 使用`default_scope`的原因
      - 範例：把`default_scope`調整為找出所有`is_hot`的article
        - `default_scope { where(is_hot: true) }`
        - 一般人通常會以為，這件事情只會影響到查詢指令而已
        - 但事實上會影響建立Model的行為
        - 在沒有`default_scope`時，使用`Article.new`得到的新物件，`is_hot`是false
        - 但使用`default_scope`時，新物件的`is_hot`卻變成true了，反映了`default_scope`
- Associations
  - 網站中有許多物件，我們需要定義物件之間的關聯性
  - 基本上與Relational DatabaseRails對應
    - 一對一
    - 一對多
    - 多對多
  - Rails支援以下六種關聯種類 (以及常用的情況，但是也非絕對)
    - `has_one` (一對一)
    - `belongs_to` (一對一 或 一對多)
    - `has_many` (一對多)
    - `has_one :through` (一對一)
    - `has_many :through` (一對多、多對多)
    - `has_and_belongs_to_many` (多對多)
  - 範例：店主、地點、店面與商品
    - 一對一：一家店面(shop)只能開在一個地點(location)
    - 一對多：店主(owner)可以有許多間店(shop)
    - 多對多：一間店(shop)可以賣很多種商品(product)，一種商品也可以在多個店面販售
    - 先建立好這些Model供後續練習使用
    ```
    rails g model shop name:string
    rails g model location name:string
    rails g model owner name:string
    rails g model product name:string price:integer
    rake db:migrate
    ```
  - `has_one`
    - 一家店面(shop)只能開在一個地點(location)
    ```ruby
    class Shop < ActiveRecord::Base
      has_one :location # 注意，使用單數
    end
    ```
    - 這會使Shop取得以下方法
      - `location`：取得所屬的地點
      - `location=`：設定所屬的地點
      - `build_location`：替此店建立地點(未儲存在資料庫，需要再save)
      - `create_location`：替此店建立地點(已儲存在資料庫)
    - 試試看建立一個`Shop`及`Location`，用用看以上功能
      - 會發現以下程式會出錯
      ```ruby
      s = Shop.first
      s.location # Error!
      ```
      - 錯誤訊息大概的意思：無法在`locations`這張表格中找出`shop_id`這個欄位，
        因此無法查出該`Shop`所屬的地點
      - 原因：當`Shop`使用`has_one :location`時，Rails會假設你在`Location`中記錄`shop_id`
        - 也就是`locations`這張表格要有`shop_id`這個欄位
      - 修正：使用migration新增`shop_id`這個欄位到`locations`這張表格
        - 建立migration：`rails g migration add_shop_id_to_locations`
        - 修改migration檔案：`db/migrate/20160805140115_add_shop_id_to_locations.rb`
        ```ruby
        def change
          add_column :locations, :shop_id, :integer
        end
        ```
      - 再次試試看，應該可以發現錯誤消失了
      ```ruby
      s = Shop.first
      s.location #=> nil
      l = Location.first
      s.location = l #=> 把s的location設為l，且進行save
      s.location #=>  #<Location id: 1 ... >

      s.create_location(name: "l2")
      # s的location更改為l2，並同時建立新的Location物件，該物件的shop_id是1

      new_location = s.build_location(name: "l3")
      # 原先的location的shop_id會被設為nil，因為該對應的shop已經換location了
      # 新的Location的shop_id已經設為1了，只是還沒save

      new_location.save # 儲存新建立的location
      ```
  - `belongs_to`
    - 一家店面(shop)只能開在一個地點(location)
    - 地點可以找到自己所屬的店面
    ```ruby
    class   Location < ActiveRecord::Base
      belongs_to :shop # 注意，使用單數
    end
    ```
    - 一樣有以下方法
      - `shop`
      - `shop=`
      - `build_shop`
      - `create_shop`
    - 跟`has_one`不同處：
      - `Location`尋找自己所屬的`Shop`時，是透過自己的`shop_id`欄位去查找`Shop`
      - 還記得`Shop`的`has_one :location`中，`Shop`尋找自己所屬的`Location`時，
        是用別的model(也就是`Location`)內的`shop_id`欄位
    - 為了兩邊的物件都能互相存取，因此常與`has_one`並用
  - `has_many`
    - 一對多：店主(owner)可以有許多間店(shop)
    - 類似`has_one`，需要在另一個物件上記錄自己的`id`
    - 修改`models/owner.rb`
    ```ruby
    class Owner < ActiveRecord::Base
      has_many :shops # 注意，使用複數
    end
    ```
    - 替`shops`這張資料表新增`owner_id`的欄位
    - 提供的方法
      - `shops`：取得所有`Shop`所形成的陣列
      - `shops=`：指定此`Owner`要擁有的`Shop`的陣列
      - `shops.build`：替此`Owner`建立新的`Shop`，不儲存在資料庫
      - `shops.create`：同上，但會儲存在資料庫
    - 範例
    ```ruby
    # 個別建立物件
    o1 = Owner.first
    s1 = Shop.create(name: "Shop1")
    s2 = Shop.create(name: "Shop2")

    # 把2間店丟給店主
    o1.shops = [s1, s2]

    # 只丟一間店，可以直接用陣列的push語法
    o1.shops << s1

    # 從店主的角度來新增商店
    o1.shops.build(name: "Shop1")
    o1.shops.create(name: "Shop2")
    ```
    - 同樣的，我們希望可以在`Shop`中存取自己所屬的`Owner`
      - 因此請在`models/shop.rb`加上`belongs_to :owner`
  - `has_one :through`
    - 類似於`has_one`
    - 差異：透過某一個第三方model來取得特定欄位
    - 範例：商店(`Shop`)擁有一個地點(`Location`)，而該地點擁有一個地址(`Address`)
      - 因此，以下關聯應該要成立
      ```ruby
      s = Shop.first
      s.location # 該店的location
      s.location.address # 該店location所屬的地址
      ```
      - 但是，既然該店都只有一個地點，且該地點也只有一個地址
      - 那麼，我們希望可以用`s.address`直接取得該店的地址，不想要再透過`Location`
    - 使用`has_one :through`來直接取得`Address`
      - 事前準備：建立`Address`：`rails g model address name:string location_id:integer`
      - 建立`Location`與`Address`的關係
        - `Location`：`has_one :address`
        - `Address`：`belongs_to :location`
        - 記得建立幾個`Address`的資料來測試
        ```ruby
        s = Shop.first
         s.location.create_address(name: "addr1")
        ```
      - 設定`Shop`與`Address間的關係`：修改`shop.rb`
      ```ruby
      has_one :address, through: :location
      ```
    - 重啟`rails c`後，可以發現`s.address`可以直接取用了
    - 為什麼不直接用`s.location.address`就好？沒差多少字，邏輯也挺清楚的
      - 效率議題：Rails會再`has_one :through`時自動join資料表，減少查詢不同資料表的次數
      - 使用`s.location.address`：先去找`shops`，再找出`locations`，最後再找`addresses`
      - 使用`s.address`：先去找`shops`後，直接去找`locations JOIN addresses`的結果
  - `has_many :through`
    - 類同`has_many`，一樣透過第三方的model來存取
    - 範例：店主(`Owner`)擁有許多間商店(`Shop`)，而每間店都會有許多員工(`employee`)，
      其中員工只能替一家店工作
      - 記得先建立員工的model：`rails g model employee name:string shop_id:integer`
      - 關聯性
        - 店主 `has_many` 商店
        - 商店 `belongs_to` 員工
        - 商店 `belongs_to` 店主
        - 員工 `belongs_to` 商店
      - 想要透過`owner.employees`來取的某一位店主旗下的所有店的所有員工
        - 在`owner.rb`ˋ中加入`has_many :employees, through: :shops`
    - 此外，`has_many :through`也可以拿來實現多對多
      - 注意！這功能在Rails 4.1.2以前有BUG，請更改`Gemfile`來更新Rails版本
        - 目前的版本為Rails 4.0.2
        - 修改`Gemfile`：`gem 'rails', '4.1.2'`
        - `bundle update`
      - 一間店(shop)可以賣很多種商品(product)，一種商品也可以在多個店面販售
      - 因為一個商品需要屬於多個商店，所以不可能只用一個`shop_id`來儲存
      - 透過第三方model：`ShopProductship`
        - `shop`-`product`的對應關係
        - `rails g model ShopProductship shop_id:integer product_id:integer`
        - 修改`shop.rb`
        ```ruby
        has_many :shop_productships
        has_many :products, through: :shop_productships
        ```
        - 修改`product.rb`
        ```ruby
        has_many :shop_productships
        has_many :shops, through: :shop_productships
        ```
        - 修改`shop_productship.rb`
        ```ruby
        belongs_to :shop
        belongs_to :product
        ```
      - 測試多對多
      ```ruby
      s1 = Shop.first
      p1 = Product.first

      s1.products.create(name: "p2")
      p1.shops.create(name: "p1 shop")
      ```
  - `has_and_belongs_to_many`
    - 另一個達成多對多的方法，但是彈性較`has_many :through`低，因此不太常用
    ```ruby
    # Store Model
    class Shop < ActiveRecord::Base
      has_and_belongs_to_many :products
    end

    # Product Model
    class Product < ActiveRecord::Base
      has_and_belongs_to_many :shops
    end
    ```
    - 然後，建立特殊的第三方Model
      - `rails g migration create_join_table product shop`
      - 檢視`db/migrate/20160806023025_create_join_table.rb`，視情況移除註解
      - `rake db:migrate`
- Validation
  - 資料驗證，在資料存入資料庫前，檢查是否滿足我們預先定義的規則
  - Rails的驗證器有這些：
    - `presence`：資料是否存在(不是空白)
    - `uniqueness`：是否在資料表中唯一
    - `length`：資料長度驗證
    - `format`：是否滿足某一個格式(例如正規表達式)
    - `numericality`：數字驗證(是否是數字/整數)
    - `inclusion`：用於select list，檢查傳來的資料是不是屬於指定陣列中的其中一個
    - `condition`：修飾上述條件，要讓某個方法return true才會去驗證
    - 還有其他驗證器，可以參考[Rails Guides](http://guides.rubyonrails.org/active_record_validations.html)
  - 驗證器的效果：
    - 如果驗證沒通過，save/create/update會失敗
    - 若要手動檢查是否通過驗證，可以用：`物件.valid?`
    - 此外，可以用`錯誤的物件.errors.full_messages`來取得錯誤訊息
  - `presence`：資料是否存在
    - 最簡單易用的驗證器
    - 驗證商品名稱與價格不可以空白
    ```ruby
    class Product < ActiveRecord::Base
      validates :name, presence: true
      validates :title, presence: true
      validates :price, presence: true
    end
    ```
    - 如果有其他多個欄位需要同時驗證`presence`，可以合併為
    ```ruby
    class Product < ActiveRecord::Base
      validates_presence_of :name, :title, :price
    end
    ```
    - 自訂錯誤訊息
      - `validates :name, presence: { message: "此欄位不可以空白" }`
      - 效果
      ```ruby
      s = Shop.create
      s.errors.full_messages #=> ["Name 此欄位不可以空白"]
      ```
  - `uniqueness`的用法與`presence`類似，把`presence`字詞取代掉就好
    - Rails就會驗證該資料欄位在資料庫中是否唯一
  - `length`：驗證資料長度
    - 範例：驗證名字的長度必須要在5~10字之間
    ```ruby
    class Shop < ActiveRecord::Base
      validates :name, length: { minimum: 5, maximum: 10 }
    end
    ```
    - 其他長度驗證
      - 在某個範圍內：`length: { in: 5..10 }` (與上述範例等價)
      - 剛好等於：`length: { is: 6 }`
  - `format`：驗證資料格式
    - 可以配合正規表達式
    - 例如要求資料滿足以英數字組成，且只限5~10個字
    - 正規表達式：`/\A\w{5,10}\z/`
      - `\A`：字串開頭 (因安全問題，禁止使用行首`^`)
      - `\z`：字串結尾 (因安全問題，禁止使用行尾`$`)
      - `\w`：一個英數字
      - `{5,10}`：由5~10個單位組成
    - 加入至model
    ```ruby
    validates :name, format: { with: /\A\w{5,10}\z/ }
    ```
  - `numericality`：數字驗證
    - 雖然某些功能可以用`format`達成，但若只是要進行簡單的驗證，可以用這個
    - 驗證是否純數字(小數或整數)
    ```ruby
    validates :price, numericality: true
    ```
    - 驗證是否是整數
    ```ruby
    validates :price, numericality: { only_integer: true }
    ```
    - 驗證其他數字關係
      - 大於、小於、等於、不等於、奇數、偶數等等
      - 範例：大於或等於10
      ```ruby
      validates :price, numericality: { greater_than_or_equal_to: 10 }
      ```
  - `inclusion`：資料是不是屬於某幾個數值之一
    - 範例
    ```ruby
    validates :size, inclusion: { in: %w(small medium large) }
    ```
  - `condition`
    - 某些情況下，我們並不會想讓所有物件都經過我們預先設定的驗證器
    - 範例：當名字不是`None`時，才去套用`uniqueness`驗證器
    ```ruby
    validates :name, uniqueness: true, if: :name_is_not_none?

    def name_is_not_none?
      name != "None"
    end
    ```
    - 以上範例應該要使用`:unless`配合`name_is_none?`會更好
  - 自訂驗證
    - 可自己定義方法來檢查
    - 範例：檢查名字是不是以`Ruby`開頭
    ```ruby
    class Shop < ActiveRecord::Base
      validate :name_validator # 注意是validate不是validates

      private
      def name_validator
        unless name.starts_with? 'Ruby'
          errors[:name] << "must begin with Ruby"
        end
      end
    end
    ```
    - 想要寫出這樣的語法嗎？來自訂驗證器(Validator)吧！
      - 在model內想要使用：
      ```ruby
      validates :name, presence: true, begin_with_ruby: true
      ```
      - 新增資料夾：`app/validators`，並在其內建立檔案：`begin_with_ruby_validator.rb`
      ```ruby
      class BeginWithRubyValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          unless value.starts_with? 'Ruby'
            record.errors[attribute] << "must begin with Ruby"
          end
        end
      end
      ```
      - 重啟server/`rails c`之後，即可直接使用此validator
  - 與flash message合併
    - 還記得稍早寫的controller中，當資料儲存失敗時，會使用`flash`顯示錯訊息嗎？
    - 當初的錯誤訊息是手動寫的，現在你可以直接用`物件.errors.full_messages`來取代
    ``` ruby
    def create
      @article = Article.new(article_params)                  
       if @article.save
        redirect_to article_path(@article), notice: "Success!"
      else
        flash[:error] = @article.errors.full_messages
        render action: :new
      end
    end
    ```
- Callback
  - 資料的存檔流程會經過以下流程
  ```
  save > valid > before_validation > validate >
  after_validate > before_save > before_create >
  create > after_create > after_save >
  after_commit
  ```
  - 我們可以在這些流程中做些事情
  - 例如：存檔前，把商店的名字第一個字變成大寫
  ```ruby
  class Shop < ActiveRecord::Base
  before_save :capitalize_name

  private
  def capitalize_name
    self.name.capitalize!
  end
  ```
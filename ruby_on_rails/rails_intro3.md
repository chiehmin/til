# NCTU+ Rails入門課程 - 2016-08-13
- Lecturer: 曾亮齊(Henry Tseng)
- Email：
  - lctseng.nctuplus@cs.nctu.edu.tw
  - lctseng@5xruby.tw
- 部分教材 Credit to: 5xRuby.tw
- 本講義連結：https://url.fit/Zs5TI

---

## 本次大綱
- 深入理解Model
  - Migration
  - 進階ORM操作
  - Associations
  - Validation
  - Callback
- 寄信功能
  - ActionMailer
- 帳號系統
  - Devise
  - Oauth(串接FB)

## 深入理解Model
- Migration：資料表遷移
  - Rails會把你對Model的操作反映到資料庫(database)中的資料表(table)
  - 但前提是你得讓資料庫與Rails中對model的理解一致
  - Rails用來管理資料庫的檔案就稱做Migration files
    - 而把變更從檔案套用到資料庫的行為就是migrate
  - migration檔案(位於`db/migrate/*`)
    - 記錄了要對資料庫進行甚麼樣的變更
    - 好處：可以進入版本控制系統，讓資料庫的樣式可以隨著Model檔案一起控管
      - 否則，你手動修改資料樣式不透過migration，就無法對資料庫的格式做控管了
    - 基本上你建立新Model的時候，Rails都會幫你產生migration檔案
```ruby
class CreateMyModels < ActiveRecord::Migration[5.0]
  def change
    create_table :my_models do |t|
      t.string :title, default: "DEFAULT TITLE", null: false
      t.integer :user_id, unique: true
      t.text :content, index: true
      t.timestamps
    end
  end
end
```
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
        - 商店 `has_many` 員工
        - 商店 `belongs_to` 店主
        - 員工 `belongs_to` 商店
      - 想要透過`owner.employees`來取的某一位店主旗下的所有店的所有員工
        - 在`owner.rb`ˋ中加入`has_many :employees, through: :shops`
    - 此外，`has_many :through`也可以拿來實現多對多
      - 注意！這功能在Rails 4.1.2以前有BUG，請更改`Gemfile`來更新Rails版本
        - 目前的版本為Rails 4.0.2 (注意，這需要Ruby版本2.1.0以上，PLUS主機不支援)
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
      ```ruby
      "aaaaaaa\nbbbbbbbbbb" =~ /^\w+$/         # return 0
      "aaaaaaa\nbbbbbbbbbb" =~ /\A\w+\z/       # return nil
      ```
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

## 寄信功能
- 很多時候網站會寄信給使用者，例如帳號建立通知等等
- Rails中可以方便的建立這樣的功能：使用`ActionMailer`
- 在啟用寄信功能之前，我們必須要先註冊一個免費的Email寄送服務(或者你自己有另外的SMTP也行)
  - 註冊[Mailgun](http://www.mailgun.com/)，每個月免費寄10000封信
  - 檢視你當前可以用的寄信domain：[View Domains](https://mailgun.com/app/domains)
  - Sandbox模式
    - 如果沒有設定自己的Domain，預設會是Sandbox模式，具有某些限制
    - 每天最多300封信
    - 收件者必須事先寫好(白名單)，只有認證過的收件者可以收到你寄出去的信
    - 設定新的收件者請到Sandbox的domain設定下找"Authorized Recipients"
    - 若要解除此，記得要"Add your domain" (需要設定MX record)
  - 以下範例以Sandbox模式作介紹，因此請先把幾個自己常用的Email加入"Authorized Recipients"
    - 注意，如果你帳號上面出現"Buiness Verification"，代表你需要聯絡mailgun的客服來啟用帳號
    - 如果真的遇到了，可以改用課程提供的練習用domain
- 設定ActionMailer
  - 修改`config/application.rb`，在`class Application`內加入
  ```ruby
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.mailgun.org',
    port: 587,
    domain: 'example.com',
    user_name: 'YOUR_MAILGUN_LOGIN_NAME',
    password: 'YOUR_MAILGUN_PASSWORD',
    authentication: 'plain',
    enable_starttls_auto: true
  }                                                                                                  }
  ```

- 新增`ActionMailer`
  - 假設每篇新增文章都會寄信通知
  - 新增一個mailer
  ```
  rails g mailer NotifyArticle
  ```
- 設定hostname，用於網址產生
  - 修改`config/environments/development.rb`，在block內加入
  ```ruby
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  ```
  - 若要部署到Heroku上，則要修改`config/environments/production.rb`，在block內加入
  ```ruby
  config.action_mailer.default_url_options = { host: 'APPLICATION_NAME.herokuapp.com' }
  ```
- 設定`ActionMailer`
  - 注意！在不同Rails版本中以下設定會有些微差異，這裡以`4.0.2`版本為主(PLUS主機的版本)
  - 其實類似一個小型的MVC，先執行action，再產生view
  - 定義寄信的action，修改：`app/mailers/notify_article.rb`
  ```ruby
  class NotifyArticle < ActionMailer::Base
    default from: "lctseng@cs.nctu.edu.tw"

    # 寫在這裡的方法都會成為類別方法，可以直接用NotifyArticle.notify_new_article來呼叫
    def notify_new_article(article, email)
      @article = article
      mail(to: email, :subject => "New Article")
    end
  end
  ```
  - 建立信件樣板，建立`app/views/notify_article/notify_new_article.html.erb`
  ```html
  <h1>有新文章!</h1>
  <p>網址：<%= article_url(@article) %></p>
  ```
    - 注意！不是用`article_path`，因為我們需要在信件中附上完整網址
  - 開始寄信，可以在`rails c`或`controller`中使用
  ```ruby
  article = Article.first
  NotifyArticle.notify_new_article(article, 'YOUR_AUTHORIZED_EMAIL@YOUR_DOMAIN').deliver
  ```
- 想在文章建立時寄信
  - 把他加入`articles_controller`的`create`中
  ```ruby
  def create
    @article = Article.new(article_params)
    if @article.save
      NotifyArticle.notify_new_article(@article, 'YOUR_AUTHORIZED_EMAIL@YOUR_DOMAIN').deliver
      redirect_to article_path(@article), notice: "Article was successfully created at #{fmt_time(Time.now)}."
    else
      flash[:error] = "Fail to create!"
      render action: :new                                                                                                             
    end
  end
  ```

## 帳號系統
- 目前我們已經有文章管理系統(CRUD)，就好比一個管理後台一樣
- 但這個管理後台誰都可以存取
- 建立帳號系統：只有登錄過的使用者可以存取後台
- Rails中最常使用的帳號管理系統：[devise](https://github.com/plataformatec/devise)
- 以下幾個步驟將帶大家建立一個能管理文章的使用者帳號系統
  - 先設定好網站的首頁位置，因為devise時常會重新導向到首頁
  ```ruby
  root to: "articles#index"
  ```
  - 安裝`devise`的gem：更改`Gemfile`，加上`gem 'devise'`，執行`bundle`
  - 初始化Devise：執行`rails g devise:install`，會產生Devise設定檔
  - 產生Devise要用的View：執行`rails g devise:views`
    - 此步驟非必要。但如果不使用這步驟，將無法客製化帳號系統相關頁面
  - 設定Devise的寄信設定，目前不會用到，但先設定起來確保Devise正常運作
    - 修改`config/environments/development.rb`，在block內加入
    ```ruby
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    ```
    - 若要部署到Heroku上，則要修改`config/environments/production.rb`，在block內加入
    ```ruby
    config.action_mailer.default_url_options = { host: 'APPLICATION_NAME.herokuapp.com' }
    ```
  - 建立管理員帳號的model：`Admin`
    - 需要使用Devise的特殊方法來建立model
    - `rails generate devise Admin`
    - 更新資料庫：`rake db:migrate`
  - 當建立好model之後，Devise會新增一條特殊的route：`devise_for :admins`
    - 用處：提供使用者登入、登出、建立帳號、修改帳號資料等功能
    - 使用`rake routs`或`pry`的`show-routes`可以看到這些：
    ```
            new_admin_session GET    /admins/sign_in(.:format)         devise/sessions#new
                admin_session POST   /admins/sign_in(.:format)         devise/sessions#create
        destroy_admin_session DELETE /admins/sign_out(.:format)        devise/sessions#destroy
               admin_password POST   /admins/password(.:format)        devise/passwords#create
           new_admin_password GET    /admins/password/new(.:format)    devise/passwords#new
          edit_admin_password GET    /admins/password/edit(.:format)   devise/passwords#edit
                              PATCH  /admins/password(.:format)        devise/passwords#update
                              PUT    /admins/password(.:format)        devise/passwords#update
    cancel_admin_registration GET    /admins/cancel(.:format)          devise/registrations#cancel
           admin_registration POST   /admins(.:format)                 devise/registrations#create
       new_admin_registration GET    /admins/sign_up(.:format)         devise/registrations#new
      edit_admin_registration GET    /admins/edit(.:format)            devise/registrations#edit
                              PATCH  /admins(.:format)                 devise/registrations#update
                              PUT    /admins(.:format)                 devise/registrations#update
                              DELETE /admins(.:format)                 devise/registrations#destroy
    ```
    - 主要的controller(都是Devise內建的)
      - `devise/sessions`：控制登入、登出的狀態
      - `devise/passwords`：忘記密碼時的處理
      - `devise/registrations`：帳號註冊相關
  - 啟用認證
    - 在需要進行認證的controller中，加入：`before_action :authenticate_admin!`
    - 例如修改：`articles_controller.rb`
    - 之後要存取文章列表時，就會看到登入的畫面
  - 取得當前的admin
    - 擁有了devise，最方便的方法之一就是可以判斷當前有沒有人登入
    - 可以使用`current_admin`來判斷
      - 如果是`Admin`這個model的instance，就是有登入的狀態
      - 如果是`nil`：代表當前沒有登入
    - 例如：在layout中加入歡迎訊息
      - 修改`views/layouts/application.html.erb`
      ```html
      <% if current_admin %>
        <h1>Welcome! <%= current_admin.email %></h1>
      <% end %>
      ```
  - 加入跟帳號有關的連結
    - 例如登出、修改密碼等欄位
    - 假設加在index頁面，修改`views/articles/index.html.erb`
    ```html
    <% if current_admin %>
      <%= link_to('登出', destroy_admin_session_path, :method => :delete) %> |
      <%= link_to('修改密碼', edit_registration_path(:admin)) %>
    <% else %>
      <%= link_to('註冊', new_registration_path(:admin)) %> |
      <%= link_to('登入', new_session_path(:admin)) %>
    <% end %>
    ```
  - 忘記密碼處理
    - 如果在上一個主題你有設定好mailer，那麼你的忘記密碼提示就可以使用
    - 記得修改`config/initializers/devise.rb`，約13行處
    ```ruby
     config.mailer_sender = 'me@gmail.com' # 改成一個有效的sender，收件者會看到這訊息
    ```
- Oauth(串接FB)
  - 不想建立自己的帳號系統，希望使用者使用第三方帳號(例如FB)登入
  - devise支援使用Oauth來做到第三方登入，可以參考[devise官方說明](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)
  - 以下簡單步驟將會讓你的文章管理系統支援FB登入
  - 申請FB開發人員的`APP_ID`與`APP_SECRET`
    - [FB 開發人員頁面](https://developers.facebook.com/apps/)，新增應用程式
    - 記得在底下"新增平台"中新增一個網站平台，並加入你的網址
      - 例如：`http://plus.nctu.edu.tw:3087`或`http://localhost:3000`
  - 修改`Gemfile`，新增`gem 'omniauth-facebook'`，並`bundle`
  - 新增Devise做FB認證時需要的資料庫欄位
    - 建立migration檔案：`rails g migration AddOmniauthToAdmins`
    - 修改該migration檔案並加入以下
    ```ruby
    def change
      add_column :admins, :provider , :string
      add_column :admins, :uid, :string
    end
    ```
    - 更新DB：`rake db:migrate`
  - 修改devise設定檔：`config/initializers/devise.rb`，加入以下，記得設定FB的認證資料
  ```ruby
  config.omniauth :facebook, "APP_ID", "APP_SECRET", scope: 'email', info_fields: 'email'
  ```
  - 修改`Admin` model：`models/admin.rb`
    - 在開頭開頭加入以下設定，來允許這個model可以接受FB登入：
    ```ruby
    devise :omniauthable, :omniauth_providers => [:facebook]
    ```
    - 新增一個FB登入用的類別方法：處理當FB資料回來的時候要如何建立這個新的Admin
    ```ruby
    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |admin|
        admin.email = auth.info.email # 這邊就是讀取該使用者的FB信箱
        admin.password = Devise.friendly_token[0,20]
      end
    end
    ```
  - 修改routes
    - 在原本的`devise_for`修改成以下：
    ```ruby
    devise_for :admins, :controllers => { :omniauth_callbacks => "admins/omniauth_callbacks" }
    ```
  - 建立controller
    - 新增資料夾：`app/controllers/admins`
      - 切換到專案根目錄，執行：`mkdir -p app/controllers/admins`
    - 新增 `app/controllers/admins/omniauth_callbacks_controller.rb`
    ``` ruby
    class Admins::OmniauthCallbacksController < Devise::OmniauthCallbacksController
      def facebook
        # 呼叫model中的方法：自FB建立admin
        @admin = Admin.from_omniauth(request.env["omniauth.auth"])

        if @admin.persisted?
          sign_in_and_redirect @admin, :event => :authentication
          # 顯示提示訊息
          set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        else
          # 如果無法從FB建立資料，就只好放棄並回到一般註冊畫面
          redirect_to new_admin_registration_url
        end
      end

      def failure
        redirect_to root_path
      end
    end
    ```
  - 之後在登入畫面應該會看到自動產生的"以FB登入"連結
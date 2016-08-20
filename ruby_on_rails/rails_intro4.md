# NCTU+ Rails入門課程 - 2016-08-20
- Lecturer: 曾亮齊(Henry Tseng)
- Email：
  - lctseng.nctuplus@cs.nctu.edu.tw
  - lctseng@5xruby.tw
- 部分教材 Credit to: 5xRuby.tw
- 本講義連結：https://url.fit/ZStzf

---

## 本次大綱
- 網站測試
- 使用RSpec
- 測試Model
- 測試Controller
- 整合測試

## 網站測試
- 為何需要測試？
  - 怕網頁寫錯
  - 小型的個人開發專案：你可以自己每一頁都試試看
  - 大型的團隊開發專案：曠日費時，且你無法知道其他工程師的網頁要怎麼測試
- 自動化測試
  - 把你平常拿來測試網頁是否正常運行的動作寫成程式，自動運行
  - 不同的工程師，將不同的網頁部分寫成不同的測試檔
    - 其他工程師只需要跑測試確定沒錯誤就好，不需要了解其內容

## 使用RSpec
- RSpec為Rails圈中著名的測試框架
- 環境設置
  - 安裝所需要的Gem，更改`Gemfile`加入以下，並執行`bundle`
  ```ruby
  gem 'rspec-rails' # RSpec框架，主要針對MVC框架測試
  gem 'capybara' # 進行功能測試或整合測試(包含使用者互動)
  gem 'factory_girl_rails' # 產生測試用的資料
  gem 'faker' # 產生假資料供測試使用
  gem 'rails-controller-testing'
  ```
  - 產生RSpec設定檔：`rails g rspec:install`
  - 產生rspec binstub：`bundle binstub rspec-core`
  - 建立測試用的DB：`rake db:migrate RAILS_ENV=test`
    - RSpec執行時不使用一般的development資料庫，而是使用特殊的test資料庫
    - test資料庫在每次重新執行測試時都會清空，確保測試正常
  - 視情況調整`config/environments/test.rb`
    - 過去我們曾修改`config/environments`內的`development.rb`與`production.rb`
    - 現在，我們必須要把類似的設定加入在`test.rb`中
    - 例如，在`test.rb`內補上這一行：
    ```
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    ```
  - 產生完後，試著使用`rspec`指令，確認指令正常
  ```
  No examples found.

  Finished in 0.00024 seconds (files took 1.22 seconds to load)
  0 examples, 0 failures
  ```
  - 此外，我們也可以移除專案底下的`test`資料夾，因為用不到了
- RSpec怎麼寫
  - 大多數的測試其實都差不多
  - 就好比模擬使用者實際操作一樣
  - 大致流程
    1. 設定已存在的資料，例如在資料庫中建立該使用者的帳號
    2. 設定使用者操作：例如瀏覽某網址、填表單、按送出
    3. 檢查結果是否滿足預期：例如在正確輸入資料的情況下，執行完create應該會有新資料產生
  - 由於RSpec從功能上一一細講會非常繁雜，因此我們直接從範例下手

## Model測試
- 測試 Validator
  - 一般來說，最常被手動測試的就是資料的validator
  - 當model數量多的時候，我們需要自動化測試他們
  - 假設我們有以下測試：
    - 文章的標題(title)不可以為空、必須唯一、長度限制在5~20字
    ```ruby
    validates :title, presence: true, uniqueness: true, length: { in: 5..20 }
    ```
  - 建立第一個rspec：`rails g rspec:model Article`
    - 這會產生一個rspec檔案`spec/models/article_spec.rb`，我們要把測試寫在這裡
  - 修改該檔案，加入以下來分別驗證這些條件
  ```ruby
  require 'rails_helper'

  RSpec.describe Article, type: :model do
    # 驗證是否沒填title
    it "is invalid without a title" do
      # 建立一個應當失敗的article
      article = Article.new(title: nil)
      # 手動執行驗證
      result = article.valid?
      # 預期驗證結果會是false，這行其實非必要
      expect(result).to be false
      # 預期會出現title can't be blank的錯誤訊息
      expect(article.errors[:title]).to include "can't be blank"
    end
    # 驗證是title不能重複
    it "is invalid when title is duplicated" do
      # 第一篇文章先存到資料庫
      article_1 = Article.create(title: "Hello")
      # 預期第一篇文章不是new_record?，因為需要存在資料庫
      # 註：be_new_record是魔術語法，會自動呼叫new_record?
      #    此行相當於expect(article_1.new_record?).to be false
      #    也可以用另外的寫法：expect(article_1).not_to be_a_new(Article)
      expect(article_1).not_to be_new_record
      # 第二篇文章先不存
      article_2 = Article.new(title: "Hello")
      # 手動執行第二篇文章的驗證，應該要失敗
      result = article_2.valid?
      expect(result).to be false
      # include：前面的陣列是否包含後面的物件
      expect(article_2.errors[:title]).to include "has already been taken"
    end
    # 驗證title的長度
    it "is invalid when title length is not in 5..20" do
      # 太短
      article = Article.new(title: "a"*3)
      result = article.valid?
      expect(result).to be false
      expect(article.errors[:title]).to include "is too short (minimum is 5 characters)"

      # 太長
      article = Article.new(title: "a"*25)
      result = article.valid?
      expect(result).to be false
      expect(article.errors[:title]).to include "is too long (maximum is 20 characters)"
    end
  end
  ```
  - 執行驗證
    - 在專案跟目錄下，使用`rspec`指令，此指令會執行專案中所有測試檔
    - 如果只想要執行某一份檔案，可以加上檔名
      - 例如：`rspec spec/models/article_spec.rb`
    - 如果只想執行某一份檔案內的某一條測試，可以加上行數
      - 會執行該行數所在的測試區塊(例如`it`的do-end所包含的區域)
      - 例如：`rspec spec/models/article_spec.rb:35`
    - 特殊快捷鍵
      - 如果你使用課程虛擬機，或者是有安裝lctseng的環境設定檔，且使用VIM編輯器時
      - 指令模式下，按下`,`再按`.`，可以直接測試游標所在的行
      - 按下`,`再按`m`，可以測試該份檔案
      - 按下`,`再按`a`，可以測試本專案內所有測試檔
- 測試 Scope
  - 還記得我們用Scope來篩選特定條件資料嗎？
  - 我們可以用RSpec來檢查我們的Scope有沒有正確撈出想要的資料
  - 例如：測試`is_hot`
    - 當初的scope寫法是：
    ```ruby
    scope :is_hot, -> (value) { where(is_hot: value) }
    ```
    - 我們可以在`spec/models/article_spec.rb`的`RSpec.describe`do-end區塊內繼續新增
    ```ruby
    # 驗證Scope: is_hot
    it "returns all articles with is_hot is same as parameters" do
      hot_article = Article.create(title: "Hot Article 1", is_hot: true)
      another_hot_article = Article.create(title: "Hot Article 2", is_hot: true)
      poor_article = Article.create(title: "Poor Article", is_hot: false)
      # 預期is_hot(true)撈出來的文章只會有hot_article與another_hot_article
      # match_array檢查陣列內容是否相同，無視順序
      expect(Article.is_hot(true)).to match_array [hot_article, another_hot_article]
      # 預期is_hot(false)撈出來的只會有poor_article
      expect(Article.is_hot(false)).to match_array [poor_article]
    end
    ```
- 測試實體方法
  - 我們可以在model中加入一些實體方法，讓我們可以在controller或view中呼叫
    - 例如：讓`Article`可以一口氣回傳標題與內容的合併字串
    ```ruby
    # 在app/models/article.rb中
    class Article < ActiveRecord::Base
      def full_content
        "Title: #{title}\nContent: #{content}"
      end
    end
    ```
    - 之後我們就可以使用`article.full_content`來取得該文章的標題加內容
  - 若要用RSpec來測試上述功能，其實非常簡單
  ```ruby
  # 驗證#full_message
  it "concatenates the title and the content" do
    article = Article.new(title: "Hello", content: "World")
    expect(article.full_content).to eq "Title: Hello\nContent: World"
  end
  ```
  - **注意** 這裡不能用`to be`而是要用`to eq`
    - 因為`to be`會檢查前後物件是不是同一個，也就是`object_id`是否相同
    - 之前提過，即使內容相同，字串每次的`object_id`都不同，因此不能用`to be`
    - 使用`to eq`來進行內容的相等比較
- 使用假資料協助測試：`FactoryGirl`與`Faker`
  - 上述測試中，我們不斷使用`Article.create`或`Article.new`來建立假資料，
    雖然不是不行，但我們有更方便的做法
  - 使用`FactoryGirl`可以幫助我們把資料產生簡化
    - 目的：把產生資料的動作集中起來，包成方法來呼叫，避免在測試檔中花太多篇幅
      - 尤其當你需要非常多假資料的時候，例如要快速產生100筆不同的Article
      - 配合`Faker`，可以產生看起來有意義的假資料。可參考[Faker官網](https://github.com/stympy/faker)
    - 建立專門產生`Article`假資料的產生器
      - 檔案：`spec/factories/articles.rb`
      - 其實當你使用`rails g rspec:model Article`的時候，就會幫你產生了
    - 根據上述測試，我們需要的產生器有
      - 正常資料
      - 缺少title
      - title字數不對(太長 或 太短)
  - 可以修改該檔案的內容為：
  ```ruby
  FactoryGirl.define do
  	factory :article do
      # 一般資料
      title { Faker::Lorem.characters(10) }
      content { Faker::Pokemon.name }
      # 使用trait：定義特殊資料的情況
      # 沒有在trait中指明的欄位，會沿用最外層的設定(例如content)
      # 缺少title的資料
      trait :nil_title do
  		    title nil
      end
      # title太短的資料
      trait :short_title do
  		    title { Faker::Lorem.characters(3) }
      end               
      # title太長的資料
      trait :long_title do
  		    title { Faker::Lorem.characters(21) }
      end
    end
  end
  ```
  - 之後就可以在RSpec或`rails c`中使用
  ```ruby
  # 產生假資料，不儲存資料庫
  FactoryGirl.build(:article)
  # 產生假資料，並儲存到資料庫
  FactoryGirl.create(:article, :long_title)
  ```
  - 改寫剛才範例中的長度驗證，改用`FactoryGirl`
  ```ruby
  # 驗證title的長度
  it "is invalid when title length is not in 5..20" do
    # 太短
    article = FactoryGirl.build(:article, :short_title)
    result = article.valid?
    expect(result).to be false
    expect(article.errors[:title]).to include "is too short (minimum is 5 characters)"

    # 太長
    article = FactoryGirl.build(:article, :long_title)
    result = article.valid?
    expect(result).to be false
    expect(article.errors[:title]).to include "is too long (maximum is 20 characters)"
  end
  ```
  - 嫌打太多字？如果有在`spec/rails_helper.rb`中加入
  ```ruby
  config.include FactoryGirl::Syntax::Methods
  ```
  - 就可以在RSpec中用`create`取代`FactoryGirl.create`
    - 同理可用`build`取代`FactoryGirl.build`
  - 使用`context`與`describe`
    - 可以進行分群，把`it`分成不同有意義的群組
    - 例如：資料驗證分一群，Scope分一群，實體方法驗證分一群
    - 分群後，使用行號進行測試時，可以指定某一個分群來執行底下的所有測試
    - 基本上`context`與`describe`作用相同，語句通順就好
    - 進行分群改寫後(僅擷取部分)：
    ```ruby
    RSpec.describe Article, type: :model do
      context "data validation"  do
        # 驗證是否沒填title
        it "is invalid without a title" do
          article = Article.new(title: nil)
          # 手動執行驗證
          result = article.valid?
          # 預期驗證結果會是false，這行其實非必要
          expect(result).to be false
          # 預期會出現title can't be blank的錯誤訊息
          expect(article.errors[:title]).to include "can't be blank"
        end
      end

      context "scope" do
        # 驗證Scope: is_hot
        it "returns all articles with is_hot is same as parameters" do
          hot_article = Article.create(title: "Hot Article 1", is_hot: true)
          another_hot_article = Article.create(title: "Hot Article 2", is_hot: true)
          poor_article = Article.create(title: "Poor Article", is_hot: false)
          # 預期is_hot(true)撈出來的文章只會有hot_article與another_hot_article
          expect(Article.is_hot(true)).to match_array [hot_article, another_hot_article]
          # 預期is_hot(false)撈出來的只會有poor_article
          expect(Article.is_hot(false)).to match_array [poor_article]
        end
      end

      context "instance method" do
        # 驗證#full_message
        it "concatenates the title and the content" do
          article = Article.new(title: "Hello", content: "World")
          expect(article.full_content).to eq "Title: Hello\nContent: World"
        end
      end
    end
    ```

## Controller測試
- 暫時移除帳號認證系統，測試CRUD的各項行為
  - 由於帳號系統(Devise)會妨礙我們測試，我們先將所有的認證功能拔除
  - 暫時註解掉`before_action :authenticate_admin!`
- 測試CRUD的方法：送參數給controller，並然後通常會檢查以下：
  - 檢查產生的view是不是我們指定的那幾個
    - 例如`create`完之後要回到`show`，失敗則要顯示`new.html.erb`
  - 資料庫中的資料數量使否正確
    - 例如`create`會增加一筆；`destroy`會減少一筆
  - 資料的實體變數是否有成功在action中被設定
    - 例如`show`會產生`@article`，`index`會產生`@articles`
    - 資料內容的變化也可以測試，例如`update`會更新資料
- 產生用來寫測試程式的檔案：`rails g rspec:controller articles`
  - 這會產生`spec/controllers/articles_controller_spec.rb`
- 我們先把七個action所需要測試的部分列出來，並寫成RSpec
  - 這些測試會用個別的`it`來寫，而他們都會被一個屬於這個action的`describe`所包含
  ```ruby
  RSpec.describe ArticlesController, type: :controller do
    describe 'GET #show' do
      # 把params指定的article存到實體變數
      it "assigns the requested article to @article"
      # 產生show.html.erb
      it "renders the :show template"
    end

    describe 'GET #index' do
      # 把所有文章存成陣列：@articles
      it "populates an array of all articles"
      # 產生index.html.erb
      it "renders the :index template"
    end

    describe 'GET #new' do
      # 產生新的Article並存到@article
      it "assigns a new Article to @article"
      # 產生new.html.erb
      it "renders the :new template"
    end

    describe 'GET #edit' do
      # 把params指定的article存到實體變數
      it "assigns the requested article to @article"
      # 產生edit.html.erb
      it "renders the :edit template"
    end

    describe "POST #create" do
      # 資料參數正確的情況，有通過validation
      context "with valid attributes" do
        # 將新文章存到資料庫
        it "saves the new article in the database"
        # 重新導向到該文章的show頁面
        it "redirects to articles#show"
      end
      # 資料錯誤，沒通過validation
      context "with invalid attributes" do
        # 不將該文章存到資料庫
        it "does not save the new article in the database"
        # 再顯示一次new.html.erb
        it "re-renders the :new template"
      end
    end

    describe 'PATCH #update' do
      # 資料正確
      context "with valid attributes" do
        # 更新原本的那一筆資料
        it "updates the article in the database"
        # 重新導向到show
        it "redirects to the articles#show"
      end
      # 資料錯誤
      context "with invalid attributes" do
        # 資料庫中的文章不能被更新
        it "does not update the article"
        # 再顯示一次edit
        it "re-renders the :edit template"
      end
    end

    describe 'DELETE #destroy' do
      # 把該筆文章從資料庫中移除
      it "deletes the article from the database"
      # 回到index頁面
      it "redirects to articles#index"
    end
  end
  ```
- 測試`show`
  - 把`describe "GET #show"`的內容補齊
  ```ruby
  describe "GET #show" do
    # 是否有根據`params[:id]`設定實體變數：`@article`
    it "assigns the requested article to @article" do
      # 先建立一個article，當作輸入也當作比對用的答案
      article = create(:article)
      # 以動詞get執行action：show，params則是用article.id代入id
      get :show, id: article.id # article.id在這裡可以用article代替就好
      # 比對答案
      # assigns(:article)代表在controller中的 @article實體變數
      expect(assigns(:article)).to eq article
    end
    # 是否有顯示`show.html.erb`
    it "renders the show.html.erb" do
      article = create(:article)
      get :show, id: article.id # article.id在這裡可以用article代替就好
      # response相當於產生的網頁內容
      expect(response).to render_template :show
    end
  end
  ```
- 測試`index`
  - 補齊`describe 'GET #index'`
  ```ruby
  describe 'GET #index' do
    # 把所有文章存成陣列：@articles
    it "populates an array of all articles" do
      # 建立兩筆資料，必須確定title不重複
      # 因此需要自己指定不重複的title
      article_1 = create(:article, title: "title1")
      article_2 = create(:article, title: "title2")
      # 執行action
      get :index
      # 檢查陣列
      expect(assigns(:articles)).to match_array [article_1, article_2]
    end
    # 產生index.html.erb
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end
  ```
- 測試`new`
  - 補齊`describe 'GET #new'`
  ```ruby
  describe 'GET #new' do
    # 產生新的Article並存到@article
    it "assigns a new Article to @article" do
      get :new
      expect(assigns(:article)).to be_a_new Article
    end
    # 產生new.html.erb
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end
  ```
- 測試`edit`
  - 補齊`describe 'GET #edit'`
  ```ruby
  describe 'GET #edit' do
    # 類同show
    # 把params指定的article存到實體變數
    it "assigns the requested article to @article" do
      article = create(:article)
      get :edit, id: article.id
      expect(assigns(:article)).to eq article
    end
    # 產生edit.html.erb
    it "renders the :edit template" do
      article = create(:article)
      get :edit, id: article.id
      expect(response).to render_template :edit
    end
  end
  ```
- 測試`create`
  - 藉由檢查資料庫的資料數量(`Article.count`)來判斷有無存到資料庫中
  - 補齊`describe 'POST #create'`
  ```ruby
  describe "POST #create" do
    # 資料參數正確的情況，有通過validation
    context "with valid attributes" do
      # 將新文章存到資料庫
      it "saves the new article in the database" do
        # 說明：attributes_for與build類似，只是前者不會產生model本身
        #      而是產生用來建立model的參數
        #      其實build(:article)就相當於Article.new(attributes_for(:article))
        # 說明：在這裡的expect使用block的方式，
        #      可以用來檢查某件事情做完之後，有沒有改變某個事實
        expect {
          post :create, article: attributes_for(:article)
        }.to change(Article, :count).by 1
      end
      # 重新導向到該文章的show頁面
      it "redirects to articles#show" do
        post :create, article: attributes_for(:article)
        # Recall：使用assigns(:article)取得在controller內被定義的實體變數：@article
        expect(response).to redirect_to article_path(assigns(:article))
      end
    end
    # 資料錯誤，沒通過validation
    context "with invalid attributes" do
      # 不將該文章存到資料庫
      it "does not save the new article in the database" do
        #這裡利用空title來引發資料錯誤
        expect {
          post :create, article: attributes_for(:article, :nil_title)
        }.not_to change(Article, :count)
      end
      # 再顯示一次new.html.erb
      it "re-renders the :new template" do
        post :create, article: attributes_for(:article, :nil_title)
        expect(response).to render_template :new
      end
    end
  end
  ```
- 測試`update`
  - 補齊`describe 'PATCH #update'`
  ```ruby
  describe 'PATCH #update' do
    # 資料正確
    context "with valid attributes" do
      # 更新原本的那一筆資料
      it "updates the article in the database" do
        article = create(:article)
        patch :update, id: article.id, article: attributes_for(:article,
          title: "Hello", content: "World")
        # 重新再從資料庫中撈出article的欄位資料
        article.reload
        # 驗證各欄位是不是有正確改變
        expect(article.title).to eq "Hello"
        expect(article.content).to eq "World"
      end
      # 重新導向到show
      it "redirects to the articles#show" do
        article = create(:article)
        patch :update, id: article.id, article: attributes_for(:article,
          title: "Hello", content: "World")
        expect(response).to redirect_to article_path(article)
      end
    end
    # 資料錯誤
    context "with invalid attributes" do
      # 資料庫中的文章不能被更新
      it "does not update the article" do
        article = create(:article, title: "Old Title")
        patch :update, id: article.id, article: attributes_for(:article,
          title: "FAIL", content: "New Content")
        article.reload
        # 驗證各欄位是不是沒有改變
        expect(article.title).to eq "Old Title"
        expect(article.content).not_to eq "New Content"
      end
      # 再顯示一次edit
      it "re-renders the :edit template" do
        article = create(:article, title: "Old Title")
        patch :update, id: article.id, article: attributes_for(:article,
          title: "FAIL", content: "New Content")
        expect(response).to render_template :edit
      end
    end
  end
  ```
- 測試`destroy`
  - 補齊`describe 'DELETE #destroy'`
  ```ruby
  describe 'DELETE #destroy' do
    # 把該筆文章從資料庫中移除
    it "deletes the article from the database" do
      article = create(:article)
      expect {
        delete :destroy, id: article
      }.to change(Article, :count).by -1
    end
    # 回到index頁面
    it "redirects to articles#index" do
      article = create(:article)
      delete :destroy, id: article
      expect(response).to redirect_to articles_path
    end
  end
  ```
- 完成以上測試以後，可以直接執行`rspec`，檢測所有的測試檔是否都通過
- 在有帳號認證系統的情況下測試
  - 由於我們有使用`devise`，因此我們也希望可以測試登入與不登入的情況
  - 目前僅驗證一般帳號登入，FB登入這裡先不提
  - 開始之前，記得把登入驗證`before_action :authenticate_admin!`復原
  - 設定Devise驗證，請在`spec/rails_helper.rb:`中修改：
    - 在第7行`require 'rspec/rails'`之後，加入`require 'devise'`
    - 在第30行之後的`RSpec.configure`的block內，加入：
    ```ruby
    config.include Devise::TestHelpers, :type => :controller
    ```
- 設定`Admin`的`FactoryGirl`，來產生admin的假資料
  - 手動建立：`spec/factories/admin.rb`
  ```ruby
  FactoryGirl.define do
    factory :admin do
      email { Faker::Internet.email }
      password "password"
      password_confirmation "password"
    end
  end
  ```
- 之後就可以使用`sign_in admin`來登入某一個管理員
  - 由於我們每一條action都要登入管理員，換句話說，每個`it`都要寫
  ```ruby
  sign_in create(:admin)
  ```
  - 顯然這太麻煩了，有沒有辦法像`before_action`那樣呢？
  - 答案是肯定的，可以使用`before`功能
  - RSpec的`before`是利用`context`區別作用範圍的
    - 也就是那個包含`before`的`context`，其下的`it`才會受到`before`影響
  - 將已登入與未登入的兩個情況區分成不同的`context`
  ```ruby
  require 'rails_helper'

  RSpec.describe ArticlesController, type: :controller do
    # 已登入的情況
    context "already sign in" do
      before do
        sign_in create(:admin)
      end
      # 測試是不是可以使用current_admin
      it "should have a current_admim" do
        # subject: 用來測試那些可以在controller內使用的方法，包含helper等
        expect(subject.current_admin).not_to eq nil
      end
      # 以下是原本的describe內容
      describe "GET #show" do
        # 原本的內容
      end
      # ...其他內容...
    end
    # 沒登入的情況
    context "haven't signed in" do
      # 任何action都應該回到登入頁面
      # 這裡只示範檢查index，事實上你應該要檢查每一個action是不是都符合預期
      describe 'GET #index' do
        it "should rediret to login page" do
          get :index
          expect(response).to redirect_to new_admin_session_path
        end
      end
    end
  end
  ```
## 整合測試(feature test)
- 為何需要整合測試？
  - 上述的model測試與controller測試都算是個別測試
  - 網站功能是否健全，仍需要真正模擬使用者操作
  - 整合測試可以用更接近使用者操作的語法，來寫自動測試
- 範例：測試登入並期待看到所有文章的列表
  - 產生測試檔：`rails g rspec:feature articles`
  - 編輯：`spec/features/articles_spec.rb`
  ```ruby
  require 'rails_helper'

  RSpec.feature "Articles", type: :feature  do     
    scenario "login and list articles" do        
      # 先建立一個管理員，讓之後可以登入使用
      admin = create(:admin)
      # 前往列出文章的頁面
      visit articles_path
      # 此時應該會被導到登入頁面，因此期待看到Log in字樣
      expect(page).to have_content "Log in"
      # 填寫登入資訊
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      # 送出
      click_button 'Log in'
      # 期待可以看到列出文章的目錄
      expect(current_path).to eq articles_path
      # 其實根目錄也就是列出使用者的畫面
      # 因此應該可以看到"<h1>Listing Articles</h1>"的字樣
      within 'h1' do
        # 在h1的範圍內進行檢查
        expect(page).to have_content "Listing Articles"
      end
    end
  end
  ```
- 整合測試的範圍很廣，這裡只做一個最簡單的範例
- RSpec基本的整合測試不支援JavaScript的互動
  - 如果需要測試前端JavaScript的功能，就要使用`Selenium`這個功能來配合
  - 更多有關JS測試的資料，可以參考[這裡](https://github.com/jnicklas/capybara#selenium)
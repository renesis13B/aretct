# Aretct

**Aretct**はオーナーが自ら仕入れた化粧品やアクセサリーを販売できるECサイトです


## 概要
DB作成から考え、haml、Sass(BEM設計)、JavaScript、jQuery、MySQL、AWSなどwebアプリケーション作成の土台となる言語を活用して実装しました。正規化表現によるrインクリメンタルサーチ、API、非同期更新、自動更新の機能がついています。

**テスト用アカウント**

[email] testuser1@gmail.com

[password] testusertestuser


## 機能
* ユーザー認証機能(gem devise)
* お気に入り機能
* 商品購入機能(Stripe)

## 技術
* amazonS3への画像アップロード
* AWS EC2
* Capistranoを利用した自動デプロイ
* Ajaxを利用したインクリメンタルサーチ・非同期通信・自動更新


## 言語・フレームワーク
ruby 2.3.1
Rails 5.0.7.2


# Aretct

**Aretct**はオーナーが自ら仕入れた化粧品やアクセサリーを販売できる架空のECサイトです。


## 概要
Aretctは、**オーナー用アプリ**と**ユーザー用アプリ**で構成されてます。

**オーナー用アプリ**では販売したい商品のカテゴリと商品詳細の管理を行う事ができます。

それぞれカテゴリー編集機能、商品編集機能が用意されおり、

オーナー自らでスマートフォン上から商品管理(追加・変更・削除)ができます。

**ユーザーアプリ**では、オーナーが追加・編集した商品を閲覧することができます。

また、ユーザーは新規会員登録 or ログインする事により選んだ商品をお気に入り登録や購入することができます。

### ユーザーテスト用アカウント
職務経歴書の制作物欄に記載

### 管理オーナーテスト用アカウント
職務経歴書の制作物欄に記載


## 画面構成
![管理オーナー側全体構成図](https://user-images.githubusercontent.com/27562468/66298770-38f6a880-e92d-11e9-84dc-115cdfb14e02.png)
![ユーザー側構成図](https://user-images.githubusercontent.com/27562468/66298789-42801080-e92d-11e9-99c9-bc77c2ff8989.png)


## 機能
**管理オーナー用**
* カテゴリー追加・編集機能(Firebase Database・Firebase Strage)
* 商品追加・編集機能(Firebase Database・Firebase Strage)

**ユーザー用**
* ユーザー認証機能(Firebase Authentication)
* カテゴリー一覧表示機能
* 商品一覧・商品詳細表示機能
* お気に入り表示・追加・削除機能
* カート追加・購入機能(Stripe)

## 技術
* Firebase Authentication(ユーザー認証)
* Firebase Database(データベース)
* Firebase Strage(ストレージ)
* XCTest(UIテスト)
* Bitrise(自動テスト)
* Stripe(決済API)
* Kingfisher(画像ダウンロード、キャッシュ)


## 言語・フレームワーク
Xcode 10.3
Swift 5.0.1


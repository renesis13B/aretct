# Aretct

**Aretct**はオーナーが自ら仕入れた化粧品やアクセサリーを販売できる架空のECサイトです。


## 概要
Aretctは、オーナー用アプリとユーザー用アプリで構成されてます。

オーナー用アプリでは販売したい商品のカテゴリと商品詳細の管理を行う事ができます。
それぞれカテゴリー管理・編集機能、商品詳細追加・編集機能が用意されおり、
オーナー自らでスマートフォン上から商品管理ができます。

ユーザーアプリでは、オーナーが追加・編集した商品を閲覧することができます。
また、ユーザーは新規会員登録 or ログインする事により選んだ商品をお気に入り登録や購入することができます。

**テスト用アカウント**

[email] joe@test.com
[password] 123123
※テスト用アカウントにはダミーのクレジットカードが登録されております。

## 機能
**管理オーナー用**
* カテゴリー追加・編集機能(Firebase Database・Firebase Strage)
* 商品追加・編集昨日(Firebase Database・Firebase Strage)

**ユーザー用**
* ユーザー認証機能(Firebase Authentication)
* カテゴリー一覧表示機能
* 商品一覧・商品詳細表示機能
* お気に入り表示・追加・削除機能
* カート追加・購入機能(Stripe)

## 技術
* Firebase Authentication
* Firebase Database
* Firebase Strage
* Stripe
* Kingfisher


## 言語・フレームワーク
Xcode 10.3
Swift 5.0.1


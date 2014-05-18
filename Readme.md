Germ - Package Manager for Ukagaka Develop
==========================================

Germは伺か開発のためのパッケージマネージャです。

インストール
----------------------------------------

    npm install https://github.com/Narazaka/germ/tarball/master

注意
----------------------------------------

人柱版です。

初回版だしアンインストール時にHDDを綺麗にするようなバグがあるかもしれません(ﾈｰﾖ……たぶん

使い方
----------------------------------------

とりあえずコマンドを実行してみてください。

    germ search test
    germ info test
    germ install test
    germ remove test
    germ get test

install/remove/search/info/getをとりあえず実装しました。

リポジトリはとりあえず[http://germ.narazaka.net/](http://germ.narazaka.net/)に静的ファイルでおいてます。

### install

install時にカレントフォルダかその上の階層にinstall.txtがあれば、そこをゴーストのルートフォルダと認識します。
そしてそこをルートとしてpackage.txtのplaceエントリにある位置にZIPを解凍します。

そうでない場合はカレントフォルダに解凍するわけですが、narとかだと最上位フォルダ作られずにどばぁーっと出るからうぁーとなるかも。
でもremoveで元に戻るはず。

名前
----------------------------------------

Rubyのgemと似てる（ぉ

短い名前をmateria, embryoから考えて辞書で引いたらこうなったです。。。

ライセンス
--------------------------

このソフトウェアにはApacheライセンスのソフトウェアrequestが使われています。

[MITライセンス](http://narazaka.net/license/MIT?2014)の元で配布いたします。

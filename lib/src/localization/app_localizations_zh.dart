// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appname => 'ToutCas';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get appearance => '外观';

  @override
  String get general => '常规';

  @override
  String get about => '关于';

  @override
  String get appName => '应用名称';

  @override
  String get slogan => '标语';

  @override
  String get version => '版本';

  @override
  String get light => '日间模式';

  @override
  String get dark => '夜间模式';

  @override
  String get newChat => '新建聊天';

  @override
  String get newTab => '新建标签页';

  @override
  String get burn => '即焚';

  @override
  String get askToutCas => '问问ToutCas';

  @override
  String get askToutCasOrEnterAURL => '问问ToutCas或输入一个网址';

  @override
  String get model => '模型';

  @override
  String get askAnything => '询问任何问题';

  @override
  String get attachFile => '添加文件';

  @override
  String get inUse => '正在使用';

  @override
  String get aigreetings => '您好！我是 ToutCas，今天有什么可以帮到您的吗？';

  @override
  String get aiprompt1 =>
      '您是 ToutCas，一款集成在网页浏览器应用程序中的实用人工智能助手。根据网页浏览上下文，为用户查询提供简洁明了且相关的答案。始终保持友好专业的语气。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appname => 'ToutCas';

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get appearance => '外觀';

  @override
  String get general => '常規';

  @override
  String get about => '關於';

  @override
  String get appName => '名稱';

  @override
  String get slogan => '標語';

  @override
  String get version => '版本';

  @override
  String get light => '日間模式';

  @override
  String get dark => '夜間模式';

  @override
  String get newChat => '新建聊天';

  @override
  String get newTab => '新標籤頁';

  @override
  String get burn => '燒毀';

  @override
  String get askToutCas => '詢問ToutCas';

  @override
  String get askToutCasOrEnterAURL => '詢問ToutCas或輸入網址';

  @override
  String get model => '模型';

  @override
  String get askAnything => '詢問任何問題';

  @override
  String get attachFile => '附加檔案';

  @override
  String get inUse => '正在使用';

  @override
  String get aigreetings => '您好！我是 ToutCas，今天有什麼可以幫到您的嗎？';

  @override
  String get aiprompt1 =>
      '您是 ToutCas，一款整合在網頁瀏覽器應用程式中的實用人工智慧助理。根據網頁瀏覽上下文，為使用者查詢提供簡潔明了且相關的答案。始終保持友好專業的語氣。';
}

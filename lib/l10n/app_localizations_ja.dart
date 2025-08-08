// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ARC ロボット';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsMenu => '設定';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get language => '言語';

  @override
  String errorPkg(Object pkg) {
    return 'エラー: 「$pkg」パッケージが見つかりません。';
  }

  @override
  String get errorPkgList => '次のパッケージが見つかりませんでした:';

  @override
  String get errorPkgListTitle => '不足しているROSパッケージ';

  @override
  String get packagePath => 'パッケージのパス：';

  @override
  String get packagePathTitle => 'ROSパッケージのパス';

  @override
  String get packageInputManually => '手動でパスを入力するにはクリックしてください';

  @override
  String packageInputManuallyTitle(Object pkg) {
    return '\'$pkg\' のパスを設定';
  }

  @override
  String get packageInputManuallyHint => '/path/to/package';

  @override
  String get packagePathNoOverwrite => '起動時にパスの値を上書きしない';

  @override
  String get sourceSystem => 'システムから検出されました';

  @override
  String get sourcePrefs => '保存された設定から読み込みました';

  @override
  String get sourceMissing => '見つかりませんでした';

  @override
  String get packagePathNoOverwriteTooltip => '起動時にシステムをチェックする代わりに保存されたパスを使用します（見つからないパスは引き続きチェックされます）。';

  @override
  String get parametersSavedTitle => 'パラメータが保存されました';

  @override
  String get description => '説明：';

  @override
  String get parameters => 'パラメータ';

  @override
  String get saveParametersButton => '新しいパラメータを保存';

  @override
  String get noParameters => '表示するパラメータがありません。選択してください。';

  @override
  String get noPathButtonTooltip => 'パスが指定されていないため、インストールできません';

  @override
  String get installButtonTooltip => 'インストールウィザードを開く';

  @override
  String get noSelection => '選択なし';

  @override
  String get advancedSettings => '詳細設定';

  @override
  String get rosPath => 'ROS2 実行ファイルのパス';

  @override
  String get rosPathTooltip => 'ROS2 がすでにシステムの PATH に含まれている場合は \'ros2\' とだけ記述できます。それ以外の場合はフルパスを指定してください。';

  @override
  String get robotTitle => 'ロボット';

  @override
  String get robotMenu => 'ロボット';

  @override
  String get selectRobotList => 'ロボットを選択してください';

  @override
  String get errorNoRobotListPath => 'ロボットコントローラーへのパスが定義されていません。ロボットリストを取得できません。';

  @override
  String get errorNoRobotList => 'パスが存在しないか、ロボットコントローラーが見つかりませんでした。';

  @override
  String get pleaseSelectRobot => 'ロボットを選択してください';

  @override
  String get installRobotButton => 'ロボットをインストール';

  @override
  String get communicationTitle => '通信インターフェース';

  @override
  String get communicationMenu => '通信';

  @override
  String get selectCommunicationList => '通信インターフェースを選択してください';

  @override
  String get errorNoCommunicationListPath => '通信インターフェースへのパスが定義されていません。リストを取得できません。';

  @override
  String get errorNoCommunicationList => 'パスが存在しないか、通信インターフェースが見つかりませんでした。';

  @override
  String get pleaseCommunicationRobot => 'インターフェースを選択してください';

  @override
  String get installCommunicationButton => 'インターフェースをインストール';

  @override
  String get videoTitle => '映像ストリーミングプロトコル';

  @override
  String get videoMenu => '映像';

  @override
  String get selectVideoList => '映像ストリーミングプロトコルを選択してください';

  @override
  String get errorNoVideoListPath => '映像プロトコルへのパスが定義されていません。リストを取得できません。';

  @override
  String get errorNoVideoList => 'パスが存在しないか、映像ストリーミングプロトコルが見つかりませんでした。';

  @override
  String get pleaseVideoRobot => 'プロトコルを選択してください';

  @override
  String get installVideoButton => 'プロトコルをインストール';

  @override
  String get intentionTitle => '意図推定アルゴリズム';

  @override
  String get intentionMenu => '意図';

  @override
  String get selectIntentionList => '意図推定アルゴリズムを選択してください';

  @override
  String get errorNoIntentionListPath => '意図推定アルゴリズムへのパスが定義されていません。リストを取得できません。';

  @override
  String get errorNoIntentionList => 'パスが存在しないか、意図推定アルゴリズムが見つかりませんでした。';

  @override
  String get pleaseIntentionRobot => 'アルゴリズムを選択してください';

  @override
  String get installIntentionButton => 'アルゴリズムをインストール';

  @override
  String get launchTitle => 'テレオペレーションを開始';

  @override
  String get launchMenu => '開始';

  @override
  String get selectedParametersSubTitle => '選択されたパラメータ';

  @override
  String get logSubtitle => 'ログ';

  @override
  String get logAllTab => 'すべて';

  @override
  String get launchButton => '起動';

  @override
  String get stopButton => '停止';

  @override
  String get exportLogButton => 'ログをエクスポート';

  @override
  String get saveLaunchParametersButton => 'パラメータをファイルに保存';

  @override
  String get loadLaunchParametersButton => 'パラメータをファイルから読み込む';

  @override
  String get genericTitle => '構成';

  @override
  String get genericMenu => '構成';

  @override
  String get selectGenericList => '項目を選択してください';

  @override
  String get errorNoGenericListPath => '構成ファイルへのパスが定義されていません。リストを取得できません。';

  @override
  String get errorNoGenericList => 'パスが存在しないか、構成ファイルが見つかりませんでした。';

  @override
  String get pleaseSelectGeneric => '項目を選択してください';

  @override
  String get installGenericButton => '項目をインストール';
}

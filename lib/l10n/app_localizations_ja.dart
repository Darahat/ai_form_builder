// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get signInToContinue => '続行するにはサインインしてください';

  @override
  String get welcome => 'ようこそ';

  @override
  String get home => 'ホーム';

  @override
  String get cancel => 'キャンセル';

  @override
  String get done => '完了';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get search => '検索';

  @override
  String get settings => '設定';

  @override
  String get aiChat => 'AIとチャット';

  @override
  String get typeMessage => 'メッセージを入力...';

  @override
  String get systemSummaryPrompt => 'あなたは、タスクの要約と計画を作成する有能なアシスタントです。';

  @override
  String get userSummaryPrompt => '次のタスクリストに基づいて、要約を作成し、賢い日次計画を提案してください:\n';

  @override
  String get systemQuickReplyPrompt => 'あなたは人間らしく、プロフェッショナルな会話パートナーです。100文字以内で返答してください。温かみがあり簡潔に、自然な会話のように応答してください。';

  @override
  String get errorMistralRequest => 'Mistralからの応答を取得できませんでした: ';

  @override
  String get logout => 'ログアウト';

  @override
  String get flutterStarterKit => 'Flutterスターターキット';

  @override
  String get email => 'Eメール';

  @override
  String get pleaseEnterYourEmail => 'メールアドレスを入力してください';

  @override
  String get pleaseEnterAValidEmailAddress => '有効なメールアドレスを入力してください';

  @override
  String get password => 'パスワード';

  @override
  String get pleaseEnterYourPassword => 'パスワードを入力してください';

  @override
  String get passwordMustBeAtLeast6Characters => 'パスワードは6文字以上である必要があります';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get signIn => 'サインイン';

  @override
  String get or => 'または';

  @override
  String get continueWithGoogle => 'Googleで続行';

  @override
  String get continueWithPhone => '電話で続行';

  @override
  String get continueWithGithub => 'Githubで続行';

  @override
  String get dontHaveAnAccount => 'アカウントをお持ちではありませんか？ ';

  @override
  String get signUp => 'サインアップ';

  @override
  String get createAccount => 'アカウントを作成';

  @override
  String get letsGetYouStarted => '始めましょう！';

  @override
  String get name => '名前';

  @override
  String get pleaseEnterYourName => '名前を入力してください';

  @override
  String get pleaseEnterAValidEmail => '有効なメールアドレスを入力してください';

  @override
  String get alreadyHaveAnAccount => 'すでにアカウントをお持ちですか？ ';

  @override
  String get resetEmailSent => 'リセットメールを送信しました（アカウントが存在する場合）。';

  @override
  String get error => 'エラー： ';

  @override
  String get forgotPasswordTitle => 'パスワードをお忘れですか';

  @override
  String get resetYourPassword => 'パスワードをリセットする';

  @override
  String get enterTheEmailAssociatedWithYourAccount => 'アカウントに関連付けられているメールアドレスを入力すると、パスワードをリセットするためのリンクが送信されます。';

  @override
  String get emailAddress => 'メールアドレス';

  @override
  String get emailIsRequired => 'メールアドレスは必須です';

  @override
  String get enterAValidEmail => '有効なメールアドレスを入力してください';

  @override
  String get sendResetEmail => 'リセットメールを送信';

  @override
  String get backToLogin => 'ログインに戻る';

  @override
  String get enterOTP => 'OTPを入力';

  @override
  String get enterTheOTPSentToYourPhone => 'お使いの携帯電話に送信されたOTPを入力してください';

  @override
  String get verifyOTP => 'OTPを確認';

  @override
  String get resendOTP => 'OTPを再送';

  @override
  String get resendOTPIn => 'でOTPを再送';

  @override
  String get enterPhoneNumber => '電話番号を入力';

  @override
  String get enterYourPhoneNumber => '電話番号を入力してください';

  @override
  String get weWillSendYouAVerificationCode => '確認コードを送信します';

  @override
  String get phoneNumber => '電話番号';

  @override
  String get pleaseEnterYourPhoneNumber => '電話番号を入力してください';

  @override
  String get sendOTP => 'OTPを送信';

  @override
  String get appearance => '外観';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get language => '言語';

  @override
  String get addNewTask => '新しいタスクを追加';

  @override
  String get enterTaskDescription => 'タスクの説明を入力してください';

  @override
  String get addTask => 'タスクを追加';

  @override
  String get takeAction => 'アクションを起こす';

  @override
  String get taskTitle => 'タスクのタイトル';

  @override
  String get aiGeneratedSummary => 'AIが生成した要約';

  @override
  String get noTasksAvailableToSummarize => '要約できるタスクはありません。';

  @override
  String get seeLess => '少なく見る';

  @override
  String get seeMore => 'もっと見る';

  @override
  String get generatingSummary => '要約を生成しています...';

  @override
  String get unableToGenerateSummary => '要約を生成できません。もう一度お試しください。';

  @override
  String get noTasksYet => 'まだタスクはありません';

  @override
  String get listening => '聞いています...';

  @override
  String get formBuilderSystemPrompt => 'あなたは知的なフォーム作成アシスタントです。あなたの目的は、明確な質問をしてユーザーがフォームを作成するのを支援することです。ユーザーは作成したいフォームの説明から始めます。あなたの仕事は、ユーザーがフォームを作成するプロセスを案内することです。各フォームフィールドの要件を理解するために、一度に1つずつ質問してください。各フィールドについて、次を決定する必要があります: 1. フォームで尋ねる質問、例えば \'あなたの名前は何ですか？\'。 2. 入力フィールドの種類、例えば \'text\', \'multiple choice\', \'checkboxes\', \'dropdown\'。 3. 複数選択、チェックボックス、またはドロップダウンフィールドの選択肢。必要な情報をすべて集め、ユーザーがフォームが完成したと確認したら、フォーム定義を単一のJSON objectとして出力してください。応答にはJSON objectのみを含め、他のテキストは含めないでください。サポートされているフィールドタイプ: \'text\', \'textarea\', \'multiple-choice\', \'checkboxes\', \'dropdown\', \'date\', \'number\'.';
}

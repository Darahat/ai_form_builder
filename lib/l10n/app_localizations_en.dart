// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get welcome => 'Welcome';

  @override
  String get home => 'Home';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get aiChat => 'Chat with AI';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get systemSummaryPrompt => 'You are a helpful assistant that generates task summaries and plans.';

  @override
  String get userSummaryPrompt => 'Based on the following task list, generate a summary and suggest smart daily plan:\n';

  @override
  String get systemQuickReplyPrompt => 'You are a human-like, professional conversational partner. Reply in under 100 characters. Be warm yet concise, and respond naturally like in real human chats.';

  @override
  String get errorMistralRequest => 'Failed to get response from Mistral: ';

  @override
  String get logout => 'Logout';

  @override
  String get flutterStarterKit => 'Flutter Starter Kit';

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterYourEmail => 'Please enter your email';

  @override
  String get pleaseEnterAValidEmailAddress => 'Please enter a valid email address';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterYourPassword => 'Please enter your password';

  @override
  String get passwordMustBeAtLeast6Characters => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get or => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithPhone => 'Continue with Phone';

  @override
  String get continueWithGithub => 'Continue with Github';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get letsGetYouStarted => 'Let\'s get you started!';

  @override
  String get name => 'Name';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get pleaseEnterAValidEmail => 'Please enter a valid email';

  @override
  String get alreadyHaveAnAccount => 'Already have an account? ';

  @override
  String get resetEmailSent => 'Reset email sent (if account exists).';

  @override
  String get error => 'Error: ';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get resetYourPassword => 'Reset your password';

  @override
  String get enterTheEmailAssociatedWithYourAccount => 'Enter the email associated with your account and we’ll send you a link to reset your password.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailIsRequired => 'Email is required';

  @override
  String get enterAValidEmail => 'Enter a valid email';

  @override
  String get sendResetEmail => 'Send Reset Email';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get enterOTP => 'Enter OTP';

  @override
  String get enterTheOTPSentToYourPhone => 'Enter the OTP sent to your phone';

  @override
  String get verifyOTP => 'Verify OTP';

  @override
  String get resendOTP => 'Resend OTP';

  @override
  String get resendOTPIn => 'Resend OTP in ';

  @override
  String get enterPhoneNumber => 'Enter Phone Number';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get weWillSendYouAVerificationCode => 'We will send you a verification code';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get pleaseEnterYourPhoneNumber => 'Please enter your phone number';

  @override
  String get sendOTP => 'Send OTP';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get addNewTask => 'Add New Task';

  @override
  String get enterTaskDescription => 'Enter task description';

  @override
  String get addTask => 'Add Task';

  @override
  String get takeAction => 'Take Action';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get aiGeneratedSummary => 'AI-Generated Summary';

  @override
  String get noTasksAvailableToSummarize => 'No tasks available to summarize.';

  @override
  String get seeLess => 'See Less';

  @override
  String get seeMore => 'See More';

  @override
  String get generatingSummary => 'Generating summary...';

  @override
  String get unableToGenerateSummary => 'Unable to generate summary. Please try again.';

  @override
  String get noTasksYet => 'No Tasks yet';

  @override
  String get listening => 'Listening...';

  @override
  String get formBuilderSystemPrompt => 'You are an intelligent form building assistant. Guide the user step by step to create a form. For each field, determine the question, the input type (text, textarea, multiple-choice, checkboxes, dropdown, date, number), and the options if required. When the form is complete, output only a valid JSON object with two keys: a \'title\' string and a \'fields\' array. Each field in the array must include a \'question\', a \'type\', and optional \'options\'. Do not add any extra text, only the JSON object. Strictly return a Single JSON object,Strictly dont ask for any tip.Strictly dont show any thumb icon.Your response must be a valid JSON object only. Do not include any preamble or postamble text.Do not include any conversational text, explanations, or markdown code blocks. dont add any kind of ```` apostrophe this sign. Do not provide multiple examples.Do not include any preamble or postamble text.';
}

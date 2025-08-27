// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get signInToContinue => 'Inicia sesión para continuar';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get home => 'Inicio';

  @override
  String get cancel => 'Cancelar';

  @override
  String get done => 'Hecho';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get search => 'Buscar';

  @override
  String get settings => 'Configuración';

  @override
  String get aiChat => 'Chatear con IA';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get systemSummaryPrompt => 'Eres un asistente útil que genera resúmenes de tareas y planes.';

  @override
  String get userSummaryPrompt => 'Basado en la siguiente lista de tareas, genera un resumen y sugiere un plan diario inteligente:\n';

  @override
  String get systemQuickReplyPrompt => 'Eres un compañero de conversación profesional y humano. Responde en menos de 100 caracteres. Sé cálido pero conciso, y responde de forma natural como en conversaciones reales.';

  @override
  String get errorMistralRequest => 'No se pudo obtener respuesta de Mistral: ';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get flutterStarterKit => 'Kit de Inicio Flutter';

  @override
  String get email => 'Correo electrónico';

  @override
  String get pleaseEnterYourEmail => 'Por favor, introduce tu correo electrónico';

  @override
  String get pleaseEnterAValidEmailAddress => 'Por favor, introduce una dirección de correo electrónico válida';

  @override
  String get password => 'Contraseña';

  @override
  String get pleaseEnterYourPassword => 'Por favor, introduce tu contraseña';

  @override
  String get passwordMustBeAtLeast6Characters => 'La contraseña debe tener al menos 6 caracteres';

  @override
  String get forgotPassword => '¿Has olvidado tu contraseña?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get or => 'O';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithPhone => 'Continuar con el teléfono';

  @override
  String get continueWithGithub => 'Continuar con Github';

  @override
  String get dontHaveAnAccount => '¿No tienes una cuenta? ';

  @override
  String get signUp => 'Regístrate';

  @override
  String get createAccount => 'Crear una cuenta';

  @override
  String get letsGetYouStarted => '¡Empecemos!';

  @override
  String get name => 'Nombre';

  @override
  String get pleaseEnterYourName => 'Por favor, introduce tu nombre';

  @override
  String get pleaseEnterAValidEmail => 'Por favor, introduce un correo electrónico válido';

  @override
  String get alreadyHaveAnAccount => '¿Ya tienes una cuenta? ';

  @override
  String get resetEmailSent => 'Correo electrónico de restablecimiento enviado (si la cuenta existe).';

  @override
  String get error => 'Error: ';

  @override
  String get forgotPasswordTitle => 'Has olvidado tu contraseña';

  @override
  String get resetYourPassword => 'Restablece tu contraseña';

  @override
  String get enterTheEmailAssociatedWithYourAccount => 'Introduce el correo electrónico asociado a tu cuenta y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get emailAddress => 'Dirección de correo electrónico';

  @override
  String get emailIsRequired => 'Se requiere un correo electrónico';

  @override
  String get enterAValidEmail => 'Introduce un correo electrónico válido';

  @override
  String get sendResetEmail => 'Enviar correo electrónico de restablecimiento';

  @override
  String get backToLogin => 'Volver a iniciar sesión';

  @override
  String get enterOTP => 'Introducir OTP';

  @override
  String get enterTheOTPSentToYourPhone => 'Introduce la OTP enviada a tu teléfono';

  @override
  String get verifyOTP => 'Verificar OTP';

  @override
  String get resendOTP => 'Reenviar OTP';

  @override
  String get resendOTPIn => 'Reenviar OTP en ';

  @override
  String get enterPhoneNumber => 'Introducir número de teléfono';

  @override
  String get enterYourPhoneNumber => 'Introduce tu número de teléfono';

  @override
  String get weWillSendYouAVerificationCode => 'Te enviaremos un código de verificación';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get pleaseEnterYourPhoneNumber => 'Por favor, introduce tu número de teléfono';

  @override
  String get sendOTP => 'Enviar OTP';

  @override
  String get appearance => 'Apariencia';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get addNewTask => 'Añadir nueva tarea';

  @override
  String get enterTaskDescription => 'Introduzca la descripción de la tarea';

  @override
  String get addTask => 'Añadir tarea';

  @override
  String get takeAction => 'Tomar medidas';

  @override
  String get taskTitle => 'Título de la tarea';

  @override
  String get aiGeneratedSummary => 'Resumen generado por IA';

  @override
  String get noTasksAvailableToSummarize => 'No hay tareas disponibles para resumir.';

  @override
  String get seeLess => 'Ver menos';

  @override
  String get seeMore => 'Ver más';

  @override
  String get generatingSummary => 'Generando resumen...';

  @override
  String get unableToGenerateSummary => 'No se ha podido generar el resumen. Por favor, inténtelo de nuevo.';

  @override
  String get noTasksYet => 'Aún no hay tareas';

  @override
  String get listening => 'Escuchando...';

  @override
  String get formBuilderSystemPrompt => 'Eres un asistente inteligente para la creación de formularios. Guía al usuario paso a paso para crear un formulario. Para cada campo, determina la pregunta, el tipo de entrada (texto, área de texto, opción múltiple, casillas de verificación, lista desplegable, fecha, número) y las opciones si es necesario. Cuando el formulario esté completo, entrega únicamente un objeto JSON válido con dos claves: un título (cadena de texto) y un arreglo de campos. Cada campo debe incluir una pregunta, un tipo y opciones opcionales. No añadas ningún texto adicional, solo el objeto JSON.';
}

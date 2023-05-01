import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "expense-tracker-flutter-383313",
  "private_key_id": "3fe892c55171f113ee1cadc19d19f2446472bdfc",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCsfinO0V2Wlat+\na4aaNyUWubA8zm9khdDRAwVf9qIRhmOM9et/Yu9GORihghLtY3JGk4sdrWw8L9pp\n8ZBJ9l0Io0ARl/jIKCtZGz/pVw+u1poHvbO3zWcp3gd+wPKPQ24M9aUFJja7CEFp\ntLAh36AqGUSgz6irnPUyqOgtpqPzUGQaQHxVrbXzFJx02H1tmt1+Kb2eZ/T42pTZ\n0zMHNFTQxSmH6kVt9zxNW4q4ImoJulmpvkvlhT3NiQ5trvuyQrQ8N+Kla0++ehzU\nJK5yehbXIySGMXp6T4VHJDLxSOLZkvGf8qFIdqnGTrXWPVtg1Y0EBYQJS+mGQejH\njfroAD1BAgMBAAECggEAEIj45Fd+O4eAwgSitDkhuApNfPa5B4+AU0ORNKrFdx1F\nK70N5Hniaqk3Kub3fi7F70KzgkEemq0SUzeR16qN2THKXCVk9s2gTNFnkKxaLNjA\n498T0ZnCED8KxDl7ca+gEWP20Vs2weUVCCyxpFL13TNA4z16HhaqC+opyj6ALDxZ\n98DEyZFwRvYw15A/rN0VTHRKKGmbzfn71z61UQxi3N043gTGhe8amWDYTxOa/HXW\nlLkp0a+oZeCiM37q//cx/gZAfuL3veeSnpanfqS8ppPQBF8CE9uQiwSowxjNdyE9\nPfBVB22mlJOzinuaY69/7evMnXlDpWhbGWAnXaoilQKBgQDSrfFbRsqDuyA9FtyH\nleUCMk/LGoMmd9SbE+kY/rABr8bVongLdkl5Qhsa+JDcBMfiRHEw8cQ03AZBvtel\n5kfGgK80vFeYVTSUrEt/9skn+rfDj0gdAMakJ21/f0wiOKK6LJESs8sP2xl2cFLi\nq4+aYx50wawG0WrJhLnJ4A7vBwKBgQDRmUsZoMmcqpOZ6BRb/wsOe4f2USgu8nNX\nIj5LNsCOPuna+84Nk4hOJFy+JygQ7iJ+kmTQEypzHS3gAaN+3PbzVVomVQ6cW+Sf\nXM+oDZPQA8AuR1KBxi9WS3hWI7nRwnkvyFjPjuyVD3MglY82TWT8t5jr8GmhQ1Oa\nlDxGht6XdwKBgEIXHQLkRz1h43AmjtHd3PR+cfel/oR/zOtFKLeVlgNBcB+ukvgN\niGkIqtYgKdlLiqTZkaSoA0QNzcysIJxDjDqiPdROTTBVcmQ9VIX1Fg97oFAxz46B\nos72K2x2s5x8pde/iVcTnd0Af5FfFTFUXn0xIOnBo8STx2smPt4scqLbAoGBAL+k\nG8iY/P5j8IUeb88VyPQ6+ru6xLT4NYGL6801iKYG3Ce/aE19gXmBQdMTVkz0j1GP\nZOHjRELwgQt6NBVA0AL5HW5DAxLv6n/TioKrt2TQqR0nVUcXAB008BhCnhouaEPK\nOXm9wo8gCzHVzZXm+dkfvZCsxsgOGRkTRHFvy4JNAoGBAM8WMCwqMRZqe1UZgsrp\nISIapEqaaAdGh68d8lCR90m2hIuagkUlVNRA0DBnTzU2DuBCEgV+sDUvyJrA5ljz\nuZL25AHfXo6ziV0WlfAAxvTeyL34VruWzV8317YAr6LNBZcX4ySg4FB5sV5wzgqT\nAPtL2YRNNh9jD9oa34Lyh1EV\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-tracker-app@expense-tracker-flutter-383313.iam.gserviceaccount.com",
  "client_id": "104877015299925157900",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-tracker-app%40expense-tracker-flutter-383313.iam.gserviceaccount.com"
}

''';

  static const _spreadSheetId = '1a_isSQ0xKk63LBWUoxxYp3c9E8cub7TmcH7iuGpb_KU';
//init gsheets
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    //fetch spreadsheet by it's id
    final ss = await _gsheets.spreadsheet(_spreadSheetId);

    //get worksgeet by it's title
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions
            .add([
              transactionName,
              transactionAmount,
              transactionType
        ]);
      }
    }
    loading = false;
  }

  static Future insert(String name, String amount, bool isIncome) async{
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      isIncome == true ? 'income' : 'expense'
    ]);

    await _worksheet!.values.appendRow([
      name,
      amount,
      isIncome == true ? 'income' : 'expense'
    ]);
  }

  static double calculateIncome(){
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++){
      if (currentTransactions[i][2] == 'income'){
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  static double calculateExpense(){
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++){
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
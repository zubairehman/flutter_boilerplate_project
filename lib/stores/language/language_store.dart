import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/language/language.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

part 'language_store.g.dart';

class LanguageStore = _LanguageStore with _$LanguageStore;

abstract class _LanguageStore with Store {
  // repository instance
  final Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // supported languages
  List<Language> supportedLanguages = [
    Language(code: 'US', locale: 'en', language: 'English'),
    Language(code: 'DK', locale: 'da', language: 'Danish'),
    Language(code: 'ES', locale: 'es', language: 'España'),
  ];

  // constructor:---------------------------------------------------------------
  _LanguageStore(Repository repository)
      : _repository = repository {
    init();
  }

  // store variables:-----------------------------------------------------------
  @observable
  String _locale = "en";

  @computed
  String get locale => _locale;

  // actions:-------------------------------------------------------------------
  @action
  void changeLanguage(String value) {
    _locale = value;
    _repository.changeLanguage(value).then((_) {
      // write additional logic here
    });
  }

  @action
  String getCode() {
    String code;

    if (_locale == 'en') {
      code = "US";
    } else if (_locale == 'da') {
      code = "DK";
    } else if (_locale == 'es') {
      code = "ES";
    } else {
      code = "US";
    }

    return code;
  }

  @action
  String? getLanguage() {
    return supportedLanguages[supportedLanguages
            .indexWhere((language) => language.locale == _locale)]
        .language;
  }

  // general:-------------------------------------------------------------------
  Future init() async {
    // getting current language from shared preference
    if(_repository.currentLanguage != null) {
      _locale = _repository.currentLanguage!;
    }
  }
}

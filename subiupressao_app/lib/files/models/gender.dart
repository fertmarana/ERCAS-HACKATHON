enum Gender {
  Masculino,
  Feminino
}

extension GenderExtension on Gender {
  String get name {
    switch (this) {
      case Gender.Masculino:
        return 'Masculino';
      case Gender.Feminino:
        return 'Feminino';
      default:
        return null;
    }
  }
}

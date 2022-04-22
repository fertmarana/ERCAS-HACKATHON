enum Gender {
  Male,
  Female
}

extension GenderExtension on Gender {
  String get name {
    switch (this) {
      case Gender.Male:
        return 'Masculino';
      case Gender.Female:
        return 'Feminino';
      default:
        return null;
    }
  }
}

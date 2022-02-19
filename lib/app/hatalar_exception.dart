class Hatalar {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case "email-already-in-use":
        return "Bu mail adresi zaten kullanılmış!";
        break;
      case "user-not-found":
        return "Böyle bir kullanıcı yok!";
        break;
      default:
        return hataKodu;
        break;
    }
  }
}

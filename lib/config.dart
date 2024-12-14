class Config {
  //URL dasar
  static const String base_domain = 'http://192.168.1.2:8000';

  //Endpoint Login
  static const String login_endpoint = '$base_domain/api/login';
  static const String register_endpoint = '$base_domain/api/register';

  //Endpoint get User Data
  static const String mahasiswa_endpoint =
      '$base_domain/api/mahasiswa/mahasiswa_data';
  static const String dosen_endpoint = '$base_domain/api/dosen/dosen_data';
  static const String tendik_endpoint = '$base_domain/api/tendik/tendik_data';
}

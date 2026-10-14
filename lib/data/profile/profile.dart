/// Padanan `ProfileVM.ProfileResponse` di CekReklameApi.
class Profile {
  const Profile({
    required this.nip,
    required this.nama,
    required this.alamat,
    required this.hp,
    required this.email,
    required this.jenisPegawai,
    required this.aktif,
    required this.tglLahir,
    required this.bidang,
    required this.jabatan,
    required this.golongan,
  });

  final String nip;
  final String nama;
  final String alamat;
  final String hp;
  final String? email;
  final String jenisPegawai;
  final String aktif;

  /// Format dari API: `yyyy-MM-dd HH:mm:ss`.
  final String tglLahir;
  final String bidang;
  final String jabatan;
  final String golongan;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    nip: json['nip'] as String? ?? '',
    nama: json['nama'] as String? ?? '',
    alamat: json['alamat'] as String? ?? '',
    hp: json['hp'] as String? ?? '',
    email: json['email'] as String?,
    jenisPegawai: json['jenisPegawai'] as String? ?? '',
    aktif: json['aktif'] as String? ?? '',
    tglLahir: json['tglLahir'] as String? ?? '',
    bidang: json['bidang'] as String? ?? '',
    jabatan: json['jabatan'] as String? ?? '',
    golongan: json['golongan'] as String? ?? '',
  );
}

// Tantangan 1: model dipisah dari layanan ke berkas sendiri.
// Tantangan 3: Koleksi menjadi sealed class; semua subtipe harus di berkas ini.

sealed class Koleksi {
  final String kode;
  final String judul;

  // Privat terhadap berkas ini. Setelah layanan dipindah ke
  // perpustakaan.dart, k._dipinjam = true menjadi error, sehingga perubahan
  // status dibuka lewat method publik di bawah.
  bool _dipinjam = false;

  Koleksi(this.kode, this.judul);

  int get lamaPinjam;
  bool get tersedia => !_dipinjam;
  String info() => '[$kode] $judul';

  void tandaiDipinjam() => _dipinjam = true;
  void tandaiKembali() => _dipinjam = false;
}

mixin BisaDiunduh {
  String get url;
  String unduh() => 'Mengunduh dari $url ...';
}

class Buku extends Koleksi {
  final String penulis;
  Buku(super.kode, super.judul, this.penulis);

  @override
  int get lamaPinjam => 14;

  @override
  String info() => '${super.info()} oleh $penulis';
}

class Majalah extends Koleksi {
  final int edisi;
  Majalah(super.kode, super.judul, this.edisi);

  @override
  int get lamaPinjam => 7;

  @override
  String info() => '${super.info()} edisi $edisi';
}

class EBook extends Buku with BisaDiunduh {
  @override
  final String url;
  EBook(super.kode, super.judul, super.penulis, this.url);

  @override
  int get lamaPinjam => 30;
}

/// Tantangan 2: skripsi hanya boleh dibaca di tempat.
class Skripsi extends Koleksi {
  final String nim;
  Skripsi(super.kode, super.judul, this.nim);

  @override
  int get lamaPinjam => 0;

  @override
  String info() => '${super.info()} (NIM $nim, baca di tempat)';
}

/// Tantangan 3: switch pada sealed class. Bila satu subtipe tidak ditulis,
/// compiler menolak dengan error non_exhaustive_switch_expression.
String ikon(Koleksi k) => switch (k) {
  EBook() => '[e-book]',
  Buku() => '[buku]',
  Majalah() => '[majalah]',
  Skripsi() => '[skripsi]',
};

class Anggota {
  final String id;
  final String nama;
  final int maksPinjam;
  Anggota(this.id, this.nama, {this.maksPinjam = 2});
}

class Peminjaman {
  final Anggota anggota;
  final Koleksi koleksi;
  final DateTime tanggal;
  Peminjaman(this.anggota, this.koleksi, this.tanggal);

  DateTime get jatuhTempo => tanggal.add(Duration(days: koleksi.lamaPinjam));

  int dendaPada(DateTime kembali) {
    final telat = kembali.difference(jatuhTempo).inDays;
    return telat > 0 ? telat * 1000 : 0; // Rp1.000 per hari
  }
}

class PeminjamanGagal implements Exception {
  final String alasan;
  PeminjamanGagal(this.alasan);

  @override
  String toString() => 'Peminjaman gagal: $alasan';
}

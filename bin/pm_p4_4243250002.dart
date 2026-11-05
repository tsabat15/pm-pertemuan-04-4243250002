import 'package:pm_p4_4243250002/model.dart';
import 'package:pm_p4_4243250002/perpustakaan.dart';

Future<void> main() async {
  final perpus = Perpustakaan('Perpustakaan FMIPA');
  perpus.log.listen((pesan) => print('[LOG] $pesan'));

  perpus
    ..tambah(Buku('B01', 'Dasar-Dasar Dart', 'A. Siregar'))
    ..tambah(Majalah('M01', 'Majalah Teknologi', 112))
    ..tambah(
      EBook(
        'E01',
        'Flutter in Action',
        'Eric Windmill',
        'https://contoh.id/e01',
      ),
    )
    ..tambah(Skripsi('S01', 'Aplikasi Presensi Flutter', '4243250002'));

  // Polimorfisme: info() dan ikon() mengikuti objek aslinya.
  for (final k in perpus.semuaKoleksi) {
    print('${ikon(k).padRight(10)} ${k.info()} (${k.lamaPinjam} hari)');
  }

  final butet = Anggota('A01', 'Butet', maksPinjam: 1);
  final ucok = Anggota('A02', 'Ucok');

  final p1 = await perpus.pinjam(butet, 'B01', tanggal: DateTime(2026, 10, 1));
  print('Jatuh tempo: ${p1.jatuhTempo}');

  // Empat percobaan yang seharusnya ditolak
  for (final (anggota, kode) in [
    (ucok, 'B01'),
    (butet, 'M01'),
    (ucok, 'X99'),
    (ucok, 'S01'),
  ]) {
    try {
      await perpus.pinjam(anggota, kode);
    } on PeminjamanGagal catch (e) {
      print(e);
    }
  }

  final denda = perpus.kembalikan(p1, tanggal: DateTime(2026, 10, 18));
  print('Denda: Rp$denda'); // terlambat 3 hari -> Rp3000
  print('Tersedia: ${perpus.koleksiTersedia.map((k) => k.judul).join(', ')}');
  await perpus.tutup();
}

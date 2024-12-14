import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final dio = Dio();
var jenis_data = [];
var periode_data = [];
String urlDomain = "http://192.168.1.2:8000/";
String urlCreateTask = urlDomain + "api/add_data";
String url_all_data = urlDomain + "api/get_data";

final TextEditingController namaTugasController = TextEditingController();
final TextEditingController deskripsiTugasController = TextEditingController();
final TextEditingController bobotTugasController = TextEditingController();
final TextEditingController tenggatWaktuController = TextEditingController();
final TextEditingController kuotaController = TextEditingController();
String? jenisTugas;
String? periodeTugas;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tambah Tugas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TambahTugas(),
    );
  }
}

class TambahTugas extends StatefulWidget {
  @override
  _TambahTugasState createState() => _TambahTugasState();
}

class _TambahTugasState extends State<TambahTugas> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final response = await dio.post(url_all_data);
      if (response.data is List && response.data.length == 2) {
        final jenisList = response.data[0] as List;
        final periodeList = response.data[1] as List;

        setState(() {
          // Check for null or empty data before processing
          jenis_data = jenisList.isNotEmpty
              ? jenisList.map((item) {
                  return {
                    'jenis_id': item['jenis_id'].toString(),
                    'jenis_nama': item['jenis_nama'] ?? 'Unknown',
                  };
                }).toList()
              : [];

          periode_data = periodeList.isNotEmpty
              ? periodeList.map((item) {
                  return {
                    'periode_id': item['periode_id'].toString(),
                    'periode_tahun': item['periode_tahun'] ?? 'Unknown',
                    'periode_semester': item['periode_semester'] ?? 'Unknown',
                  };
                }).toList()
              : [];

          // Default values set after data loading
          periodeTugas =
              periode_data.isNotEmpty ? periode_data.first['periode_id'] : null;

          jenisTugas =
              jenis_data.isNotEmpty ? jenis_data.first['jenis_id'] : null;
        });
      } else {
        print("Unexpected data format: ${response.data}");
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void tambahTugas() async {
    try {
      var response = await dio.post(urlCreateTask, queryParameters: {
        "user_id": 8,
        "tugas_nama": namaTugasController.text,
        "deskripsi": deskripsiTugasController.text,
        "tugas_bobot": bobotTugasController.text,
        "tugas_tenggat": tenggatWaktuController.text,
        "jenis_id": jenisTugas,
        "periode_id": periodeTugas,
        "kuota": kuotaController.text,
      });
      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        throw Exception("Gagal menambahkan tugas");
      }
    } catch (e) {
      print(e);
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text(
              'Apakah anda sudah yakin dan memeriksa detail tugas yang anda buat? Pastikan semuanya sudah benar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                tambahTugas();
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Tugas berhasil ditambahkan!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: jenisTugas,
                    onChanged: (value) {
                      setState(() {
                        jenisTugas = value;
                      });
                    },
                    items: jenis_data.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item['jenis_id'], // String value
                        child: Text(item['jenis_nama'] ?? 'Unknown'),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: "Jenis Tugas"),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: namaTugasController,
                    decoration: InputDecoration(labelText: "Nama Tugas"),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: deskripsiTugasController,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: "Deskripsi Tugas"),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: bobotTugasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Bobot Tugas (Jam)"),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: tenggatWaktuController,
                    decoration: InputDecoration(
                      labelText: "Tenggat Waktu",
                      hintText: "Pilih tanggal",
                    ),
                    readOnly:
                        true, // Prevents typing in the field, only allow date picking
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          tenggatWaktuController.text =
                              "${selectedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: kuotaController,
                    decoration: InputDecoration(labelText: "Kuota"),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: periodeTugas,
                    onChanged: (value) {
                      setState(() {
                        periodeTugas = value;
                      });
                    },
                    items: periode_data.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item['periode_id'],
                        child: Text(item['periode_tahun'] +
                                " " +
                                item['periode_semester'] ??
                            'Unknown'),
                      );
                    }).toList(),
                    decoration:
                        const InputDecoration(labelText: "Periode Tugas"),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity, // Tombol memenuhi lebar layar
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2260), // Warna tombol
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0), // Padding vertikal
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Border tombol
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

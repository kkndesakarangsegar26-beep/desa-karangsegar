import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerangkatDesaPage extends StatefulWidget {
  const PerangkatDesaPage({super.key});

  @override
  State<PerangkatDesaPage> createState() => _PerangkatDesaPageState();
}

class _PerangkatDesaPageState extends State<PerangkatDesaPage> {
  final namaCtrl = TextEditingController();
  final jabatanCtrl = TextEditingController();

  String kategori = 'kepala';
  Uint8List? imageBytes;
  String? imageName;
  String? editingId;

  final kategoriList = [
    'kepala',
    'sekdes',
    'kegiatan',
    'seksi',
    'dusun',
  ];

  // ================= IMAGE PICK =================
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageBytes = await picked.readAsBytes();
      imageName = picked.name;
      setState(() {});
    }
  }

  Future<String?> uploadImage() async {
  if (imageBytes == null || imageName == null) return null;

  final supabase = Supabase.instance.client;

  final path = 'perangkat/${DateTime.now().millisecondsSinceEpoch}_$imageName';

  await supabase.storage
      .from('perangkat')
      .uploadBinary(
        path,
        imageBytes!,
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

  final publicUrl =
      supabase.storage.from('perangkat').getPublicUrl(path);

  return publicUrl;
}


  // ================= SAVE =================
  Future<void> saveData() async {
    if (namaCtrl.text.isEmpty || jabatanCtrl.text.isEmpty) return;

    final photoUrl = await uploadImage();

    final payload = {
      'nama': namaCtrl.text,
      'jabatan': jabatanCtrl.text,
      'kategori': kategori,
      'urutan': 0,
      if (photoUrl != null) 'photo_url': photoUrl,
    };

    if (editingId == null) {
      await Supabase.instance.client
          .from('perangkat_desa')
          .insert(payload);
    } else {
      await Supabase.instance.client
          .from('perangkat_desa')
          .update(payload)
          .eq('id', editingId!);
    }

    resetForm();
  }

  void resetForm() {
    namaCtrl.clear();
    jabatanCtrl.clear();
    imageBytes = null;
    imageName = null;
    editingId = null;
    kategori = 'kepala';
    setState(() {});
  }

  // ================= DELETE =================
  Future<void> deleteData(String id) async {
    await Supabase.instance.client
        .from('perangkat_desa')
        .delete()
        .eq('id', id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Perangkat Desa'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= FORM =================
            const Text(
              'Tambah / Edit Perangkat',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: namaCtrl,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: jabatanCtrl,
              decoration: const InputDecoration(labelText: 'Jabatan'),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: kategori,
              items: kategoriList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => kategori = val!),
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Foto'),
                ),
                const SizedBox(width: 10),
                if (imageBytes != null) const Text('✔ Foto dipilih'),
              ],
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: saveData,
              child: Text(editingId == null ? 'Simpan' : 'Update'),
            ),

            const Divider(height: 40),

            // ================= LIST =================
            const Text(
              'Daftar Perangkat Desa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            FutureBuilder<List<dynamic>>(
              future: Supabase.instance.client
                  .from('perangkat_desa')
                  .select()
                  .order('kategori')
                  .order('created_at'),
              builder: (context, snapshot) {
                // LOADING
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                // ERROR
                if (snapshot.hasError) {
                  return const Text(
                    'Gagal memuat data perangkat desa',
                    style: TextStyle(color: Colors.red),
                  );
                }

                // EMPTY
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Belum ada data perangkat desa');
                }

                final data = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    final item = data[i];

                    return Card(
                      child: ListTile(
                        leading: item['photo_url'] != null
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(item['photo_url']),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                        title: Text(item['nama']),
                        subtitle: Text(
                          '${item['jabatan']} (${item['kategori']})',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                namaCtrl.text = item['nama'];
                                jabatanCtrl.text = item['jabatan'];
                                kategori = item['kategori'];
                                editingId = item['id'];
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () =>
                                  deleteData(item['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

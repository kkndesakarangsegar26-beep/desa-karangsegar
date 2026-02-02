import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'perangkat_desa_page.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // ===============================
  // BERITA
  // ===============================
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  Uint8List? imageBytes;
  String? imageName;
  String? editingPostId;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageBytes = await picked.readAsBytes();
      imageName = picked.name;
      setState(() {});
    }
  }

  Future<String?> uploadImage() async {
    if (imageBytes == null) return null;

    final filePath =
        'posts/${DateTime.now().millisecondsSinceEpoch}_$imageName';

    await Supabase.instance.client.storage
        .from('posts-images')
        .uploadBinary(filePath, imageBytes!);

    return Supabase.instance.client.storage
        .from('posts-images')
        .getPublicUrl(filePath);
  }

  Future<void> savePost() async {
    if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty) return;

    final imageUrl = await uploadImage();

    if (editingPostId == null) {
      await Supabase.instance.client.from('posts').insert({
        'title': titleCtrl.text,
        'content': contentCtrl.text,
        'image_url': imageUrl,
      });
    } else {
      await Supabase.instance.client.from('posts').update({
        'title': titleCtrl.text,
        'content': contentCtrl.text,
        if (imageUrl != null) 'image_url': imageUrl,
      }).eq('id', editingPostId!);
    }

    titleCtrl.clear();
    contentCtrl.clear();
    imageBytes = null;
    imageName = null;
    editingPostId = null;

    setState(() {});
  }

  Future<void> deletePost(String id) async {
    await Supabase.instance.client.from('posts').delete().eq('id', id);
    setState(() {});
  }

  // ===============================
  // PROFIL DESA
  // ===============================
  final lakiCtrl = TextEditingController();
  final perempuanCtrl = TextEditingController();
  final dusunCtrl = TextEditingController();
  final ketinggianCtrl = TextEditingController();
  final latCtrl = TextEditingController();
  final lngCtrl = TextEditingController();
  final visiCtrl = TextEditingController();
  final misiCtrl = TextEditingController();

  String? profilId;
  bool loadingProfil = true;

  @override
  void initState() {
    super.initState();
    loadProfil();
  }

  Future<void> loadProfil() async {
    final data = await Supabase.instance.client
        .from('profil_desa')
        .select()
        .limit(1)
        .single();

    profilId = data['id'] as String;

    lakiCtrl.text = data['jumlah_laki'].toString();
    perempuanCtrl.text = data['jumlah_perempuan'].toString();
    dusunCtrl.text = data['jumlah_dusun'].toString();
    ketinggianCtrl.text = data['ketinggian'] ?? '';
    latCtrl.text = data['latitude'].toString();
    lngCtrl.text = data['longitude'].toString();
    visiCtrl.text = data['visi'] ?? '';
    misiCtrl.text = data['misi'] ?? '';

    setState(() => loadingProfil = false);
  }

  Future<void> saveProfil() async {
    if (profilId == null) return;

    await Supabase.instance.client
        .from('profil_desa')
        .update({
          'jumlah_laki': int.parse(lakiCtrl.text),
          'jumlah_perempuan': int.parse(perempuanCtrl.text),
          'jumlah_dusun': int.parse(dusunCtrl.text),
          'ketinggian': ketinggianCtrl.text,
          'latitude': double.parse(latCtrl.text),
          'longitude': double.parse(lngCtrl.text),
          'visi': visiCtrl.text,
          'misi': misiCtrl.text,
        })
        .eq('id', profilId!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil desa berhasil diperbarui')),
    );
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel Desa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================
            // EDIT PROFIL DESA
            // ===============================
            const Text(
              'Edit Profil Desa',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (loadingProfil)
              const Center(child: CircularProgressIndicator())
            else ...[
              _input('Jumlah Laki-laki', lakiCtrl),
              _input('Jumlah Perempuan', perempuanCtrl),
              _input('Jumlah Dusun', dusunCtrl),
              _input('Ketinggian (mdpl)', ketinggianCtrl),
              _input('Latitude', latCtrl),
              _input('Longitude', lngCtrl),
              _input('Visi Desa', visiCtrl, maxLines: 3),
              _input('Misi Desa', misiCtrl, maxLines: 4),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: saveProfil,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Profil Desa'),
              ),
            ],

            const Divider(height: 50),


            // ===============================
            // KELOLA PERANGKAT DESA
            // ===============================
            const Divider(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.groups),
              label: const Text('Kelola Perangkat Desa'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push( 
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PerangkatDesaPage(),
                  ),
                );
              },
            ),

            const Divider(height: 50),


            // ===============================
            // KELOLA BERITA
            // ===============================
            const Text(
              'Kelola Berita',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Judul Berita'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentCtrl,
              decoration: const InputDecoration(labelText: 'Isi Berita'),
              maxLines: 4,
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pilih Gambar'),
                ),
                const SizedBox(width: 10),
                if (imageBytes != null) const Text('✔ Gambar dipilih'),
              ],
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: savePost,
              child: Text(
                editingPostId == null ? 'Tambah Berita' : 'Update Berita',
              ),
            ),

            const SizedBox(height: 20),

            FutureBuilder(
              future: Supabase.instance.client
                  .from('posts')
                  .select()
                  .order('created_at', ascending: false),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final data = snapshot.data as List;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final post = data[index];
                    return Card(
                      child: ListTile(
                        leading: post['image_url'] != null
                            ? Image.network(
                                post['image_url'],
                                width: 60,
                                fit: BoxFit.cover,
                              )
                            : null,
                        title: Text(post['title']),
                        subtitle: Text(
                          post['content'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deletePost(post['id']),
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

  Widget _input(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

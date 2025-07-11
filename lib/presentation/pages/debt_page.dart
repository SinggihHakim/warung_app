import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:warung_app/data/models/debt.dart';
import 'package:warung_app/presentation/cubit/debt_cubit.dart';

class DebtPage extends StatefulWidget {
  const DebtPage({super.key});

  @override
  State<DebtPage> createState() => _DebtPageState();
}

// Tambahkan "with AutomaticKeepAliveClientMixin"
class _DebtPageState extends State<DebtPage> with AutomaticKeepAliveClientMixin {
  // Override wantKeepAlive dan return true
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Panggil fetchDebts saat halaman pertama kali dibuat
    context.read<DebtCubit>().fetchDebts();
  }
  
  // ... (kode _showDebtDialog Anda sudah benar)

  @override
  Widget build(BuildContext context) {
    // Panggil super.build(context) untuk keep-alive
    super.build(context);
    final priceFormat = NumberFormat("#,##0", "id_ID");

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Utang')),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DebtCubit>().fetchDebts();
        },
        child: BlocBuilder<DebtCubit, List<Debt>>(
          builder: (context, debts) {
            if (debts.isEmpty) {
              return const Center(child: Text('Tidak ada catatan utang.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: debts.length,
              itemBuilder: (context, index) {
                final debt = debts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(debt.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(debt.description ?? 'Tidak ada keterangan'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Rp ${priceFormat.format(debt.amount)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.edit, size: 20, color: Colors.blue), onPressed: () => _showDebtDialog(debt: debt)),
                        IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => context.read<DebtCubit>().deleteDebt(debt.id)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDebtDialog(),
        tooltip: 'Tambah Utang',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  // Dialog untuk menambah/mengedit utang
  void _showDebtDialog({Debt? debt}) {
    final nameController = TextEditingController(text: debt?.name);
    final amountController = TextEditingController(text: debt?.amount.toString());
    final descController = TextEditingController(text: debt?.description);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(debt == null ? 'Tambah Utang' : 'Edit Utang'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama* (Wajib diisi)')),
                TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Jumlah (Rp)* (Wajib diisi)'), keyboardType: TextInputType.number),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Keterangan (opsional)')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                try {
                  final newDebt = debt ?? Debt();
                  newDebt
                    ..name = nameController.text
                    ..amount = int.tryParse(amountController.text) ?? 0
                    ..description = descController.text
                    ..createdAt = DateTime.now();

                  await context.read<DebtCubit>().addOrUpdateDebt(newDebt);

                  if (mounted) Navigator.pop(dialogContext);

                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
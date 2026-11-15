import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

import '../menu/menu_image.dart';
import 'validators.dart';

/// ฟอร์มปรับแต่งเครื่องดื่ม: StatefulWidget เพราะค่าที่เลือกเปลี่ยนได้
class CustomizePage extends StatefulWidget {
  const CustomizePage({super.key, required this.item});

  final MenuItem item; // ค่าคงที่จากพ่อ อ่านผ่าน widget.item

  @override
  State<CustomizePage> createState() => _CustomizePageState();
}

class _CustomizePageState extends State<CustomizePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  final _nameFocus = FocusNode(); // ใช้พาช่องชื่อที่ยังไม่กรอกกลับมาให้เห็น

  // สถานะของฟอร์ม เปลี่ยนผ่าน setState เท่านั้น
  CupSize _size = CupSize.medium;
  Sweetness _sweetness = Sweetness.normal;
  final Set<Topping> _toppings = {};
  int _quantity = 1;

  @override
  void dispose() {
    _nameController.dispose(); // คืนทรัพยากรของ controller
    _noteController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  /// รายการที่กำลังปรับแต่ง (คำนวณราคาด้วย cafe_core)
  OrderItem get _draft => OrderItem(
    item: widget.item,
    size: _size,
    sweetness: _sweetness,
    toppings: {..._toppings},
    quantity: _quantity,
    cupName: _nameController.text.trim(),
    note: _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim(),
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      // ช่องชื่ออยู่ท้ายฟอร์ม ข้อความแจ้งอาจอยู่นอกจอ:
      // โฟกัสช่องนั้น Flutter จะเลื่อนช่องขึ้นมาให้เห็นเอง
      if (validateCupName(_nameController.text) != null) {
        _nameFocus.requestFocus();
      }
      return;
    }
    final item = _draft;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'เพิ่ม ${item.item.name} ×${item.quantity} (${item.priceText}) แล้ว',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: Form(
        key: _formKey,
        // ใช้ SingleChildScrollView + Column (ไม่ใช่ ListView) เพื่อให้ทุกช่อง
        // ถูกสร้างจริง validate() จึงตรวจได้ครบแม้ช่องอยู่นอกจอ
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MenuImage(item: item, size: 160),
                ),
              ),
              const SizedBox(height: 16),
              if (item.isDrink) ...[
                const _Label('ขนาดแก้ว'),
                SegmentedButton<CupSize>(
                  segments: [
                    for (final s in CupSize.values)
                      ButtonSegment(
                        value: s,
                        label: Text('${s.label} +${s.extra}'),
                      ),
                  ],
                  selected: {_size},
                  onSelectionChanged: (s) => setState(() => _size = s.first),
                ),
                const _Label('ความหวาน'),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final s in Sweetness.values)
                      ChoiceChip(
                        label: Text(s.label),
                        selected: _sweetness == s,
                        onSelected: (_) => setState(() => _sweetness = s),
                      ),
                  ],
                ),
                const _Label('ท็อปปิง'),
                for (final t in allToppings)
                  CheckboxListTile(
                    title: Text(t.name),
                    secondary: Text('+${t.price}'),
                    value: _toppings.contains(t),
                    onChanged: (checked) => setState(() {
                      checked! ? _toppings.add(t) : _toppings.remove(t);
                    }),
                  ),
              ],
              const _Label('จำนวน'),
              Row(
                children: [
                  IconButton.outlined(
                    tooltip: 'ลดจำนวน',
                    icon: const Icon(Icons.remove),
                    // null = ปุ่มถูกปิด เมื่อเหลือ 1
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$_quantity',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton.outlined(
                    tooltip: 'เพิ่มจำนวน',
                    icon: const Icon(Icons.add),
                    onPressed: _quantity < 10
                        ? () => setState(() => _quantity++)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocus,
                // เผื่อพื้นที่ใต้ช่องตอนเลื่อนมาให้เห็น ให้บรรทัดข้อความแจ้งพ้นปุ่มด้านล่าง
                scrollPadding: const EdgeInsets.fromLTRB(20, 20, 20, 64),
                decoration: const InputDecoration(
                  labelText: 'ชื่อบนแก้ว *',
                  border: OutlineInputBorder(),
                ),
                validator: validateCupName,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'หมายเหตุถึงบาริสต้า',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
                validator: validateNote,
              ),
            ],
          ),
        ),
      ),
      // ปุ่มยืนยันอยู่ด้านล่างเสมอ ไม่ต้องเลื่อนหา
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.add_shopping_cart),
            label: Text('ใส่ตะกร้า · ${_draft.priceText}'),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

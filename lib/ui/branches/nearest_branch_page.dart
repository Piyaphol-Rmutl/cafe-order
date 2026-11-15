import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/location_service.dart';
import '../l10n_ext.dart';
import 'nearest_branch_view_model.dart';

class NearestBranchPage extends StatelessWidget {
  const NearestBranchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NearestBranchViewModel>();
    final l10n = context.l10n;
    final Widget body;
    if (vm.loading) {
      body = Center(child: Text(l10n.findingLocation));
    } else if (vm.locationError != null) {
      final denied = vm.locationError!.reason == LocationFailure.deniedForever;
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 48),
            Text(vm.locationError!.message),
            const SizedBox(height: 8),
            // ปฏิเสธถาวร: แอปขอสิทธิ์ซ้ำไม่ได้ ต้องพาไปหน้าตั้งค่า
            FilledButton(
              onPressed: denied ? vm.openSettings : vm.load,
              child: Text(denied ? l10n.openSettings : l10n.retry),
            ),
          ],
        ),
      );
    } else if (vm.error != null) {
      // ข้อผิดพลาดอื่น (เช่น โหลดสาขาจากเซิร์ฟเวอร์ไม่ได้) ให้ลองใหม่ได้เช่นกัน
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${vm.error}'),
            const SizedBox(height: 8),
            FilledButton(onPressed: vm.load, child: Text(l10n.retry)),
          ],
        ),
      );
    } else {
      body = ListView(
        children: [
          for (final (i, (branch, meters)) in vm.results.indexed)
            ListTile(
              leading: Icon(i == 0 ? Icons.near_me : Icons.storefront),
              title: Text(branch.name),
              subtitle: Text(branch.hours),
              trailing: Text(
                l10n.distanceKm((meters / 1000).toStringAsFixed(2)),
              ),
            ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.nearestBranch)),
      body: body,
    );
  }
}

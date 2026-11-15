/// mixin: เพิ่มความสามารถ "แสดงราคา" ให้คลาสใดก็ได้ที่มี total
mixin Priced {
  int get total;

  String get priceText => '$total บาท';
}

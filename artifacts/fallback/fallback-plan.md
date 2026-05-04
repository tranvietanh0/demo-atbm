# Fallback plan

## Bước 3 — Flow Kerberos bình thường
### Fallback A — service access lỗi
- Bỏ bước truy cập service thật
- Dùng `klist` trước/sau và screenshot để giải thích TGT/TGS

### Fallback B — lỗi DNS hoặc clock skew
- Trên CL01 chạy `w32tm /resync`
- Nếu chưa ổn, đăng xuất/đăng nhập lại
- Nếu vẫn lỗi, revert snapshot gần nhất hoặc phát video rehearsal

## Bước 4 — Flow Kerberoasting
### Fallback C — crack chậm
- Dừng live crack sau 20-30 giây
- Mở output crack đã chuẩn bị sẵn

### Fallback D — tool bị chặn
- Dùng bản portable đã test trước
- Nếu vẫn lỗi, dùng screenshot hash + output crack

## Toàn buổi demo
### Fallback E — VM lag
- Reboot snapshot pre-demo
- Nếu không kịp, chuyển sang slide + video

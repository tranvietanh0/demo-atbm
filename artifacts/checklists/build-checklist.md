# Build checklist

## Host
- [ ] Laptop còn ít nhất 80GB trống
- [ ] Hypervisor chạy ổn định
- [ ] Mạng host-only hoặc NAT đã cố định
- [ ] Tắt sleep và update tự động trước buổi demo

## DC01
- [ ] Hostname là `DC01`
- [ ] IP tĩnh đã đặt
- [ ] AD DS + DNS hoạt động
- [ ] Domain `demo.local` tạo xong
- [ ] `student` tạo xong
- [ ] `svc_sql` tạo xong
- [ ] `setspn -L svc_sql` hiển thị đúng SPN

## CL01
- [ ] DNS chỉ trỏ về DC01
- [ ] Join domain thành công
- [ ] Login được bằng `DEMO\\student`
- [ ] `klist` có TGT

## Tooling
- [ ] Trên CL01 có `setspn` để enumerate SPN
- [ ] Trên host crack có Python + Impacket hoặc công cụ tương đương
- [ ] Tool crack offline sẵn sàng
- [ ] Wordlist đã kiểm tra
- [ ] Host crack nhìn thấy DC01 qua mạng lab
- [ ] Antivirus không chặn tool

## Artifact
- [ ] Có screenshot flow thường
- [ ] Có screenshot Kerberoasting
- [ ] Có video fallback
- [ ] Có snapshot sau từng mốc

## Phase 1: Scope, deliverables, kiến trúc lab

### 1) Phạm vi
In scope:
- Minh họa cơ chế Kerberos chuẩn: identity -> TGT -> service ticket -> access.
- Minh họa Kerberoasting: enumerate SPN -> request TGS -> export hash -> crack offline.
- Môi trường lab độc lập, không dùng hạ tầng thật của trường.
- Tài liệu hóa để một người khác có thể dựng lại.

Out of scope:
- Triển khai SIEM, EDR, log forwarding.
- Multi-DC, trust giữa domain, Azure AD hybrid thực tế.
- Hardening đầy đủ hay remediation sau tấn công.
- SQL Server/IIS production thật nếu không phục vụ trực tiếp cho việc minh họa.

### 2) Deliverables
Bắt buộc có:
- `plan.md`
- 01 sơ đồ lab 1 trang
- 01 slide deck 5-7 trang
- 01 checklist dựng môi trường
- 01 runbook demo 10-15 phút
- 01 checklist rehearsal
- 01 fallback pack: screenshot + video ngắn + log text
- 01 file credentials lab nội bộ, không commit secret thật nếu repo public

Nên có:
- Script PowerShell tạo user/service/SPN
- Script kiểm tra nhanh time, DNS, ticket cache
- Wordlist rút gọn chỉ phục vụ demo

### 3) Kiến trúc lab đề xuất
#### Thành phần
1. DC01 - Windows Server 2019/2022
   - AD DS, DNS, KDC
   - Domain: `demo.local`
   - IP tĩnh, ví dụ `192.168.56.10`

2. CL01 - Windows 10/11
   - Joined domain `demo.local`
   - DNS trỏ duy nhất về DC01
   - User đăng nhập: `demo\\student`

3. Tài khoản domain
   - `student`: user thường, quyền domain user mặc định
   - `svc_sql`: service account có SPN, password yếu để crack demo
   - `Administrator`: chỉ dùng để setup, không dùng trong flow tấn công

4. Service target
   - Tối giản nhất: chỉ cần SPN trên `svc_sql`, không bắt buộc có SQL chạy thật
   - Khuyến nghị nếu muốn trực quan: IIS site đơn giản chạy app pool identity/service account riêng

#### Tại sao gọi là hybrid
- Hạ tầng nhận thực thật chạy trong AD lab.
- Thành phần trình diễn và crack có thể chia giữa Windows client và host/Kali/WSL.
- Phần live + phần artifact dự phòng cùng tồn tại, tăng độ ổn định buổi học.

### 4) Thông điệp giảng dạy cần chốt
- Kerberos an toàn hơn NTLM vì không gửi password trực tiếp.
- Nhưng service ticket cho SPN account vẫn có thể bị lạm dụng để crack offline nếu password yếu.
- Điểm yếu nằm ở vận hành tài khoản dịch vụ, không phải Kerberos “tự hỏng”.

### 5) Quyết định thực dụng
- Ưu tiên ít VM hơn nhiều chức năng.
- Không dựng SQL Server thật nếu không tăng giá trị demo.
- Dùng mật khẩu yếu có chủ đích và giải thích rõ đây là điều kiện lab để thấy tấn công hoàn tất.
- Chụp artifact sau mỗi milestone thay vì tin hoàn toàn vào live demo.

### 6) Verify phase
Pass khi:
- Danh sách asset, account, IP, hostname, công cụ đã chốt.
- Có sơ đồ lab 1 trang và script/thao tác setup cấp cao.
- Mọi thành phần trong kiến trúc đều phục vụ trực tiếp cho 2 mục tiêu demo.
## Phase 2: Breakdown theo ngày, dựng lab, rehearsal

### Breakdown theo ngày

#### Ngày 1 - Dựng nền lab
1. Chuẩn bị host
   - Kiểm tra RAM/CPU/dung lượng.
   - Cài hypervisor, tạo network host-only/NAT ổn định.
   - Tạo thư mục chứa ISO, VM, snapshot, tools.
   - Verify: tạo được 2 VM boot bình thường.

2. Dựng DC01
   - Cài Windows Server.
   - Đặt IP tĩnh, hostname `DC01`.
   - Cài AD DS + DNS, promote domain `demo.local`.
   - Tạo OU nếu cần tối giản, tạo user `student`, service account `svc_sql`.
   - Gán SPN cho `svc_sql`.
   - Verify:
     - `echo %LOGONSERVER%` hoặc kiểm tra domain controller.
     - `setspn -L svc_sql`
     - DNS resolve đúng `demo.local`, `dc01.demo.local`.

3. Dựng CL01
   - Cài Windows 10/11.
   - DNS trỏ về DC01.
   - Join domain `demo.local`.
   - Login bằng `demo\\student`.
   - Verify:
     - `whoami`
     - `systeminfo`/domain joined state
     - `klist` có TGT sau khi login

4. Snapshot mốc 1
   - Snapshot sau khi domain join thành công.
   - Ghi lại mọi credential lab vào file nội bộ.

#### Ngày 2 - Chuẩn bị 2 luồng demo
1. Luồng Kerberos bình thường
   - Từ CL01 xóa cache ticket nếu cần.
   - Login lại hoặc dùng `klist purge` rồi truy cập service.
   - Quan sát TGT/TGS bằng `klist`.
   - Nếu có IIS/service, truy cập resource thành công.
   - Chụp screenshot theo thứ tự trước/sau.
   - Verify: giải thích được ticket nào sinh ra ở bước nào.

2. Luồng Kerberoasting
   - Cài/chép công cụ cần dùng: Impacket/Rubeus/PowerView/GetUserSPNs và hashcat/john.
   - Enumerate SPN account.
   - Request TGS cho SPN.
   - Export hash định dạng crack được.
   - Chạy crack với wordlist tối giản.
   - Verify:
     - Có file hash.
     - Crack ra đúng password của `svc_sql` trong thời gian mục tiêu.

3. Tạo artifact dự phòng
   - Chụp toàn bộ màn hình chính: domain join, klist, SPN list, hash, crack success.
   - Quay video 2-3 phút cho mỗi luồng.
   - Lưu log text command + output.

4. Snapshot mốc 2
   - Snapshot sau khi tool setup và demo chạy xanh.

#### Ngày 3 - Rehearsal và đóng gói
1. Viết runbook final
   - Chỉ giữ các lệnh thật sự dùng trên sân khấu.
   - Mỗi lệnh có expected output ngắn.

2. Dry run lần 1
   - Bấm giờ toàn bộ demo.
   - Cắt mọi bước không tăng giá trị giảng dạy.

3. Dry run lần 2
   - Giả lập lỗi: mất DNS, clock skew, crack chậm.
   - Thử fallback pack.

4. Khóa môi trường
   - Tắt update, sleep, antivirus popup nếu phù hợp lab.
   - Sắp xếp desktop/thư mục demo gọn.
   - Chuẩn bị snapshot ngay trước giờ dạy.

### Checklist dựng môi trường

#### Hạ tầng host
- [ ] Laptop có tối thiểu 16GB RAM, khuyến nghị 24GB+
- [ ] Còn trống >= 80GB
- [ ] Hypervisor chạy ổn định
- [ ] Có network host-only hoặc NAT cố định
- [ ] Tắt các tác nhân gây sleep/update giữa buổi demo

#### DC01
- [ ] Hostname đúng `DC01`
- [ ] IP tĩnh đã đặt
- [ ] Domain `demo.local` hoạt động
- [ ] DNS role chạy
- [ ] Forward/reverse lookup ổn nếu cần
- [ ] User `student` tạo xong
- [ ] Service account `svc_sql` tạo xong
- [ ] SPN gán đúng và kiểm tra bằng `setspn -L`
- [ ] Password service account đã benchmark crack được

#### CL01
- [ ] DNS chỉ về DC01
- [ ] Join domain thành công
- [ ] Login bằng `demo\\student`
- [ ] `klist` thấy TGT
- [ ] Truy cập service target được nếu có service thật

#### Tooling
- [ ] Công cụ enumerate/request TGS sẵn sàng
- [ ] Công cụ crack sẵn sàng
- [ ] Wordlist đúng nơi
- [ ] Antivirus không chặn tool
- [ ] Script/lệnh copy-paste đặt đúng thứ tự

#### Artifact
- [ ] Screenshot flow thường đủ bước
- [ ] Screenshot flow attack đủ bước
- [ ] Video fallback ngắn đã quay
- [ ] Log text/output đã lưu
- [ ] Snapshot VM theo mốc đã tạo

### Checklist rehearsal trước khi demo
- [ ] Đồng hồ CL01 và DC01 lệch < 1 phút
- [ ] `nslookup demo.local` trả về DC đúng
- [ ] Login `demo\\student` thành công
- [ ] `klist purge` và xin lại ticket chạy được
- [ ] Lệnh enumerate SPN trả về `svc_sql`
- [ ] Xuất hash đúng định dạng đã test
- [ ] Crack ra password trong thời gian chấp nhận được hoặc mở sẵn artifact fallback
- [ ] Mọi cửa sổ/terminal đã đặt sẵn đúng thư mục
- [ ] Font/zoom đủ lớn để cả lớp nhìn
- [ ] Runbook in giấy hoặc mở offline
- [ ] Tắt thông báo hệ thống không liên quan
- [ ] Có file dự phòng trên host ngoài VM

### Verify phase
Pass khi:
- Chạy end-to-end cả 2 luồng ít nhất 2 lần liên tiếp.
- Tổng thời gian rehearsal <= 15 phút.
- Fallback pack mở được không cần internet.
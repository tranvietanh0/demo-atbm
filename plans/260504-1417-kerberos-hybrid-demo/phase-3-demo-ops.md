## Phase 3: Runbook buổi demo, fallback, tiêu chí hoàn thành

### Runbook buổi demo 10-15 phút

#### 0. Mở bài - 1 phút
Mục tiêu nói rõ:
- Phần 1: Kerberos hoạt động bình thường ra sao.
- Phần 2: Vì sao Kerberoasting vẫn khả thi nếu service account yếu.

Hiển thị sơ đồ lab:
- DC01 = KDC/AD/DNS
- CL01 = user client
- `svc_sql` = service account có SPN

#### 1. Demo Kerberos bình thường - 4 đến 5 phút
1. Đăng nhập CL01 bằng `demo\\student`.
2. Mở terminal, chạy kiểm tra nhanh:
   - `whoami`
   - `klist`
3. Giải thích TGT đã có sau đăng nhập.
4. Truy cập service hoặc kích hoạt request tới SPN target.
5. Chạy lại `klist`.
6. Chỉ ra service ticket mới xuất hiện.
7. Kết luận ngắn:
   - User không gửi password cho service.
   - KDC cấp ticket để truy cập dịch vụ.

Expected outcome:
- Có TGT trước truy cập service.
- Có thêm TGS/service ticket sau truy cập service.

#### 2. Demo Kerberoasting - 5 đến 6 phút
1. Từ CL01 với user thường `student`, enumerate SPN account.
2. Chỉ ra `svc_sql` là service account có SPN.
3. Request TGS cho SPN đó.
4. Xuất hash từ ticket.
5. Chuyển sang terminal crack hoặc host crack.
6. Chạy hashcat/john với wordlist demo.
7. Khi crack xong, chỉ ra password yếu của `svc_sql`.
8. Kết luận ngắn:
   - Không cần admin domain.
   - Không cần chạm password trực tiếp trên mạng.
   - Điểm mấu chốt là service account password yếu.

Expected outcome:
- Có hash đại diện cho TGS.
- Crack ra password trong thời gian ngắn.

#### 3. Chốt bài - 2 đến 3 phút
Thông điệp kết thúc:
- Kerberos không “vô dụng”; nó vẫn là cơ chế nhận thực mạnh.
- Kerberoasting thành công vì service account/SPN cấu hình yếu.
- Biện pháp giảm thiểu:
  - Password dài, ngẫu nhiên cho service account
  - gMSA nếu có điều kiện
  - Giảm SPN dư thừa
  - Giám sát request TGS bất thường

### Fallback nếu live demo lỗi

#### Fallback A - lỗi service access nhưng ticket vẫn có
- Bỏ bước truy cập service thật.
- Dùng `klist` + artifact screenshot để vẫn giải thích TGT/TGS.
- Mục tiêu học thuật vẫn đạt.

#### Fallback B - lỗi DNS / domain join / clock skew
- Chuyển sang snapshot sạch gần nhất.
- Nếu không kịp, mở video fallback 2-3 phút quay từ rehearsal.
- Vẫn giữ phần bình luận trực tiếp theo runbook.

#### Fallback C - hash extract thành công nhưng crack chậm
- Dừng live crack sau 20-30 giây.
- Mở output crack thành công đã chuẩn bị sẵn.
- Nói rõ đây là kết quả từ cùng hash cùng wordlist trên rehearsal.

#### Fallback D - tool bị chặn
- Dùng bản portable khác đã test trước.
- Nếu vẫn lỗi, mở artifact: SPN enumerate, hash, crack output.

#### Fallback E - VM lag hoặc treo
- Reboot vào snapshot pre-demo.
- Nếu thời gian không cho phép, chuyển sang slide + video minh họa.

### Bộ đồ nghề nên chuẩn bị trước giờ lên lớp
- 01 file txt chứa toàn bộ lệnh theo thứ tự
- 01 thư mục screenshots đánh số 01-02-03...
- 02 video ngắn: normal-flow.mp4, kerberoast-flow.mp4
- 01 file note expected output từng lệnh
- 01 bản sơ đồ lab PNG/PDF
- 01 bản slide offline

### Tiêu chí hoàn thành
- Có thể giải thích được đầy đủ TGT, TGS, SPN, service account bằng chính lab đã dựng.
- Phần 1 cho thấy Kerberos hoạt động hợp lệ với bằng chứng ticket.
- Phần 2 cho thấy Kerberoasting khả thi với user thường và password yếu.
- Có ít nhất 1 fallback khả dụng cho từng điểm lỗi chính: DNS/time/tool/crack/service.
- Người khác cầm runbook có thể rehearsal lại với cùng artifacts.

### Success criteria có thể đo
- Demo live hoàn chỉnh trong 10-15 phút.
- Không có bước nào phụ thuộc internet.
- Ít nhất 2 lần dry-run liên tiếp không phát sinh blocker mới.
- Artifact pack đủ để thay thế live demo mà vẫn giữ logic bài giảng.

### Verify phase
Pass khi:
- Runbook đã timebox từng phần.
- Fallback mapping rõ: lỗi nào -> chuyển sang gì.
- Tiêu chí hoàn thành đo được, không mơ hồ.
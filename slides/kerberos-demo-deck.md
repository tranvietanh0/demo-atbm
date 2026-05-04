# Slide 1 — Mục tiêu demo
- Minh họa Kerberos hoạt động bình thường
- Minh họa Kerberoasting trong lab cô lập
- Kết luận: điểm yếu nằm ở service account yếu, không phải Kerberos tự hỏng

---

# Slide 2 — Kiến trúc lab
- `DC01`: AD DS + DNS + KDC
- `CL01`: máy người dùng domain
- Host crack: WSL/Kali hoặc máy host ngoài lab
- `student`: user thường
- `svc_sql`: service account có SPN để roast
- Domain: `demo.local`

---

# Slide 3 — Flow Kerberos bình thường
1. User login trên `CL01`
2. Client nhận TGT từ KDC
3. User truy cập `\\dc01.demo.local\\SYSVOL`
4. Client nhận service ticket cho `cifs/dc01...`
5. User truy cập resource mà không gửi password trực tiếp cho service

---

# Slide 4 — Bằng chứng live
- `klist` trước khi truy cập resource
- Truy cập `SYSVOL`
- `klist` sau khi truy cập resource
- Chỉ ra TGT và service ticket mới sinh

---

# Slide 5 — Flow Kerberoasting
1. User thường enumerate SPN của `svc_sql`
2. Yêu cầu TGS cho SPN đó
3. Xuất hash từ TGS trên host crack
4. Crack offline bằng wordlist
5. Thu được mật khẩu yếu của service account

---

# Slide 6 — Ý nghĩa bảo mật
- Kerberos vẫn là cơ chế xác thực mạnh
- Luồng bình thường và luồng roast dùng hai target khác nhau
- Rủi ro đến từ vận hành account dịch vụ
- Giảm thiểu:
  - mật khẩu dài, ngẫu nhiên
  - gMSA nếu có
  - giảm SPN dư thừa
  - giám sát TGS request bất thường

---

# Slide 7 — Kết luận
- Phần 1: Kerberos hoạt động đúng với TGT và service ticket
- Phần 2: Kerberoasting khả thi khi service account yếu
- Bài học: an toàn giao thức vẫn phụ thuộc mạnh vào cấu hình và vận hành

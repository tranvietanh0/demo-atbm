## Plan: Demo học phần Kerberos hybrid

### Mục tiêu
Dựng một lab tối giản nhưng đủ thuyết phục để trình diễn 2 luồng trong 10-15 phút:
1. Kerberos hoạt động bình thường: AS-REQ/AS-REP, TGS-REQ/TGS-REP, truy cập service bằng vé hợp lệ.
2. Kerberoasting thực tế: user domain thường lấy service ticket của SPN account, xuất hash, crack offline với wordlist đã chuẩn bị.

### Phạm vi và deliverables
- 01 lab hybrid tối giản chạy được trên 1 laptop, ưu tiên local-first.
- 01 bộ slide ngắn 5-7 trang giải thích flow và mapping từng bước demo.
- 01 runbook thao tác demo 10-15 phút, có lệnh copy-paste sẵn.
- 01 checklist dựng môi trường.
- 01 checklist rehearsal trước giờ lên lớp.
- 01 phương án fallback khi live demo lỗi mạng, lỗi time sync, lỗi DNS, lỗi crack.
- 01 gói bằng chứng chụp màn hình/log: klist, GetUserSPNs, hashcat/john output, truy cập service thành công.

### Feasibility
- Reuse check: NEW, repo gần như trống; chỉ cần dùng repo để lưu kế hoạch, script, ảnh chụp, slide và runbook.
- Complexity: moderate.
- Backwards compatibility: additive, không đụng code hiện có.

### Kiến trúc lab đề xuất
Mô hình hybrid thực dụng, không cầu kỳ nhưng đúng bản chất:
- Host chính: laptop Windows 11 có VMware/VirtualBox.
- VM 1: Windows Server 2019/2022, vai trò AD DS + DNS + KDC.
  - Domain: demo.local
  - Máy: DC01
  - User thường: student
  - Service account có SPN: svc_sql / Password yếu có chủ đích để crack demo.
  - SPN gợi ý: MSSQLSvc/sql.demo.local:1433 hoặc HTTP/web.demo.local.
- VM 2: Windows 10/11 domain-joined, vai trò client.
  - Máy: CL01
  - User đăng nhập demo: student
  - Cài RSAT hoặc bộ công cụ cần thiết.
- Service mô phỏng:
  - Ưu tiên: service giả lập bằng account svc_sql có SPN, không cần SQL Server thật nếu mục tiêu chỉ là xin TGS.
  - Nếu muốn trực quan hơn: IIS đơn giản chạy bằng svc_web để có service target rõ ràng.
- Máy attacker:
  - Cùng CL01 hoặc máy host Kali/WSL tùy mức tiện.
  - Tối giản nhất: dùng CL01 để lấy TGS, host Windows/Kali để crack offline.

Lý do chọn mô hình này:
- Đủ thành phần để giải thích KDC, TGT, TGS, SPN, service account.
- Dựng được trong 2-3 ngày.
- Không phụ thuộc cloud hay hạ tầng trường.
- Có thể quay video/screenshot dự phòng ngay trên cùng bộ lab.

### Phases
- Phase 1: Chốt scope demo và asset cần chuẩn bị — phạm vi, thông điệp giảng dạy, cấu trúc repo, slide skeleton | Effort: S
- Phase 2: Dựng lab Kerberos tối giản — DC, domain join, DNS, time sync, user/service account, SPN, snapshot sạch | Effort: M
- Phase 3: Chuẩn bị flow Kerberos bình thường — script/lệnh xác minh TGT-TGS-service access, bằng chứng màn hình | Effort: S
- Phase 4: Chuẩn bị flow Kerberoasting — lệnh lấy SPN/TGS, xuất hash, crack offline, artifact dự phòng | Effort: M
- Phase 5: Rehearsal và đóng gói demo — runbook 10-15 phút, fallback pack, dry run end-to-end | Effort: S

### Dependencies
- Blocks: Slide hoàn chỉnh, runbook cuối, rehearsal cuối.
- Blocked by: Có image VM, ISO hệ điều hành, công cụ crack, quyền admin local để dựng lab.

### Data flow
- Normal flow: student -> KDC(AS) -> nhận TGT -> KDC(TGS) -> nhận service ticket -> service/SPN account -> truy cập thành công.
- Attack flow: student -> LDAP/SPN enumeration -> KDC(TGS) -> service ticket mã hóa theo secret của SPN account -> xuất hash -> hashcat/john offline -> lộ mật khẩu yếu của service account.
- Ownership:
  - Hạ tầng: VM DC01/CL01.
  - Chứng cứ demo: thư mục artifacts/ hoặc screenshots/ trong repo.
  - Lệnh thao tác: runbook + scripts/.

### Risk Assessment
| Risk | Likelihood (1-5) | Impact (1-5) | Score | Mitigation |
|------|------------------|--------------|-------|------------|
| Lệch giờ giữa client và DC làm Kerberos fail | 4 | 5 | 20 | Đồng bộ time trước mỗi rehearsal, tắt internet time ngoài lab, chụp sẵn ảnh lỗi và cách sửa |
| DNS/domain join sai nên client không lấy được ticket | 3 | 5 | 15 | Dùng DC làm DNS duy nhất, kiểm tra nslookup/ping/klist ngay sau join, tạo snapshot sau khi join thành công |
| Crack không ra mật khẩu trong thời gian demo | 3 | 5 | 15 | Dùng password yếu có chủ đích, benchmark trước, chuẩn bị sẵn output đã crack và video fallback |
| Công cụ tấn công bị antivirus chặn | 3 | 4 | 12 | Chuẩn bị exclusion/offline tools, test đúng máy sẽ demo, có bản zip nội bộ và checksum |
| VM giật, thiếu RAM, snapshot nặng | 3 | 4 | 12 | Giữ lab 2 VM tối giản, cấp phát RAM vừa đủ, tắt app nền, snapshot theo mốc |
| Trình bày quá dài, vượt 15 phút | 2 | 4 | 8 | Giới hạn 2 luồng chính, mọi lệnh copy-paste sẵn, rehearsal bấm giờ |
| User/service account cấu hình sai SPN | 2 | 4 | 8 | Script hóa bước setspn và kiểm tra lại bằng setspn -L trước rehearsal |

High-risk bắt buộc mitigation trước khi vào Phase 4:
- Đồng bộ thời gian và DNS phải được khóa ổn định.
- Hash cracking phải benchmark xong với đúng wordlist và đúng máy demo.

### Timeline
| Phase | Effort | Notes |
|-------|--------|-------|
| Phase 1: Scope và asset | S | Làm đầu tiên, unblock mọi phase sau |
| Phase 2: Dựng lab | M | Critical path, cần snapshot sau từng mốc |
| Phase 3: Flow Kerberos bình thường | S | Phụ thuộc Phase 2 |
| Phase 4: Flow Kerberoasting | M | Phụ thuộc Phase 2, cần mitigation rủi ro crack |
| Phase 5: Rehearsal và đóng gói | S | Phụ thuộc Phase 3-4 |
| Total | M | Critical path: 1 -> 2 -> 4 -> 5 |

### Tiêu chí hoàn thành
- Có thể dựng lab sạch từ checklist trong <= 4 giờ trên 1 máy.
- Demo flow thường chạy được liên tục không thao tác ngẫu hứng.
- Kerberoasting crack ra password yếu trong thời gian rehearsal mục tiêu <= 2 phút, hoặc có artifact fallback tương đương.
- Runbook 10-15 phút có timebox từng đoạn.
- Có snapshot/gói dự phòng cho cả 2 phần demo.
- Mỗi phase có bước verify rõ ràng, lặp lại được.

### Test matrix / verification
- Phase 1: Kiểm tra đủ file kế hoạch, runbook, checklist, asset list.
- Phase 2: `whoami`, `hostname`, domain join status, `klist`, `nslookup demo.local`, `setspn -L svc_sql` đều đúng.
- Phase 3: Từ CL01 xin và xem ticket thành công; truy cập service bằng account domain user hoạt động.
- Phase 4: `GetUserSPNs` hoặc tương đương xuất được ticket/hash; hashcat/john crack thành công với mật khẩu đã định.
- Phase 5: Dry-run full demo trong <= 15 phút, không thiếu file/lệnh.

### Rollback plan
- Sau mỗi mốc lớn tạo snapshot: sạch sau cài OS, sau promote DC, sau join domain, sau SPN/service setup, sau tool setup.
- Nếu Phase 4 hỏng: quay lại snapshot sau Phase 2, import lại công cụ, dùng artifacts đã chụp.
- Nếu demo live hỏng: chuyển sang video ngắn/screenshot pack nhưng vẫn giữ flow giải thích và chỉ ra log thật từ lab.

### File ownership
- `plans/260504-1417-kerberos-hybrid-demo/plan.md`: overview, dependency graph, risk, timeline.
- `plans/260504-1417-kerberos-hybrid-demo/phase-1-lab-scope.md`: scope, deliverables, kiến trúc lab.
- `plans/260504-1417-kerberos-hybrid-demo/phase-2-build-and-attack.md`: breakdown theo ngày, environment checklist, rehearsal checklist.
- `plans/260504-1417-kerberos-hybrid-demo/phase-3-demo-ops.md`: runbook, fallback, success criteria.

### Handoff
Sau khi duyệt kế hoạch, thực thi theo thứ tự:
1. Tạo thư mục `artifacts/`, `scripts/`, `slides/`.
2. Viết runbook lệnh chi tiết.
3. Dựng lab và chụp proof theo checklist.

/t1k:cook C:/Projects/MyProject/demo-atbm/plans/260504-1417-kerberos-hybrid-demo/plan.md
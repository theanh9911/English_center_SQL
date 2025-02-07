# 📚 English Center - Relational Database System

## 1️⃣ Introduction

The English center information management system is built on the SQL platform. The system was created to help update information of students, teachers, and center managers more easily.
The system has main functions such as: managing classrooms, shifts, schedules, classes, teacher and student information, information about courses at the center and the learning results of students.
---

## 2️⃣ Entity Relationship Model:

The entity relationship model describes the main entities in the system and the relationships between them:

- **Học viên (HOC_VIEN)**: Saves personal information of students.
- **Giáo viên (GIAO_VIEN)**: Saves personal information and IELTS level of teachers.
- **Khóa học (KHOA_HOC)**: List of courses provided by the center.
- **Lớp học (LOP_HOC)**: Shows each specific class of a course.
- **Ca học (CA)**: Includes the hours of the shifts.
- **Phòng học (PHONG)**: Includes the room numbers of the classrooms.
- **Lịch học (LICH)**: Includes the days of the week.
  
📌 *The ERD diagram will be attached as an image in the repository.*
![image](https://github.com/user-attachments/assets/5b0fff1d-e4d4-4047-8340-4dd2e78cb481)

---

## 3️⃣ Relational Data Model:

- **GIAO_VIEN (ma_gv, hoten_gv, namsinh_gv, phai_gv, diachi_gv, sdt_gv, email_gv, diem_ielts_gv, luong)**
- **HOC_VIEN (ma_hv, hoten_hv, namsinh_hv, phai_hv, diachi_hv, sdt_hv, email_hv)**
- **KHOA_HOC (ma_kh, ten_kh, dau_vao, dau_ra, hoc_phi)**
- **LOP_HOC (ma_lh, ten_lh, ma_kh, gv_ptrach, ngay_mo, ngay_dong)**
- **DANG_KY (ma_hv, ma_kh)**
- **LICH (ma_thu, thu)**
- **CA (ma_ca, gio_vao, gio_ra)**
- **PHONG (ma_phong, so_phong)**
- **NGAY_CA (ma_id, ma_thu, ma_ca**
- **PHONG_NGAY_CA (ma_id, ma_phong, ma_lh)**
- **KQHT (ma_hv, ma_lh, diem, so_buoi_vang, ngay_nhap_hoc)**




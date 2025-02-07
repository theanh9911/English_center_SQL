create database TTTA

create table GIAO_VIEN ( 
                        [ma_gv] char(4) primary key,
						[hoten_gv] nvarchar(50) not null,
						[namsinh_gv] int,
						[phai_gv] nvarchar(3) check ([phai_gv] in (N'Nam',N'Nữ')),
						[diachi_gv] nvarchar(500),
						[sdt_gv] varchar(10) not null,
						[email_gv] varchar(40) ,
						[diem_ielts_gv] float not null,
						[luong] int
                        )

CREATE table HOC_VIEN  (
                       [ma_hv] char(6) primary key,
					   [hoten_hv] nvarchar(50) not null,
					   [namsinh_hv] int,
					   [phai_hv] nvarchar(3) check ([phai_hv] in (N'Nam',N'Nữ')),
					   [diachi_hv] nvarchar(500),
					   [sdt_hv] varchar(10) not null ,
					   [email_hv] varchar(40) 
                       )

create table KHOA_HOC (
                       [ma_kh] char(4) primary key,
					   [ten_kh] nvarchar(50) not null,
					   [dau_vao] nvarchar(50) not null,
					   [dau_ra] nvarchar(50) not null,
					   [hoc_phi] int
					   )

create table LOP_HOC (
                      [ma_lh] char(5) primary key,
					  [ten_lh] nvarchar(50) not null,
					  [ma_kh] char(4) foreign key references KHOA_HOC([ma_kh]),
					  [gv_ptrach] char(4) foreign key references GIAO_VIEN([ma_gv]),
					  [ngay_mo] date,
					  [ngay_dong] date
					  )
alter table LOP_HOC alter column [gv_ptrach] char(4) not null
alter table LOP_HOC alter column [ma_kh] char(4) not null
					
create table DANG_KY (
                      [ma_hv] char(6) foreign key references HOC_VIEN([ma_hv]) not null,
					  [ma_kh] char(4) foreign key references KHOA_HOC([ma_kh]) not null,
					  )
alter table DANG_KY add primary key ([ma_hv],[ma_kh])

create table LICH (
                   [ma_thu] char(3) primary key,
				   [thu] nvarchar(10),
				   )

create table CA (
                 [ma_ca] char(3) primary key,
				 [gio_vao] varchar(10) not null,
				 [gio_ra] varchar(10) not null,
				 )

create table PHONG (
                    [ma_phong] char(4) primary key,
					[so_phong] char(3) not NULL UNIQUE,
					)

create table NGAY_CA (
                      [ma_id] char(4) primary key,
					  [ma_thu] char(3) foreign key references LICH([ma_thu]),
					  [ma_ca] char(3) foreign key references CA([ma_ca]),
					  )

create table PHONG_NGAY_CA (
                            [ma_id] char(4) foreign key references NGAY_CA([ma_id]) not null,
							[ma_phong] char(4) foreign key references PHONG([ma_phong]) not null,
							[ma_lh] char(5) foreign key references LOP_HOC([ma_lh]) not null,
							)
alter table PHONG_NGAY_CA add primary key ([ma_id],[ma_phong])
alter table PHONG_NGAY_CA add unique ([ma_id],[ma_lh])

create table KQHT (
                   [ma_hv] char(6) foreign key references HOC_VIEN([ma_hv]) not null,
				   [ma_lh] char(5) foreign key references LOP_HOC([ma_lh]) not null,
				   [diem] float,
				   [so_buoi_vang] INT DEFAULT 0,
				   [ngay_nhap_hoc] date,
				   )
				  
alter table KQHT add primary key ([ma_hv],[ma_lh])

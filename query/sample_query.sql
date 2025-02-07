--1. Danh sách các học viên đang học khóa TOEIC 4 KỸ NĂNG có đầu ra là 600+
select t3.[ma_kh], t3.[ma_hv], t4.[hoten_hv]
from
(
select t1.[ma_kh], t1.[ma_hv]
from DANG_KY t1 left join LOP_HOC t2 on t1.[ma_kh] = t2.[ma_kh]
where t1.[ma_kh] = (select [ma_kh] from KHOA_HOC where [ten_kh] = N'TOEIC 4 KỸ NĂNG' and [dau_ra] = '600+')
) t3
left join HOC_VIEN t4 on t3.[ma_hv] = t4.[ma_hv]

-- 2. Tỷ lệ học viên tốt nghiệp khóa TOEIC 2 KỸ NĂNG có đầu ra là 800+ 
--   (điểm của sinh viên đó lớn hơn hoặc bằng 7)

select t1.[ma_hv] into #1
from DANG_KY t1 left join KQHT t2 on t1.[ma_hv] = t2.[ma_hv]
where t1.[ma_kh] = (select [ma_kh] from KHOA_HOC where [ten_kh] = N'TOEIC 2 KỸ NĂNG' and [dau_ra] = '800+')

select t1.[ma_hv] into #2
from DANG_KY t1 left join KQHT t2 on t1.[ma_hv] = t2.[ma_hv]
where t1.[ma_kh] = (select [ma_kh] from KHOA_HOC where [ten_kh] = N'TOEIC 2 KỸ NĂNG' and [dau_ra] = '800+')
      and t2.[diem] >= 7

select (select convert(float,count([ma_hv])) from #2)/(select convert(float,count([ma_hv])) from #1) 

-- 7. Các lớp do giáo viên Phạm Bằng phụ trách.
select * from LOP_HOC
select * from GIAO_VIEN
select t1.[ma_lh], t1.[ten_lh], t2.[hoten_gv]
from LOP_HOC t1 left join GIAO_VIEN t2 on t1.[gv_ptrach] = t2.[ma_gv]
where t2.[hoten_gv] = N'Phạm Bằng'

-- 8. Khóa học có nhiều học viên theo học nhất hiện tại
SELECT TOP 1 DK.[ma_kh], LH.ten_lh, count(*) as [soluong_hv]
from DANG_KY DK JOIN dbo.LOP_HOC LH ON DK.ma_kh=LH.ma_kh
group by DK.ma_kh,LH.ten_lh
ORDER BY soluong_hv DESC

SELECT * FROM dbo.DANG_KY


-- 9. Danh sách những học viên vắng từ 3 buổi trở lên và có điểm tổng kết bé hơn 7
select t2.[ma_hv], t2.[ma_lh], t1.[hoten_hv], t2.[diem], t2.[so_buoi_vang]
from HOC_VIEN t1 right join KQHT t2 on t1.[ma_hv] = t2.[ma_hv]
where t2.[so_buoi_vang] > 2 and t2.[diem] < 7

-- 10. Danh sách học viên học lại tại trung tâm và danh sách các lớp mà học viên đó học lại
select t4.[ma_hv], t4.[ma_lh], t4.[ngay_nhap_hoc]
from 
(
select t1.[ma_hv]
from KQHT t1 left join LOP_HOC t2 on t1.[ma_lh] = t2.[ma_lh]
group by t1.[ma_hv] having count([ma_kh]) > 1
) t3
inner join KQHT t4 on t3.[ma_hv] = t4.[ma_hv]

----IN lịch của gv
create PROCEDURE PR_LICH
@ten nvarCHAR (20)
AS
BEGIN
	SELECT L.thu,gio_vao,gio_ra,PNC.ma_phong,PNC.ma_lh 
	FROM dbo.LICH AS L,dbo.NGAY_CA AS NC,dbo.CA,dbo.PHONG_NGAY_CA AS PNC
	WHERE L.ma_thu=NC.ma_thu 
		AND NC.ma_ca=CA.ma_ca 
		AND NC.ma_id=PNC.ma_id
		AND PNC.ma_lh IN (
				SELECT LH.ma_lh
				FROM dbo.GIAO_VIEN AS GV,dbo.LOP_HOC AS LH
				WHERE GV.ma_gv =LH.gv_ptrach AND GV.hoten_gv=@ten)

END
EXEC PR_LICH N'Phạm Khác'
--- in lịch hs
CREATE PROCEDURE PR_LICH_HS
@ten nvarCHAR (20)
AS
BEGIN
	SELECT L.thu,gio_vao,gio_ra,PNC.ma_phong,PNC.ma_lh 
	FROM dbo.LICH AS L,dbo.NGAY_CA AS NC,dbo.CA,dbo.PHONG_NGAY_CA AS PNC
	WHERE L.ma_thu=NC.ma_thu 
		AND NC.ma_ca=CA.ma_ca 
		AND NC.ma_id=PNC.ma_id
		AND PNC.ma_lh IN (
				SELECT LH.ma_lh
				FROM dbo.HOC_VIEN AS HV,dbo.LOP_HOC AS LH,dbo.KQHT
				WHERE HV.ma_hv = dbo.KQHT.ma_hv AND LH.ma_lh=dbo.KQHT.ma_lh AND HV.hoten_hv=@ten)

END
EXEC PR_LICH_HS N'Nguyễn Văn Một'

SELECT * FROM dbo.GIAO_VIEN
SELECT *  FROM dbo.PHONG_NGAY_CA


--số phòng của lớp X
CREATE PROCEDURE PR_SOPHONG
@malop CHAR(5)
AS
BEGIN 
SELECT L.thu,gio_vao,gio_ra,PNC.ma_phong,P.so_phong
	FROM dbo.LICH AS L,dbo.NGAY_CA AS NC,dbo.CA,dbo.PHONG_NGAY_CA AS PNC,dbo.PHONG AS P
	WHERE L.ma_thu=NC.ma_thu 
		AND NC.ma_ca=CA.ma_ca 
		AND NC.ma_id=PNC.ma_id
		AND	 PNC.ma_phong=P.ma_phong
		AND PNC.ma_lh=@malop
END
EXEC dbo.PR_SOPHONG 'LH002' -- nvarchar(20)
PRINT (date_sub)


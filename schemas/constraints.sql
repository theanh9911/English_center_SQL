-- RBTV 1: Giáo viên phải có bằng IELTS từ 7.5 trở lên và bé hơn hoặc bằng 9.0
CREATE trigger TRIGGER1 on GIAO_VIEN 
for insert, update
as
begin
      declare @count int = 0
	  select @count = count(*) from inserted where inserted.diem_ielts_gv < 7.5 and inserted.diem_ielts_gv > 9.0
	  if (@count > 0)
	  begin
	        print N'Điểm IELTS của giáo viên phải lớn hơn hoặc bằng 7.5'
			rollback tran
	  end
end
GO

-- RBTV 2: Các giáo viên có bằng IELTS dưới 8.0 không được dạy các khóa IELTS 7.5+, TOEIC 2 kỹ năng 800+, TOEIC 4 kỹ năng 800+
CREATE trigger TRIGGER2 on LOP_HOC 
for insert, update
as
begin
      declare @count int = 0
	  declare @makh1 char(4)
	  declare @makh2 char(4)
	  declare @makh3 char(4)
	  select @makh1 = ma_kh from khoa_hoc where ten_kh = 'IELTS' and dau_ra = '7.5+'
	  select @makh2 = ma_kh from khoa_hoc where ten_kh = N'TOEIC 2 KỸ NĂNG' and dau_ra = '800+'
	  select @makh3 = ma_kh from khoa_hoc where ten_kh = N'TOEIC 4 KỸ NĂNG' and dau_ra = '800+'
	  select @count = count(*) from GIAO_VIEN join inserted on GIAO_VIEN.[ma_gv] = [inserted].[gv_ptrach]
	  where [inserted].[ma_kh] in (@makh1, @makh2, @makh3) and GIAO_VIEN.[diem_ielts_gv] < 8.0
	  if (@count > 0)
	  begin
	        print N'Giáo viên không đủ điều kiện để dạy học lớp này'
			rollback tran
	  end
end
GO

-- RBTV 3: Một lớp học không được phân vào 2 phòng khác nhau trong cùng một thời điểm.
alter table PHONG_NGAY_CA add unique ([ma_id],[ma_lh])
GO

-- RBTV 4: Lương của giáo viên thấp nhất là 5 triệu.
Create trigger TRIGGER4 on GIAO_VIEN 
for insert, update
as
begin
      declare @count int = 0
	  select @count = count(*) from inserted where [luong] < 5000
	  if (@count > 0)
	  begin
	        print N'Lương giáo viên phải cao hơn hoặc bằng 5000'
			rollback tran
	  end
end
GO

-- RBTV 5: Một học viên không thể học cùng lúc nhiều hơn 1 lớp học trong cùng một khóa học.
Create trigger TRIGGER5 on KQHT 
for insert, update
as
begin
      declare @count int = 0
	  select @count = count(*) from 
	  (select KQHT.[ma_hv], KQHT.[ma_lh], LOP_HOC.[ma_kh], LOP_HOC.[ngay_mo], LOP_HOC.[ngay_dong]
	         from KQHT join LOP_HOC on KQHT.[ma_lh] = LOP_HOC.[ma_lh]) as B1,
	  (select inserted.[ma_hv], inserted.[ma_lh], LOP_HOC.[ma_kh], LOP_HOC.[ngay_mo], LOP_HOC.[ngay_dong]
	         from inserted join LOP_HOC on inserted.[ma_lh] = LOP_HOC.[ma_lh]) as B2
	  where B1.[ma_hv] = B2.[ma_hv] and B1.[ma_lh] != B2.[ma_lh]
	        and ((B1.[ngay_mo] > B2.[ngay_mo] and B1.[ngay_mo] < B2.[ngay_dong])
			    or (B1.[ngay_mo] < B2.[ngay_mo] and B2.[ngay_mo] < B1.[ngay_dong]))
			and B1.[ma_kh] = B2.[ma_kh]
	  if (@count > 0)
	  begin
	        print N'Một học viên không thể học cùng lúc nhiều hơn 1 lớp học trong cùng một khóa học'
			rollback tran
	  end
END
GO

-- RBTV 6: Ngày mở nhỏ hơn ngày đóng
Create trigger TRIGGER6 on LOP_HOC
for insert, update
as
begin
       declare @count int = 0
	   select @count = count(*) from [inserted]
	   where [inserted].[ngay_mo] > [inserted].[ngay_dong]
	   if (@count > 0)
	   begin
	         print N'Ngày mở phải nhỏ hơn ngày đóng'
			 rollback tran
	   end
END
GO

-- RBTV 7: Lớp học có thể nhận thêm học viên nếu như lớp đó mở chưa quá một tuần
Create trigger TRIGGER7 on KQHT
for insert, update
as
begin
     declare @ngaymo date
	 declare @ngaynhaphoc date
	 select @ngaymo = ngay_mo, @ngaynhaphoc = ngay_nhap_hoc from LOP_HOC as A1,
	        [inserted] as A2 
	 where A1.[ma_lh] = A2.[ma_lh]
	 if (DATEDIFF(day, @ngaymo, @ngaynhaphoc) > 7 or DATEDIFF(day, @ngaymo, @ngaynhaphoc) < 0)
	 begin
	       print N'Dữ liệu không hợp lệ'
		   rollback tran
	 end
END
GO

-- RBTV 8: Trung tâm chỉ tuyển giáo viên lớn hơn 19 tuổi
Create trigger TRIGGER9 on GIAO_VIEN
for insert, update
as
begin
      declare @count int
	  select @count = count(*) from [inserted] 
	  where YEAR(getdate()) - YEAR(namsinh_gv) <= 20
	  if @count > 0
	  begin
	        print N'Dữ liệu không hợp lệ'
			rollback tran
	 end
END
GO

-- RBTV 9: Lớp học mà học viên theo học phải dạy chương trình khóa học mà học viên đó đăng ký
create trigger TRIGGER10 on KQHT
for insert, update
as
begin
	declare @lopday char(5)
	declare @lophoc char(5)
	

	select @lopday =LH.ma_kh 
	from LOP_HOC as LH,inserted
	where LH.ma_lh=inserted.ma_lh
	if (@lopday not in 
						(select DANG_KY.ma_kh 
						from inserted,DANG_KY
						where inserted.ma_hv=DANG_KY.ma_hv)) 
		begin
			print N'Lớp đăng ký không trùng khớp'
			rollback transaction
		end
end
GO

-- RBTV 11.1: MA_GV phải có dạng ‘GV%’
CREATE TRIGGER TRIGGER11 ON GIAO_VIEN
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @Count INT = 0
	SELECT @Count = COUNT(*) FROM INSERTED WHERE MA_GV NOT LIKE 'GV%'
	IF(@Count > 0)
		BEGIN
			PRINT N'MA_GV không hợp lệ'
			ROLLBACK TRAN
		END
END
GO

-- RBTV 11.2: MA_HV phải có dạng ‘HV%’
CREATE TRIGGER TRIGGER12 ON HOC_VIEN
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @Count INT = 0
	SELECT @Count = COUNT(*) FROM INSERTED WHERE MA_HV NOT LIKE 'HV%'
	IF(@Count > 0)
		BEGIN
			PRINT N'MA_HV không hợp lệ'
			ROLLBACK TRAN
		END
END

-- RBTV 11.3: MA_LH phải có dạng ‘LH%’
CREATE TRIGGER TRIGGER13 ON LOP_HOC
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @Count INT = 0
	SELECT @Count = COUNT(*) FROM INSERTED WHERE MA_LH NOT LIKE 'LH%'
	IF(@Count > 0)
		BEGIN
			PRINT N'MA_LH không hợp lệ'
			ROLLBACK TRAN
		END
END
GO

-- RBTV 12: Một lớp học có tối thiểu 5 học viên và tối đa 15 học viên
CREATE TRIGGER gioi_han_hoc_vien ON dbo.KQHT
AFTER INSERT, UPDATE 
AS 
BEGIN
	DECLARE @slhocvien INT 
	SELECT @slhocvien = COUNT(*) FROM (SELECT ma_lh, COUNT(*) AS soluong  FROM dbo.KQHT
                                   GROUP BY ma_lh
								   HAVING COUNT(*) <5 OR COUNT(*) >15) AS slhv
	IF @slhocvien > 0
	BEGIN
		PRINT 'LOP HOC THIEU THANH VIEN HOAC QUA SO LUONG QUY DINH'
		ROLLBACK TRAN
	END
END

CREATE DATABASE [QuanLyBanHang_K23548010069]
GO
USE [QuanLyBanHang_K23548010069]
GO
-- Bảng KhachHang
CREATE TABLE [KhachHang]
(
    [maKhachHang] INT PRIMARY KEY IDENTITY(1,1),
    [tenKhachHang] NVARCHAR(100) NOT NULL,
    [soDienThoai] VARCHAR(15),
    [diaChi] NVARCHAR(200)
)

-- Bảng SanPham
CREATE TABLE [SanPham]
(
    [maSanPham] INT PRIMARY KEY IDENTITY(1,1),
    [tenSanPham] NVARCHAR(100) NOT NULL,
    [gia] MONEY CHECK (gia > 0),
    [soLuongTon] INT CHECK (soLuongTon >= 0)
)

-- Bảng HoaDon
CREATE TABLE [HoaDon]
(
    [maHoaDon] INT PRIMARY KEY IDENTITY(1,1),
    [maKhachHang] INT,
    [maSanPham] INT,
    [soLuong] INT CHECK (soLuong > 0),
    [ngayLap] DATE DEFAULT GETDATE(),

    FOREIGN KEY ([maKhachHang]) REFERENCES [KhachHang]([maKhachHang]),
    FOREIGN KEY ([maSanPham]) REFERENCES [SanPham]([maSanPham])
)
-- Thêm khách hàng
INSERT INTO [KhachHang] ([tenKhachHang], [soDienThoai], [diaChi])
VALUES 
(N'Nguyễn Văn A', '0123456789', N'Hà Nội'),
(N'Trần Thị B', '0987654321', N'Hồ Chí Minh')

-- Thêm sản phẩm
INSERT INTO [SanPham] ([tenSanPham], [gia], [soLuongTon])
VALUES 
(N'Laptop', 15000000, 10),
(N'Chuột', 200000, 50)

-- Thêm hóa đơn
INSERT INTO [HoaDon] ([maKhachHang], [maSanPham], [soLuong])
VALUES 
(1, 1, 2),
(2, 2, 5)
SELECT * FROM [KhachHang]
SELECT * FROM [SanPham]
SELECT * FROM [HoaDon]
GO
CREATE FUNCTION [fn_TinhTongTienHoaDon]
(
    @maHoaDon INT
)
RETURNS MONEY
AS
BEGIN
    DECLARE @tongTien MONEY

    SELECT @tongTien = sp.gia * hd.soLuong
    FROM [HoaDon] hd
    JOIN [SanPham] sp ON hd.maSanPham = sp.maSanPham
    WHERE hd.maHoaDon = @maHoaDon

    RETURN @tongTien
END
GO
SELECT dbo.fn_TinhTongTienHoaDon(1) AS TongTien
GO
CREATE FUNCTION [fn_DanhSachHoaDonTheoKhach]
(
    @maKhachHang INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        hd.maHoaDon,
        hd.maKhachHang,
        hd.maSanPham,
        hd.soLuong,
        hd.ngayLap,
        sp.tenSanPham,
        sp.gia
    FROM [HoaDon] hd
    JOIN [SanPham] sp ON hd.maSanPham = sp.maSanPham
    WHERE hd.maKhachHang = @maKhachHang
)
GO
SELECT * 
FROM dbo.fn_DanhSachHoaDonTheoKhach(1)
GO
CREATE FUNCTION [fn_TongTienTheoKhach]
(
    @maKhachHang INT
)
RETURNS @ketQua TABLE
(
    maKhachHang INT,
    tongTien MONEY
)
AS
BEGIN
    DECLARE @tong MONEY

    SELECT @tong = SUM(sp.gia * hd.soLuong)
    FROM [HoaDon] hd
    JOIN [SanPham] sp ON hd.maSanPham = sp.maSanPham
    WHERE hd.maKhachHang = @maKhachHang

    INSERT INTO @ketQua
    VALUES (@maKhachHang, @tong)

    RETURN
END
GO
SELECT * 
FROM dbo.fn_TongTienTheoKhach(1)
GO
CREATE PROCEDURE [sp_ThemSanPham]
    @tenSanPham NVARCHAR(100),
    @gia MONEY,
    @soLuong INT
AS
BEGIN
    IF @gia <= 0
    BEGIN
        PRINT N'Giá phải lớn hơn 0'
        RETURN
    END

    INSERT INTO [SanPham] ([tenSanPham], [gia], [soLuongTon])
    VALUES (@tenSanPham, @gia, @soLuong)
END
GO
EXEC sp_ThemSanPham N'Bàn phím', 500000, 20
EXEC sp_ThemSanPham N'Lỗi', -100, 10
GO
CREATE PROCEDURE [sp_TongTienKhachHang]
    @maKhachHang INT,
    @tongTien MONEY OUTPUT
AS
BEGIN
    SELECT @tongTien = SUM(sp.gia * hd.soLuong)
    FROM [HoaDon] hd
    JOIN [SanPham] sp ON hd.maSanPham = sp.maSanPham
    WHERE hd.maKhachHang = @maKhachHang
END
GO
DECLARE @tong MONEY
EXEC sp_TongTienKhachHang 1, @tong OUTPUT
SELECT @tong AS TongTien
GO
CREATE PROCEDURE [sp_DanhSachHoaDon]
AS
BEGIN
    SELECT 
        hd.maHoaDon,
        kh.tenKhachHang,
        sp.tenSanPham,
        hd.soLuong,
        hd.ngayLap,
        sp.gia
    FROM [HoaDon] hd
    JOIN [KhachHang] kh ON hd.maKhachHang = kh.maKhachHang
    JOIN [SanPham] sp ON hd.maSanPham = sp.maSanPham
END
GO
EXEC sp_DanhSachHoaDon
GO
CREATE TRIGGER trg_GiamSoLuongTon
ON HoaDon
AFTER INSERT
AS
BEGIN
    UPDATE sp
    SET sp.soLuongTon = sp.soLuongTon - i.soLuong
    FROM SanPham sp
    JOIN inserted i ON sp.maSanPham = i.maSanPham
END
GO
SELECT * FROM SanPham
INSERT INTO HoaDon(maKhachHang, maSanPham, soLuong)
VALUES (1, 1, 2)
SELECT * FROM SanPham
# BÀI KIỂM TRA SỐ 2

## Thông tin sinh viên
- Họ tên: Nguyễn Đăng Thịnh
- MSSV: K235480106069
- Lớp: K59KMT.K01

## Yêu cầu bài toán
Xây dựng hệ thống quản lý bán hàng gồm:
- Tạo database và các bảng (KhachHang, SanPham, HoaDon)
- Thêm dữ liệu mẫu
- Xây dựng các Function
- Xây dựng Stored Procedure
- Xây dựng Trigger

## Cách thực hiện
- Sử dụng SQL Server để tạo database và các bảng
- Áp dụng các ràng buộc khóa chính, khóa ngoại
- Sử dụng JOIN để xử lý dữ liệu giữa các bảng
- Kiểm tra kết quả bằng SELECT và EXEC
# PHẦN 1: DATABASE + TABLE
<img width="1920" height="1079" alt="image" src="https://github.com/user-attachments/assets/23f0a877-92c1-4e47-a6b0-158b5f95cd28" />
Ảnh này cho thấy tôi đã tạo thành công database QuanLyBanHang_K23548010069 và chuyển sang sử dụng database này để thực hiện các bước tiếp theo.
<img width="1919" height="1080" alt="image" src="https://github.com/user-attachments/assets/d8605fa5-7710-4fa6-b9e2-7cc6c78091c3" />
Ảnh này cho thấy tôi đã tạo thành công 3 bảng KhachHang, SanPham, HoaDon với các kiểu dữ liệu phù hợp. 
Trong đó:
- maKhachHang, maSanPham, maHoaDon là khóa chính (PK)
- maKhachHang và maSanPham trong bảng HoaDon là khóa ngoại (FK)
- Các ràng buộc CHECK đảm bảo dữ liệu hợp lệ (giá > 0, số lượng >= 0)

# PHẦN 2: INSERT DATA
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/089e3690-9315-4c4d-a206-97eaa8fbfbc9" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/5d9744cf-a785-44dc-9eac-da697c0bdf79" />
Ảnh trên cho thấy tôi đã thêm dữ liệu mẫu vào các bảng KhachHang, SanPham, HoaDon. 
Kết quả SELECT cho thấy dữ liệu đã được lưu thành công và các bảng liên kết đúng với nhau thông qua khóa ngoại.
Dữ liệu này sẽ được sử dụng để kiểm tra các Function, Store Procedure và Trigger ở các phần tiếp theo.

# PHẦN 3: FUNCTION
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ddde7702-05d9-40ec-a373-0ee5a84cfc62" />
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/d4220400-7fbb-408f-bab5-bde1b7c557a3" />
Hàm fn_TinhTongTienHoaDon được xây dựng để tính tổng tiền của một hóa đơn dựa trên giá sản phẩm và số lượng mua.
Hàm sử dụng phép JOIN giữa bảng HoaDon và SanPham để lấy giá sản phẩm, sau đó nhân với số lượng để tính tổng tiền.
Kết quả trả về là một giá trị kiểu MONEY.
<img width="1914" height="1073" alt="image" src="https://github.com/user-attachments/assets/ecfc175f-45ef-442f-aebb-2f1d33b5d736" />
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/e7d3d801-641e-4766-ab51-6d79a0c668db" />
Hàm fn_DanhSachHoaDonTheoKhach là Inline Table-Valued Function dùng để trả về danh sách các hóa đơn của một khách hàng cụ thể.
Hàm sử dụng phép JOIN giữa bảng HoaDon và SanPham để hiển thị đầy đủ thông tin hóa đơn cùng với tên sản phẩm và giá.
<img width="1920" height="1078" alt="image" src="https://github.com/user-attachments/assets/7e49c7dd-149e-43e5-af5c-a94d6e61d665" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b4ea30b3-c114-47a8-a5c1-570bd3d8b388" />
Hàm fn_TongTienTheoKhach là Multi-statement Table-Valued Function dùng để tính tổng tiền của tất cả hóa đơn theo từng khách hàng.
Hàm sử dụng biến bảng @ketQua để lưu kết quả, có khai báo biến @tong để tính tổng tiền thông qua phép SUM giữa giá sản phẩm và số lượng.
Khác với Inline Function, hàm này có nhiều bước xử lý logic trong khối BEGIN...END.

# PHẦN 4: STORED PROCEDURE
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/195ebf0a-19f7-4883-a6fe-5c73309bb808" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/caedff89-72c3-43e6-a871-738a59eeeb6c" />
<img width="1910" height="1075" alt="image" src="https://github.com/user-attachments/assets/e79986cf-e702-4e54-8c55-13a0f69140d0" />
Store Procedure sp_ThemSanPham được xây dựng để thêm sản phẩm mới vào bảng SanPham.
Procedure có kiểm tra điều kiện logic: nếu giá sản phẩm nhỏ hơn hoặc bằng 0 thì không cho phép thêm và hiển thị thông báo lỗi.
Khi giá hợp lệ, dữ liệu sẽ được thêm vào bảng SanPham.
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/92778f67-1833-4a58-9f10-af50a0ec0369" />
<img width="1892" height="1053" alt="image" src="https://github.com/user-attachments/assets/9d0fbdc0-daf1-4431-9d10-005573b90f01" />
Store Procedure sp_TongTienKhachHang được sử dụng để tính tổng tiền của một khách hàng.
Procedure sử dụng tham số OUTPUT để trả về giá trị tổng tiền sau khi tính toán từ bảng HoaDon và SanPham thông qua phép JOIN.
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2c2fec65-7c50-4bbf-bf91-fe583605c86b" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ae2b0444-4901-467a-ae90-5a6f90732641" />
Store Procedure sp_DanhSachHoaDon được xây dựng để trả về danh sách hóa đơn.
Procedure sử dụng JOIN giữa các bảng HoaDon, KhachHang và SanPham để hiển thị đầy đủ thông tin gồm tên khách hàng, tên sản phẩm và giá.

# PHẦN 5: TRIGGER
<img width="1920" height="1079" alt="image" src="https://github.com/user-attachments/assets/f62d379b-b030-4729-988c-3749c469ee24" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0335a573-cad4-4f85-b509-17d3407d10e0" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/c350c6ec-f28d-4835-8de2-e2049b1cc1e1" />
<img width="1916" height="1080" alt="image" src="https://github.com/user-attachments/assets/4bf92b38-09de-4f5c-934d-188ec085efda" />
Trigger trg_GiamSoLuongTon được tạo để tự động giảm số lượng tồn của sản phẩm khi có hóa đơn mới được thêm vào.
Khi thực hiện INSERT vào bảng HoaDon, trigger sẽ kích hoạt và cập nhật lại số lượng tồn trong bảng SanPham tương ứng.





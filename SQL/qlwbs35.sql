-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th8 13, 2025 lúc 07:16 AM
-- Phiên bản máy phục vụ: 10.4.28-MariaDB
-- Phiên bản PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `qlwbs35`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_gh_at_ins` (IN `Ma_KH` VARCHAR(15), IN `Ma_DH` VARCHAR(15))   BEGIN
	DECLARE mdh varchar(15);
	UPDATE donhang set donhang.TrangThai='Đã gửi yêu cầu' WHERE donhang.Ma_DH=Ma_DH and donhang.Ma_KH=Ma_KH;
    
    set mdh= CONCAT('DH', SUBSTRING(REPLACE(UUID(), '-', ''), 1, 10));
    INSERT INTO `donhang`(`Ma_DH`, `Ma_KH`) VALUES (mdh, Ma_KH);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_tq_ch` (IN `Ma_KH` VARCHAR(15), IN `Ma_S` VARCHAR(15), IN `TT_TQ` VARCHAR(10), IN `TD` VARCHAR(1))   BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE cur_TL VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT TL FROM s_tl WHERE s_tl.Ma_S=Ma_S;
    DECLARE EXIT HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    
    IF TT_TQ = 'xem' THEN
    	UPDATE sach set LX_S=LX_S+1 WHERE sach.Ma_S=Ma_S;
    	WHILE NOT done DO
        	FETCH cur INTO cur_TL; 
        	IF EXISTS(SELECT * FROM thoiquen WHERE thoiquen.TL = cur_TL and thoiquen.Ma_KH=Ma_KH) THEN
            	UPDATE thoiquen SET SL_Xem = SL_Xem + 1, TS = TS + 1.25 WHERE thoiquen.Ma_KH = Ma_KH AND thoiquen.TL IN (SELECT TL FROM s_tl WHERE s_tl.Ma_S = Ma_S);
        	ELSE
            	INSERT INTO thoiquen(Ma_KH, TL, SL_Xem, TS) value (Ma_KH, cur_TL, 1, 1.25);
        	END IF;
            
        END WHILE;
    ELSEIF TT_TQ = 'qt' THEN
        IF TD = '+' THEN
            UPDATE sach SET LQT_S = LQT_S + 1 WHERE sach.Ma_S = Ma_S;
            UPDATE thoiquen SET SL_QT = SL_QT + 1, TS = TS + 1.5 WHERE thoiquen.Ma_KH = Ma_KH AND thoiquen.TL IN (SELECT TL FROM s_tl WHERE s_tl.Ma_S = Ma_S);
        ELSEIF TD = '-' THEN
            UPDATE sach SET LQT_S = LQT_S - 1 WHERE sach.Ma_S = Ma_S;
            UPDATE thoiquen SET SL_QT = SL_QT - 1, TS = TS - 1.25 WHERE thoiquen.Ma_KH = Ma_KH AND thoiquen.TL IN (SELECT TL FROM s_tl WHERE s_tl.Ma_S = Ma_S);
        END IF;
    ELSEIF TT_TQ = 'tk' THEN
        UPDATE sach SET LX_S = LX_S + 1 WHERE sach.Ma_S = Ma_S;
        UPDATE thoiquen SET SL_TK = SL_TK + 1, TS = TS + 1.75 WHERE thoiquen.Ma_KH = Ma_KH AND thoiquen.TL IN (SELECT TL FROM s_tl WHERE s_tl.Ma_S = Ma_S);
    ELSEIF TT_TQ = 'mua' THEN
        UPDATE sach SET LM_S = LM_S + 1 WHERE sach.Ma_S = Ma_S;
        UPDATE thoiquen SET SL_Mua = SL_Mua + 1, TS = TS + 2 WHERE thoiquen.Ma_KH = Ma_KH AND thoiquen.TL IN (SELECT TL FROM s_tl WHERE s_tl.Ma_S = Ma_S);
        
    END IF;
    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_xtk` (IN `Ma_TK` VARCHAR(15), IN `Ma_KH` VARCHAR(15))   BEGIN
	DELETE FROM thongbao WHERE thongbao.Cho=Ma_KH;
    DELETE FROM bl_s WHERE bl_s.Ma_KH=Ma_KH;
    DELETE FROM sdh WHERE sdh.Ma_DH IN (SELECT Ma_DH FROM donhang WHERE donhang.Ma_KH=Ma_KH);
    DELETE FROM ql_dh WHERE ql_dh.Ma_DH IN (SELECT Ma_DH FROM donhang WHERE donhang.Ma_KH=Ma_KH);
    DELETE FROM donhang WHERE donhang.Ma_KH=Ma_KH;
    DELETE FROM thoiquen WHERE thoiquen.Ma_KH=Ma_KH;
    DELETE FROM quantam WHERE quantam.Ma_KH=Ma_KH;
    DELETE FROM khachhang WHERE khachhang.Ma_KH=Ma_KH;
    DELETE FROM taikhoan WHERE taikhoan.Ma_TK=Ma_TK;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `a_s`
--

CREATE TABLE `a_s` (
  `Ma_S` varchar(15) NOT NULL,
  `STT_A` int(11) NOT NULL,
  `Anh` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `a_s`
--

INSERT INTO `a_s` (`Ma_S`, `STT_A`, `Anh`) VALUES
('BG17', 1, 'anhsach\\BG.jpg'),
('BG17', 2, 'anhsach\\BG1.jpg'),
('CCLD10', 1, 'anhsach\\CCLD_0.jpg'),
('CSKGH22', 1, 'anhsach\\KGH.jpg'),
('CSKGH22', 2, 'anhsach\\KGH1.jpg'),
('CTCN-HTT12', 1, 'anhsach\\CTCN2_0.jpg'),
('CTCN-HTT12', 2, 'anhsach\\CTCN2_1.jpg'),
('D-T1', 1, 'anhsach\\D1_0.jpg'),
('D-T2', 1, 'anhsach\\D2_0.jpg'),
('D-T3', 1, 'anhsach\\D3_0.jpg'),
('D-T4', 1, 'anhsach\\D4_0.jpg'),
('DNT16', 1, 'anhsach\\dac-nhan-tam.jpg'),
('DTD18-BH', 1, 'anhsach\\DTD1_0.jpg'),
('DTD18-BH', 2, 'anhsach\\DTD1_1.jpg'),
('DTD18-BHT', 1, 'anhsach\\DTD4_0.jpg'),
('DTD18-BHT', 2, 'anhsach\\DTD4_1.jpg'),
('DTD18-FYH', 1, 'anhsach\\DTD3_0.jpg'),
('DTD18-FYH', 2, 'anhsach\\DTD3_1.jpg'),
('DTD18-INS', 1, 'anhsach\\DTD5_0.jpg'),
('DTD18-INS', 2, 'anhsach\\DTD5_1.jpg'),
('DTD18-MF', 1, 'anhsach\\DTD2_0.jpg'),
('DTD18-MF', 2, 'anhsach\\DTD2_1.jpg'),
('DVBKA10', 1, 'anhsach\\Doc-vi-bia.jpg'),
('DVBKA10', 2, 'anhsach\\Doc-vi-bia1.jpg'),
('GVK19', 1, 'anhsach\\GVK_0.jpg'),
('GVK19', 2, 'anhsach\\GVK_1.jpg'),
('HPHD22', 1, 'anhsach\\HPHD_0.jpg'),
('HTVPD21', 1, 'anhsach\\HTVPD_0.png'),
('HTVPD21', 2, 'anhsach\\HVPD_1.jpg'),
('KVNT15', 1, 'anhsach\\KVNT_0.jpg'),
('LSVNXIX23', 1, 'anhsach\\LSVNXIX_0.jpg'),
('LSVNXIX23', 2, 'anhsach\\LSVNXIX_1.jpg'),
('M3320', 1, 'anhsach\\M33_0.jpg'),
('M3320', 2, 'anhsach\\M33_1.jpg'),
('M3420', 1, 'anhsach\\M34_0.jpg'),
('M3420', 2, 'anhsach\\M34_1.jpg'),
('M3520', 1, 'anhsach\\M35_0.jpg'),
('M3520', 2, 'anhsach\\M35_1.jpg'),
('NBH20', 1, 'anhsach\\NBH_0.png'),
('NDD17', 1, 'anhsach\\NDD_0.jpg'),
('NGC20', 1, 'anhsach\\NGC20.jpg'),
('NGK13', 1, 'anhsach\\nha-gia-kim-01.jpg'),
('NGK13', 2, 'anhsach\\nha-gia-kim-02.jpg'),
('OP-BM22', 1, 'anhsach\\OP1_0.jpg'),
('OP-HTB22', 1, 'anhsach\\OP2_0.jpg'),
('OP-KND22', 1, 'anhsach\\OP3_0.jpg'),
('OP-TLL22', 1, 'anhsach\\OP4_0.jpg'),
('QGLDVVS18', 1, 'anhsach\\QGDVVS.jpg'),
('QGLDVVS18', 2, 'anhsach\\QGDVVS1.jpg'),
('QGNH17', 1, 'anhsach\\QGNH_0.jpg'),
('S_3a98f12467', 1, 'anhsach\\as_350631001a.jpg'),
('S_3a98f12467', 2, 'anhsach\\as_1bd4a38b05.jpg'),
('S_3a98f12467', 3, 'anhsach\\as_9e3fdbdc3a.jpg'),
('SNVLG12', 1, 'anhsach\\nghigiaulamgiau.jpg'),
('SNVLG12', 2, 'anhsach\\nghigiaulamgiau1.jpg'),
('STQ20', 1, 'anhsach\\STQ20.jpg'),
('STQ20', 2, 'anhsach\\STQ20_1.jpg'),
('TAVHP23', 1, 'anhsach\\TAVHP_0.jpg'),
('TAVHP23', 2, 'anhsach\\TAVHP_1.jpg'),
('TCLG17', 1, 'anhsach\\TCLG_0.jpg'),
('TDT20', 1, 'anhsach\\TDT_0.jpg'),
('TDT20', 2, 'anhsach\\TDT_1.jpg'),
('TTC-T1', 1, 'anhsach\\TTC1_0.jpg'),
('TTC-T2', 1, 'anhsach\\TTC2_0.jpg'),
('TTC-T3', 1, 'anhsach\\TTC3_0.jpg'),
('TTC-T4', 1, 'anhsach\\TTC4_0.jpg');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bl_s`
--

CREATE TABLE `bl_s` (
  `Ma_S` varchar(15) NOT NULL,
  `Ma_KH` varchar(15) NOT NULL,
  `BL` varchar(2048) DEFAULT NULL,
  `T_BL` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `bl_s`
--

INSERT INTO `bl_s` (`Ma_S`, `Ma_KH`, `BL`, `T_BL`) VALUES
('D-T1', 'KH001', 'Hay quá', '2024-02-20 16:06:00'),
('D-T1', 'KH001', 'Doraemon đây :>>>', '2024-05-29 20:14:17'),
('D-T1', 'KH003', 'Ui tuổi thơ của tôi', '2024-05-12 07:20:00'),
('D-T1', 'KH003', 'Không biết khi nào mới nhập thêm phần mới nhỉ', '2024-05-20 10:10:00'),
('HPHD22', 'KH001', 'Có cả bản sách sao , lúc bé vào mỗi tối , tôi rất mong chờ bộ này trên TV', '2024-05-29 19:54:03'),
('HPHD22', 'KH001', 'Bộ này thực sự rất hay. tôi đã thức tới lúc này và vẫn đọc tiếp đây không thế dừng lại được', '2024-05-29 19:55:44'),
('HPHD22', 'KH001', '1 lần nữa', '2024-05-30 01:06:33'),
('M3320', 'KH001', 'Cuốn này lạ nhỉ có ai mua thử chưa', '2023-09-30 15:01:00'),
('M3320', 'KH001', 'Đọc xong tôi tự hỏi sao tác giả có thể nghĩ ra những con quái vật kinh khủng như thế', '2023-11-05 20:15:00'),
('M3320', 'KH001', 'Bạn thật là hư cấu quá đi', '2024-06-08 13:44:27'),
('M3320', 'KH002', 'Thú vị vậy sao mua thử mới được', '2024-03-22 17:11:00'),
('M3320', 'KH003', 'Không ngờ chỉ với những đường tàu điện ngầm có thể vẽ nên một thế giới đặc biệt như thế', '2024-02-11 11:55:00'),
('NGK13', 'KH001', 'Cuốn sách này hay quá', '2024-04-12 08:20:00'),
('NGK13', 'KH003', 'Thật thú vị liệu còn cuốn nào hay như thế này không', '2022-11-01 11:40:00');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `donhang`
--

CREATE TABLE `donhang` (
  `Ma_DH` varchar(15) NOT NULL,
  `Ma_KH` varchar(15) DEFAULT NULL,
  `NgT_DH` date DEFAULT current_timestamp(),
  `T_SL` int(11) DEFAULT 0,
  `TongTien` int(11) DEFAULT 0,
  `TrangThai` varchar(1024) DEFAULT 'đang thêm'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `donhang`
--

INSERT INTO `donhang` (`Ma_DH`, `Ma_KH`, `NgT_DH`, `T_SL`, `TongTien`, `TrangThai`) VALUES
('DH01', 'KH001', '2024-04-20', 5, 600, 'Đang thêm'),
('DH02', 'KH001', '2024-02-01', 1, 230, 'Chờ xác nhận'),
('DH03', 'KH001', '2023-05-23', 2, 210, 'Đã hoàn thành'),
('DH04', 'KH001', '2023-04-10', 2, 160, 'Đã hoàn thành'),
('DH4f3ddba878', 'KH_ae8e4b5575', '2025-08-13', 0, 0, 'đang thêm'),
('DH7c4a9d9a38', 'KH_e821a0681f', '2024-07-02', 0, 0, 'đang thêm'),
('DH8c76b22a28', 'KH_f8a5fefa19', '2024-06-13', 0, 0, 'Đang thêm'),
('DHb1ca7a3834', 'KH_e821a0681f', '2024-06-28', 3, 320, 'Hoàn thành'),
('DHb6a4bab339', 'KH_cc85a74473', '2024-07-03', 0, 0, 'đang thêm'),
('DHc6d424e338', 'KH_e821a0681f', '2024-07-02', 1, 195, 'Đã từ chối');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khachhang`
--

CREATE TABLE `khachhang` (
  `Ma_KH` varchar(15) NOT NULL,
  `Ma_TK` varchar(15) DEFAULT NULL,
  `Ten_KH` varchar(15) DEFAULT NULL,
  `GT_KH` varchar(10) DEFAULT NULL,
  `NgS_KH` date DEFAULT NULL,
  `SDT_KH` varchar(15) DEFAULT NULL,
  `Email_KH` varchar(100) DEFAULT NULL,
  `DC_KH` varchar(200) DEFAULT NULL,
  `A_KH` varchar(1024) DEFAULT 'a_kh\\defaultava.jpg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `khachhang`
--

INSERT INTO `khachhang` (`Ma_KH`, `Ma_TK`, `Ten_KH`, `GT_KH`, `NgS_KH`, `SDT_KH`, `Email_KH`, `DC_KH`, `A_KH`) VALUES
('KH_ae8e4b5575', 'TK_e67de1ae29', 'HPD', 'Nam', '2003-07-04', '1547154761', 'hpd@gmail.com', 'khaai', 'a_kh\\defaultava.jpg'),
('KH_cc85a74473', 'TK_b5a9f32220', 'BaoCao', 'Nam', '2005-07-20', '571654761', 'baocao@gmail.com', 'VinhLong', 'a_kh\\defaultava.jpg'),
('KH_e821a0681f', 'TK_3b0f339255', 'who1', 'Nam', '2004-06-28', '1547154761', 'testcnnv@gmail.com', 'place1', 'a_kh\\defaultava.jpg'),
('KH_f8a5fefa19', 'TK_a48bccfe1d', 'nagy', 'Nữ', '2016-10-06', '093264823', 'betatest@gmail.com', 'some where in the world', 'a_kh\\akh_7dd9d0c5dc.jpg'),
('KH001', 'TKKH001', 'Tomori Nao', 'Nữ', '2010-03-17', ' 0395886196', 'kh1@gmail.com', '45/8, Tường Nhơn, Tường Lộc, Tam Bình, Tỉnh Vĩnh Long', 'a_kh\\607486.jpg'),
('KH002', 'TKKH002', 'Khách hàng 2', 'Nam', '2007-08-14', ' 0395854727', 'kh2@gmail.com', '45/8, Phú Long, Tân Phú, Tam Bình, Tỉnh Vĩnh Long', 'a_kh\\668521.jpg'),
('KH003', 'TKKH003', 'Khách hàng 3', 'Nam', '2007-08-10', ' 0395476993', 'kh3@gmail.com', '45/8, Danh Tấm, Hậu Lộc, Tam Bình, Tỉnh Vĩnh Long', 'a_kh\\2384252.jpg');

--
-- Bẫy `khachhang`
--
DELIMITER $$
CREATE TRIGGER `trg_ins_kh_dh` AFTER INSERT ON `khachhang` FOR EACH ROW begin
	DECLARE mdh varchar(15);
    set mdh= CONCAT('DH', SUBSTRING(REPLACE(UUID(), '-', ''), 1, 10));
	INSERT INTO `donhang`(`Ma_DH`, `Ma_KH`) VALUES (mdh, New.Ma_KH);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nhanvien`
--

CREATE TABLE `nhanvien` (
  `Ma_NV` varchar(15) NOT NULL,
  `Ma_TK` varchar(15) DEFAULT NULL,
  `Ten_NV` varchar(15) DEFAULT NULL,
  `GT_NV` varchar(10) DEFAULT NULL,
  `NgS_NV` date DEFAULT NULL,
  `SDT_NV` varchar(15) DEFAULT NULL,
  `Email_NV` varchar(100) DEFAULT NULL,
  `DC_NV` varchar(200) DEFAULT NULL,
  `A_NV` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `nhanvien`
--

INSERT INTO `nhanvien` (`Ma_NV`, `Ma_TK`, `Ten_NV`, `GT_NV`, `NgS_NV`, `SDT_NV`, `Email_NV`, `DC_NV`, `A_NV`) VALUES
('NV001', 'TKNV001', 'Nhân viên 1', 'Nam', '2008-12-09', '0382953745', 'nv1@gmail.com', '45/8, Mỹ Phú 1, Tường Lộc, Tam Bình,  Tỉnh Vĩnh Long', 'a_nv\\defaultava.jpg'),
('NV002', 'TKNV002', 'Nhân viên 2', 'Nữ', '2008-03-10', '0382928499', 'nv2@gmail.com', '33/15,  Sóc Hoang, Mỹ Hòa, Thị xã Bình Minh,  Tỉnh Vĩnh Long', 'a_nv\\defaultava.jpg');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ql_dh`
--

CREATE TABLE `ql_dh` (
  `Ma_NV` varchar(15) NOT NULL,
  `Ma_DH` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `ql_dh`
--

INSERT INTO `ql_dh` (`Ma_NV`, `Ma_DH`) VALUES
('NV001', 'DH02'),
('NV001', 'DHb1ca7a3834'),
('NV001', 'DHc6d424e338'),
('NV002', 'DH04');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `quantam`
--

CREATE TABLE `quantam` (
  `Ma_KH` varchar(15) NOT NULL,
  `Ma_S` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `quantam`
--

INSERT INTO `quantam` (`Ma_KH`, `Ma_S`) VALUES
('KH_ae8e4b5575', 'D-T1'),
('KH_e821a0681f', 'BG17'),
('KH_e821a0681f', 'KVNT15'),
('KH_e821a0681f', 'NBH20'),
('KH001', 'D-T1'),
('KH001', 'M3420');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `quyen`
--

CREATE TABLE `quyen` (
  `Ma_Q` varchar(15) NOT NULL,
  `ND_Q` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `quyen`
--

INSERT INTO `quyen` (`Ma_Q`, `ND_Q`) VALUES
('Q_KH', 'Xem, thao tác tìm kiếm sản phẩm và thực hiện mua hàng'),
('Q_NV', 'Quyền KH(trừ mua hàng) +  thêm chỉnh sửa xóa sản phẩm và xác nhận đơn hàng'),
('Q_QL', 'Quyền NV + KH(trừ mua hàng) + Thêm chỉnh sửa nhân viên');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sach`
--

CREATE TABLE `sach` (
  `Ma_S` varchar(15) NOT NULL,
  `Ten_S` varchar(100) DEFAULT NULL,
  `NXB_S` int(11) DEFAULT NULL,
  `GiaTien` int(11) DEFAULT NULL,
  `Chap` int(11) DEFAULT NULL,
  `Loai_S` varchar(50) DEFAULT NULL,
  `SL_S` int(11) DEFAULT NULL,
  `LX_S` int(11) NOT NULL DEFAULT 0,
  `LQT_S` int(11) DEFAULT 0,
  `LM_S` int(11) DEFAULT 0,
  `Ten_NXB` varchar(50) DEFAULT NULL,
  `HCDT_S` int(11) DEFAULT NULL,
  `Ma_NV` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `sach`
--

INSERT INTO `sach` (`Ma_S`, `Ten_S`, `NXB_S`, `GiaTien`, `Chap`, `Loai_S`, `SL_S`, `LX_S`, `LQT_S`, `LM_S`, `Ten_NXB`, `HCDT_S`, `Ma_NV`) VALUES
('BG17', 'Bố Già', 2017, 230, 0, 'Tiểu thuyết', 45, 105, 341, 300, 'Tổng hợp TP.HCM', 17, 'NV001'),
('CCLD10', 'Cuộc Chiến Lỗ Đen', 2010, 195, 0, 'Khoa Học', 120, 100, 180, 71, 'Trẻ', 16, 'NV001'),
('CSKGH22', 'Cuộc sống không giới hạn', 2022, 120, 0, 'Tiểu Sử', 30, 100, 230, 340, 'Tổng hợp TP.HCM', 14, 'NV001'),
('CTCN-HTT12', 'Chúa tể của những chiếc nhẫn-Hai tòa tháp', 2012, 160, 2, 'Tiểu Thuyết', 43, 100, 270, 200, 'HarperCollins', 16, 'NV001'),
('D-T1', 'Doraemon Tập 1', 2022, 25, 1, 'Truyện Tranh', 200, 113, 301, 230, 'Kim Đồng', 6, 'NV002'),
('D-T2', 'Doraemon Tập 2', 2022, 25, 2, 'Truyện Tranh', 200, 100, 300, 210, 'Kim Đồng', 6, 'NV002'),
('D-T3', 'Doraemon Tập 3', 2022, 25, 3, 'Truyện Tranh', 180, 100, 300, 210, 'Kim Đồng', 6, 'NV002'),
('D-T4', 'Doraemon Tập 4', 2022, 25, 4, 'Truyện Tranh', 150, 100, 300, 210, 'Kim Đồng', 6, 'NV002'),
('DNT16', 'Đắc Nhân Tâm', 2016, 80, 0, 'Hướng dẫn', 32, 100, 500, 230, 'Tổng hợp TP.HCM', 16, 'NV002'),
('DTD18-BH', 'Đời Thay Đổi Khi Chúng Ta Thay Đổi- Being Happy', 2018, 60, 1, 'Hướng dẫn', 25, 100, 200, 145, 'Trẻ', 12, 'NV002'),
('DTD18-BHT', 'Đời Thay Đổi Khi Chúng Ta Thay Đổi- Being Happy Teenager', 2018, 60, 4, 'Hướng dẫn', 56, 101, 150, 122, 'Trẻ', 12, 'NV002'),
('DTD18-FYH', 'Đời Thay Đổi Khi Chúng Ta Thay Đổi- Follow your heart', 2018, 60, 3, 'Hướng dẫn', 43, 100, 300, 210, 'Trẻ', 12, 'NV002'),
('DTD18-INS', 'Đời Thay Đổi Khi Chúng Ta Thay Đổi- Happiness In a nutshell', 2018, 60, 5, 'Hướng dẫn', 12, 102, 310, 200, 'Trẻ', 12, 'NV002'),
('DTD18-MF', 'Đời Thay Đổi Khi Chúng Ta Thay Đổi- Making Friends', 2018, 60, 2, 'Hướng dẫn', 40, 100, 240, 100, 'Trẻ', 12, 'NV002'),
('DVBKA10', 'Đọc Vị Bất Kỳ Ai', 2010, 89, 0, 'Hướng dẫn', 40, 100, 230, 100, 'Đại Học Kinh Tế Quốc Dân', 16, 'NV002'),
('GVK19', 'Gen vị kỷ', 2019, 250, 0, 'Khoa Học', 130, 100, 250, 160, 'Tri Thức', 16, 'NV001'),
('HPHD22', 'Harry Potter và Hòn đá phù thủy', 2022, 130, 1, 'Tiểu Thuyết', 50, 101, 420, 340, 'Trẻ', 12, 'NV001'),
('HTVPD21', 'Hành trình về phương Đông', 2021, 80, 0, 'Tài liệu tham khảo', 34, 100, 70, 40, 'Thế Giới', 14, 'NV002'),
('KVNT15', 'Bí mật của Khu vườn ngôn từ', 2015, 120, 0, 'Tiểu Thuyết', 45, 106, 291, 210, 'Văn Học', 16, 'NV001'),
('LSVNXIX23', 'Lịch Sử Việt Nam Từ Nguồn Gốc Đến Thế Kỷ XIX', 2023, 160, 0, 'Lịch Sử', 120, 100, 280, 200, 'Hồng Đức', 16, 'NV001'),
('M3320', 'Metro 2033', 2020, 120, 1, 'Tiểu Thuyết', 23, 113, 169, 120, 'Tổng Hợp TPHCM', 17, 'NV001'),
('M3420', 'Metro 2034', 2020, 190, 2, 'Tiểu Thuyết', 15, 101, 101, 70, 'Tổng Hợp TPHCM', 17, 'NV001'),
('M3520', 'Metro 2035', 2020, 200, 3, 'Tiểu Thuyết', 11, 102, 80, 30, 'Tổng Hợp TPHCM', 17, 'NV001'),
('NBH20', 'Người Bán Hàng Vĩ Đại Nhất Thế Giới', 2020, 120, 0, 'Hướng dẫn', 23, 102, 81, 45, 'Tổng hợp TP.HCM', 16, 'NV001'),
('NDD17', 'Napoleon Đại đế', 2017, 400, 0, 'Lịch Sử', 100, 101, 210, 120, 'Thế Giới', 16, 'NV001'),
('NGC20', 'Người giàu có nhất thành Babylon', 2020, 90, 0, 'Hướng dẫn', 23, 103, 200, 140, 'Tổng hợp TP.HCM', 16, 'NV002'),
('NGK13', 'Nhà giả kim', 2013, 60, 0, 'Tiểu Thuyết', 20, 101, 300, 180, 'Hội Nhà Văn', 16, 'NV001'),
('OP-BM22', 'One Piece- Bình Minh Của Cuộc Phiêu Lưu', 2022, 20, 1, 'Truyện Tranh', 130, 100, 200, 120, 'Kim Đồng', 12, 'NV002'),
('OP-HTB22', 'One Piece- VS Binh Đoàn Hải Tặc Buggy', 2022, 20, 2, 'Truyện Tranh', 120, 100, 200, 120, 'Kim Đồng', 12, 'NV002'),
('OP-KND22', 'One Piece- Thứ không Thể Nói Dối', 2022, 20, 3, 'Truyện Tranh', 130, 100, 200, 120, 'Kim Đồng', 12, 'NV002'),
('OP-TLL22', 'One Piece- Trăng Lưỡi Liềm', 2022, 20, 4, 'Truyện Tranh', 110, 100, 200, 120, 'Kim Đồng', 12, 'NV002'),
('QGLDVVS18', 'Quẳng gánh lo đi và vui sống', 2018, 90, 0, 'Hướng dẫn', 25, 100, 300, 150, 'Tổng Hợp TP.HCM', 16, 'NV002'),
('QGNH17', 'Bí Kíp Quá Giang Vào Ngân Hà', 2017, 80, 0, 'Tiểu Thuyết', 26, 101, 170, 100, 'Lao Động', 16, 'NV001'),
('S_3a98f12467', 'Hand Book YN', 2024, 45, 0, 'Bộ sưu tập', 350, 0, 0, 0, 'Hệ Thống', 16, 'NV001'),
('SNVLG12', 'Suy nghĩ và làm giàu', 2012, 60, 0, 'Hướng dẫn', 15, 100, 120, 50, 'Trẻ', 16, 'NV002'),
('STQ20', '7 Thói Quen Để Thành Đạt', 2020, 120, 0, 'Hướng dẫn', 16, 100, 90, 30, 'Tổng hợp TP.HCM', 14, 'NV002'),
('TAVHP23', 'Tội Ác Và Hình Phạt', 2023, 66, 0, 'Tiểu thuyết', 45, 102, 150, 34, 'Văn Học', 17, 'NV001'),
('TCLG17', 'Tên cậu là gì?', 2017, 80, 0, 'Tiểu Thuyết', 50, 106, 320, 510, 'Hồng Đức', 16, 'NV001'),
('TDT20', 'Thép Đã Tôi Thế Đấy', 2020, 110, 0, 'Tiểu Thuyết', 50, 101, 210, 140, 'Văn Học', 14, 'NV001'),
('TTC-T1', 'Thám Tử Lừng Danh Conan Tập 1', 2021, 25, 1, 'Truyện Tranh', 180, 100, 300, 220, 'Kim Đồng', 16, 'NV002'),
('TTC-T2', 'Thám Tử Lừng Danh Conan Tập 2', 2021, 25, 2, 'Truyện Tranh', 180, 100, 300, 220, 'Kim Đồng', 16, 'NV002'),
('TTC-T3', 'Thám Tử Lừng Danh Conan Tập 3', 2021, 25, 3, 'Truyện Tranh', 180, 100, 300, 220, 'Kim Đồng', 16, 'NV002'),
('TTC-T4', 'Thám Tử Lừng Danh Conan Tập 4', 2021, 25, 4, 'Truyện Tranh', 180, 100, 300, 220, 'Kim Đồng', 16, 'NV002');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sdh`
--

CREATE TABLE `sdh` (
  `Ma_DH` varchar(15) NOT NULL,
  `Ma_S` varchar(15) NOT NULL,
  `SL` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `sdh`
--

INSERT INTO `sdh` (`Ma_DH`, `Ma_S`, `SL`) VALUES
('DH01', 'BG17', 1),
('DH01', 'HPHD22', 1),
('DH01', 'TCLG17', 3),
('DH02', 'BG17', 1),
('DH03', 'NGC20', 1),
('DH03', 'STQ20', 1),
('DH04', 'M3320', 2),
('DHb1ca7a3834', 'KVNT15', 1),
('DHb1ca7a3834', 'NBH20', 1),
('DHb1ca7a3834', 'TCLG17', 1),
('DHc6d424e338', 'CCLD10', 1);

--
-- Bẫy `sdh`
--
DELIMITER $$
CREATE TRIGGER `trg_del_sdh` AFTER DELETE ON `sdh` FOR EACH ROW BEGIN
DECLARE TT int;
SELECT GiaTien INTO TT FROM sach WHERE Ma_S=OLD.Ma_S;

UPDATE donhang set T_SL=T_SL-OLD.SL, TongTien=TongTien-(TT*OLD.SL) WHERE Ma_DH=OLD.Ma_DH;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_ins_sdh` AFTER INSERT ON `sdh` FOR EACH ROW BEGIN
DECLARE TT int;
SELECT GiaTien INTO TT FROM sach WHERE Ma_S=NEW.Ma_S;

UPDATE donhang set T_SL=T_SL+NEW.SL, TongTien=TongTien+(TT*NEW.SL) WHERE Ma_DH=NEW.Ma_DH;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_upd_sdh` AFTER UPDATE ON `sdh` FOR EACH ROW BEGIN
	DECLARE TT int;
	SELECT GiaTien INTO TT FROM sach WHERE Ma_S=NEW.Ma_S;

	UPDATE donhang set T_SL=T_SL-OLD.SL+NEW.SL, TongTien=TongTien-(TT*OLD .SL)+(TT*NEW.SL) WHERE Ma_DH=NEW.Ma_DH;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `s_tg`
--

CREATE TABLE `s_tg` (
  `Ma_S` varchar(15) NOT NULL,
  `Ma_TG` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `s_tg`
--

INSERT INTO `s_tg` (`Ma_S`, `Ma_TG`) VALUES
('BG17', 'MP20AMRC'),
('CCLD10', 'LS40AMRC'),
('CSKGH22', 'NV82ATLA'),
('CTCN-HTT12', 'JRRT92OR'),
('D-T1', 'FFF33JP'),
('D-T2', 'FFF33JP'),
('D-T3', 'FFF33JP'),
('D-T4', 'FFF33JP'),
('DNT16', 'DC1888AMRC'),
('DTD18-BH', 'AM57ATLA'),
('DTD18-BHT', 'AM57ATLA'),
('DTD18-FYH', 'AM57ATLA'),
('DTD18-INS', 'AM57ATLA'),
('DTD18-MF', 'AM57ATLA'),
('DVBKA10', 'DJL53AMRC'),
('GVK19', 'RD41KY'),
('HPHD22', 'JKR65KOEL'),
('HTVPD21', 'BTS72AMRC'),
('KVNT15', 'SM73JP'),
('LSVNXIX23', 'DDDA04VN'),
('M3320', 'DAG79RS'),
('M3420', 'DAG79RS'),
('M3520', 'DAG79RS'),
('NBH20', 'QM23AMRC'),
('NDD17', 'AR63KOEL'),
('NGC20', 'GSC74AMRC'),
('NGK13', 'PC47B'),
('OP-BM22', 'OE75JP'),
('OP-HTB22', 'OE75JP'),
('OP-KND22', 'OE75JP'),
('OP-TLL22', 'OE75JP'),
('QGLDVVS18', 'DC1888AMRC'),
('QGNH17', 'DA52KOEL'),
('S_3a98f12467', 'SM73JP'),
('SNVLG12', 'NH83AMRC'),
('STQ20', 'SRC32AMRC'),
('TAVHP23', 'FD21RS'),
('TCLG17', 'SM73JP'),
('TDT20', 'NAO04UR'),
('TTC-T1', 'AG63JP'),
('TTC-T2', 'AG63JP'),
('TTC-T3', 'AG63JP'),
('TTC-T4', 'AG63JP');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `s_tl`
--

CREATE TABLE `s_tl` (
  `Ma_S` varchar(15) NOT NULL,
  `TL` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `s_tl`
--

INSERT INTO `s_tl` (`Ma_S`, `TL`) VALUES
('BG17', 'Giả tưởng hình sự'),
('BG17', 'Giật gân'),
('BG17', 'Thần bí'),
('BG17', 'tội phạm giả tưởng'),
('BG17', 'Văn học đô thị'),
('CCLD10', 'Vật lý'),
('CCLD10', 'Vũ trụ'),
('CSKGH22', 'Tiểu Sử'),
('CTCN-HTT12', 'Huyền thoại'),
('D-T1', 'Hài hước'),
('D-T1', 'Khoa học viễn tưởng'),
('D-T2', 'Hài hước'),
('D-T2', 'Khoa học viễn tưởng'),
('D-T3', 'Hài hước'),
('D-T3', 'Khoa học viễn tưởng'),
('D-T4', 'Hài hước'),
('D-T4', 'Khoa học viễn tưởng'),
('DNT16', 'Phát triển cá nhân'),
('DTD18-BH', 'Phát triển cá nhân'),
('DTD18-BHT', 'Phát triển cá nhân'),
('DTD18-FYH', 'Phát triển cá nhân'),
('DTD18-INS', 'Phát triển cá nhân'),
('DTD18-MF', 'Phát triển cá nhân'),
('DVBKA10', 'Phát triển cá nhân'),
('GVK19', 'Sinh học'),
('HPHD22', 'Kỳ ảo'),
('HTVPD21', 'Khoa học'),
('HTVPD21', 'Văn học'),
('KVNT15', 'Đời thường'),
('KVNT15', 'Lãng mạn'),
('LSVNXIX23', 'Việt Nam'),
('M3320', 'Hậu tận thế'),
('M3420', 'Hậu tận thế'),
('M3520', 'Hậu tận thế'),
('NBH20', 'Phát triển cá nhân'),
('NDD17', 'Nhân vật'),
('NDD17', 'Văn Học Nước Ngoài'),
('NGC20', 'Phát triển cá nhân'),
('NGC20', 'Tài Chính'),
('NGK13', 'Phiêu lưu'),
('NGK13', 'thần bí'),
('NGK13', 'tưởng tượng'),
('OP-BM22', 'Hài hước'),
('OP-BM22', 'Hành động'),
('OP-BM22', 'Phiêu lưu'),
('OP-HTB22', 'Hài hước'),
('OP-HTB22', 'Hành động'),
('OP-HTB22', 'Phiêu lưu'),
('OP-KND22', 'Hài hước'),
('OP-KND22', 'Hành động'),
('OP-KND22', 'Phiêu lưu'),
('OP-TLL22', 'Hài hước'),
('OP-TLL22', 'Hành động'),
('OP-TLL22', 'Phiêu lưu'),
('QGLDVVS18', 'Phát triển cá nhân'),
('QGNH17', 'Hài hước'),
('QGNH17', 'Huyền bí'),
('QGNH17', 'Viễn tưởng'),
('S_3a98f12467', 'Kỳ ảo'),
('S_3a98f12467', 'Lãng mạn'),
('SNVLG12', 'Phát triển cá nhân'),
('STQ20', 'Phát triển cá nhân'),
('TAVHP23', 'Giả tưởng hình sự'),
('TAVHP23', 'Hư cấu tâm lý'),
('TAVHP23', 'Hư cấu triết học'),
('TAVHP23', 'Thần bí'),
('TAVHP23', 'Văn học đô thị'),
('TCLG17', 'Hư cấu'),
('TCLG17', 'Lãng mạn'),
('TCLG17', 'Thần bí'),
('TDT20', 'Hư cấu'),
('TTC-T1', 'Bí ẩn'),
('TTC-T1', 'Hình sự'),
('TTC-T1', 'Trinh thám'),
('TTC-T2', 'Bí ẩn'),
('TTC-T2', 'Hình sự'),
('TTC-T2', 'Trinh thám'),
('TTC-T3', 'Bí ẩn'),
('TTC-T3', 'Hình sự'),
('TTC-T3', 'Trinh thám'),
('TTC-T4', 'Bí ẩn'),
('TTC-T4', 'Hình sự'),
('TTC-T4', 'Trinh thám');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tacgia`
--

CREATE TABLE `tacgia` (
  `Ma_TG` varchar(15) NOT NULL,
  `Ten_TG` varchar(50) DEFAULT NULL,
  `NS_TG` varchar(10) DEFAULT NULL,
  `NoiS_TG` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `tacgia`
--

INSERT INTO `tacgia` (`Ma_TG`, `Ten_TG`, `NS_TG`, `NoiS_TG`) VALUES
('AG63JP', 'Aoyama Gōshō', '1963', 'Tottori, Japan'),
('AM57ATLA', 'Andrew Matthews', '1957', 'Victor Harbor, South Australia'),
('AR63KOEL', 'Andrew Roberts', '1963', 'Hammersmith, London, Kingdom of England'),
('BTS72AMRC', 'Baird T. Spalding', '1872', 'Cohocton,New York, America'),
('DA52KOEL', 'Douglas Adams', '1952', 'Cambridge, Kingdom of England'),
('DAG79RS', 'Dmitry Alekseyevich Glukhovsky', '1979', 'Mát-cơ-va, Nga'),
('DC1888AMRC', 'Dale Carnegie', '1888', 'Maryville, Missouri,America'),
('DDDA04VN', 'Đào Duy Anh', '1904', 'Thanh Oai, Hà Nội, Việt Nam'),
('DJL53AMRC', 'David J. Lieberman', '1953', 'America'),
('FD21RS', 'Fyodor Dostoevsky', '1821', 'Moskva, Russia'),
('FFF33JP', 'Fujiko F. Fujio', '1933', 'Takaoka, Toyama, Japan'),
('GSC74AMRC', 'George Samuel Clason', '1874', 'Louisiana, Missouri, America'),
('JKR65KOEL', 'J. K. Rowling', '1965', 'Yate,Kingdom of England'),
('JRRT92OR', 'J. R. R. Tolkien', '1892', 'Bloemfontein, Orange'),
('LS40AMRC', 'Leonard Susskind', '1940', 'South Bronx,  New York City , New York, America'),
('MP20AMRC', 'Mario Puzo', '1920', 'Hells Kitchen,New York , New York, America'),
('NAO04UR', 'Nikolai A.Ostrovsky', '1904', 'Viliya, Ukraina'),
('NH83AMRC', 'Napoleon Hill', '1883', 'South Carolina,America'),
('NV82ATLA', 'Nick Vujicic', '1982', 'Melbourne,  Australia'),
('OE75JP', 'Oda Eiichiro', '1975', 'Kumamoto, Kumamoto, Japan'),
('PC47B', 'Paulo Coelho', '1947', 'Rio de Janeiro, Brasil'),
('QM23AMRC', 'Og Mandino', '1923', 'Framingham, Massachusetts, America'),
('RD41KY', 'Richard Dawkins', '1941', 'Nairobi, Kenya'),
('SM73JP', 'Shinkai Makoto', '1973', 'Koumi, Nagano, Japan'),
('SRC32AMRC', 'Stephen R. Covey', '1932', 'Salt Lake, Utah, America');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `taikhoan`
--

CREATE TABLE `taikhoan` (
  `Ma_TK` varchar(15) NOT NULL,
  `Ma_Q` varchar(15) DEFAULT NULL,
  `Ma_VT` varchar(15) DEFAULT NULL,
  `Ten_TK` varchar(50) DEFAULT NULL,
  `MK_TK` varchar(20) DEFAULT NULL,
  `ycx` int(11) NOT NULL DEFAULT 0,
  `t_x` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `taikhoan`
--

INSERT INTO `taikhoan` (`Ma_TK`, `Ma_Q`, `Ma_VT`, `Ten_TK`, `MK_TK`, `ycx`, `t_x`) VALUES
('TK_3b0f339255', 'Q_KH', 'KH', 'TestCNNV', '123456', 0, NULL),
('TK_a48bccfe1d', 'Q_KH', 'KH', 'KHbeta1', '123456', 0, NULL),
('TK_b5a9f32220', 'Q_KH', 'KH', 'BaoCao', '123456', 0, NULL),
('TK_e67de1ae29', 'Q_KH', 'KH', 'duck82', '123456', 0, NULL),
('TKKH001', 'Q_KH', 'KH', 'knowmyname', '123456', 2, '2024-06-27'),
('TKKH002', 'Q_KH', 'KH', 'KHtest2', '123456', 0, NULL),
('TKKH003', 'Q_KH', 'KH', 'KHtest3', '123456', 0, NULL),
('TKNV001', 'Q_NV', 'NV', 'NVtest1', '123456', 0, NULL),
('TKNV002', 'Q_NV', 'NV', 'NVtest2', '123456', 0, NULL),
('TKQL001', 'Q_QL', 'QL', 'QLtest1', '123456', 0, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `theloai`
--

CREATE TABLE `theloai` (
  `TL` varchar(30) NOT NULL,
  `GiaiThich` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `theloai`
--

INSERT INTO `theloai` (`TL`, `GiaiThich`) VALUES
('Bí ẩn', 'Các tác phẩm có mang các yếu tố bí ẩn'),
('Đời Thường', '.....'),
('Giả tưởng hình sự', '.....'),
('Giật gân', '.....'),
('Hài hước', '.....'),
('Hành động', '.....'),
('Hậu tận thế', '.....'),
('Hình sự', '.....'),
('Huyền bí', '.....'),
('Huyền thoại', '.....'),
('Hư cấu', '.....'),
('Hư cấu tâm lý', '.....'),
('Hư cấu triết học', '.....'),
('Khoa học', '.....'),
('khoa học viễn tưởng', '.....'),
('Kỳ ảo', '.....'),
('Lãng mạn', '.....'),
('Nhân vật', '.....'),
('Phát triển cá nhân', '.....'),
('Phiêu lưu', '.....'),
('Sinh học', '.....'),
('Tài chính', '.....'),
('Thần bí', '.....'),
('Tiểu Sử', '.....'),
('tội phạm giả tưởng', '.....'),
('Trinh thám', '.....'),
('tưởng tượng', '.....'),
('Văn hóa', '.....'),
('Văn học', '.....'),
('Văn học đô thị', '.....'),
('Văn Học Nước Ngoài', '...'),
('Vật lý', '.....'),
('Viễn tưởng', '.....'),
('Việt Nam', '.....'),
('Vũ trụ', '.....');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thoiquen`
--

CREATE TABLE `thoiquen` (
  `Ma_KH` varchar(15) NOT NULL,
  `TL` varchar(30) NOT NULL,
  `YT` int(11) DEFAULT 0,
  `SL_Xem` int(11) DEFAULT 0,
  `SL_QT` int(11) DEFAULT 0,
  `SL_TK` int(11) DEFAULT 0,
  `SL_Mua` int(11) DEFAULT 0,
  `TS` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `thoiquen`
--

INSERT INTO `thoiquen` (`Ma_KH`, `TL`, `YT`, `SL_Xem`, `SL_QT`, `SL_TK`, `SL_Mua`, `TS`) VALUES
('KH_ae8e4b5575', 'Đời Thường', 1, 0, 0, 0, 0, 0),
('KH_ae8e4b5575', 'Hài hước', 1, 23, 1, 0, 0, 30.5),
('KH_ae8e4b5575', 'Hành động', 1, 0, 0, 0, 0, 0),
('KH_ae8e4b5575', 'Hậu tận thế', 0, 1, 0, 0, 0, 1.25),
('KH_ae8e4b5575', 'Khoa học viễn tưởng', 0, 23, 1, 0, 0, 30.5),
('KH_ae8e4b5575', 'Lãng mạn', 1, 0, 0, 0, 0, 0),
('KH_cc85a74473', 'Hình sự', 1, 0, 0, 0, 0, 0),
('KH_e821a0681f', 'Đời thường', 0, 12, 1, 0, 9, 34.5),
('KH_e821a0681f', 'Giả tưởng hình sự', 0, 20, 1, 0, 0, 26.5),
('KH_e821a0681f', 'Giật gân', 0, 3, 1, 0, 0, 5.25),
('KH_e821a0681f', 'Hài hước', 0, 1, 0, 0, 0, 1.25),
('KH_e821a0681f', 'Hư cấu', 0, 9, 0, 0, 9, 29.25),
('KH_e821a0681f', 'Hư cấu tâm lý', 0, 17, 0, 0, 0, 21.25),
('KH_e821a0681f', 'Hư cấu triết học', 0, 17, 0, 0, 0, 21.25),
('KH_e821a0681f', 'Khoa học viễn tưởng', 0, 1, 0, 0, 0, 1.25),
('KH_e821a0681f', 'Kỳ ảo', 0, 4, 0, 0, 0, 5),
('KH_e821a0681f', 'Lãng mạn', 1, 29, 1, 0, 20, 77.75),
('KH_e821a0681f', 'Nhân vật', 0, 3, 0, 0, 0, 3.5),
('KH_e821a0681f', 'Phát triển cá nhân', 0, 3, 1, 0, 9, 23.25),
('KH_e821a0681f', 'Tài Chính', 0, 2, 0, 0, 0, 2.5),
('KH_e821a0681f', 'Thần bí', 0, 26, 1, 0, 9, 52),
('KH_e821a0681f', 'tội phạm giả tưởng', 0, 2, 1, 0, 0, 4),
('KH_e821a0681f', 'Trinh thám', 1, 0, 0, 0, 0, 0),
('KH_e821a0681f', 'Văn học đô thị', 0, 19, 1, 0, 0, 25.25),
('KH_e821a0681f', 'Văn Học Nước Ngoài', 0, 3, 0, 0, 0, 3.5),
('KH_e821a0681f', 'Vật lý', 0, 1, 0, 0, 1, 3.25),
('KH_e821a0681f', 'Việt Nam', 1, 0, 0, 0, 0, 0),
('KH_e821a0681f', 'Vũ trụ', 0, 1, 0, 0, 1, 3.25),
('KH_f8a5fefa19', 'Hành động', 1, 0, 0, 0, 0, 0),
('KH_f8a5fefa19', 'Hậu tận thế', 1, 0, 0, 0, 0, 0),
('KH_f8a5fefa19', 'Hình sự', 1, 0, 0, 0, 0, 0),
('KH_f8a5fefa19', 'Việt Nam', 1, 0, 0, 0, 0, 0),
('KH001', 'Bí ẩn', 0, 0, 0, 0, 0, 0),
('KH001', 'Đời Thường', 0, 0, 0, 0, 0, 0),
('KH001', 'Giả tưởng hình sự', 0, 6, 1, 4, 0, 15.75),
('KH001', 'Giật gân', 1, 6, 1, 5, 0, 17.25),
('KH001', 'Hài hước', 1, 2, 0, 0, 0, 3.5),
('KH001', 'Hành động', 0, 0, 0, 0, 0, 0),
('KH001', 'Hình sự', 0, 0, 0, 0, 0, 0),
('KH001', 'Huyền bí', 0, 0, 0, 0, 0, 0),
('KH001', 'Huyền thoại', 0, 0, 0, 0, 0, 0),
('KH001', 'Hư cấu', 0, 3, 0, 0, 0, 3.75),
('KH001', 'Hư cấu tâm lý', 0, 0, 0, 0, 0, 0),
('KH001', 'Hư cấu triết học', 0, 0, 0, 0, 0, 0),
('KH001', 'Khoa học', 0, 0, 0, 0, 0, 0),
('KH001', 'khoa học viễn tưởng', 0, 2, 0, 0, 0, 3.5),
('KH001', 'Kỳ Ảo', 0, 2, 1, 3, 0, 9),
('KH001', 'Lãng mạn', 0, 3, 0, 0, 0, 3.75),
('KH001', 'Nhân vật', 0, 0, 0, 0, 0, 0),
('KH001', 'Phiêu lưu', 0, 0, 0, 0, 0, 0),
('KH001', 'Sinh học', 0, 0, 0, 0, 0, 0),
('KH001', 'Tài Chính', 0, 3, 1, 1, 0, 6.75),
('KH001', 'Thần bí', 0, 9, 1, 2, 0, 16),
('KH001', 'Tiểu Sử', 0, 0, 0, 0, 0, 0),
('KH001', 'tội phạm giả tưởng', 0, 6, 1, 1, 0, 10.5),
('KH001', 'Trinh thám', 0, 0, 0, 0, 0, 0),
('KH001', 'tưởng tượng', 0, 0, 0, 0, 0, 0),
('KH001', 'Văn hóa', 0, 0, 0, 0, 0, 0),
('KH001', 'Văn học', 0, 0, 0, 0, 0, 0),
('KH001', 'Văn học đô thị', 1, 6, 1, 1, 0, 10.5),
('KH001', 'Vật lý', 0, 0, 0, 0, 0, 0),
('KH001', 'Viễn tưởng', 0, 0, 0, 0, 0, 0),
('KH001', 'Việt Nam', 0, 0, 0, 0, 0, 0),
('KH001', 'Vũ trụ', 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thongbao`
--

CREATE TABLE `thongbao` (
  `Ma_NV` varchar(15) NOT NULL,
  `T_TB` datetime NOT NULL DEFAULT current_timestamp(),
  `ND_TB` varchar(1024) DEFAULT NULL,
  `Cho` varchar(15) DEFAULT 'Tatca'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `thongbao`
--

INSERT INTO `thongbao` (`Ma_NV`, `T_TB`, `ND_TB`, `Cho`) VALUES
('NV001', '2024-06-12 16:12:48', 'Chào mừng các bạn đã đến web của chúng tôi', 'Tatca'),
('NV001', '2024-06-27 02:48:25', 'Yêu cầu xóa tài khoản của bạn đã bị từ chối, nếu bạn vẫn muốn xóa thì hãy hoàn thành tất cả đơn hàng đã gửi yêu cầu.', 'KH001'),
('NV001', '2024-06-27 08:53:49', 'Đơn hàng của bạn đã được tiếp nhận, hãy chờ chúng tôi xác nhận.', 'KH001'),
('NV001', '2024-06-27 09:28:03', 'Yêu cầu xóa tài khoản của bạn đã đạt yêu cầu và sẽ được xóa sau 7 ngày, bạn có thể hủy nếu tài khoản vẫn còn.', 'KH001'),
('NV001', '2024-07-02 18:34:55', 'Đơn hàng của bạn đã được tiếp nhận, hãy chờ chúng tôi xác nhận.', 'KH_e821a0681f'),
('NV001', '2024-07-02 18:42:38', 'Đơn hàng của bạn đã được tiếp nhận, hãy chờ chúng tôi xác nhận.', 'KH_e821a0681f'),
('NV001', '2024-07-02 18:46:41', 'Đơn hàng của bạn đã được tiếp nhận, hãy chờ chúng tôi xác nhận.', 'KH_e821a0681f'),
('NV001', '2024-07-02 18:57:27', 'Đơn hàng của bạn(DHb1ca7a3834) đã được tiếp nhận, hãy chờ chúng tôi xác nhận.', 'KH_e821a0681f'),
('NV001', '2024-07-02 19:11:11', 'Đơn hàng của bạn(DHb1ca7a3834) đã hoàn thành,  cảm ơn bạn đã mua hàng ở chúng tôi.', 'KH_e821a0681f'),
('NV001', '2024-07-02 19:14:06', 'Đơn hàng của bạn (DHc6d424e338) đã được tiếp nhận, hãy chờ chúng tôi xác nhận.', 'KH_e821a0681f'),
('NV001', '2024-07-02 19:14:22', 'Đơn hàng của bạn(DHc6d424e338) đã bị từ chối, có thể do thông tin để giao hàng không chính xác bạn nên kiểm tra lại trước khi thực hiện đơn hàng tiếp theo.', 'KH_e821a0681f'),
('NV001', '2024-07-03 07:18:01', 'Đây là thông báo thử nghiệm', 'Tatca'),
('NV002', '2024-06-12 16:12:48', 'Cảm ơn bạn đã đồng hành cùng chúng tôi suốt thời gian qua', 'KH001');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vaitro`
--

CREATE TABLE `vaitro` (
  `Ma_VT` varchar(15) NOT NULL,
  `Ten_VT` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `vaitro`
--

INSERT INTO `vaitro` (`Ma_VT`, `Ten_VT`) VALUES
('KH', 'Khách hàng'),
('NV', 'Nhân viên'),
('QL', 'Quản lý');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `a_s`
--
ALTER TABLE `a_s`
  ADD PRIMARY KEY (`Ma_S`,`STT_A`);

--
-- Chỉ mục cho bảng `bl_s`
--
ALTER TABLE `bl_s`
  ADD PRIMARY KEY (`Ma_S`,`Ma_KH`,`T_BL`),
  ADD KEY `FK_BLS_KH` (`Ma_KH`);

--
-- Chỉ mục cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD PRIMARY KEY (`Ma_DH`),
  ADD KEY `FK_DH_KH` (`Ma_KH`);

--
-- Chỉ mục cho bảng `khachhang`
--
ALTER TABLE `khachhang`
  ADD PRIMARY KEY (`Ma_KH`),
  ADD KEY `FK_KH_TK` (`Ma_TK`);

--
-- Chỉ mục cho bảng `nhanvien`
--
ALTER TABLE `nhanvien`
  ADD PRIMARY KEY (`Ma_NV`),
  ADD KEY `FK_NV_TK` (`Ma_TK`);

--
-- Chỉ mục cho bảng `ql_dh`
--
ALTER TABLE `ql_dh`
  ADD PRIMARY KEY (`Ma_NV`,`Ma_DH`),
  ADD KEY `FK_QL_DH` (`Ma_DH`);

--
-- Chỉ mục cho bảng `quantam`
--
ALTER TABLE `quantam`
  ADD PRIMARY KEY (`Ma_KH`,`Ma_S`),
  ADD KEY `FK_QT_S` (`Ma_S`);

--
-- Chỉ mục cho bảng `quyen`
--
ALTER TABLE `quyen`
  ADD PRIMARY KEY (`Ma_Q`);

--
-- Chỉ mục cho bảng `sach`
--
ALTER TABLE `sach`
  ADD PRIMARY KEY (`Ma_S`),
  ADD KEY `FK_S_NV` (`Ma_NV`);

--
-- Chỉ mục cho bảng `sdh`
--
ALTER TABLE `sdh`
  ADD PRIMARY KEY (`Ma_DH`,`Ma_S`),
  ADD KEY `FK_SDH_S` (`Ma_S`);

--
-- Chỉ mục cho bảng `s_tg`
--
ALTER TABLE `s_tg`
  ADD PRIMARY KEY (`Ma_S`,`Ma_TG`),
  ADD KEY `FK_STG_S` (`Ma_TG`);

--
-- Chỉ mục cho bảng `s_tl`
--
ALTER TABLE `s_tl`
  ADD PRIMARY KEY (`Ma_S`,`TL`),
  ADD KEY `FK_STL_TL` (`TL`);

--
-- Chỉ mục cho bảng `tacgia`
--
ALTER TABLE `tacgia`
  ADD PRIMARY KEY (`Ma_TG`);

--
-- Chỉ mục cho bảng `taikhoan`
--
ALTER TABLE `taikhoan`
  ADD PRIMARY KEY (`Ma_TK`),
  ADD KEY `FK_TK_Q` (`Ma_Q`),
  ADD KEY `FK_TK_VT` (`Ma_VT`);

--
-- Chỉ mục cho bảng `theloai`
--
ALTER TABLE `theloai`
  ADD PRIMARY KEY (`TL`);

--
-- Chỉ mục cho bảng `thoiquen`
--
ALTER TABLE `thoiquen`
  ADD PRIMARY KEY (`Ma_KH`,`TL`),
  ADD KEY `FK_TQ_TL` (`TL`);

--
-- Chỉ mục cho bảng `thongbao`
--
ALTER TABLE `thongbao`
  ADD PRIMARY KEY (`Ma_NV`,`T_TB`);

--
-- Chỉ mục cho bảng `vaitro`
--
ALTER TABLE `vaitro`
  ADD PRIMARY KEY (`Ma_VT`);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `a_s`
--
ALTER TABLE `a_s`
  ADD CONSTRAINT `FK_AS_S` FOREIGN KEY (`Ma_S`) REFERENCES `sach` (`Ma_S`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `bl_s`
--
ALTER TABLE `bl_s`
  ADD CONSTRAINT `FK_BLS_KH` FOREIGN KEY (`Ma_KH`) REFERENCES `khachhang` (`Ma_KH`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_BLS_S` FOREIGN KEY (`Ma_S`) REFERENCES `sach` (`Ma_S`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD CONSTRAINT `FK_DH_KH` FOREIGN KEY (`Ma_KH`) REFERENCES `khachhang` (`Ma_KH`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `khachhang`
--
ALTER TABLE `khachhang`
  ADD CONSTRAINT `FK_KH_TK` FOREIGN KEY (`Ma_TK`) REFERENCES `taikhoan` (`Ma_TK`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `nhanvien`
--
ALTER TABLE `nhanvien`
  ADD CONSTRAINT `FK_NV_TK` FOREIGN KEY (`Ma_TK`) REFERENCES `taikhoan` (`Ma_TK`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `ql_dh`
--
ALTER TABLE `ql_dh`
  ADD CONSTRAINT `FK_QL_DH` FOREIGN KEY (`Ma_DH`) REFERENCES `donhang` (`Ma_DH`),
  ADD CONSTRAINT `FK_QL_NV` FOREIGN KEY (`Ma_NV`) REFERENCES `nhanvien` (`Ma_NV`);

--
-- Các ràng buộc cho bảng `quantam`
--
ALTER TABLE `quantam`
  ADD CONSTRAINT `FK_QT_KH` FOREIGN KEY (`Ma_KH`) REFERENCES `khachhang` (`Ma_KH`),
  ADD CONSTRAINT `FK_QT_S` FOREIGN KEY (`Ma_S`) REFERENCES `sach` (`Ma_S`);

--
-- Các ràng buộc cho bảng `sach`
--
ALTER TABLE `sach`
  ADD CONSTRAINT `FK_S_NV` FOREIGN KEY (`Ma_NV`) REFERENCES `nhanvien` (`Ma_NV`);

--
-- Các ràng buộc cho bảng `sdh`
--
ALTER TABLE `sdh`
  ADD CONSTRAINT `FK_SDH_DH` FOREIGN KEY (`Ma_DH`) REFERENCES `donhang` (`Ma_DH`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_SDH_S` FOREIGN KEY (`Ma_S`) REFERENCES `sach` (`Ma_S`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `s_tg`
--
ALTER TABLE `s_tg`
  ADD CONSTRAINT `FK_STG_S` FOREIGN KEY (`Ma_TG`) REFERENCES `tacgia` (`Ma_TG`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_STG_TG` FOREIGN KEY (`Ma_S`) REFERENCES `sach` (`Ma_S`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `s_tl`
--
ALTER TABLE `s_tl`
  ADD CONSTRAINT `FK_STL_S` FOREIGN KEY (`Ma_S`) REFERENCES `sach` (`Ma_S`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_STL_TL` FOREIGN KEY (`TL`) REFERENCES `theloai` (`TL`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `taikhoan`
--
ALTER TABLE `taikhoan`
  ADD CONSTRAINT `FK_TK_Q` FOREIGN KEY (`Ma_Q`) REFERENCES `quyen` (`Ma_Q`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_TK_VT` FOREIGN KEY (`Ma_VT`) REFERENCES `vaitro` (`Ma_VT`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `thoiquen`
--
ALTER TABLE `thoiquen`
  ADD CONSTRAINT `FK_TQ_KH` FOREIGN KEY (`Ma_KH`) REFERENCES `khachhang` (`Ma_KH`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_TQ_TL` FOREIGN KEY (`TL`) REFERENCES `theloai` (`TL`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `thongbao`
--
ALTER TABLE `thongbao`
  ADD CONSTRAINT `FK_TB_NV` FOREIGN KEY (`Ma_NV`) REFERENCES `nhanvien` (`Ma_NV`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

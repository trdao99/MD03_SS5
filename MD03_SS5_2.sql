USE YourDatabaseName;
DELIMITER //

CREATE TRIGGER check_salePrice
    BEFORE INSERT
    ON Room
    FOR EACH ROW
BEGIN
    IF NEW.SalePrice > NEW.Price THEN
        SET NEW.SalePrice = NEW.Price;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Value of SalePrice must be <= Price value';
    END IF;
END //

DELIMITER //

CREATE TRIGGER check_salePrice_UPDATE
    BEFORE UPDATE
    ON Room
    FOR EACH ROW
BEGIN
    IF NEW.SalePrice > NEW.Price THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Value of SalePrice must be <= Price value';
    END IF;
END //
DELIMITER ;
# 4.1
delimiter //
CREATE TRIGGER tr_Check_Price_Value
    before insert
    on room
    for each row
begin
    IF NEW.Price > 5000000 THEN
        SET NEW.Price = 5000000;
    end if;
end;
DELIMITER ;


delimiter //
CREATE TRIGGER tr_Check_Price_Value_UPDATE
    before
        UPDATE
    on room
    for each row
begin
    IF NEW.Price > 5000000 THEN
        SET NEW.Price = 5000000;
    end if;
end;
DELIMITER ;
# 4.2	Tạo trigger tr_check_Room_NotAllow khi thực hiện đặt pòng,
# nếu ngày đến (StartDate) và ngày đi (EndDate) của đơn hiện tại mà phòng đã có người đặt rồi thì
# báo lỗi “Phòng này đã có người đặt trong thời gian này, vui lòng chọn thời gian khác”
DELIMITER //

CREATE TRIGGER tr_check_Room_NotAllow
    BEFORE INSERT
    ON bookingdetail
    FOR EACH ROW
BEGIN
    DECLARE booking_count INT;

    SELECT COUNT(*)
    INTO booking_count
    FROM bookingdetail
    WHERE RoomId = NEW.RoomId
      AND (
        (NEW.StartDate >= StartDate AND NEW.StartDate <= EndDate)
            OR (NEW.EndDate >= StartDate AND NEW.EndDate <= EndDate)
            OR (NEW.StartDate <= StartDate AND NEW.EndDate >= EndDate)
        );

    IF booking_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Phòng này đã có người đặt trong thời gian này, vui lòng chọn thời gian khác';
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER tr_check_Room_NotAllow_UPDATE
    BEFORE UPDATE
    ON bookingdetail
    FOR EACH ROW
BEGIN
    DECLARE booking_count INT;

    SELECT COUNT(*)
    INTO booking_count
    FROM bookingdetail
    WHERE RoomId = NEW.RoomId
      AND (
        (NEW.StartDate >= StartDate AND NEW.StartDate <= EndDate)
            OR (NEW.EndDate >= StartDate AND NEW.EndDate <= EndDate)
            OR (NEW.StartDate <= StartDate AND NEW.EndDate >= EndDate)
        );

    IF booking_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Phòng này đã có người đặt trong thời gian này, vui lòng chọn thời gian khác';
    END IF;
END //

DELIMITER ;
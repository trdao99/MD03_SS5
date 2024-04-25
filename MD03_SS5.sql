Drop database YourDatabaseName;
-- Tạo cơ sở dữ liệu
CREATE DATABASE YourDatabaseName;

-- Sử dụng cơ sở dữ liệu
USE YourDatabaseName;

-- Tạo bảng Category
CREATE TABLE Category
(
    Id     INT PRIMARY KEY,
    Name   VARCHAR(100) NOT NULL UNIQUE,
    Status TINYINT DEFAULT 1 CHECK (Status IN (0, 1))
);

-- Tạo bảng Room
CREATE TABLE Room
(
    Id          INT PRIMARY KEY,
    Name        VARCHAR(150) NOT NULL,
    Status      TINYINT DEFAULT 1 CHECK (Status IN (0, 1)),
    Price       FLOAT        NOT NULL CHECK (Price >= 100000),
    SalePrice   FLOAT   DEFAULT 0,
    CreatedDate DATE    DEFAULT (CURDATE()),
    CategoryId  INT          NOT NULL,
    FOREIGN KEY (CategoryId) REFERENCES Category (Id)
);

-- Tạo bảng Customer
CREATE TABLE Customer
(
    Id          INT PRIMARY KEY,
    Name        VARCHAR(150) NOT NULL,
    Email       VARCHAR(150) NOT NULL UNIQUE,
    Phone       VARCHAR(50)  NOT NULL UNIQUE,
    Address     VARCHAR(255),
    CreatedDate DATE DEFAULT (CURDATE()),
    Gender      TINYINT      NOT NULL CHECK (Gender IN (0, 1, 2)),
    BirthDay    DATE         NOT NULL
);

-- Tạo bảng Booking
CREATE TABLE Booking
(
    Id          INT PRIMARY KEY,
    CustomerId  INT NOT NULL,
    Status      TINYINT  DEFAULT 1 CHECK (Status IN (0, 1, 2, 3)),
    BookingDate DATETIME DEFAULT (CURDATE()),
    FOREIGN KEY (CustomerId) REFERENCES Customer (Id)
);


-- Tạo bảng BookingDetail
CREATE TABLE BookingDetail
(
    BookingId INT      NOT NULL,
    RoomId    INT      NOT NULL,
    Price     FLOAT    NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate   DATETIME NOT NULL,
    PRIMARY KEY (BookingId, RoomId),
    FOREIGN KEY (BookingId) REFERENCES Booking (Id),
    FOREIGN KEY (RoomId) REFERENCES Room (Id)
);
# Bảng Category (ít nhất 5 bản ghi):
INSERT INTO Category (Id, Name, Status)
VALUES (1, 'Electronics', 1),
       (2, 'Clothing', 1),
       (3, 'Home Appliances', 1),
       (4, 'Books', 1),
       (5, 'Sports Equipment', 1);
INSERT INTO Room (Id, Name, Status, Price, SalePrice, CreatedDate, CategoryId)
VALUES (1, 'Standard Room', 1, 150000, 0, '2024-04-25', 1),
       (2, 'Deluxe Room', 1, 250000, 0, '2024-04-25', 1),
       (3, 'Suite Room', 1, 350000, 0, '2024-04-25', 1),
       (4, 'Single Room', 1, 120000, 0, '2024-04-25', 1),
       (5, 'Double Room', 1, 180000, 0, '2024-04-25', 1),
       (6, 'Superior Room', 1, 200000, 0, '2024-04-25', 1),
       (7, 'Executive Suite', 1, 400000, 0, '2024-04-25', 1),
       (8, 'Twin Room', 1, 160000, 0, '2024-04-25', 1),
       (9, 'King Suite', 1, 450000, 0, '2024-04-25', 1),
       (10, 'Presidential Suite', 1, 800000, 0, '2024-04-25', 1),
       (11, 'Beachfront Villa', 1, 1000000, 0, '2024-04-25', 2),
       (12, 'Garden View Villa', 1, 700000, 0, '2024-04-25', 2),
       (13, 'Pool Villa', 1, 900000, 0, '2024-04-25', 2),
       (14, 'Mountain View Villa', 1, 750000, 0, '2024-04-25', 2),
       (15, 'Family Room', 1, 400000, 0, '2024-04-25', 1);
INSERT INTO Customer (Id, Name, Email, Phone, Address, CreatedDate, Gender, BirthDay)
VALUES (1, 'John Smith', 'john.smith@example.com', '123456789', '123 Main Street', CURDATE(), 1, '1990-01-01'),
       (2, 'Emily Johnson', 'emily.johnson@example.com', '987654321', '456 Elm Street', CURDATE(), 0, '1995-05-10'),
       (3, 'Michael Davis', 'michael.davis@example.com', '555555555', '789 Oak Street', CURDATE(), 1, '1988-08-15');
-- Chèn bản ghi Booking
INSERT INTO Booking (Id, CustomerId, Status, BookingDate)
VALUES (1, 1, 1, CURDATE()),
       (2, 2, 1, CURDATE()),
       (3, 3, 1, CURDATE());

-- Chèn bản ghi BookingDetail (liên kết với Booking)
INSERT INTO BookingDetail (BookingId, RoomId, Price, StartDate, EndDate)
VALUES (1, 1, 150000, '2024-05-01', '2024-05-05'), -- BookingId 1 có RoomId 1
       (1, 2, 250000, '2024-05-01', '2024-05-05'), -- BookingId 1 có RoomId 2
       (2, 3, 350000, '2024-05-10', '2024-05-15'), -- BookingId 2 có RoomId 3
       (2, 4, 120000, '2024-05-10', '2024-05-15'), -- BookingId 2 có RoomId 4
       (3, 5, 180000, '2024-05-20', '2024-05-25'), -- BookingId 3 có RoomId 5
       (3, 6, 200000, '2024-05-20', '2024-05-25');
-- BookingId 3 có RoomId 6
#1.1
select Room.Id, Room.Name, Price, SalePrice, Room.Status, C.Name, CreatedDate
from room
         join Category C on C.Id = room.CategoryId
order by Price desc;
#1.2
SELECT Category.Id, Category.Name, COUNT(R.id), IF(Category.Status = 0, 'Ẩn', 'Hiện')
FROM Category
         JOIN Room R ON Category.Id = R.CategoryId
GROUP BY Category.Id;
#1.3
SELECT Id,
       Name,
       Email,
       Phone,
       Address,
       CreatedDate,
       CASE
           WHEN Gender = 0 THEN 'NAM'
           WHEN Gender = 1 THEN 'NU'
           WHEN Gender = 2 THEN 'KHAC'
           END                                  AS Gender,
       BirthDay,
       TIMESTAMPDIFF(YEAR, BirthDay, CURDATE()) AS Age
FROM Customer;
#1.4 Truy vấn xóa các room chưa được book
SELECT *
FROM room
WHERE Id NOT IN (SELECT RoomId
                 FROM booking
                          JOIN BookingDetail BD ON booking.Id = BD.BookingId);
#1.5
UPDATE room
SET SalePrice = SalePrice + (SalePrice * 0.1)
WHERE Price >= 250000;
# 2.1
create view v_getRoomInfo as
select *
from room
order by Price desc
limit 10;
select *
from v_getRoomInfo;
# 2.2
create view v_getBookingList as
select Booking.Id, BookingDate, booking.Status, C.Name, Email, Phone, sum(R.Price) totalPRICE
from booking
         join BookingDetail BD on booking.Id = BD.BookingId
         join Customer C on C.Id = booking.CustomerId
         join Room R on BD.RoomId = R.Id
group by Booking.Id
;
select *
from v_getBookingList;
# 3.1
delimiter //
create procedure addRoomInfo(Id_IN INT,
                             Name_IN VARCHAR(150),
                             Status_IN TINYINT,
                             Price_IN FLOAT,
                             SalePrice_IN FLOAT,
                             CreatedDate_IN DATE,
                             CategoryId_IN INT)
begin
    INSERT INTO Room (Id, Name, Status, Price, SalePrice, CreatedDate, CategoryId)
        value
        (Id_IN,
         Name_IN,
         Status_IN,
         Price_IN,
         SalePrice_IN,
         CreatedDate_IN,
         CategoryId_IN);
end
//
# 3.2
delimiter //
create procedure getBookingByCustomerId(id_IN int)
begin
    select Booking.Id, BookingDate, booking.Status, C.Name, Email, Phone, sum(R.Price) totalPRICE
    from booking
             join BookingDetail BD on booking.Id = BD.BookingId
             join Customer C on C.Id = booking.CustomerId
             join Room R on BD.RoomId = R.Id
    where C.id = id_IN
    group by Booking.Id;
end //


# 3.3	Thủ tục getRoomPaginate lấy ra danh sách phòng có phân trang gồm:
# Id, Name, Price, SalePrice, Khi gọi thủ tuc truyền vào limit và page
delimiter //
create procedure getRoomPaginate(page int , size int)
begin
    declare off_set int ;
    set off_set = page*size;
    select Id, Name, Price, SalePrice
    from room limit off_set,size;
end ;
delimiter //















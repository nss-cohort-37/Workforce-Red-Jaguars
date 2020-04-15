USE MASTER
GO

IF NOT EXISTS (
    SELECT [name]
    FROM sys.databases
    WHERE [name] = N'BangazonWorkforce'
)
CREATE DATABASE BangazonWorkforce
GO

USE BangazonWorkforce
GO


CREATE TABLE Department (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL,
	Budget 	INTEGER NOT NULL
);

CREATE TABLE Computer (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	PurchaseDate DATETIME NOT NULL,
	DecomissionDate DATETIME,
	Make VARCHAR(55) NOT NULL,
	Model VARCHAR(55) NOT NULL
);

CREATE TABLE Employee (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	FirstName VARCHAR(55) NOT NULL,
	LastName VARCHAR(55) NOT NULL,
	DepartmentId INTEGER NOT NULL,
	Email VARCHAR(55) NOT NULL,
	IsSupervisor BIT NOT NULL DEFAULT(0),
	ComputerId INTEGER NOT NULL,
    CONSTRAINT FK_EmployeeDepartment FOREIGN KEY(DepartmentId) REFERENCES Department(Id),
	CONSTRAINT FK_EmployeeComputer FOREIGN KEY (ComputerId) REFERENCES Computer(Id)
);

CREATE TABLE TrainingProgram (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(255) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	MaxAttendees INTEGER NOT NULL
);

CREATE TABLE EmployeeTraining (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	EmployeeId INTEGER NOT NULL,
	TrainingProgramId INTEGER NOT NULL,
    CONSTRAINT FK_EmployeeTraining_Employee FOREIGN KEY(EmployeeId) REFERENCES Employee(Id),
    CONSTRAINT FK_EmployeeTraining_Training FOREIGN KEY(TrainingProgramId) REFERENCES TrainingProgram(Id)
);

CREATE TABLE ProductType (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL
);

CREATE TABLE Customer (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	FirstName VARCHAR(55) NOT NULL,
	LastName VARCHAR(55) NOT NULL,
	CreatedDate DATETIME NOT NULL,
	Active BIT NOT NULL DEFAULT(1),
	[Address] VARCHAR(255) NOT NULL,
	City VARCHAR(55) NOT NULL,
	[State] VARCHAR(55) NOT NULL,
	Email VARCHAR(55) NOT NULL,
	Phone VARCHAR(55) NOT NULL
);

CREATE TABLE Product (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	DateAdded DATETIME NOT NULL,
	ProductTypeId INTEGER NOT NULL,
	CustomerId INTEGER NOT NULL,
	Price MONEY NOT NULL,
	Title VARCHAR(255) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
    CONSTRAINT FK_Product_ProductType FOREIGN KEY(ProductTypeId) REFERENCES ProductType(Id),
    CONSTRAINT FK_Product_Customer FOREIGN KEY(CustomerId) REFERENCES Customer(Id)
);

CREATE TABLE PaymentType (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL,
	Active BIT NOT NULL DEFAULT(1)
);

CREATE TABLE UserPaymentType (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	AcctNumber VARCHAR(55) NOT NULL,
	Active BIT NOT NULL DEFAULT(1),
	CustomerId INTEGER NOT NULL,
	PaymentTypeId INTEGER NOT NULL,
    CONSTRAINT FK_UserPaymentType_Customer FOREIGN KEY(CustomerId) REFERENCES Customer(Id),
	CONSTRAINT FK_UserPaymentType_PaymentType FOREIGN KEY(PaymentTypeId) REFERENCES PaymentType(Id)
);

CREATE TABLE [Order] (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	CustomerId INTEGER NOT NULL,
	UserPaymentTypeId INTEGER,
    CONSTRAINT FK_Order_Customer FOREIGN KEY(CustomerId) REFERENCES Customer(Id),
    CONSTRAINT FK_Order_Payment FOREIGN KEY(UserPaymentTypeId) REFERENCES UserPaymentType(Id)
);

CREATE TABLE OrderProduct (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	OrderId INTEGER NOT NULL,
	ProductId INTEGER NOT NULL,
    CONSTRAINT FK_OrderProduct_Product FOREIGN KEY(ProductId) REFERENCES Product(Id),
    CONSTRAINT FK_OrderProduct_Order FOREIGN KEY(OrderId) REFERENCES [Order](Id)
);

INSERT INTO Department([Name],Budget) VALUES ('Marketing',415000);
INSERT INTO Department([Name],Budget) VALUES ('Engineering',57200);
INSERT INTO Department([Name],Budget) VALUES ('Accounting',123000);
INSERT INTO Department([Name],Budget) VALUES ('Legal',923000);
INSERT INTO Department([Name],Budget) VALUES ('I.T.',90300);
INSERT INTO Department([Name],Budget) VALUES ('Human Resources',23000);
INSERT INTO Department([Name],Budget) VALUES ('Research and Development',1000000);
INSERT INTO Department([Name],Budget) VALUES ('Sales', 3000);

INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2016-01-01T23:28:56.782Z',NULL,'Apple','Macbook Pro');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2018-02-09T23:28:56.782Z',NULL,'Apple','Macbook Air');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2019-05-05T23:28:56.782Z',NULL,'Microsoft','Suface Pro');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2014-01-01T23:28:56.782Z','2017-03-01T23:28:56.782Z','Lenovo','Thinkpad X1');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2016-01-01T23:28:56.782Z',NULL,'Apple','Macbook Pro');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2016-01-01T23:28:56.782Z',NULL,'System 76','Oryx Pro');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2016-01-01T23:28:56.782Z',NULL,'System 76','Gazelle');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2016-01-01T23:28:56.782Z',NULL,'System 76','Oryx Pro Lite');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2016-01-01T00:00:00.000Z','1970-01-01T00:00:00.000Z','System 76','Oryx Pro Lite');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2019-01-19T23:28:56.782Z',NULL,'Apple','Macbook Pro');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2019-01-19T23:28:56.782Z',NULL,'Apple','Macbook Pro');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2019-01-19T23:28:56.782Z',NULL,'Apple','Macbook Pro');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2020-01-12T23:28:56.782Z',NULL,'Apple','Macbook Pro');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2020-01-12T23:28:56.782Z',NULL,'Apple','Macbook Pro');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2020-01-12T23:28:56.782Z',NULL,'Apple','Macbook Air');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2020-01-12T23:28:56.782Z',NULL,'Apple','Macbook Air');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2020-01-12T23:28:56.782Z',NULL,'Apple','Macbook Air');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2020-01-12T23:28:56.782Z',NULL,'Apple','Macbook Air');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2020-01-12T23:28:56.782Z',NULL,'Apple','Macbook Air');
INSERT INTO Computer(PurchaseDate,DecomissionDate,Make,Model) VALUES ('2020-01-12T23:28:56.782Z',NULL,'Apple','Macbook Air');

INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Adam','Sheaffer',1,1,4,'iamtheboss@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Madi','Peper',2,1,3,'everythingisawesome@bangzon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Andy','Collins',3,1,2,'losinghorn@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Coach','Steve',4,1,1,'coach@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Brenda','Long',5,1,5,'blong@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Amber','Antony',6,1,6,'ambant@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Beau','Bundersnatch',7,1,7,'bandersnatch@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Caulin','Conner',8,1,8,'ccme@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Dina','Holly',1,0,9,'dina@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Kelly','Tall',2,0,10,'iamtall@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Link','Lamont',3,0,11,'mythicallink@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Rhett','McLaughlin',4,0,12,'mythicalrhett@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Olivia','Oliander',5,0,13,'olioli@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Ken','Kenny',6,0,14,'kenny.k@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Steve','Polst',7,0,15,'steve.polst@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Austin','Tall',8,0,16,'iamtaller@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Frank','Hank',1,0,17,'frankhank@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Dave','Strider',2,0,18,'strider@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Molly','Jackson',3,0,19,'molly.j@bangazon.com');
INSERT INTO Employee(FirstName,LastName,DepartmentId,IsSupervisor,ComputerId,Email) VALUES ('Morgan','Smith',4,0,20,'m.smith@bangazon.com');

INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('GIS Application','2018-09-25T00:00:00.000Z','2018-10-05T00:00:00.000Z',45);
INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('Business Process','2019-05-25T00:00:00.000Z','2018-05-26T00:00:00.000Z',100);
INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('Spanish 101','2019-09-25T00:00:00.000Z','2019-10-05T00:00:00.000Z',20);
INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('Application Architecture','2020-08-15T00:00:00.000Z','2020-08-28T00:00:00.000Z',15);
INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('Ethical Hacking','2020-06-16T00:00:00.000Z','2020-06-28T00:00:00.000Z',15);
INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('How to Knit','2020-02-06T00:00:00.000Z','2020-02-18T00:00:00.000Z',15);
INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('Scuba Diving','2020-03-19T00:00:00.000Z','2020-03-20T00:00:00.000Z',5);
INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('Making Coffee','2020-07-29T00:00:00.000Z','2020-08-17T00:00:00.000Z',100);
INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('Cleaning out the Sink','2020-02-10T00:00:00.000Z','2020-02-27T00:00:00.000Z',100);
INSERT INTO TrainingProgram([Name],StartDate,EndDate,MaxAttendees) VALUES ('How to show up for work','2020-05-28T00:00:00.000Z','2020-05-29T00:00:00.000Z',100);

INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (10,1);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (9,1);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (8,2);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (7,3);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (6,4);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (5,5);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (4,6);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (3,7);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (2,8);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (1,9);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (20,10);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (19,1);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (18,2);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (17,3);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (16,4);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (15,5);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (14,6);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (13,7);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (12,8);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (11,9);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (10,10);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (8,1);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (7,2);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (6,3);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (5,4);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (3,5);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (2,6);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (1,7);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (3,8);
INSERT INTO EmployeeTraining(EmployeeId,TrainingProgramId) VALUES (4,9);

INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Nathanael','Laverenz','401 Nunya Business Dr','Herman','New York','n.lav@sbcglobal.net','6151237584','2018-09-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Chrissy','Vivian','302 Puppy Way','Nashville','Tennessee','vivi@gmail.com','5782036593','2018-09-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Halli','Storten','404 Outtamai Way','Los Angelos','California','halliday@hotmail.com','2893750183','2018-09-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Godfree','Chase','500 Internal Cir','Topeka','Kansas','eerfdogesahc@gmail.com','1238693029','2018-09-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Willi','Warnes','418 Teapot Way','Seattle','Washington','willi.warnes@yahoo.com','7693025473','2018-09-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Salmon','O''''Nions','100 Continue Blvd','Atlanta','Georgia','salmonstriker@gmail.com','6151237584','2018-09-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Kimble','Peskett','508 Loop Cir','Nashville','Tennessee','peskykimble@hotmail.com','5671234567','2018-09-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (0,'Laura','Darner','504 Timeout Way','New York City','New York','laura.d@yahoo.com','1987654321','2018-09-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Jimmy','Schmitt','688 Frankfurt Dr','Kansas City','Kansas','schmitty@gmail.com','8293674589','2019-09-15T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Karl','Dunce','1203 Correct Ave','Redding','California','karl.d@hotmail.com','9162873087','2020-01-10T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Janet','Kings','473 Freedom Way','Louisville','Kentucky','queen.janet@gmail.com','5672084837','2019-12-20T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Abbey','Martin','78 Kingsman Dr','Oakland','California','abbey.rd@yahoo.com','5472047382','2019-10-22T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Kimmy','Bird','156 Russell Dr','Nashville','Tennessee','kimmythegreatest@gmail.com','5682036548','2019-04-13T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Lindsey','Frante','2462 Justice Ave','New York City','New York','frantic@gmail.com','6629375657','2019-04-05T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Michelle','Johnson','312 Dagmar Blvd','Portland','Oregon','queen.dagmar@gmail.com','8759163647','2019-02-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Nancy','Humm','1354 Dragonside Dr','Hillside','Montana','nancy.h@yahoo.com','2452349876','2019-11-25T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Oliver','Cuprit','474 Kingston Way','Johnson City','Missouri','daking@yahoo.com','1205637893','2019-05-29T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Penelope','Quaire','908 Hanser Dr','Lansing','Michigan','pquaire@gmail.com','9741230746','2019-12-04T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Quincy','Jackson','702 Hackman Blvd','Madison','Wisconsin','jq@gmail.com','6492348265','2019-05-07T00:00:00.000Z');
INSERT INTO Customer(Active,FirstName,LastName,[Address],City,[State],Email,Phone, CreatedDate) VALUES (1,'Rufus','Nanners','562','Anchorage','Alaska','rufus@gmail.com','1987654321','2019-07-03T00:00:00.000Z');

INSERT INTO ProductType([Name]) VALUES ('Tanks');
INSERT INTO ProductType([Name]) VALUES ('Accessories');
INSERT INTO ProductType([Name]) VALUES ('Stands');
INSERT INTO ProductType([Name]) VALUES ('Filters');
INSERT INTO ProductType([Name]) VALUES ('Pebbles');
INSERT INTO ProductType([Name]) VALUES ('Food');
INSERT INTO ProductType([Name]) VALUES ('Cleaning Supplies');
INSERT INTO ProductType([Name]) VALUES ('Bowls');
INSERT INTO ProductType([Name]) VALUES ('Filters');
INSERT INTO ProductType([Name]) VALUES ('Plants');
INSERT INTO ProductType([Name]) VALUES ('Heaters');

INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (2,3,76.91,'morbi ut odio cras mi pede malesuada in imperdiet et commodo','Passat','2019-08-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (1,2,62.54,'pede ullamcorper augue a suscipit nulla elit ac nulla sed','Murcilago LP640','2018-12-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (3,1,79.32,'lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut','Loyale','2018-09-16T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (4,3,10.94,'tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl','Millenia','2019-12-05T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (5,5,66.57,'eget nunc donec quis orci eget orci vehicula condimentum curabitur','Accord','2019-06-14T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (1,3,79.92,'semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero','Santa Fe','2019-09-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (2,6,9.09,'dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet','A3','2019-09-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (6,7,20.93,'amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus','Corvette','2019-09-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (1,5,53.45,'faucibus orci luctus et ultrices posuere cubilia curae duis faucibus','Discovery','2019-09-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (1,2,18.28,'pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at','SLX','2019-09-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (4,7,72.25,'sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis','Concorde','2019-09-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (4,5,37.99,'eget nunc donec quis orci eget orci vehicula condimentum curabitur','Windstar','2019-09-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (2,6,14.14,'curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis','Sunbird','2019-09-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (4,6,51.05,'nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at','XC60','2019-09-25T00:00:00.000Z');
INSERT INTO Product(ProductTypeId,CustomerId,Price,[Description],Title,DateAdded) VALUES (1,5,67.83,'consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus','Rocky','2019-09-25T00:00:00.000Z');

INSERT INTO PaymentType([Name],Active) VALUES ('Mastercard',1);
INSERT INTO PaymentType([Name],Active) VALUES ('Visa',1);
INSERT INTO PaymentType([Name],Active) VALUES ('Discover',1);
INSERT INTO PaymentType([Name],Active) VALUES ('American Express',1);
INSERT INTO PaymentType([Name],Active) VALUES ('Diners Club',0)

INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (1,5,'2234 5689 0123',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (2,2,'4563 5678 9012',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (1,2,'9864 5679 6473',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (4,1,'8763 5678 1937',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (3,2,'7653 5678 0327',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (4,2,'6541 5789 6543',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (5,4,'4532 6789 1234',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (6,4,'8764 5678 8643',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (7,3,'2345 5589 8753',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (8,3,'1284 2789 5672',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (9,2,'8764 8678 9012',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (10,2,'6532 1689 7542',1);
INSERT INTO UserPaymentType(CustomerId,PaymentTypeId,AcctNumber,Active) VALUES (11,1,'6543 5659 6634',1);

INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (1,1);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (2,2);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (1,1);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (2,2);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (1,3);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (2,2);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (1,3);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (2,2);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (4,4);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (4,6);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (4,4);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (2,2);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (1,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (2,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (3,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (4,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (5,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (6,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (7,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (8,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (9,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (10,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (11,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (12,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (13,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (14,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (15,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (16,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (17,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (18,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (19,NULL);
INSERT INTO [Order](CustomerId,UserPaymentTypeId) VALUES (20,NULL);

INSERT INTO OrderProduct(OrderId,ProductId) VALUES (1,2);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (1,4);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (1,3);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (1,15);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (2,12);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (2,10);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (3,5);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (3,4);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (4,3);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (5,8);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (5,8);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (5,9);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (14,7);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (6,4);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (7,3);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (8,1);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (8,2);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (8,11);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (9,12);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (10,14);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (10,3);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (11,10);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (12,2);
INSERT INTO OrderProduct(OrderId,ProductId) VALUES (13,15);
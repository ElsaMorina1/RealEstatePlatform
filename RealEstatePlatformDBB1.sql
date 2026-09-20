USE RealEstatePlatformDBB;
GO


IF OBJECT_ID('dbo.Comments', 'U') IS NOT NULL DROP TABLE dbo.Comments;
IF OBJECT_ID('dbo.FavoriteProperties', 'U') IS NOT NULL DROP TABLE dbo.FavoriteProperties;
IF OBJECT_ID('dbo.PropertyFeatures', 'U') IS NOT NULL DROP TABLE dbo.PropertyFeatures;
IF OBJECT_ID('dbo.Addresses', 'U') IS NOT NULL DROP TABLE dbo.Addresses;
IF OBJECT_ID('dbo.Properties', 'U') IS NOT NULL DROP TABLE dbo.Properties;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Features', 'U') IS NOT NULL DROP TABLE dbo.Features;


IF OBJECT_ID('dbo.AspNetUserRoles', 'U') IS NOT NULL DROP TABLE dbo.AspNetUserRoles;
IF OBJECT_ID('dbo.AspNetRoleClaims', 'U') IS NOT NULL DROP TABLE dbo.AspNetRoleClaims;
IF OBJECT_ID('dbo.AspNetUserClaims', 'U') IS NOT NULL DROP TABLE dbo.AspNetUserClaims;
IF OBJECT_ID('dbo.AspNetUserLogins', 'U') IS NOT NULL DROP TABLE dbo.AspNetUserLogins;
IF OBJECT_ID('dbo.AspNetUserTokens', 'U') IS NOT NULL DROP TABLE dbo.AspNetUserTokens;
IF OBJECT_ID('dbo.AspNetRoles', 'U') IS NOT NULL DROP TABLE dbo.AspNetRoles;
IF OBJECT_ID('dbo.AspNetUsers', 'U') IS NOT NULL DROP TABLE dbo.AspNetUsers;
GO

-- Krijimi i tabelës AspNetUsers (zgjerim i IdentityUser)
CREATE TABLE AspNetUsers (
    Id NVARCHAR(450) PRIMARY KEY,
    UserName NVARCHAR(256) NULL,
    NormalizedUserName NVARCHAR(256) NULL,
    Email NVARCHAR(256) NULL,
    NormalizedEmail NVARCHAR(256) NULL,
    EmailConfirmed BIT NOT NULL,
    PasswordHash NVARCHAR(MAX) NULL,
    SecurityStamp NVARCHAR(MAX) NULL,
    ConcurrencyStamp NVARCHAR(MAX) NULL,
    PhoneNumber NVARCHAR(MAX) NULL,
    PhoneNumberConfirmed BIT NOT NULL,
    TwoFactorEnabled BIT NOT NULL,
    LockoutEnd DATETIMEOFFSET NULL,
    LockoutEnabled BIT NOT NULL,
    AccessFailedCount INT NOT NULL,
    FullName NVARCHAR(MAX) NULL,
    ProfileImage NVARCHAR(MAX) NULL
);
GO

-- Krijimi i tabelës AspNetRoles
CREATE TABLE AspNetRoles (
    Id NVARCHAR(450) PRIMARY KEY,
    Name NVARCHAR(256) NULL,
    NormalizedName NVARCHAR(256) NULL,
    ConcurrencyStamp NVARCHAR(MAX) NULL
);
GO

-- Krijimi i tabelës AspNetUserRoles
CREATE TABLE AspNetUserRoles (
    UserId NVARCHAR(450) NOT NULL,
    RoleId NVARCHAR(450) NOT NULL,
    PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_AspNetUserRoles_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE,
    CONSTRAINT FK_AspNetUserRoles_AspNetRoles_RoleId FOREIGN KEY (RoleId) REFERENCES AspNetRoles(Id) ON DELETE CASCADE
);
GO

-- Krijimi i tabelës AspNetRoleClaims
CREATE TABLE AspNetRoleClaims (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    RoleId NVARCHAR(450) NOT NULL,
    ClaimType NVARCHAR(MAX) NULL,
    ClaimValue NVARCHAR(MAX) NULL,
    CONSTRAINT FK_AspNetRoleClaims_AspNetRoles_RoleId FOREIGN KEY (RoleId) REFERENCES AspNetRoles(Id) ON DELETE CASCADE
);
GO

-- Krijimi i tabelës AspNetUserClaims
CREATE TABLE AspNetUserClaims (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId NVARCHAR(450) NOT NULL,
    ClaimType NVARCHAR(MAX) NULL,
    ClaimValue NVARCHAR(MAX) NULL,
    CONSTRAINT FK_AspNetUserClaims_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);
GO

-- Krijimi i tabelës AspNetUserLogins
CREATE TABLE AspNetUserLogins (
    LoginProvider NVARCHAR(450) NOT NULL,
    ProviderKey NVARCHAR(450) NOT NULL,
    ProviderDisplayName NVARCHAR(MAX) NULL,
    UserId NVARCHAR(450) NOT NULL,
    PRIMARY KEY (LoginProvider, ProviderKey),
    CONSTRAINT FK_AspNetUserLogins_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);
GO

-- Krijimi i tabelës AspNetUserTokens
CREATE TABLE AspNetUserTokens (
    UserId NVARCHAR(450) NOT NULL,
    LoginProvider NVARCHAR(450) NOT NULL,
    Name NVARCHAR(450) NOT NULL,
    Value NVARCHAR(MAX) NULL,
    PRIMARY KEY (UserId, LoginProvider, Name),
    CONSTRAINT FK_AspNetUserTokens_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);
GO

-- Krijimi i tabelës Categories
CREATE TABLE Categories (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Icon NVARCHAR(MAX) NULL
);
GO

-- Krijimi i tabelës Features
CREATE TABLE Features (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL,
    Icon NVARCHAR(MAX) NULL
);
GO

-- Krijimi i tabelës Properties
CREATE TABLE Properties (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(150) NOT NULL,
    Description NVARCHAR(1000) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    ImageUrl NVARCHAR(MAX) NULL,
    City NVARCHAR(MAX) NOT NULL,
    AddressLine NVARCHAR(MAX) NOT NULL,
    Bedrooms INT NOT NULL,
    Bathrooms INT NOT NULL,
    Area FLOAT NOT NULL,
    IsFeatured BIT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    PropertyType NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(MAX) NOT NULL,
    CategoryId INT NOT NULL,
    UserId NVARCHAR(450) NULL,
    CONSTRAINT FK_Properties_Categories_CategoryId FOREIGN KEY (CategoryId) REFERENCES Categories(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_Properties_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE NO ACTION
);
GO

-- Krijimi i tabelës Addresses
CREATE TABLE Addresses (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    City NVARCHAR(MAX) NOT NULL,
    Street NVARCHAR(MAX) NOT NULL,
    PropertyId INT NOT NULL UNIQUE,
    CONSTRAINT FK_Addresses_Properties_PropertyId FOREIGN KEY (PropertyId) REFERENCES Properties(Id) ON DELETE CASCADE
);
GO

-- Krijimi i tabelës PropertyFeatures (tabelë lidhëse Many-to-Many)
CREATE TABLE PropertyFeatures (
    PropertyId INT NOT NULL,
    FeatureId INT NOT NULL,
    PRIMARY KEY (PropertyId, FeatureId),
    CONSTRAINT FK_PropertyFeatures_Properties_PropertyId FOREIGN KEY (PropertyId) REFERENCES Properties(Id) ON DELETE CASCADE,
    CONSTRAINT FK_PropertyFeatures_Features_FeatureId FOREIGN KEY (FeatureId) REFERENCES Features(Id) ON DELETE CASCADE
);
GO

-- Krijimi i tabelës FavoriteProperties
CREATE TABLE FavoriteProperties (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId NVARCHAR(450) NOT NULL,
    PropertyId INT NOT NULL,
    CONSTRAINT FK_FavoriteProperties_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE,
    CONSTRAINT FK_FavoriteProperties_Properties_PropertyId FOREIGN KEY (PropertyId) REFERENCES Properties(Id) ON DELETE CASCADE
);
GO

-- Krijimi i tabelës Comments
CREATE TABLE Comments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Text NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UserId NVARCHAR(450) NOT NULL,
    PropertyId INT NOT NULL,
    CONSTRAINT FK_Comments_AspNetUsers_UserId FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE,
    CONSTRAINT FK_Comments_Properties_PropertyId FOREIGN KEY (PropertyId) REFERENCES Properties(Id) ON DELETE CASCADE
);
GO

-- Shto rolin 'User' në tabelën AspNetRoles
IF NOT EXISTS (SELECT 1 FROM AspNetRoles WHERE NormalizedName = 'USER')
BEGIN
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
    VALUES (NEWID(), 'User', 'USER', NEWID());
END
GO

-- 1. Kontrollo dhe krijo tabelën AspNetRoles nëse mungon
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetRoles]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[AspNetRoles](
        [Id] [nvarchar](450) NOT NULL,
        [Name] [nvarchar](256) NULL,
        [NormalizedName] [nvarchar](256) NULL,
        [ConcurrencyStamp] [nvarchar](max) NULL,
        CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END
GO

-- 2. Kontrollo dhe krijo tabelën AspNetUserRoles (lidhja midis përdoruesit dhe rolit)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUserRoles]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[AspNetUserRoles](
        [UserId] [nvarchar](450) NOT NULL,
        [RoleId] [nvarchar](450) NOT NULL,
        CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
        CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END
GO

-- 3. Shto rolin 'User' nëse nuk ekziston
IF NOT EXISTS (SELECT 1 FROM [dbo].[AspNetRoles] WHERE [NormalizedName] = 'USER')
BEGIN
    INSERT INTO [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
    VALUES (NEWID(), 'User', 'USER', NEWID());
END
GO


-- 1. Krijo tabelën AspNetUserClaims (për SignInAsync)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUserClaims]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[AspNetUserClaims](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [UserId] [nvarchar](450) NOT NULL,
        [ClaimType] [nvarchar](max) NULL,
        [ClaimValue] [nvarchar](max) NULL,
        CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END
GO

-- 2. Krijo tabelën AspNetUserLogins (për login-et e jashtme)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUserLogins]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[AspNetUserLogins](
        [LoginProvider] [nvarchar](450) NOT NULL,
        [ProviderKey] [nvarchar](450) NOT NULL,
        [ProviderDisplayName] [nvarchar](max) NULL,
        [UserId] [nvarchar](450) NOT NULL,
        CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC),
        CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END
GO

-- 3. Krijo tabelën AspNetUserTokens (për token-et e sigurisë)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUserTokens]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[AspNetUserTokens](
        [UserId] [nvarchar](450) NOT NULL,
        [LoginProvider] [nvarchar](450) NOT NULL,
        [Name] [nvarchar](450) NOT NULL,
        [Value] [nvarchar](max) NULL,
        CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED ([UserId] ASC, [LoginProvider] ASC, [Name] ASC),
        CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END
GO

-- 4. Krijo tabelën AspNetRoleClaims
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetRoleClaims]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[AspNetRoleClaims](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [RoleId] [nvarchar](450) NOT NULL,
        [ClaimType] [nvarchar](max) NULL,
        [ClaimValue] [nvarchar](max) NULL,
        CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE
    );
END
GO


INSERT INTO Categories(Name, Icon)
VALUES
('Apartment','bi bi-building'),
('House','bi bi-house-door'),
('Land','bi bi-tree'),
('Local','bi bi-shop'),
('Cafe','bi bi-cup-hot'),
('Hotel','bi bi-building-fill'),
('Restaurant','bi bi-egg-fried');

INSERT INTO Features(Name,Icon)
VALUES
('Parking','bi bi-p-circle'),
('WiFi','bi bi-wifi'),
('Swimming Pool','bi bi-water'),
('Garden','bi bi-tree'),
('Balcony','bi bi-house'),
('Air Conditioning','bi bi-snow'),
('Security','bi bi-shield-check'),
('Elevator','bi bi-arrow-up-square'),
('Garage','bi bi-car-front'),
('Terrace','bi bi-sun');


--APARTAMENT
INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Modern Apartment Drenas', 'Beautiful modern apartment in Drenas.', 68000, '/images/apartments/apartament1.jpg', 'Drenas', 'Main Street', 2, 1, 86, 1, 'Apartment', 'For Sale', 1),
('Luxury Apartment Drenas', 'Luxury apartment near city center.', 92000, '/images/apartments/apartament2.jpg', 'Drenas', 'Center', 3, 2, 110, 1, 'Apartment', 'For Sale', 1),
('Family Apartment Drenas', 'Perfect family apartment.', 78000, '/images/apartments/apartament3.jpg', 'Drenas', 'New City', 3, 2, 102, 0, 'Apartment', 'For Sale', 1),
('Green Apartment', 'Apartment with beautiful garden.', 85000, '/images/apartments/apartament4.jpg', 'Drenas', 'Park Street', 2, 2, 90, 0, 'Apartment', 'For Sale', 1),
('Elite Apartment', 'Premium apartment.', 98000, '/images/apartments/apartament5.jpg', 'Drenas', 'Central Boulevard', 3, 2, 115, 1, 'Apartment', 'For Sale', 1), 
('City Apartment', 'Close to schools.', 72000, '/images/apartments/apartament6.jpg', 'Drenas', 'School Street', 2, 1, 82, 0, 'Apartment', 'For Sale', 1),
('Sun Apartment', 'Sunny apartment.', 64000, '/images/apartments/apartament7.jpg', 'Drenas', 'Sun Street', 2, 1, 79, 0, 'Apartment', 'For Sale', 1),
('Premium Apartment', 'Modern design.', 105000, '/images/apartments/apartament8.jpg', 'Drenas', 'Park Street', 3, 2, 122, 1, 'Apartment', 'For Sale', 1),
('Dream Apartment', 'Luxury interior.', 89000, '/images/apartments/apartament9.jpg', 'Drenas', 'Dream Street', 3, 2, 104, 0, 'Apartment', 'For Sale', 1),
('Sky Apartment', 'Top floor apartment.', 99000, '/images/apartments/apartament10.jpg', 'Drenas', 'Sky Street', 3, 2, 118, 1, 'Apartment', 'For Sale', 1);

INSERT INTO Addresses(City,Street,PropertyId)
VALUES
('Drenas','Main Street',1),
('Drenas','Center',2),
('Drenas','New City',3),
('Drenas','Park Street',4),
('Drenas','Central Boulevard',5),
('Drenas','School Street',6),
('Drenas','Sun Street',7),
('Drenas','Premium Street',8),
('Drenas','Dream Street',9),
('Drenas','Sky Street',10);

INSERT INTO PropertyFeatures(PropertyId,FeatureId)
VALUES
(1,1),(1,2),(1,5),
(2,1),(2,2),(2,3),(2,6),
(3,1),(3,4),
(4,2),(4,5),
(5,1),(5,3),(5,7),
(6,1),(6,2),
(7,4),(7,5),
(8,1),(8,2),(8,3),(8,6),
(9,1),(9,7),
(10,1),(10,2),(10,10);




INSERT INTO Properties
(Title,Description,Price,ImageUrl,City,AddressLine,Bedrooms,Bathrooms,Area,IsFeatured,PropertyType,Status,CategoryId)
VALUES
('Modern Apartment Prishtina','Modern apartment near city center.',125000,'/images/apartments/apartment4.jpg','Prishtinë','Ulpiana',2,2,95,1,'Apartment','For Sale',1),
('Luxury Apartment Prishtina','Luxury apartment with parking.',165000,'/images/apartments/apartment7.jpg','Prishtinë','Dardania',3,2,120,1,'Apartment','For Sale',1),
('Family Apartment','Family apartment in Prishtina.',98000,'/images/apartments/apartment1.jpg','Prishtinë','Bregu i Diellit',2,1,88,0,'Apartment','For Sale',1),
('Elite Apartment','Elite apartment close to downtown.',175000,'/images/apartments/apartment5.jpg','Prishtinë','Qendra',3,2,135,1,'Apartment','For Sale',1),
('Green Apartment','Apartment with balcony.',112000,'/images/apartments/apartment10.jpg','Prishtinë','Arbëria',2,2,97,0,'Apartment','For Sale',1),
('City Apartment','Beautiful city apartment.',138000,'/images/apartments/apartment8.jpg','Prishtinë','Lakrishtë',3,2,115,1,'Apartment','For Sale',1),
('Dream Apartment','Apartment with amazing view.',149000,'/images/apartments/apartment2.jpg','Prishtinë','Mati 1',3,2,123,1,'Apartment','For Sale',1),
('Premium Apartment','Premium quality apartment.',185000,'/images/apartments/apartment6.jpg','Prishtinë','Dragodan',4,2,148,1,'Apartment','For Sale',1),
('Sky Apartment','Apartment on the top floor.',159000,'/images/apartments/apartment3.jpg','Prishtinë','Emshir',3,2,118,0,'Apartment','For Sale',1),
('Sun Apartment','Sunny apartment with terrace.',132000,'/images/apartments/apartment9.jpg','Prishtinë','Veternik',2,2,102,0,'Apartment','For Sale',1);

INSERT INTO Addresses(City,Street,PropertyId)
VALUES
('Prishtinë','Ulpiana',11),
('Prishtinë','Dardania',12),
('Prishtinë','Bregu i Diellit',13),
('Prishtinë','Qendra',14),
('Prishtinë','Arbëria',15),
('Prishtinë','Lakrishtë',16),
('Prishtinë','Mati 1',17),
('Prishtinë','Dragodan',18),
('Prishtinë','Emshir',19),
('Prishtinë','Veternik',20);

INSERT INTO PropertyFeatures(PropertyId,FeatureId)
VALUES
(11,1),(11,2),(11,5),
(12,1),(12,2),(12,3),(12,6),
(13,1),(13,4),
(14,1),(14,2),(14,7),
(15,2),(15,5),
(16,1),(16,2),(16,6),
(17,1),(17,2),(17,3),
(18,1),(18,2),(18,3),(18,7),
(19,1),(19,5),
(20,2),(20,10);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Modern Apartment Prizren', 'Modern apartment in Prizren.', 72000, '/images/apartmets/apartment7.jpg', 'Prizren', 'Ortakoll', 2, 1, 82, 1, 'Apartment', 'For Sale', 1),
('Luxury Apartment Prizren', 'Luxury apartment.', 98000, '/images/apartments/apartment4.jpg', 'Prizren', 'Bazhdarhane', 3, 2, 118, 1, 'Apartment', 'For Sale', 1),
('Family Apartment', 'Perfect family apartment.', 81000, '/images/apartments/apartment9.jpg', 'Prizren', 'Kurila', 3, 2, 105, 0, 'Apartment', 'For Sale', 1),
('Elite Apartment', 'Elite apartment.', 115000, '/images/apartments/apartment1.jpg', 'Prizren', 'Qendra', 3, 2, 125, 1, 'Apartment', 'For Sale', 1),
('Green Apartment', 'Apartment with balcony.', 76000, '/images/apartments/apartment10.jpg', 'Prizren', 'Arbana', 2, 1, 90, 0, 'Apartment', 'For Sale', 1),
('City Apartment', 'Close to schools.', 69000, '/images/apartments/apartment3.jpg', 'Prizren', 'Tusuz', 2, 1, 80, 0, 'Apartment', 'For Sale', 1),
('Dream Apartment', 'Beautiful apartment.', 95000, '/images/apartments/apartment6.jpg', 'Prizren', 'Bajram Curri', 3, 2, 116, 1, 'Apartment', 'For Sale', 1),
('Premium Apartment', 'Premium interior.', 102000, '/images/apartments/apartment2.jpg', 'Prizren', 'Jeta e Re', 3, 2, 120, 1, 'Apartment', 'For Sale', 1),
('Sun Apartment', 'Sunny apartment.', 74000, '/images/apartments/apartment8.jpg', 'Prizren', 'Lakuriq', 2, 1, 84, 0, 'Apartment', 'For Sale', 1),
('Sky Apartment', 'Top floor apartment.', 108000, '/images/apartments/apartment5.jpg', 'Prizren', 'Center', 3, 2, 130, 1, 'Apartment', 'For Sale', 1);


INSERT INTO Addresses(City,Street,PropertyId)
VALUES
('Prizren','Ortakoll',21),
('Prizren','Bazhdarhane',22),
('Prizren','Kurila',23),
('Prizren','Qendra',24),
('Prizren','Arbana',25),
('Prizren','Tusuz',26),
('Prizren','Bajram Curri',27),
('Prizren','Jeta e Re',28),
('Prizren','Lakuriq',29),
('Prizren','Center',30);

INSERT INTO PropertyFeatures(PropertyId,FeatureId)
VALUES
(21,1),(21,2),(21,5),
(22,1),(22,2),(22,3),(22,6),
(23,1),(23,4),
(24,1),(24,2),(24,7),
(25,2),(25,5),
(26,1),(26,2),
(27,1),(27,2),(27,3),
(28,1),(28,2),(28,3),(28,7),
(29,1),(29,5),
(30,2),(30,10);





INSERT INTO Properties
(Title,Description,Price,ImageUrl,City,AddressLine,Bedrooms,Bathrooms,Area,IsFeatured,PropertyType,Status,CategoryId)VALUES
('Modern Apartment Pejë','Modern apartment in Pejë.',78000,'/images/apartments/apartment8.jpg','Pejë','Qendra',2,1,84,1,'Apartment','For Sale',1),
('Luxury Apartment Pejë','Luxury apartment.',118000,'/images/apartments/apartment5.jpg','Pejë','Kristal',3,2,125,1,'Apartment','For Sale',1),
('Family Apartment Pejë','Family apartment.',82000,'/images/apartments/apartment10.jpg','Pejë','Dardania',3,2,108,0,'Apartment','For Sale',1),
('Elite Apartment Pejë','Elite apartment.',128000,'/images/apartments/apartment3.jpg','Pejë','Fidanishte',3,2,132,1,'Apartment','For Sale',1),
('Green Apartment Pejë','Apartment with garden.',76000,'/images/apartments/apartment6.jpg','Pejë','Karagaç',2,1,88,0,'Apartment','For Sale',1),
('City Apartment Pejë','Near city center.',72000,'/images/apartments/apartment4.jpg','Pejë','Qendra',2,1,81,0,'Apartment','For Sale',1),
('Dream Apartment Pejë','Luxury interior.',96000,'/images/apartments/apartment9.jpg','Pejë','Kapeshnicë',3,2,118,1,'Apartment','For Sale',1),
('Premium Apartment Pejë','Premium apartment.',109000,'/images/apartments/apartment2.jpg','Pejë','Kristal',3,2,121,1,'Apartment','For Sale',1),
('Sun Apartment Pejë','Sunny apartment.',79000,'/images/apartments/apartment7.jpg','Pejë','Dardania',2,1,90,0,'Apartment','For Sale',1),
('Sky Apartment Pejë','Top floor apartment.',119000,'/images/apartments/apartment1.jpg','Pejë','Qendra',3,2,135,1,'Apartment','For Sale',1);


INSERT INTO Addresses(City,Street,PropertyId)
VALUES
('Pejë','Qendra',31),
('Pejë','Kristal',32),
('Pejë','Dardania',33),
('Pejë','Fidanishte',34),
('Pejë','Karagaç',35),
('Pejë','Qendra',36),
('Pejë','Kapeshnicë',37),
('Pejë','Kristal',38),
('Pejë','Dardania',39),
('Pejë','Qendra',40);

INSERT INTO PropertyFeatures(PropertyId,FeatureId)
VALUES
(31,1),(31,2),(31,5),
(32,1),(32,2),(32,3),(32,6),
(33,1),(33,4),
(34,1),(34,2),(34,7),
(35,2),(35,5),
(36,1),(36,2),
(37,1),(37,2),(37,3),
(38,1),(38,2),(38,3),(38,7),
(39,1),(39,5),
(40,2),(40,10);




INSERT INTO Properties
(Title,Description,Price,ImageUrl,City,AddressLine,Bedrooms,Bathrooms,Area,IsFeatured,PropertyType,Status,CategoryId)
VALUES
('Modern Apartment Ferizaj','Modern apartment in Ferizaj.',73000,'/images/apartments/apartment10.jpg','Ferizaj','Qendra',2,1,83,1,'Apartment','For Sale',1),
('Luxury Apartment Ferizaj','Luxury apartment.',115000,'/images/apartments/apartment3.jpg','Ferizaj','Dardania',3,2,126,1,'Apartment','For Sale',1),
('Family Apartment Ferizaj','Family apartment.',81000,'/images/apartments/apartment7.jpg','Ferizaj','Lagjja e Re',3,2,108,0,'Apartment','For Sale',1),
('Elite Apartment Ferizaj','Elite apartment.',125000,'/images/apartments/apartment4.jpg','Ferizaj','Qendra',3,2,134,1,'Apartment','For Sale',1),
('Green Apartment Ferizaj','Apartment with balcony.',79000,'/images/apartments/apartment9.jpg','Ferizaj','Dardania',2,1,91,0,'Apartment','For Sale',1),
('City Apartment Ferizaj','Apartment near center.',69000,'/images/apartments/apartment1.jpg','Ferizaj','Parku',2,1,80,0,'Apartment','For Sale',1),
('Dream Apartment Ferizaj','Luxury interior.',96000,'/images/apartments/apartment8.jpg','Ferizaj','Qendra',3,2,116,1,'Apartment','For Sale',1),
('Premium Apartment Ferizaj','Premium apartment.',109000,'/images/apartments/apartment6.jpg','Ferizaj','Lagjja e Re',3,2,122,1,'Apartment','For Sale',1),
('Sun Apartment Ferizaj','Sunny apartment.',76000,'/images/apartments/apartment1.jpg','Ferizaj','Parku',2,1,89,0,'Apartment','For Sale',1),
('Sky Apartment Ferizaj','Top floor apartment.',119000,'/images/apartments/apartment5.jpg','Ferizaj','Qendra',3,2,136,1,'Apartment','For Sale',1);


INSERT INTO Addresses(City,Street,PropertyId)
VALUES
('Ferizaj','Qendra',41),
('Ferizaj','Dardania',42),
('Ferizaj','Lagjja e Re',43),
('Ferizaj','Qendra',44),
('Ferizaj','Dardania',45),
('Ferizaj','Parku',46),
('Ferizaj','Qendra',47),
('Ferizaj','Lagjja e Re',48),
('Ferizaj','Parku',49),
('Ferizaj','Qendra',50);

INSERT INTO PropertyFeatures(PropertyId,FeatureId)
VALUES
(41,1),(41,2),(41,5),
(42,1),(42,2),(42,3),(42,6),
(43,1),(43,4),
(44,1),(44,2),(44,7),
(45,2),(45,5),
(46,1),(46,2),
(47,1),(47,2),(47,3),
(48,1),(48,2),(48,3),(48,7),
(49,1),(49,5),
(50,2),(50,10);





INSERT INTO Properties
(Title,Description,Price,ImageUrl,City,AddressLine,Bedrooms,Bathrooms,Area,IsFeatured,PropertyType,Status,CategoryId)
VALUES
('Modern Apartment Gjilan','Modern apartment in Gjilan.',71000,'/images/apartments/apartment9.jpg','Gjilan','Qendra',2,1,81,1,'Apartment','For Sale',1),
('Luxury Apartment Gjilan','Luxury apartment with parking.',118000,'/images/apartments/apartment6.jpg','Gjilan','Dardania',3,2,124,1,'Apartment','For Sale',1),
('Family Apartment Gjilan','Perfect family apartment.',84000,'/images/apartments/apartment1.jpg','Gjilan','Lagjja e Re',3,2,108,0,'Apartment','For Sale',1),
('Elite Apartment Gjilan','Elite apartment.',129000,'/images/apartments/apartment10.jpg','Gjilan','Qendra',3,2,136,1,'Apartment','For Sale',1),
('Green Apartment Gjilan','Apartment with balcony.',76000,'/images/apartments/apartment4.jpg','Gjilan','Dardania',2,1,90,0,'Apartment','For Sale',1),
('City Apartment Gjilan','Near city center.',69000,'/images/apartments/apartment8.jpg','Gjilan','Parku',2,1,82,0,'Apartment','For Sale',1),
('Dream Apartment Gjilan','Luxury apartment.',98000,'/images/apartments/apartment5.jpg','Gjilan','Qendra',3,2,118,1,'Apartment','For Sale',1),
('Premium Apartment Gjilan','Premium interior.',112000,'/images/apartments/apartment2.jpg','Gjilan','Lagjja e Re',3,2,121,1,'Apartment','For Sale',1),
('Sun Apartment Gjilan','Sunny apartment.',78000,'/images/apartments/apartment7.jpg','Gjilan','Parku',2,1,89,0,'Apartment','For Sale',1),
('Sky Apartment Gjilan','Top floor apartment.',122000,'/images/apartments/apartment3.jpg','Gjilan','Qendra',3,2,138,1,'Apartment','For Sale',1);



INSERT INTO Addresses(City,Street,PropertyId)
VALUES
('Gjilan','Qendra',51),
('Gjilan','Dardania',52),
('Gjilan','Lagjja e Re',53),
('Gjilan','Qendra',54),
('Gjilan','Dardania',55),
('Gjilan','Parku',56),
('Gjilan','Qendra',57),
('Gjilan','Lagjja e Re',58),
('Gjilan','Parku',59),
('Gjilan','Qendra',60);

INSERT INTO PropertyFeatures(PropertyId,FeatureId)
VALUES
(51,1),(51,2),(51,5),
(52,1),(52,2),(52,3),(52,6),
(53,1),(53,4),
(54,1),(54,2),(54,7),
(55,2),(55,5),
(56,1),(56,2),
(57,1),(57,2),(57,3),
(58,1),(58,2),(58,3),(58,7),
(59,1),(59,5),
(60,2),(60,10);






INSERT INTO Properties 
( Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
( 'River View Apartment', 'Apartment with Ibar river view.', 75000, '/images/apartments/apartment2.jpg', 'Mitrovicë', 'Qendra', 2, 1, 85, 1, 'Apartment', 'For Sale', 1),
( 'City Center Flat', 'Right in the heart of Mitrovica.', 82000, '/images/apartments/apartment4.jpg', 'Mitrovicë', 'Qendra', 3, 2, 110, 1, 'Apartment', 'For Sale', 1),
( 'Ilirida Modern Home', 'Newly built in Ilirida.', 68000, '/images/apartments/apartment8.jpg', 'Mitrovicë', 'Ilirida', 2, 1, 78, 0, 'Apartment', 'For Sale', 1),
( 'Bair Panorama', 'Beautiful view from Bair hill.', 95000, '/images/apartments/apartment3.jpg', 'Mitrovicë', 'Bair', 3, 2, 125, 1, 'Apartment', 'For Sale', 1),
( 'Tavnik Residence', 'Spacious apartment in Tavnik.', 72000, '/images/apartments/apartment7.jpg', 'Mitrovicë', 'Tavnik', 2, 1, 92, 0, 'Apartment', 'For Sale', 1),
( 'North Side Apartment', 'Close to the bridge.', 64000, '/images/apartments/apartment10.jpg', 'Mitrovicë', 'Qendra', 2, 1, 75, 0, 'Apartment', 'For Sale', 1),
( 'Luxury Mitrovica', 'High-end interior design.', 115000, '/images/apartments/apartment5.jpg', 'Mitrovicë', 'Qendra', 3, 2, 140, 1, 'Apartment', 'For Sale', 1),
( 'Family Flat Bair', 'Quiet neighborhood for families.', 79000, '/images/apartments/apartment9.jpg', 'Mitrovicë', 'Bair', 3, 1, 105, 0, 'Apartment', 'For Sale', 1),
( 'Cozy Tavnik', 'Small but very functional.', 58000, '/images/apartments/apartment1.jpg', 'Mitrovicë', 'Tavnik', 1, 1, 65, 0, 'Apartment', 'For Sale', 1),
( 'Skyline Mitrovica', 'Penthouse style apartment.', 130000, '/images/apartments/apartment6.jpg', 'Mitrovicë', 'Qendra', 4, 2, 160, 1, 'Apartment', 'For Sale', 1);



-- Shtimi i Adresave
DELETE FROM Addresses WHERE PropertyId BETWEEN 61 AND 70;
INSERT INTO Addresses(City, Street, PropertyId)
VALUES
('Mitrovicë', 'Qendra', 61),
('Mitrovicë', 'Qendra', 62),
('Mitrovicë', 'Ilirida', 63),
('Mitrovicë', 'Bair', 64),
('Mitrovicë', 'Tavnik', 65),
('Mitrovicë', 'Qendra', 66),
('Mitrovicë', 'Qendra', 67),
('Mitrovicë', 'Bair', 68),
('Mitrovicë', 'Tavnik', 69),
('Mitrovicë', 'Qendra', 70);

-- Shtimi i Karakteristikave (Features)
INSERT INTO PropertyFeatures(PropertyId, FeatureId)
VALUES
(61,1), (61,5),
(62,1), (62,2), (62,3),
(63,1), (63,4),
(64,1), (64,2), (64,7),
(65,2), (65,5),
(66,1), (66,6),
(67,1), (67,2), (67,3), (67,8),
(68,1), (68,4),
(69,1), (69,5),
(70,1), (70,2), (70,3), (70,10);







INSERT INTO Properties 
( Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
( 'Old Bazaar Apartment', 'Traditional style near the Old Bazaar.', 68000, '/images/apartments/apartment2.jpg', 'Gjakovë', 'Çarshia e Vjetër', 2, 1, 80, 1, 'Apartment', 'For Sale', 1),
( 'Modern Flat Gjakova', 'Close to the city park.', 85000, '/images/apartments/apartment7.jpg', 'Gjakovë', 'Qendra', 3, 2, 115, 1, 'Apartment', 'For Sale', 1),
( 'Krena River Apartment', 'View over the Krena river.', 72000, '/images/apartments/apartment5.jpg', 'Gjakovë', 'Qendra', 2, 1, 88, 0, 'Apartment', 'For Sale', 1),
( 'Family Residence Gjakovë', 'Spacious and quiet area.', 92000, '/images/apartments/apartment9.jpg', 'Gjakovë', 'Blloku i Ri', 3, 2, 120, 1, 'Apartment', 'For Sale', 1),
( 'Economic Studio', 'Perfect for students or couples.', 45000, '/images/apartments/apartment3.jpg', 'Gjakovë', 'Qendra', 1, 1, 55, 0, 'Apartment', 'For Sale', 1),
( 'Garden View Flat', 'Ground floor with a small garden.', 77000, '/images/apartments/apartment8.jpg', 'Gjakovë', 'Blloku i Ri', 2, 1, 95, 0, 'Apartment', 'For Sale', 1),
( 'Premium Gjakova', 'Luxurious apartment with smart home features.', 125000, '/images/apartments/apartment10.jpg', 'Gjakovë', 'Qendra', 3, 2, 145, 1, 'Apartment', 'For Sale', 1),
( 'Sunny Hill Apartment', 'Great natural light all day.', 81000, '/images/apartments/apartment6.jpg', 'Gjakovë', 'Kodra e Diellit', 3, 1, 102, 0, 'Apartment', 'For Sale', 1),
( 'Classic Gjakova', 'Well maintained classic apartment.', 63000, '/images/apartments/apartment4.jpg', 'Gjakovë', 'Qendra', 2, 1, 75, 0, 'Apartment', 'For Sale', 1),
( 'Penthouse Gjakovë', 'Top floor with a huge terrace.', 140000, '/images/apartments/apartment1.jpg', 'Gjakovë', 'Blloku i Ri', 4, 3, 175, 1, 'Apartment', 'For Sale', 1);



-- Shtimi i Adresave
INSERT INTO Addresses(City, Street, PropertyId)
VALUES
('Gjakovë', 'Çarshia e Vjetër', 71),
('Gjakovë', 'Qendra', 72),
('Gjakovë', 'Qendra', 73),
('Gjakovë', 'Blloku i Ri', 74),
('Gjakovë', 'Qendra', 75),
('Gjakovë', 'Blloku i Ri', 76),
('Gjakovë', 'Qendra', 77),
('Gjakovë', 'Kodra e Diellit', 78),
('Gjakovë', 'Qendra', 79),
('Gjakovë', 'Blloku i Ri', 80);

-- Shtimi i Karakteristikave (Features)
INSERT INTO PropertyFeatures(PropertyId, FeatureId)
VALUES
(71,1), (71,5),
(72,1), (72,2), (72,3),
(73,1), (73,6),
(74,1), (74,2), (74,7),
(75,5),
(76,1), (76,4),
(77,1), (77,2), (77,3), (77,8), (77,10),
(78,1), (78,5),
(79,1), (79,2),
(80,1), (80,2), (80,3), (80,7), (80,10);







INSERT INTO Properties 
( Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
( 'New Build Fushë Kosovë', 'Modern apartment in a new complex.', 62000, '/images/apartments/apartment10.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 2, 1, 75, 1, 'Apartment', 'For Sale', 1),
('Spacious Family Flat', 'Great for families, near schools.', 78000, '/images/apartments/apartment5.jpg', 'Fushë Kosovë', 'Qendra', 3, 2, 105, 1, 'Apartment', 'For Sale', 1),
( 'Modern Studio FK', 'Compact and stylish studio.', 39000, '/images/apartments/apartment1.jpg', 'Fushë Kosovë', 'Dardania', 1, 1, 48, 0, 'Apartment', 'For Sale', 1),
('Economic Apartment', 'Affordable price in a good location.', 55000, '/images/apartments/apartment8.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 2, 1, 68, 0, 'Apartment', 'For Sale', 1),
('Business District Flat', 'Near the main business area.', 88000, '/images/apartments/apartment6.jpg', 'Fushë Kosovë', 'Qendra', 3, 2, 112, 1, 'Apartment', 'For Sale', 1),
( 'Park Side Residence', 'Quiet area facing the local park.', 69000, '/images/apartments/apartment2.jpg', 'Fushë Kosovë', 'Dardania', 2, 1, 82, 0, 'Apartment', 'For Sale', 1),
( 'Elite Complex FK', 'High security and premium building.', 105000, '/images/apartments/apartment9.jpg', 'Fushë Kosovë', 'Qendra', 3, 2, 130, 1, 'Apartment', 'For Sale', 1),
('Sunny Apartment FK', 'Bright apartment with large windows.', 73000, '/images/apartments/apartment4.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 3, 1, 95, 0, 'Apartment', 'For Sale', 1),
('Standard Living FK', 'Well organized standard apartment.', 59000, '/images/apartments/apartment7.jpg', 'Fushë Kosovë', 'Dardania', 2, 1, 72, 0, 'Apartment', 'For Sale', 1),
( 'Grand Penthouse FK', 'Huge space with panoramic view.', 145000, '/images/apartments/apartment3.jpg', 'Fushë Kosovë', 'Qendra', 4, 3, 180, 1, 'Apartment', 'For Sale', 1);


-- Shtimi i Adresave
INSERT INTO Addresses(City, Street, PropertyId)
VALUES
('Fushë Kosovë', 'Rruga e Pejës', 81),
('Fushë Kosovë', 'Qendra', 82),
('Fushë Kosovë', 'Dardania', 83),
('Fushë Kosovë', 'Rruga e Pejës', 84),
('Fushë Kosovë', 'Qendra', 85),
('Fushë Kosovë', 'Dardania', 86),
('Fushë Kosovë', 'Qendra', 87),
('Fushë Kosovë', 'Rruga e Pejës', 88),
('Fushë Kosovë', 'Dardania', 89),
('Fushë Kosovë', 'Qendra', 90);

-- Shtimi i Karakteristikave (Features)
INSERT INTO PropertyFeatures(PropertyId, FeatureId)
VALUES
(81,1), (81,5),
(82,1), (82,2), (82,3),
(83,5), (83,6),
(84,1), (84,4),
(85,1), (85,2), (85,7),
(86,1), (86,5),
(87,1), (87,2), (87,3), (87,10),
(88,1), (88,4),
(89,1), (89,2),
(90,1), (90,2), (90,3), (90,7), (90,10);







INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
( 'Central Podujeva Flat', 'Located in the heart of the city.', 65000, '/images/apartments/apartment4.jpg', 'Podujevë', 'Qendra', 2, 1, 80, 1, 'Apartment', 'For Sale', 1),
('Modern Residence Podujevë', 'High quality construction.', 82000, '/images/apartments/apartment7.jpg', 'Podujevë', 'Besiana', 3, 2, 110, 1, 'Apartment', 'For Sale', 1),
( 'Economic Living Podujevë', 'Affordable and cozy apartment.', 52000, '/images/apartments/apartment1.jpg', 'Podujevë', 'Qendra', 2, 1, 70, 0, 'Apartment', 'For Sale', 1),
( 'Park View Apartment', 'Facing the city park of Podujeva.', 75000, '/images/apartments/apartment6.jpg', 'Podujevë', 'Besiana', 2, 1, 88, 1, 'Apartment', 'For Sale', 1),
( 'Family Home Podujevë', 'Large space for big families.', 98000, '/images/apartments/apartment10.jpg', 'Podujevë', 'Qendra', 3, 2, 130, 1, 'Apartment', 'For Sale', 1),
( 'Sunny Side Flat', 'Great orientation with plenty of sun.', 68000, '/images/apartments/apartment8.jpg', 'Podujevë', 'Besiana', 2, 1, 82, 0, 'Apartment', 'For Sale', 1),
('Elite Podujeva Apartment', 'Premium materials and smart design.', 110000, '/images/apartments/apartment3.jpg', 'Podujevë', 'Qendra', 3, 2, 140, 1, 'Apartment', 'For Sale', 1),
( 'Besiana Heights', 'Top floor apartment with a view.', 89000, '/images/apartments/apartment5.jpg', 'Podujevë', 'Besiana', 3, 2, 115, 0, 'Apartment', 'For Sale', 1),
('Standard Flat Besiana', 'Simple and functional living.', 58000, '/images/apartments/apartment2.jpg', 'Podujevë', 'Besiana', 2, 1, 75, 0, 'Apartment', 'For Sale', 1),
('Luxury Penthouse Podujevë', 'Exclusive penthouse with large terrace.', 155000, '/images/apartments/apartment9.jpg', 'Podujevë', 'Qendra', 4, 3, 190, 1, 'Apartment', 'For Sale', 1);


-- Shtimi i Adresave
INSERT INTO Addresses(City, Street, PropertyId)
VALUES
('Podujevë', 'Qendra', 91),
('Podujevë', 'Besiana', 92),
('Podujevë', 'Qendra', 93),
('Podujevë', 'Besiana', 94),
('Podujevë', 'Qendra', 95),
('Podujevë', 'Besiana', 96),
('Podujevë', 'Qendra', 97),
('Podujevë', 'Besiana', 98),
('Podujevë', 'Besiana', 99),
('Podujevë', 'Qendra', 100);

-- Shtimi i Karakteristikave (Features)
INSERT INTO PropertyFeatures(PropertyId, FeatureId)
VALUES
(91,1), (91,5),
(92,1), (92,2), (92,3),
(93,1), (93,4),
(94,1), (94,6),
(95,1), (95,2), (95,7),
(96,1), (96,5),
(97,1), (97,2), (97,3), (97,10),
(98,1), (98,4),
(99,1), (99,2),
(100,1), (100,2), (100,3), (100,7), (100,10);





--TOKAT



INSERT INTO Properties 
( Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Tokë Bujqësore Drenas(Land)', 'Tokë pjellore e përshtatshme për bujqësi.', 15000, '/images/lands/land1.jpg', 'Drenas', 'Zabel', 0, 0, 5000, 0, 'Land', 'For Sale', 2),
('Truall për Ndërtim(Land)', 'Afër zonës industriale, i përshtatshëm për depo.', 45000, '/images/lands/land2.jpg', 'Drenas', 'Qendra', 0, 0, 1000, 1, 'Land', 'For Sale', 2),
('Tokë në fshatin Polluzhë(Land)', 'Pozitë e mirë, qasje në rrugë.', 12000, '/images/lands/land3.jpg', 'Drenas', 'Polluzhë', 0, 0, 3000, 0, 'Land', 'For Sale', 2),
('Truall Industrial Drenas(Land)', 'Sipërfaqe e madhe buzë rrugës kryesore.', 120000, '/images/lands/land4.jpg', 'Drenas', 'Zona Industriale', 0, 0, 8000, 1, 'Land', 'For Sale', 2),
( 'Tokë afër Ferronikelit(Land)', 'E përshtatshme për aktivitete biznesi.', 35000, '/images/lands/land5.jpg', 'Drenas', 'Çikatovë', 0, 0, 2500, 0, 'Land', 'For Sale', 2),
('Truall afër Qendrës(Land)', 'I gatshëm për ndërtim të shtëpisë.', 28000, '/images/lands/land6.jpg', 'Drenas', 'Qendra', 0, 0, 500, 1, 'Land', 'For Sale', 2),
( 'Tokë për Fermë(Land)', 'Hapsirë e gjelbëruar dhe e qetë.', 22000, '/images/lands/land7.jpg', 'Drenas', 'Gllogoc', 0, 0, 4000, 0, 'Land', 'For Sale', 2),
('Parcelë në Komoran(Land)', 'Pikë strategjike afër autostradës.', 65000, '/images/lands/land8.jpg', 'Drenas', 'Komoran', 0, 0, 1500, 1, 'Land', 'For Sale', 2),
( 'Tokë Mali Drenas(Land)', 'E përshtatshme për rekreacion ose vilë.', 18000, '/images/lands/land9.jpg', 'Drenas', 'Koritë', 0, 0, 6000, 0, 'Land', 'For Sale', 2),
( 'Truall Komercial(Land)', 'Ideale për showroom ose biznes.', 85000, '/images/lands/land10.jpg', 'Drenas', 'Rruga kryesore', 0, 0, 2000, 1, 'Land', 'For Sale', 2);



-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Drenas', 'Zabel', 101), ('Drenas', 'Qendra', 102), ('Drenas', 'Polluzhë', 103), ('Drenas', 'Zona Industriale', 104), ('Drenas', 'Çikatovë', 105),
('Drenas', 'Qendra', 106), ('Drenas', 'Gllogoc', 107), ('Drenas', 'Komoran', 108), ('Drenas', 'Koritë', 109), ('Drenas', 'Rruga kryesore', 110);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(101,2),(101,4),
(102,2),(102,4),
(103,2),(103,4),(103,6),
(104,2),(104,4),
(105,2),(105,4),
(106,2),(106,4),
(107,2),(107,4),(107,5),
(108,2),(108,4),
(109,2),(109,4),(109,7),(109,10),
(110,2),(110,4);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Truall në Çagllavicë(Land)', 'Zonë luksoze për vila.', 95000, '/images/lands/land10.jpg', 'Prishtinë', 'Çagllavicë', 0, 0, 600, 1, 'Land', 'For Sale', 2),
('Tokë në Veternik(Land)', 'Pamje nga qyteti, zonë elitare.', 150000, '/images/lands/land4.jpg', 'Prishtinë', 'Veternik', 0, 0, 1000, 1, 'Land', 'For Sale', 2),
('Truall në Mat(Land)', 'Afër rrugës kryesore, i urbanizuar.', 75000, '/images/lands/land7.jpg', 'Prishtinë', 'Mat', 0, 0, 500, 0, 'Land', 'For Sale', 2),
('Tokë në Hajvali(Land)', 'Afër liqenit të Badovcit.', 40000, '/images/lands/land1.jpg', 'Prishtinë', 'Hajvali', 0, 0, 1200, 0, 'Land', 'For Sale', 2),
('Truall në Kolovicë<Land)', 'Pozitë e lartë, ajër i pastër.', 55000, '/images/lands/land9.jpg', 'Prishtinë', 'Kolovicë', 0, 0, 800, 0, 'Land', 'For Sale', 2),
('Tokë Komerciale magjistrale(Land)', 'Buzë rrugës Prishtinë-Ferizaj.', 300000, '/images/lands/land3.jpg', 'Prishtinë', 'Magjistralja', 0, 0, 5000, 1, 'Land', 'For Sale', 2),
('Truall në Sofali(Land)', 'Afër parkut të Gërmisë.', 120000, '/images/lands/land6.jpg', 'Prishtinë', 'Sofali', 0, 0, 700, 1, 'Land', 'For Sale', 2),
('Tokë në Bërnicë(Land)', 'Zonë e qetë për shtëpi banimi.', 65000, '/images/lands/land2.jpg', 'Prishtinë', 'Bërnicë', 0, 0, 1500, 0, 'Land', 'For Sale', 2),
('Truall në Bardhosh(Land)', 'Qasje e lehtë në autostradë.', 48000, '/images/lands/land8.jpg', 'Prishtinë', 'Bardhosh', 0, 0, 1000, 0, 'Land', 'For Sale', 2),
('Parcelë në Shkabaj(Land)', 'Ideale për investim afatgjatë.', 38000, '/images/lands/land5.jpg', 'Prishtinë', 'Shkabaj', 0, 0, 2000, 0, 'Land', 'For Sale', 2);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prishtinë', 'Çagllavicë', 111), ('Prishtinë', 'Veternik', 112), ('Prishtinë', 'Mat', 113), ('Prishtinë', 'Hajvali', 114), ('Prishtinë', 'Kolovicë', 115),
('Prishtinë', 'Magjistralja', 116), ('Prishtinë', 'Sofali', 117), ('Prishtinë', 'Bërnicë', 118), ('Prishtinë', 'Bardhosh', 119), ('Prishtinë', 'Shkabaj', 120);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(111,2),(111,3),(111,4),
(112,2),(112,4),
(113,2),(113,4),
(114,2),(114,4),(114,6),(114,7),
(115,2),(115,4),
(116,2),(116,4),
(117,2),(117,4),
(118,2),(118,4),(118,9),
(119,2),(119,4),
(120,2),(120,4);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Truall në Reçan(Land)', 'Afër lumit, zonë shumë e qetë.', 45000, '/images/lands/land8.jpg', 'Prizren', 'Reçan', 0, 0, 1200, 1, 'Land', 'For Sale', 2),
('Tokë në Zhur(Land)', 'Përgjatë rrugës kryesore për Shqipëri.', 35000, '/images/lands/land10.jpg', 'Prizren', 'Zhur', 0, 0, 2500, 0, 'Land', 'For Sale', 2),
('Truall në Jaglenicë(land)', 'I urbanizuar, gati për ndërtim.', 65000, '/images/lands/land4.jpg', 'Prizren', 'Jaglenicë', 0, 0, 600, 1, 'Land', 'For Sale', 2),
('Tokë në Korishë(Land)', 'Tokë pjellore me sistem ujitjeje.', 28000, '/images/lands/land1.jpg', 'Prizren', 'Korishë', 0, 0, 3000, 0, 'Land', 'For Sale', 2),
('Truall afër Qendrës(Land)', 'Zonë e banueshme, qasje në rrugë.', 110000, '/images/lands/land9.jpg', 'Prizren', 'Qendra', 0, 0, 400, 1, 'Land', 'For Sale', 2),
('Tokë në Lubizhdë(Land)', 'Ideale për depo ose biznes.', 85000, '/images/lands/land5.jpg', 'Prizren', 'Lubizhdë', 0, 0, 1500, 0, 'Land', 'For Sale', 2),
('Truall në Vlashnje(Land)', 'Pozitë e mirë, afër autostradës.', 55000, '/images/lands/land3.jpg', 'Prizren', 'Vlashnje', 0, 0, 1000, 0, 'Land', 'For Sale', 2),
('Tokë në Prevallë(Land)', 'Zonë malore, perfekte për vilë.', 125000, '/images/lands/land7.jpg', 'Prizren', 'Prevallë', 0, 0, 500, 1, 'Land', 'For Sale', 2),
('Truall në Arbana(Land)', 'Lagje e re dhe moderne.', 72000, '/images/lands/land2.jpg', 'Prizren', 'Arbana', 0, 0, 700, 0, 'Land', 'For Sale', 2),
('Tokë në Gërnçar(Land)', 'Tokë e rrafshët, afër kufirit.', 22000, '/images/lands/land6.jpg', 'Prizren', 'Gërnçar', 0, 0, 4000, 0, 'Land', 'For Sale', 2);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prizren', 'Reçan', 121), ('Prizren', 'Zhur', 122), ('Prizren', 'Jaglenicë', 123), ('Prizren', 'Korishë', 124), ('Prizren', 'Qendra', 125),
('Prizren', 'Lubizhdë', 126), ('Prizren', 'Vlashnje', 127), ('Prizren', 'Prevallë', 128), ('Prizren', 'Arbana', 129), ('Prizren', 'Gërnçar', 130);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(121,1),(121,2),(121,4),
(122,2),(122,4),
(123,2),(123,4),
(124,2),(124,4),
(125,2),(125,4),(125,6),(125,8),
(126,2),(126,4),
(127,2),(127,4),
(128,2),(128,4),(128,5),
(129,2),(129,4),
(130,1),(130,2),(130,3),(130,4);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Truall në Rugovë(Land)', 'Pamje spektakolare, ideale për turizëm.', 140000, '/images/lands/land7.jpg', 'Pejë', 'Rugovë', 0, 0, 1000, 1, 'Land', 'For Sale', 2),
('Tokë në Vitomiricë(Land)', 'Sipërfaqe e madhe, rrugë e asfaltuar.', 55000, '/images/lands/land5.jpg', 'Pejë', 'Vitomiricë', 0, 0, 2000, 0, 'Land', 'For Sale', 2),
('Truall në Radavc(Land)', 'Afër burimit të Drinit të Bardhë.', 95000, '/images/lands/land10.jpg', 'Pejë', 'Radavc', 0, 0, 1500, 1, 'Land', 'For Sale', 2),
('Tokë Bujqësore Zahaq(Land)', 'Tokë shumë pjellore buzë rrugës.', 42000, '/images/lands/land8.jpg', 'Pejë', 'Zahaq', 0, 0, 5000, 0, 'Land', 'For Sale', 2),
('Truall në Karagaç(Land)', 'Zonë elitare afër parkut.', 180000, '/images/lands/land1.jpg', 'Pejë', 'Karagaç', 0, 0, 600, 1, 'Land', 'For Sale', 2),
('Tokë në Brestovik(Land)', 'Ajër i pastër, pamje nga qyteti.', 68000, '/images/lands/land9.jpg', 'Pejë', 'Brestovik', 0, 0, 1200, 0, 'Land', 'For Sale', 2),
('Truall Industrial Pejë(Land)', 'Afër zonës industriale, qasje e lehtë.', 120000, '/images/lands/land3.jpg', 'Pejë', 'Zona Industriale', 0, 0, 3000, 1, 'Land', 'For Sale', 2),
('Tokë në Raushiq(Land)', 'E përshtatshme për shtëpi ose fermë.', 38000, '/images/lands/land6.jpg', 'Pejë', 'Raushiq', 0, 0, 2500, 0, 'Land', 'For Sale', 2),
('Truall në Fidanishte(Land)', 'Lagje e qetë dhe e urbanizuar.', 85000, '/images/lands/land7.jpg', 'Pejë', 'Fidanishte', 0, 0, 800, 0, 'Land', 'For Sale', 2),
('Parcelë në Treboviq(Land)', 'Investim i mirë për të ardhmen.', 25000, '/images/lands/land2.jpg', 'Pejë', 'Treboviq', 0, 0, 1800, 0, 'Land', 'For Sale', 2);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Pejë', 'Rugovë', 131), ('Pejë', 'Vitomiricë', 132), ('Pejë', 'Radavc', 133), ('Pejë', 'Zahaq', 134), ('Pejë', 'Karagaç', 135),
('Pejë', 'Brestovik', 136), ('Pejë', 'Zona Industriale', 137), ('Pejë', 'Raushiq', 138), ('Pejë', 'Fidanishte', 139), ('Pejë', 'Treboviq', 140);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(131,2),(131,4),
(132,2),(132,4),(132,7),
(133,2),(133,4),
(134,2),(134,4),
(135,2),(135,4),
(136,2),(136,4),
(137,2),(137,4),
(138,2),(138,4),
(139,2),(139,4),(139,9),
(140,2),(140,4);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Truall në Bibaj(Land)', 'Afër autostradës, zonë industriale.', 110000, '/images/lands/land4.jpg', 'Ferizaj', 'Bibaj', 0, 0, 2500, 1, 'Land', 'For Sale', 2),
('Tokë në Prelez(Land)', 'Përgjatë rrugës Prishtinë-Ferizaj.', 180000, '/images/lands/land10.jpg', 'Ferizaj', 'Prelez', 0, 0, 4000, 1, 'Land', 'For Sale', 2),
('Truall për Shtëpi(Land)', 'Zonë e qetë, lagje e re.', 45000, '/images/lands/land6.jpg', 'Ferizaj', 'Talinoc', 0, 0, 600, 0, 'Land', 'For Sale', 2),
('Tokë në Gërlicë(Land)', 'E përshtatshme për biznese apo depo.', 95000, '/images/lands/land1.jpg', 'Ferizaj', 'Gërlicë', 0, 0, 3500, 1, 'Land', 'For Sale', 2),
('Truall në Qendër(Land)', 'Truall i vogël për ndërtim komercial.', 150000, '/images/lands/land7.jpg', 'Ferizaj', 'Qendra', 0, 0, 300, 1, 'Land', 'For Sale', 2),
('Tokë në Jezerc(Land)', 'Zonë malore, ajër i pastër për vila.', 60000, '/images/lands/land5.jpg', 'Ferizaj', 'Jezerc', 0, 0, 1500, 0, 'Land', 'For Sale', 2),
('Truall në Muhoc(Land)', 'Afër qytetit, i urbanizuar.', 55000, '/images/lands/land8.jpg', 'Ferizaj', 'Muhoc', 0, 0, 800, 0, 'Land', 'For Sale', 2),
('Tokë Bujqësore(Land)', 'Tokë pjellore në fshatin Pojatë.', 25000, '/images/lands/land2.jpg', 'Ferizaj', 'Pojatë', 0, 0, 5000, 0, 'Land', 'For Sale', 2),
('Truall Industrial(Land)', 'Qasje e lehtë në rrugën kryesore.', 130000, '/images/lands/land9.jpg', 'Ferizaj', 'Zona Industriale', 0, 0, 3000, 1, 'Land', 'For Sale', 2),
('Parcelë në Doganaj(Land)', 'Investim i mirë afër rrugës kryesore.', 40000, '/images/lands/land3.jpg', 'Ferizaj', 'Doganaj', 0, 0, 2000, 0, 'Land', 'For Sale', 2);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Ferizaj', 'Bibaj', 141), ('Ferizaj', 'Prelez', 142), ('Ferizaj', 'Talinoc', 143), ('Ferizaj', 'Gërlicë', 144), ('Ferizaj', 'Qendra', 145),
('Ferizaj', 'Jezerc', 146), ('Ferizaj', 'Muhoc', 147), ('Ferizaj', 'Pojatë', 148), ('Ferizaj', 'Zona Industriale', 149), ('Ferizaj', 'Doganaj', 150);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(141,1),(141,2),(141,4),
(142,2),(142,4),
(143,2),(143,4),
(144,2),(144,4),
(145,2),(145,4),
(146,2),(146,4),(146,10),
(147,2),(147,4),
(148,2),(148,4),
(149,2),(149,4),
(150,1),(150,2),(150,3),(150,4);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Truall në Livoç(Land)', 'Afër liqenit, zonë shumë e kërkuar.', 75000, '/images/lands/land8.jpg', 'Gjilan', 'Livoç', 0, 0, 1000, 1, 'Land', 'For Sale', 2),
('Tokë në Malishevë(Land)', 'Përgjatë rrugës Gjilan-Kamenicë.', 55000, '/images/lands/land1.jpg', 'Gjilan', 'Malishevë', 0, 0, 2500, 0, 'Land', 'For Sale', 2),
('Truall në Qarkore(Land)', 'Zonë e banueshme, i urbanizuar.', 90000, '/images/lands/land7.jpg', 'Gjilan', 'Rruga Qarkore', 0, 0, 500, 1, 'Land', 'For Sale', 2),
('Tokë në Pasjak(Land)', 'E përshtatshme për shtëpi banimi.', 35000, '/images/lands/land10.jpg', 'Gjilan', 'Pasjak', 0, 0, 1200, 0, 'Land', 'For Sale', 2),
('Truall në Dardani(Land)', 'Lagje e re me infrastrukturë moderne.', 65000, '/images/lands/land3.jpg', 'Gjilan', 'Dardania', 0, 0, 800, 1, 'Land', 'For Sale', 2),
('Tokë në Dobërçan(Land)', 'Tokë pjellore afër lumit.', 28000, '/images/lands/land4.jpg', 'Gjilan', 'Dobërçan', 0, 0, 3000, 0, 'Land', 'For Sale', 2),
('Truall Industrial(Land)', 'Zona industriale Gjilan, i rrafshët.', 120000, '/images/lands/land9.jpg', 'Gjilan', 'Zona Industriale', 0, 0, 4000, 1, 'Land', 'For Sale', 2),
('Tokë në Bresalc(Land)', 'Buzë rrugës magjistrale Gjilan-Prishtinë.', 140000, '/images/lands/land2.jpg', 'Gjilan', 'Bresalc', 0, 0, 5000, 1, 'Land', 'For Sale', 2),
('Truall në Kufcë(Land)', 'Afër qytetit, qasje e lehtë.', 42000, '/images/lands/land6.jpg', 'Gjilan', 'Kufcë', 0, 0, 1500, 0, 'Land', 'For Sale', 2),
('Parcelë në Përlepnicë(Land)', 'Pamje e bukur afër pishinave.', 38000, '/images/lands/land5.jpg', 'Gjilan', 'Përlepnicë', 0, 0, 2000, 0, 'Land', 'For Sale', 2);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjilan', 'Livoç', 151), ('Gjilan', 'Malishevë', 152), ('Gjilan', 'Rruga Qarkore', 153), ('Gjilan', 'Pasjak', 154), ('Gjilan', 'Dardania', 155),
('Gjilan', 'Dobërçan', 156), ('Gjilan', 'Zona Industriale', 157), ('Gjilan', 'Bresalc', 158), ('Gjilan', 'Kufcë', 159), ('Gjilan', 'Përlepnicë', 160);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(151,2),(151,4),
(152,2),(152,4),
(153,2),(153,4),
(154,2),(154,4),(154,5),(154,6),
(155,2),(155,4),
(156,2),(156,4),
(157,2),(157,4),(154,7),
(158,2),(158,4),
(159,2),(159,4),
(160,2),(160,4);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Truall në Shupkovc(Land)', 'Pozitë ideale afër rrugës kryesore.', 55000, '/images/lands/land5.jpg', 'Mitrovicë', 'Shupkovc', 0, 0, 1000, 1, 'Land', 'For Sale', 2),
('Tokë në Shipol(Land)', 'Zonë e qetë për shtëpi banimi.', 42000, '/images/lands/land7.jpg', 'Mitrovicë', 'Shipol', 0, 0, 800, 0, 'Land', 'For Sale', 2),
('Truall Industrial(Land)', 'Hapsirë e madhe për depo ose fabrikë.', 135000, '/images/lands/land10.jpg', 'Mitrovicë', 'Zona Industriale', 0, 0, 5000, 1, 'Land', 'For Sale', 2),
('Tokë në Tavnik(Land)', 'Afër qendrës, i urbanizuar.', 78000, '/images/lands/land8.jpg', 'Mitrovicë', 'Tavnik', 0, 0, 600, 1, 'Land', 'For Sale', 2),
('Truall në Zhabar(Land)', 'Tashmë me qasje në ujë dhe rrymë.', 35000, '/images/lands/land3.jpg', 'Mitrovicë', 'Zhabar', 0, 0, 1200, 0, 'Land', 'For Sale', 2),
('Tokë Bujqësore Kçiq(Land)', 'Tokë pjellore buzë lumit.', 25000, '/images/lands/land10.jpg', 'Mitrovicë', 'Kçiq', 0, 0, 4000, 0, 'Land', 'For Sale', 2),
('Truall në Bair(Land)', 'Pamje e hapur mbi qytet.', 65000, '/images/lands/land.9jpg', 'Mitrovicë', 'Bair', 0, 0, 1000, 1, 'Land', 'For Sale', 2),
('Parcelë në Frashër(Land)', 'Afër autostradës së re.', 48000, '/images/lands/land6.jpg', 'Mitrovicë', 'Frashër', 0, 0, 2500, 0, 'Land', 'For Sale', 2),
('Tokë afër Liqenit(Land)', 'Ideale për vilë ose rekreacion.', 90000, '/images/lands/land2.jpg', 'Mitrovicë', 'Liqeni Akumulues', 0, 0, 1500, 1, 'Land', 'For Sale', 2),
('Truall në Tunelin e Parë(Land)', 'Zonë malore, ajër i pastër.', 22000, '/images/lands/land1.jpg', 'Mitrovicë', 'Tuneli i Parë', 0, 0, 3000, 0, 'Land', 'For Sale', 2);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Mitrovicë', 'Shupkovc', 161), ('Mitrovicë', 'Shipol', 162), ('Mitrovicë', 'Zona Industriale', 163), ('Mitrovicë', 'Tavnik', 164), ('Mitrovicë', 'Zhabar', 165),
('Mitrovicë', 'Kçiq', 166), ('Mitrovicë', 'Bair', 167), ('Mitrovicë', 'Frashër', 168), ('Mitrovicë', 'Liqeni Akumulues', 169), ('Mitrovicë', 'Tuneli i Parë', 170);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(161,2),(161,4),
(162,2),(162,4),
(163,2),(163,4),
(164,2),(164,4),
(165,2),(165,4),(165,8),
(166,2),(166,4),
(167,2),(167,4),
(168,2),(168,4),(168,7),(168,9),
(169,2),(169,4),
(170,2),(170,4);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Truall në Shkugëz(Land)', 'Zonë turistike, afër pishave.', 120000, '/images/lands/land2.jpg', 'Gjakovë', 'Shkugëz', 0, 0, 1500, 1, 'Land', 'For Sale', 2),
('Tokë në Meje(Land)', 'Tokë e rrafshët për shtëpi.', 38000, '/images/lands/land5.jpg', 'Gjakovë', 'Meje', 0, 0, 1000, 0, 'Land', 'For Sale', 2),
('Truall në Bllokun e Ri(Land)', 'Zonë e urbanizuar, infrastrukturë e plotë.', 85000, '/images/lands/land7.jpg', 'Gjakovë', 'Blloku i Ri', 0, 0, 500, 1, 'Land', 'For Sale', 2),
('Tokë në Brekoc(Land)', 'Ideale për biznese të vogla.', 45000, '/images/lands/land9.jpg', 'Gjakovë', 'Brekoc', 0, 0, 2000, 0, 'Land', 'For Sale', 2),
('Truall afër Çarshisë(Land)', 'Truall i rrallë në zonën historike.', 150000, '/images/lands/land4.jpg', 'Gjakovë', 'Çarshia e Vjetër', 0, 0, 300, 1, 'Land', 'For Sale', 2),
('Tokë në Skivjan(Land)', 'Tokë bujqësore pjellore.', 28000, '/images/lands/land10.jpg', 'Gjakovë', 'Skivjan', 0, 0, 5000, 0, 'Land', 'For Sale', 2),
('Truall në Moglicë(Land)', 'Qasje e lehtë në rrugën kryesore.', 52000, '/images/lands/land3.jpg', 'Gjakovë', 'Moglicë', 0, 0, 1200, 0, 'Land', 'For Sale', 2),
('Tokë në Ponoshec(Land)', 'Sipërfaqe e madhe buzë rrugës.', 60000, '/images/lands/land1.jpg', 'Gjakovë', 'Ponoshec', 0, 0, 8000, 1, 'Land', 'For Sale', 2),
('Truall në Korenicë(Land)', 'Zonë e qetë dhe e gjelbëruar.', 32000, '/images/lands/land6.jpg', 'Gjakovë', 'Korenicë', 0, 0, 2500, 0, 'Land', 'For Sale', 2),
('Parcelë në Orize(Land)', 'Investim i mirë për ndërtim.', 40000, '/images/lands/land8.jpg', 'Gjakovë', 'Orize', 0, 0, 1500, 0, 'Land', 'For Sale', 2);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjakovë', 'Shkugëz', 171), ('Gjakovë', 'Meje', 172), ('Gjakovë', 'Blloku i Ri', 173), ('Gjakovë', 'Brekoc', 174), ('Gjakovë', 'Çarshia e Vjetër', 175),
('Gjakovë', 'Skivjan', 176), ('Gjakovë', 'Moglicë', 177), ('Gjakovë', 'Ponoshec', 178), ('Gjakovë', 'Korenicë', 179), ('Gjakovë', 'Orize', 180);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(171,2),(171,4),
(172,2),(172,4),
(173,2),(173,4),
(174,2),(174,4),
(175,2),(175,4),
(176,2),(176,4),(176,6),
(177,2),(177,4),
(178,2),(178,4),
(179,2),(179,4),
(180,2),(180,4),(180,5),(180,7),(180,8),(180,10);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Truall Industrial FK(Land)', 'Afër zonës industriale, qasje në rrugë.', 145000, '/images/lands/land3.jpg', 'Fushë Kosovë', 'Zona Industriale', 0, 0, 3000, 1, 'Land', 'For Sale', 2),
('Tokë në Dardani(Land)', 'Zonë e banueshme, infrastrukturë e plotë.', 65000, '/images/lands/land8.jpg', 'Fushë Kosovë', 'Dardania', 0, 0, 600, 1, 'Land', 'For Sale', 2),
('Truall afër Magjistrales(Land)', 'Ideale për showroom ose biznes.', 220000, '/images/lands/land4.jpg', 'Fushë Kosovë', 'Magjistralja', 0, 0, 5000, 1, 'Land', 'For Sale', 2),
('Tokë në Miradi(Land)', 'Tokë e rrafshët, afër autostradës.', 55000, '/images/lands/land7.jpg', 'Fushë Kosovë', 'Miradi', 0, 0, 2000, 0, 'Land', 'For Sale', 2),
('Truall për Shtëpi(Land)', 'Lagje e qetë, qasje e lehtë në qytet.', 42000, '/images/lands/land10.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 0, 0, 800, 0, 'Land', 'For Sale', 2),
('Tokë në Uglar(Land)', 'E përshtatshme për ndërtim të ulët.', 38000, '/images/lands/land1.jpg', 'Fushë Kosovë', 'Uglar', 0, 0, 1200, 0, 'Land', 'For Sale', 2),
('Truall Komercial(Land)', 'Buzë rrugës kryesore, qasje e dyanshme.', 180000, '/images/lands/land6.jpg', 'Fushë Kosovë', 'Qendra', 0, 0, 1500, 1, 'Land', 'For Sale', 2),
('Tokë në Kuzmin(Land)', 'Tokë bujqësore pjellore.', 28000, '/images/lands/land2.jpg', 'Fushë Kosovë', 'Kuzmin', 0, 0, 4500, 0, 'Land', 'For Sale', 2),
('Truall në Bresje(Land)', 'Afër shkollës dhe qendrës mjekësore.', 72000, '/images/lands/land5.jpg', 'Fushë Kosovë', 'Bresje', 0, 0, 700, 0, 'Land', 'For Sale', 2),
('Parcelë Investimi(Land)', 'Zonë me zhvillim të shpejtë.', 95000, '/images/lands/land9.jpg', 'Fushë Kosovë', 'Qendra', 0, 0, 2500, 1, 'Land', 'For Sale', 2);



-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Fushë Kosovë', 'Zona Industriale', 181), ('Fushë Kosovë', 'Dardania', 182), ('Fushë Kosovë', 'Magjistralja', 183), ('Fushë Kosovë', 'Miradi', 184), ('Fushë Kosovë', 'Rruga e Pejës', 185),
('Fushë Kosovë', 'Uglar', 186), ('Fushë Kosovë', 'Qendra', 187), ('Fushë Kosovë', 'Kuzmin', 188), ('Fushë Kosovë', 'Bresje', 189), ('Fushë Kosovë', 'Qendra', 190);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(181,2),(181,4),(181,5),(181,6),(181,7),
(182,2),(182,4),
(183,2),(183,4),
(184,2),(184,4),
(185,2),(185,4),
(186,2),(186,4),
(187,2),(187,4),(181,10),
(188,2),(188,4),
(189,2),(189,4),
(190,2),(190,4);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Truall në Besiana(Land)', 'Lagje e re, infrastrukturë e rregulluar.', 48000, '/images/lands/land10.jpg', 'Podujevë', 'Besiana', 0, 0, 800, 1, 'Land', 'For Sale', 2),
('Tokë në Siboc(Land)', 'Tokë pjellore buzë rrugës magjistrale.', 65000, '/images/lands/land6.jpg', 'Podujevë', 'Siboc', 0, 0, 3500, 0, 'Land', 'For Sale', 2),
('Truall në Qendër(Land)', 'Truall për ndërtim shtëpie ose biznesi.', 95000, '/images/lands/land2.jpg', 'Podujevë', 'Qendra', 0, 0, 500, 1, 'Land', 'For Sale', 2),
('Tokë në Dumosh(Land)', 'E përshtatshme për fermë ose vilë.', 32000, '/images/lands/land5.jpg', 'Podujevë', 'Dumosh', 0, 0, 5000, 0, 'Land', 'For Sale', 2),
('Truall afër Parkut(Land)', 'Ajër i pastër, zonë shumë e qetë.', 55000, '/images/lands/land9.jpg', 'Podujevë', 'Besiana', 0, 0, 1000, 1, 'Land', 'For Sale', 2),
('Tokë në Gllamnik(Land)', 'Buzë rrugës Prishtinë-Podujevë.', 120000, '/images/lands/land7.jpg', 'Podujevë', 'Gllamnik', 0, 0, 4000, 1, 'Land', 'For Sale', 2),
('Truall në Letanc(Land)', 'Investim i mirë për të ardhmen.', 28000, '/images/lands/land2.jpg', 'Podujevë', 'Letanc', 0, 0, 1500, 0, 'Land', 'For Sale', 2),
('Tokë në Lupç(Land)', 'Qasje e lehtë në rrugën kryesore.', 42000, '/images/lands/land1.jpg', 'Podujevë', 'Lupç', 0, 0, 2500, 0, 'Land', 'For Sale', 2),
('Truall për Biznes(Land)', 'Afër zonës industriale të qytetit.', 85000, '/images/lands/land8.jpg', 'Podujevë', 'Zona Industriale', 0, 0, 2000, 1, 'Land', 'For Sale', 2),
('Parcelë në Përpellac(Land)', 'Tokë mali, e përshtatshme për vila.', 20000, '/images/lands/land3.jpg', 'Podujevë', 'Përpellac', 0, 0, 6000, 0, 'Land', 'For Sale', 2);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Podujevë', 'Besiana', 191), ('Podujevë', 'Siboc', 192), ('Podujevë', 'Qendra', 193), ('Podujevë', 'Dumosh', 194), ('Podujevë', 'Besiana', 195),
('Podujevë', 'Gllamnik', 196), ('Podujevë', 'Letanc', 197), ('Podujevë', 'Lupç', 198), ('Podujevë', 'Zona Industriale', 199), ('Podujevë', 'Përpellac', 200);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(191,2),(191,4),(191,8),
(192,2),(192,4),
(193,2),(193,4),
(194,2),(194,4),
(195,2),(195,4),
(196,2),(196,4),
(197,2),(197,4),(197,7),(197,9),
(198,2),(198,4),
(199,2),(199,4),
(200,2),(200,4);




--HOTEL

INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Hotel Drenasi', 'Hotel modern në qendër të qytetit.', 450000, '/images/hotels/hotel1.jpg', 'Drenas', 'Qendra', 15, 15, 800, 1, 'Hotel', 'For Sale', 3),
('Business Hotel Komoran', 'Ideale për udhëtarët e biznesit afër autostradës.', 380000, '/images/hotels/hotel2.jpg', 'Drenas', 'Komoran', 12, 12, 650, 0, 'Hotel', 'For Sale', 3),
('Hotel Garden', 'Hapsirë e qetë me kopsht të madh.', 250000, '/images/hotels/hotel3.jpg', 'Drenas', 'Zabel', 10, 10, 500, 0, 'Hotel', 'For Sale', 3),
('Hotel Industrial', 'Hotel afër zonës industriale.', 320000, '/images/hotels/hotel4.jpg', 'Drenas', 'Zona Industriale', 14, 14, 700, 1, 'Hotel', 'For Sale', 3),
('Park Hotel Drenas', 'Pamje nga parku i qytetit.', 290000, '/images/hotels/hotel5.jpg', 'Drenas', 'Qendra', 11, 11, 600, 0, 'Hotel', 'For Sale', 3),
('Hotel Ferronikeli', 'Hotel me restorant dhe sallë dasmash.', 550000, '/images/hotels/hotel6.jpg', 'Drenas', 'Çikatovë', 20, 20, 1200, 1, 'Hotel', 'For Sale', 3),
('Classic Hotel', 'Stil klasik dhe komoditet i lartë.', 270000, '/images/hotels/hotel7.jpg', 'Drenas', 'Qendra', 9, 9, 550, 0, 'Hotel', 'For Sale', 3),
('Transit Hotel', 'Pikë ndalimi perfekte për udhëtarët.', 220000, '/images/hotels/hotel8.jpg', 'Drenas', 'Komoran', 8, 8, 450, 0, 'Hotel', 'For Sale', 3),
('Grand Drenas Hotel', 'Hotel luksoz me suitë presidenciale.', 600000, '/images/hotels/hotel9.jpg', 'Drenas', 'Qendra', 18, 18, 1000, 1, 'Hotel', 'For Sale', 3),
('Eco Hotel', 'Hotel miqësor me ambientin.', 310000, '/images/hotels/hotel10.jpg', 'Drenas', 'Gllogoc', 13, 13, 680, 0, 'Hotel', 'For Sale', 3);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Drenas', 'Qendra', 201), ('Drenas', 'Komoran', 202), ('Drenas', 'Zabel', 203), ('Drenas', 'Zona Industriale', 204), ('Drenas', 'Qendra', 205),
('Drenas', 'Çikatovë', 206), ('Drenas', 'Qendra', 207), ('Drenas', 'Komoran', 208), ('Drenas', 'Qendra', 209), ('Drenas', 'Gllogoc', 210);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(201,1),(201,2),
(202,1),(202,2),
(203,1),(203,2),
(204,1),(204,2),
(205,1),(205,2),
(206,1),(206,2),
(207,1),(207,2),
(208,1),(208,2),
(209,1),(209,2),
(210,1),(210,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Prishtina Grand Hotel', 'Hotel ikonik në qendër të kryeqytetit.', 2500000, '/images/hotels/hotel9.jpg', 'Prishtinë', 'Sheshi Nënë Tereza', 50, 50, 5000, 1, 'Hotel', 'For Sale', 3),
('Swiss Diamond Style Hotel', 'Luks dhe elegancë në çdo detaj.', 3200000, '/images/hotels/hotel6.jpg', 'Prishtinë', 'Qendra', 45, 45, 4500, 1, 'Hotel', 'For Sale', 3),
('Veternik Boutique Hotel', 'Hotel i vogël por shumë luksoz.', 850000, '/images/hotels/hotel1.jpg', 'Prishtinë', 'Veternik', 15, 15, 1200, 1, 'Hotel', 'For Sale', 3),
('City Inn Prishtina Hotel', 'Hotel modern për qëndrime afatshkurtra.', 720000, '/images/hotels/hotel3.jpg', 'Prishtinë', 'Qendra', 20, 20, 1500, 0, 'Hotel', 'For Sale', 3),
('Hotel Germia Park', 'Afër natyrës dhe ajrit të pastër.', 980000, '/images/hotels/hotel10.jpg', 'Prishtinë', 'Gërmia', 25, 25, 2000, 1, 'Hotel', 'For Sale', 3),
('Airport Transit Hotel', 'Hotel afër aeroportit ndërkombëtar.', 650000, '/images/hotels/hotel5.jpg', 'Prishtinë', 'Magjistralja', 18, 18, 1300, 0, 'Hotel', 'For Sale', 3),
('Blloku Boutique Hotel', 'Në zonën më të gjallë të qytetit.', 790000, '/images/hotels/hotel2.jpg', 'Prishtinë', 'Pejton', 12, 12, 900, 1, 'Hotel', 'For Sale', 3),
('Skyline Hotel', 'Pamje panoramike e gjithë Prishtinës.', 1500000, '/images/hotels/hotel4.jpg', 'Prishtinë', 'Arbëria', 30, 30, 2800, 1, 'Hotel', 'For Sale', 3),
('Heritage Hotel', 'Hotel me stil tradicional dhe modern.', 680000, '/images/hotels/hotel7.jpg', 'Prishtinë', 'Qendra', 16, 16, 1100, 0, 'Hotel', 'For Sale', 3),
('Diplomat Hotel', 'I preferuar nga diplomatët dhe zyrtarët.', 1200000, '/images/hotels/hotel8.jpg', 'Prishtinë', 'Dragodan', 22, 22, 2200, 1, 'Hotel', 'For Sale', 3);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prishtinë', 'Sheshi Nënë Tereza', 211), ('Prishtinë', 'Qendra', 212), ('Prishtinë', 'Veternik', 213), ('Prishtinë', 'Qendra', 214), ('Prishtinë', 'Gërmia', 215),
('Prishtinë', 'Magjistralja', 216), ('Prishtinë', 'Pejton', 217), ('Prishtinë', 'Arbëria', 218), ('Prishtinë', 'Qendra', 219), ('Prishtinë', 'Dragodan', 220);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(211,1),(211,2),
(212,1),(212,2),
(213,1),(213,2),
(214,1),(214,2),
(215,1),(215,2),
(216,1),(216,2),
(217,1),(217,2),
(218,1),(218,2),
(219,1),(219,2),
(220,1),(220,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Hotel Theranda', 'Hotel historik në qendër të Prizrenit.', 1200000, '/images/hotels/hotel4.jpg', 'Prizren', 'Qendra', 35, 35, 3000, 1, 'Hotel', 'For Sale', 3),
('Old Bazaar Hotel', 'Hotel me stil tradicional në Çarshinë e Vjetër.', 650000, '/images/hotels/hotel7.jpg', 'Prizren', 'Shadërvan', 12, 12, 850, 1, 'Hotel', 'For Sale', 3),
('Castle View Hotel', 'Pamje mahnitëse nga Kalaja e Prizrenit.', 850000, '/images/hotels/hotel2.jpg', 'Prizren', 'Qendra', 18, 18, 1200, 1, 'Hotel', 'For Sale', 3),
('Lumbardhi Riverside Hotel', 'Hotel buzë lumit Lumbardh.', 750000, '/images/hotels/hotel9.jpg', 'Prizren', 'Qendra', 15, 15, 1000, 0, 'Hotel', 'For Sale', 3),
('Hotel Classic Prizren', 'Elegancë dhe rehati në zemër të qytetit.', 580000, '/images/hotels/hotel10.jpg', 'Prizren', 'Ortakoll', 14, 14, 900, 0, 'Hotel', 'For Sale', 3),
('Boutique Hotel Shadërvan', 'Hotel i vogël dhe unik për turistë.', 480000, '/images/hotels/hotel8.jpg', 'Prizren', 'Shadërvan', 10, 10, 600, 1, 'Hotel', 'For Sale', 3),
('Hotel Arasta', 'Afër xhamisë së Sinan Pashës.', 520000, '/images/hotels/hotel1.jpg', 'Prizren', 'Qendra', 11, 11, 750, 0, 'Hotel', 'For Sale', 3),
('Grand Hotel Prizren', 'Hotel i madh me sallë konferencash.', 1500000, '/images/hotels/hotel5.jpg', 'Prizren', 'Qendra', 40, 40, 4000, 1, 'Hotel', 'For Sale', 3),
('Prevalla Mountain Hotel', 'Hotel malor në zonën e Prevallës.', 950000, '/images/hotels/hotel3.jpg', 'Prizren', 'Prevallë', 25, 25, 2500, 1, 'Hotel', 'For Sale', 3),
('City Gate Hotel', 'Hotel modern në hyrje të qytetit.', 620000, '/images/hotels/hotel2.jpg', 'Prizren', 'Magjistralja', 16, 16, 1100, 0, 'Hotel', 'For Sale', 3);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prizren', 'Qendra', 221), ('Prizren', 'Shadërvan', 222), ('Prizren', 'Qendra', 223), ('Prizren', 'Qendra', 224), ('Prizren', 'Ortakoll', 225),
('Prizren', 'Shadërvan', 226), ('Prizren', 'Qendra', 227), ('Prizren', 'Qendra', 228), ('Prizren', 'Prevallë', 229), ('Prizren', 'Magjistralja', 230);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(221,1),(221,2),
(222,1),(222,2),
(223,1),(223,2),
(224,1),(224,2),
(225,1),(225,2),
(226,1),(226,2),
(227,1),(227,2),
(228,1),(228,2),
(229,1),(229,2),
(230,1),(230,2);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Hotel Dukagjini', 'Hotel luksoz me pesë yje në qendër.', 3500000, '/images/hotels/hotel7.jpg', 'Pejë', 'Qendra', 60, 60, 6000, 1, 'Hotel', 'For Sale', 3),
('Rugova Valley Hotel', 'Hotel në mes të grykës së Rugovës.', 1100000, '/images/hotels/hotel5.jpg', 'Pejë', 'Rugovë', 22, 22, 2800, 1, 'Hotel', 'For Sale', 3),
('Hotel Korza', 'Në shëtitoren kryesore të Pejës.', 850000, '/images/hotels/hotel1.jpg', 'Pejë', 'Qendra', 18, 18, 1400, 1, 'Hotel', 'For Sale', 3),
('Semira Boutique Hotel', 'Hotel modern me dizajn unik.', 680000, '/images/hotels/hotel9.jpg', 'Pejë', 'Qendra', 14, 14, 950, 0, 'Hotel', 'For Sale', 3),
('Hotel Karagaç', 'Afër parkut dhe qendrës sportive.', 720000, '/images/hotels/hotel6.jpg', 'Pejë', 'Karagaç', 15, 15, 1100, 0, 'Hotel', 'For Sale', 3),
('Panorama Rugova Hotel', 'Pamje spektakolare nga Alpet Shqiptare.', 980000, '/images/hotels/hotel2.jpg', 'Pejë', 'Rugovë', 20, 20, 2200, 1, 'Hotel', 'For Sale', 3),
('City Center Inn Hotel', 'Hotel praktik për vizitorët e qytetit.', 550000, '/images/hotels/hotel10.jpg', 'Pejë', 'Qendra', 12, 12, 800, 0, 'Hotel', 'For Sale', 3),
('Hotel Camp Karagaç', 'Hotel me hapsira rekreative.', 890000, '/images/hotels/hotel3.jpg', 'Pejë', 'Karagaç', 19, 19, 1600, 1, 'Hotel', 'For Sale', 3),
('Sky Hotel Peja', 'Hotel modern në katet e larta.', 790000, '/images/hotels/hotel8.jpg', 'Pejë', 'Qendra', 16, 16, 1200, 0, 'Hotel', 'For Sale', 3),
('Boutique Hotel Peja', 'Atmosferë e ngrohtë dhe shërbim cilësor.', 620000, '/images/hotels/hotel4.jpg', 'Pejë', 'Qendra', 13, 13, 850, 0, 'Hotel', 'For Sale', 3);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Pejë', 'Qendra', 231), ('Pejë', 'Rugovë', 232), ('Pejë', 'Qendra', 233), ('Pejë', 'Qendra', 234), ('Pejë', 'Karagaç', 235),
('Pejë', 'Rugovë', 236), ('Pejë', 'Qendra', 237), ('Pejë', 'Karagaç', 238), ('Pejë', 'Qendra', 239), ('Pejë', 'Qendra', 240);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(231,1),(231,2),
(232,1),(232,2),
(233,1),(233,2),
(234,1),(234,2),
(235,1),(235,2),
(236,1),(236,2),
(237,1),(237,2),
(238,1),(238,2),
(239,1),(239,2),
(240,1),(240,2);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Hotel Lybeteni', 'Hotel me traditë në zemër të Ferizajt.', 950000, '/images/hotels/hotel2.jpg', 'Ferizaj', 'Qendra', 25, 25, 2200, 1, 'Hotel', 'For Sale', 3),
('Business Hotel Bibaj', 'Hotel modern afër zonës industriale.', 780000, '/images/hotels/hotel4.jpg', 'Ferizaj', 'Bibaj', 20, 20, 1800, 1, 'Hotel', 'For Sale', 3),
('Hotel City Ferizaj', 'Hotel praktik për vizitorë dhe biznes.', 550000, '/images/hotels/hotel8.jpg', 'Ferizaj', 'Qendra', 15, 15, 1100, 0, 'Hotel', 'For Sale', 3),
('Hotel Euro Park', 'Hapsirë e madhe me parkim dhe restorant.', 420000, '/images/hotels/hotel6.jpg', 'Ferizaj', 'Prelez', 12, 12, 1500, 0, 'Hotel', 'For Sale', 3),
('Hotel Luxury Ferizaj', 'Hotel luksoz me dizajn modern.', 880000, '/images/hotels/fe5.jpg', 'Ferizaj', 'Qendra', 18, 18, 1400, 1, 'Hotel', 'For Sale', 3),
('Grand Hotel Ferizaj', 'Hotel i madh për konferenca dhe evente.', 1300000, '/images/hotels/hotel9.jpg', 'Ferizaj', 'Qendra', 35, 35, 3500, 1, 'Hotel', 'For Sale', 3),
('Hotel Talinoc', 'Hotel i qetë në periferi të qytetit.', 480000, '/images/hotels/hotel10.jpg', 'Ferizaj', 'Talinoc', 14, 14, 950, 0, 'Hotel', 'For Sale', 3),
('Hotel Central', 'Qasje e lehtë në të gjitha pikat e qytetit.', 620000, '/images/hotels/hotel7.jpg', 'Ferizaj', 'Qendra', 16, 16, 1200, 0, 'Hotel', 'For Sale', 3),
('Hotel Panorama Jezerc', 'Hotel malor me pamje përrallore.', 1100000, '/images/hotels/hotel1.jpg', 'Ferizaj', 'Jezerc', 22, 22, 2800, 1, 'Hotel', 'For Sale', 3),
('Boutique Hotel Ferizaj', 'Atmosferë unike dhe shërbim ekskluziv.', 750000, '/images/hotels/hotel3.jpg', 'Ferizaj', 'Qendra', 13, 13, 1000, 1, 'Hotel', 'For Sale', 3);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Ferizaj', 'Qendra', 241), ('Ferizaj', 'Bibaj', 242), ('Ferizaj', 'Qendra', 243), ('Ferizaj', 'Prelez', 244), ('Ferizaj', 'Qendra', 245),
('Ferizaj', 'Qendra', 246), ('Ferizaj', 'Talinoc', 247), ('Ferizaj', 'Qendra', 248), ('Ferizaj', 'Jezerc', 249), ('Ferizaj', 'Qendra', 250);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(241,1),(241,2),
(242,1),(242,2),
(243,1),(243,2),
(244,1),(244,2),
(245,1),(245,2),
(246,1),(246,2),
(247,1),(247,2),
(248,1),(248,2),
(249,1),(249,2),
(250,1),(250,2);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Hotel Crystal Gjilan', 'Hotel luksoz me shërbime të plota.', 1150000, '/images/hotels/hotel9.jpg', 'Gjilan', 'Qendra', 28, 28, 2500, 1, 'Hotel', 'For Sale', 3),
('Astoria Hotel', 'Stil modern në zemër të Anamoravës.', 820000, '/images/hotels/hotel5.jpg', 'Gjilan', 'Qendra', 20, 20, 1800, 1, 'Hotel', 'For Sale', 3),
('Hotel Vali Ranch', 'Resort i njohur me aktivitete rekreative.', 2800000, '/images/hotels/hotel6.jpg', 'Gjilan', 'Përlepnicë', 45, 45, 5500, 1, 'Hotel', 'For Sale', 3),
('City Hotel Gjilan', 'Hotel komod për vizitorë biznesi.', 650000, '/images/hotels/hotel10.jpg', 'Gjilan', 'Qendra', 16, 16, 1200, 0, 'Hotel', 'For Sale', 3),
('Hotel Fontana', 'Hotel me traditë dhe restorant cilësor.', 580000, '/images/hotels/hotel4.jpg', 'Gjilan', 'Qendra', 14, 14, 1000, 0, 'Hotel', 'For Sale', 3),
('Hotel Relax Livoç', 'Hapsirë e qetë afër liqenit.', 490000, '/images/hotels/hotel3.jpg', 'Gjilan', 'Livoç', 12, 12, 950, 0, 'Hotel', 'For Sale', 3),
('Grand Hotel Gjilan', 'Hotel i madh me salla për ahengje.', 1500000, '/images/hotels/hotel8.jpg', 'Gjilan', 'Qendra', 40, 40, 4200, 1, 'Hotel', 'For Sale', 3),
('Boutique Hotel Gjilan', 'Hotel me dizajn unik dhe komoditet.', 720000, '/images/hotels/hotel1.jpg', 'Gjilan', 'Qendra', 15, 15, 1100, 1, 'Hotel', 'For Sale', 3),
('Hotel Dardania', 'I vendosur në njërën nga lagjet më të mira.', 600000, '/images/hotels/hotel7.jpg', 'Gjilan', 'Dardania', 14, 14, 1050, 0, 'Hotel', 'For Sale', 3),
('Hotel Panorama Gjilan', 'Pamje e bukur mbi gjithë qytetin.', 850000, '/images/hotels/hotel2.jpg', 'Gjilan', 'Rruga Qarkore', 18, 18, 1600, 1, 'Hotel', 'For Sale', 3);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjilan', 'Qendra', 251), ('Gjilan', 'Qendra', 252), ('Gjilan', 'Përlepnicë', 253), ('Gjilan', 'Qendra', 254), ('Gjilan', 'Qendra', 255),
('Gjilan', 'Livoç', 256), ('Gjilan', 'Qendra', 257), ('Gjilan', 'Qendra', 258), ('Gjilan', 'Dardania', 259), ('Gjilan', 'Rruga Qarkore', 260);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(251,1),(251,2),
(252,1),(252,2),
(253,1),(253,2),
(254,1),(254,2),
(255,1),(255,2),
(256,1),(256,2),
(257,1),(257,2),
(258,1),(258,2),
(259,1),(259,2),
(260,1),(260,2);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Hotel Palace Mitrovica', 'Hotel luksoz me pamje nga lumi Ibër.', 950000, '/images/hotels/hotel7.jpg', 'Mitrovicë', 'Qendra', 20, 20, 1800, 1, 'Hotel', 'For Sale', 3),
('Ibar Riverside Hotel', 'Hotel modern buzë lumit Ibër.', 720000, '/images/hotels/hotel3.jpg', 'Mitrovicë', 'Qendra', 15, 15, 1300, 1, 'Hotel', 'For Sale', 3),
('Hotel North Side', 'Hotel komod afër urës kryesore.', 580000, '/images/hotels/hotel4.jpg', 'Mitrovicë', 'Qendra', 12, 12, 950, 0, 'Hotel', 'For Sale', 3),
('Bair Hill Hotel', 'Hotel me pamje panoramike të qytetit.', 780000, '/images/hotels/hotel8.jpg', 'Mitrovicë', 'Bair', 18, 18, 1500, 1, 'Hotel', 'For Sale', 3),
('Hotel Industrial Mitrovica', 'Hotel i përshtatshëm për vizitorë biznesi.', 1100000, '/images/hotels/hotel6jpg', 'Mitrovicë', 'Zona Industriale', 25, 25, 2200, 1, 'Hotel', 'For Sale', 3),
('Tavnik City Hotel', 'Hotel modern në lagjen Tavnik.', 620000, '/images/hotels/hotel10.jpg', 'Mitrovicë', 'Tavnik', 14, 14, 1100, 0, 'Hotel', 'For Sale', 3),
('Hotel Lux Mitrovica', 'Hotel luksoz me shërbime të plota.', 1050000, '/images/hotels/hotel9.jpg', 'Mitrovicë', 'Qendra', 22, 22, 1900, 1, 'Hotel', 'For Sale', 3),
('Bridge Hotel', 'Hotel i vogël dhe i ngrohtë afër urës.', 450000, '/images/hotels/hotel2.jpg', 'Mitrovicë', 'Qendra', 10, 10, 800, 0, 'Hotel', 'For Sale', 3),
('Hotel Panorama Mitrovica', 'Hotel me tarracë dhe pamje të bukur.', 690000, '/images/hotels/hotel5.jpg', 'Mitrovicë', 'Bair', 16, 16, 1250, 0, 'Hotel', 'For Sale', 3),
('Grand Hotel Mitrovica', 'Hotel i madh për evente dhe konferenca.', 1450000, '/images/hotels/hotel1.jpg', 'Mitrovicë', 'Qendra', 30, 30, 3200, 1, 'Hotel', 'For Sale', 3);



-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Mitrovicë', 'Qendra', 261), ('Mitrovicë', 'Qendra', 262), ('Mitrovicë', 'Qendra', 263), ('Mitrovicë', 'Bair', 264), ('Mitrovicë', 'Zona Industriale', 265),
('Mitrovicë', 'Tavnik', 266), ('Mitrovicë', 'Qendra', 267), ('Mitrovicë', 'Qendra', 268), ('Mitrovicë', 'Bair', 269), ('Mitrovicë', 'Qendra', 270);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(261,1),(261,2),
(262,1),(262,2),
(263,1),(263,2),
(264,1),(264,2),
(265,1),(265,2),
(266,1),(266,2),
(267,1),(267,2),
(268,1),(268,2),
(269,1),(269,2),
(270,1),(270,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Hotel Çarshia e Jupave', 'Hotel unik me stil tradicional në Çarshi.', 1250000, '/images/hotels/hotel5.jpg', 'Gjakovë', 'Çarshia e Vjetër', 20, 20, 1800, 1, 'Hotel', 'For Sale', 3),
('Hotel Pashtriku', 'Hotel historik në qendër të qytetit.', 1800000, '/images/hotels/hotel9.jpg', 'Gjakovë', 'Qendra', 40, 40, 3500, 1, 'Hotel', 'For Sale', 3),
('Hotel Amant', 'Hotel modern me dizajn bashkëkohor.', 780000, '/images/hotels/hotel1.jpg', 'Gjakovë', 'Qendra', 15, 15, 1200, 1, 'Hotel', 'For Sale', 3),
('Krena River Hotel', 'Hotel i qetë buzë lumit Krena.', 620000, '/images/hotels/hotel6.jpg', 'Gjakovë', 'Qendra', 12, 12, 950, 0, 'Hotel', 'For Sale', 3),
('Hotel La Villa', 'Hotel resort në zonën turistike të Shkugëzës.', 980000, '/images/hotels/hotel4.jpg', 'Gjakovë', 'Shkugëz', 18, 18, 2200, 1, 'Hotel', 'For Sale', 3),
('Blloku Boutique Hotel', 'Hotel i vogël dhe elegant në Bllokun e Ri.', 720000, '/images/hotels/hotel10.jpg', 'Gjakovë', 'Blloku i Ri', 14, 14, 1100, 1, 'Hotel', 'For Sale', 3),
('Hotel Gjakova', 'Hotel modern me shërbim cilësor.', 1150000, '/images/hotels/hotel8.jpg', 'Gjakovë', 'Qendra', 25, 25, 2400, 1, 'Hotel', 'For Sale', 3),
('Old Town Inn Hotel', 'Bujtinë tradicionale në zemër të historisë.', 520000, '/images/hotels/hotel3.jpg', 'Gjakovë', 'Çarshia e Vjetër', 10, 10, 850, 0, 'Hotel', 'For Sale', 3),
('Hotel Park Gjakova', 'Hotel afër parkut kryesor të qytetit.', 750000, '/images/hotels/hotel7.jpg', 'Gjakovë', 'Qendra', 16, 16, 1300, 0, 'Hotel', 'For Sale', 3),
('Grand Hotel Gjakova', 'Hotel luksoz për evente dhe qëndrime elitare.', 1550000, '/images/hotels/hotel2.jpg', 'Gjakovë', 'Blloku i Ri', 35, 35, 3800, 1, 'Hotel', 'For Sale', 3);



-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjakovë', 'Çarshia e Vjetër', 271), ('Gjakovë', 'Qendra', 272), ('Gjakovë', 'Qendra', 273), ('Gjakovë', 'Qendra', 274), ('Gjakovë', 'Shkugëz', 275),
('Gjakovë', 'Blloku i Ri', 276), ('Gjakovë', 'Qendra', 277), ('Gjakovë', 'Çarshia e Vjetër', 278), ('Gjakovë', 'Qendra', 279), ('Gjakovë', 'Blloku i Ri', 280);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(271,1),(271,2),
(272,1),(272,2),
(273,1),(273,2),
(274,1),(274,2),
(275,1),(275,2),
(276,1),(276,2),
(277,1),(277,2),
(278,1),(278,2),
(279,1),(279,2),
(280,1),(280,2);




INSERT INTO Properties
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Hotel Fushë Kosova', 'Hotel modern në zonën më të frekuentuar.', 850000, '/images/hotels/hotel3.jpg', 'Fushë Kosovë', 'Qendra', 20, 20, 1800, 1, 'Hotel', 'For Sale', 3),
('Business Transit Hotel', 'Ideale për udhëtarë dhe biznesmenë.', 720000, '/images/hotels/hotel9.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 18, 18, 1500, 1, 'Hotel', 'For Sale', 3),
('Hotel Dardania FK', 'Hotel komod në lagjen Dardania.', 580000, '/images/hotels/hotel4.jpg', 'Fushë Kosovë', 'Dardania', 15, 15, 1200, 0, 'Hotel', 'For Sale', 3),
('Industrial Park Hotel', 'Hotel afër zonës industriale të qytetit.', 1100000, '/images/hotels/hotel48jpg', 'Fushë Kosovë', 'Zona Industriale', 25, 25, 2200, 1, 'Hotel', 'For Sale', 3),
('Hotel City FK', 'Hotel modern me shërbim cilësor.', 650000, '/images/hotels/hotel10.jpg', 'Fushë Kosovë', 'Qendra', 16, 16, 1300, 0, 'Hotel', 'For Sale', 3),
('Boutique Hotel FK', 'Atmosferë unike dhe dizajn bashkëkohor.', 480000, '/images/hotels/hotel5.jpg', 'Fushë Kosovë', 'Dardania', 12, 12, 950, 1, 'Hotel', 'For Sale', 3),
('Grand Hotel FK', 'Hotel i madh me salla për konferenca.', 1350000, '/images/hotels/hotel2.jpg', 'Fushë Kosovë', 'Qendra', 30, 30, 3000, 1, 'Hotel', 'For Sale', 3),
('Hotel Bresje', 'Hotel i qetë në lagjen Bresje.', 520000, '/images/hotels/hotel7.jpg', 'Fushë Kosovë', 'Bresje', 14, 14, 1100, 0, 'Hotel', 'For Sale', 3),
('Skyline Hotel FK', 'Pamje e bukur nga katet e larta.', 790000, '/images/hotels/hotel1.jpg', 'Fushë Kosovë', 'Qendra', 18, 18, 1450, 1, 'Hotel', 'For Sale', 3),
('Hotel Express FK', 'Shërbim i shpejtë dhe komoditet maksimal.', 420000, '/images/hotels/hotel6.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 10, 10, 850, 0, 'Hotel', 'For Sale', 3);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Fushë Kosovë', 'Qendra', 281), ('Fushë Kosovë', 'Rruga e Pejës', 282), ('Fushë Kosovë', 'Dardania', 283), ('Fushë Kosovë', 'Zona Industriale', 284), ('Fushë Kosovë', 'Qendra', 285),
('Fushë Kosovë', 'Dardania', 286), ('Fushë Kosovë', 'Qendra', 287), ('Fushë Kosovë', 'Bresje', 288), ('Fushë Kosovë', 'Qendra', 289), ('Fushë Kosovë', 'Rruga e Pejës', 290);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(281,1),(281,2),
(282,1),(282,2),
(283,1),(283,2),
(284,1),(284,2),
(285,1),(285,2),
(286,1),(286,2),
(287,1),(287,2),
(288,1),(288,2),
(289,1),(289,2),
(290,1),(290,2);





INSERT INTO Properties
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Hotel Besiana', 'Hotel modern në zemër të Podujevës.', 750000, '/images/hotels/hotel5.jpg', 'Podujevë', 'Besiana', 18, 18, 1500, 1, 'Hotel', 'For Sale', 3),
('Hotel Central Podujeva', 'Hotel me traditë dhe shërbim cilësor.', 620000, '/images/hotels/hotel10.jpg', 'Podujevë', 'Qendra', 15, 15, 1200, 1, 'Hotel', 'For Sale', 3),
('Hotel Llapi', 'Hotel buzë lumit Llap.', 550000, '/images/hotels/hotel4.jpg', 'Podujevë', 'Qendra', 14, 14, 1100, 0, 'Hotel', 'For Sale', 3),
('Besiana Heights Hotel', 'Hotel me pamje panoramike të qytetit.', 890000, '/images/hotels/hotel1.jpg', 'Podujevë', 'Besiana', 22, 22, 2000, 1, 'Hotel', 'For Sale', 3),
('Hotel Park Podujeva', 'Afër parkut të qytetit, zonë e qetë.', 480000, '/images/hotels/hotel9.jpg', 'Podujevë', 'Besiana', 12, 12, 950, 0, 'Hotel', 'For Sale', 3),
('Hotel Grand Besiana', 'Hotel i madh për ahengje dhe konferenca.', 1250000, '/images/hotels/hotel2.jpg', 'Podujevë', 'Besiana', 30, 30, 3200, 1, 'Hotel', 'For Sale', 3),
('Boutique Hotel Podujeva', 'Dizajn unik dhe komoditet i lartë.', 680000, '/images/hotels/hotel8.jpg', 'Podujevë', 'Qendra', 16, 16, 1300, 1, 'Hotel', 'For Sale', 3),
('Hotel Transit Podujeva', 'Hotel afër rrugës kryesore Prishtinë-Podujevë.', 520000, '/images/hotels/hotel6.jpg', 'Podujevë', 'Besiana', 13, 13, 1000, 0, 'Hotel', 'For Sale', 3),
('Sky Hotel Podujeva', 'Hotel modern me tarracë të hapur.', 720000, '/images/hotels/hotel1.jpg', 'Podujevë', 'Qendra', 17, 17, 1400, 1, 'Hotel', 'For Sale', 3),
('Hotel Elite Podujeva', 'Hotel luksoz me shërbime elitare.', 980000, '/images/hotels/hotel7.jpg', 'Podujevë', 'Qendra', 24, 24, 2500, 1, 'Hotel', 'For Sale', 3);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Podujevë', 'Besiana', 291), ('Podujevë', 'Qendra', 292), ('Podujevë', 'Qendra', 293), ('Podujevë', 'Besiana', 294), ('Podujevë', 'Besiana', 295),
('Podujevë', 'Besiana', 296), ('Podujevë', 'Qendra', 297), ('Podujevë', 'Besiana', 298), ('Podujevë', 'Qendra', 299), ('Podujevë', 'Qendra', 300);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(291,1),(291,2),
(292,1),(292,2),
(293,1),(293,2),
(294,1),(294,2),
(295,1),(295,2),
(296,1),(296,2),
(297,1),(297,2),
(298,1),(298,2),
(299,1),(299,2),
(300,1),(300,2);





--RESTAURANT


INSERT INTO Properties
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Restorant Tradicional Drenasi', 'Ushqime tradicionale në zemër të qytetit.', 120000, '/images/restaurants/restaurant1.jpg', 'Drenas', 'Qendra', 25, 2, 300, 1, 'Restaurant', 'For Sale', 4),
('Restorant Roma Drenas', 'Pica autentike me furrë druri.', 85000, '/images/restaurants/restaurant2.jpg', 'Drenas', 'Qendra', 15, 1, 150, 0, 'Restaurant', 'For Sale', 4),
('Restorant Panorama', 'Pamje e bukur dhe ambient i qetë.', 150000, '/images/restaurants/restaurant3.jpg', 'Drenas', 'Gllogoc', 30, 2, 450, 1, 'Restaurant', 'For Sale', 4),
('Fast Food Restorant Central', 'Lokacion ideal me shumë frekuentim.', 45000, '/images/restaurants/restaurant4.jpg', 'Drenas', 'Qendra', 10, 1, 80, 0, 'Restaurant', 'For Sale', 4),
('Restorant & Grill Komoran', 'Specialitete mishi në skarë.', 95000, '/images/restaurants/restaurant5.jpg', 'Drenas', 'Komoran', 20, 2, 250, 0, 'Restaurant', 'For Sale', 4),
('Steakhouse Restorant Drenas', 'Mishi më i mirë në rajon.', 180000, '/images/restaurants/restaurant6.jpg', 'Drenas', 'Zona Industriale', 22, 2, 350, 1, 'Restaurant', 'For Sale', 4),
('Fish House Restorant Drenas', 'Specialitete peshku të freskët.', 110000, '/images/restaurants/restaurant7.jpg', 'Drenas', 'Qendra', 18, 2, 200, 0, 'Restaurant', 'For Sale', 4),
('Restorant Fontana', 'Ambient me kopsht dhe fontanë.', 140000, '/images/restaurants/restaurant8.jpg', 'Drenas', 'Zabel', 28, 2, 400, 1, 'Restaurant', 'For Sale', 4),
('Coffee & Bistro Restorant Drenas', 'Ambient modern për kafe dhe ushqim.', 75000, '/images/restaurants/restaurant9.jpg', 'Drenas', 'Qendra', 12, 1, 120, 0, 'Restaurant', 'For Sale', 4),
('Restorant Family', 'Ideale për dreka familjare.', 130000, '/images/restaurants/restaurant10.jpg', 'Drenas', 'Qendra', 25, 2, 320, 0, 'Restaurant', 'For Sale', 4);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Drenas', 'Qendra', 301), ('Drenas', 'Qendra', 302), ('Drenas', 'Gllogoc', 303), ('Drenas', 'Qendra', 304), ('Drenas', 'Komoran', 305),
('Drenas', 'Zona Industriale', 306), ('Drenas', 'Qendra', 307), ('Drenas', 'Zabel', 308), ('Drenas', 'Qendra', 309), ('Drenas', 'Qendra', 310);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(301,1),(301,2),(301,3),(301,5),(301,6),
(302,1),(302,2),(302,3),(302,5),(302,6),
(303,1),(303,2),(303,3),(303,5),(303,6),
(304,1),(304,2),(304,3),(304,5),(304,6),
(305,1),(305,2),(305,3),(305,5),(305,6),
(306,1),(306,2),(306,3),(306,5),(306,6),
(307,1),(307,2),(307,3),(307,5),(307,6),
(308,1),(308,2),(308,3),(308,5),(308,6),
(309,1),(309,2),(309,3),(309,5),(309,6),
(310,1),(310,2),(310,3),(310,5),(310,6);




INSERT INTO Properties
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Fine Dining Prishtina Restorant', 'Restorant ekskluziv në qendër të qytetit.', 450000, '/images/restaurants/restaurant2.jpg', 'Prishtinë', 'Qendra', 35, 3, 500, 1, 'Restaurant', 'For Sale', 4),
('Pizzeria Napoli Restorant', 'Pica autentike italiane në Pejton.', 180000, '/images/restaurants/restaurant9.jpg', 'Prishtinë', 'Pejton', 20, 2, 200, 1, 'Restaurant', 'For Sale', 4),
('Sushi Bar Prishtina Restorant', 'Restoranti më i mirë i sushit në kryeqytet.', 220000, '/images/restaurants/restaurant4.jpg', 'Prishtinë', 'Arbëria', 15, 2, 150, 1, 'Restaurant', 'For Sale', 4),
('Restorant Liburnia Style', 'Ambient antik dhe ushqim tradicional.', 350000, '/images/restaurants/restaurant7.jpg', 'Prishtinë', 'Qendra e Vjetër', 40, 3, 600, 1, 'Restaurant', 'For Sale', 4),
('Burger House Prishtina Restorant', 'Burgerët më të mirë artizanalë.', 95000, '/images/restaurants/restaurant3.jpg', 'Prishtinë', 'Blloku', 12, 1, 100, 0, 'Restaurant', 'For Sale', 4),
('Sky Restaurant Prishtina', 'Darkë me pamje mbi gjithë qytetin.', 550000, '/images/restaurants/restaurant8.jpg', 'Prishtinë', 'Veternik', 45, 4, 800, 1, 'Restaurant', 'For Sale', 4),
('Pasta & Wine Bar Restorant', 'Specialitete italiane dhe verëra cilësore.', 280000, '/images/restaurants/restaurant10.jpg', 'Prishtinë', 'Qendra', 25, 2, 250, 0, 'Restaurant', 'For Sale', 4),
('Garden Restaurant Gërmia', 'Restorant në mes të natyrës.', 320000, '/images/restaurants/restaurant5.jpg', 'Prishtinë', 'Gërmia', 50, 3, 1000, 1, 'Restaurant', 'For Sale', 4),
('Steakhouse 01 Restorant', 'Për adhuruesit e mishit cilësor.', 240000, '/images/restaurants/restaurant1.jpg', 'Prishtinë', 'Magjistralja', 30, 2, 400, 0, 'Restaurant', 'For Sale', 4),
('Bistro & Lounge Restorant Prishtina', 'Ambient modern për çdo kohë të ditës.', 160000, '/images/restaurants/restaurant6.jpg', 'Prishtinë', 'Dardania', 22, 2, 180, 0, 'Restaurant', 'For Sale', 4);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prishtinë', 'Qendra', 311), ('Prishtinë', 'Pejton', 312), ('Prishtinë', 'Arbëria', 313), ('Prishtinë', 'Qendra e Vjetër', 314), ('Prishtinë', 'Blloku', 315),
('Prishtinë', 'Veternik', 316), ('Prishtinë', 'Qendra', 317), ('Prishtinë', 'Gërmia', 318), ('Prishtinë', 'Magjistralja', 319), ('Prishtinë', 'Dardania', 320);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(311,1),(311,2),(311,3),(311,5),(311,6),
(312,1),(312,2),(312,3),(312,5),(312,6),
(313,1),(313,2),(313,3),(313,5),(313,6),
(314,1),(314,2),(314,3),(314,5),(314,6),
(315,1),(315,2),(315,3),(315,5),(315,6),
(316,1),(316,2),(316,3),(316,5),(316,6),
(317,1),(317,2),(317,3),(317,5),(317,6),
(318,1),(318,2),(318,3),(318,5),(318,6),
(319,1),(319,2),(319,3),(319,5),(319,6),
(320,1),(320,2),(320,3),(320,5),(320,6);



INSERT INTO Properties 
( Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
( 'Restorant Shadërvani', 'Restoranti më i njohur në zemër të Prizrenit.', 280000, '/images/restaurants/restaurant3.jpg', 'Prizren', 'Shadërvan', 30, 2, 400, 1, 'Restaurant', 'For Sale', 4),
( 'Qebaptore Prizreni Restorant', 'Qebapët tradicionalë me shije unike.', 95000, '/images/restaurants/restaurant5.jpg', 'Prizren', 'Qendra', 15, 1, 120, 1, 'Restaurant', 'For Sale', 4),
( 'Restorant Riverside', 'Darkë buzë lumit Lumbardh.', 220000, '/images/restaurants/restaurant10.jpg', 'Prizren', 'Qendra', 25, 2, 350, 1, 'Restaurant', 'For Sale', 4),
( 'Castle Restaurant', 'Pamje mahnitëse nga kalaja e qytetit.', 310000, '/images/restaurants/restaurant7.jpg', 'Prizren', 'Kalaja', 35, 3, 500, 1, 'Restaurant', 'For Sale', 4),
( 'Restorant Roma Prizren', 'Pica italiane në ambient tradicional.', 110000, '/images/restaurants/restaurant2.jpg', 'Prizren', 'Ortakoll', 20, 2, 180, 0, 'Restaurant', 'For Sale', 4),
( 'Restorant Marashi', 'Ambient i mrekullueshëm nën hijen e rrapit.', 380000, '/images/restaurants/restaurant4.jpg', 'Prizren', 'Marash', 45, 3, 700, 1, 'Restaurant', 'For Sale', 4),
( 'Fish House Restorant Lumbardhi', 'Peshk i freskët dhe specialitete deti.', 190000, '/images/restaurants/restaurant8.jpg', 'Prizren', 'Qendra', 22, 2, 250, 0, 'Restaurant', 'For Sale', 4),
( 'Balkan Food Restorant Prizren', 'Gjellëra tradicionale ballkanike.', 130000, '/images/restaurants/restaurant9.jpg', 'Prizren', 'Qendra', 28, 2, 300, 0, 'Restaurant', 'For Sale', 4),
( 'Restorant Prevalla', 'Ushqim shtëpie në zonën malore.', 160000, '/images/restaurants/restaurant6.jpg', 'Prizren', 'Prevallë', 40, 2, 600, 1, 'Restaurant', 'For Sale', 4),
( 'Lounge & Bistro Restorant Prizren', 'Kombinim i modernes me tradicionalen.', 145000, '/images/restaurants/restaurant1.jpg', 'Prizren', 'Bazhdarhane', 18, 1, 200, 0, 'Restaurant', 'For Sale', 4);


-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prizren', 'Shadërvan', 321), ('Prizren', 'Qendra', 322), ('Prizren', 'Qendra', 323), ('Prizren', 'Kalaja', 324), ('Prizren', 'Ortakoll', 325),
('Prizren', 'Marash', 326), ('Prizren', 'Qendra', 327), ('Prizren', 'Qendra', 328), ('Prizren', 'Prevallë', 329), ('Prizren', 'Bazhdarhane', 330);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(321,1),(321,2),(321,3),(321,5),(321,6),
(322,1),(322,2),(322,3),(322,5),(322,6),
(323,1),(323,2),(323,3),(323,5),(323,6),
(324,1),(324,2),(324,3),(324,5),(324,6),
(325,1),(325,2),(325,3),(325,5),(325,6),
(326,1),(326,2),(326,3),(326,5),(326,6),
(327,1),(327,2),(327,3),(327,5),(327,6),
(328,1),(328,2),(328,3),(328,5),(328,6),
(329,1),(329,2),(329,3),(329,5),(329,6),
(330,1),(330,2),(330,3),(330,5),(330,6);




DELETE FROM Addresses WHERE PropertyId BETWEEN 331 AND 340;
DELETE FROM Properties WHERE Id BETWEEN 331 AND 340;

INSERT INTO Properties
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Restorant Art Design', 'Kuzhinë moderne me prezantim unik.', 250000, '/images/restaurants/restaurant4.jpg', 'Pejë', 'Qendra', 28, 2, 380, 1, 'Restaurant', 'For Sale', 4),
('Gryka e Rugovës Restaurant', 'Specialitete mishi në mes të grykës.', 320000, '/images/restaurants/restaurant8.jpg', 'Pejë', 'Rugovë', 50, 3, 800, 1, 'Restaurant', 'For Sale', 4),
('Restorant Bellini', 'Pica dhe pasta cilësore në korzë.', 120000, '/images/restaurants/restaurant5.jpg', 'Pejë', 'Qendra', 20, 2, 220, 1, 'Restaurant', 'For Sale', 4),
('Restorant Kulla e Zenel Beut', 'Ambient historik dhe ushqim tradicional.', 280000, '/images/restaurants/restaurant1.jpg', 'Pejë', 'Qendra', 30, 2, 450, 1, 'Restaurant', 'For Sale', 4),
('Steakhouse Restorant Peja', 'Mishi më i mirë në skarë.', 195000, '/images/restaurants/restaurant6.jpg', 'Pejë', 'Karagaç', 25, 2, 300, 0, 'Restaurant', 'For Sale', 4),
('Restorant Panorama Rugova', 'Darkë mbi re në lartësitë e Rugovës.', 290000, '/images/restaurants/restaurant9.jpg', 'Pejë', 'Rugovë', 40, 2, 650, 1, 'Restaurant', 'For Sale', 4),
('Fast Food Restorant King Peja', 'Ushqim i shpejtë dhe cilësor.', 65000, '/images/restaurants/restaurant3.jpg', 'Pejë', 'Qendra', 12, 1, 100, 0, 'Restaurant', 'For Sale', 4),
('Restorant Hotel Dukagjini', 'Kuzhinë ndërkombëtare elitare.', 450000, '/images/restaurants/restaurant7.jpg', 'Pejë', 'Qendra', 45, 4, 700, 1, 'Restaurant', 'For Sale', 4),
('Bistro 03 Restorant', 'Ambient modern për të rinj.', 135000, '/images/restaurants/restaurant10.jpg', 'Pejë', 'Fidanishte', 18, 1, 180, 0, 'Restaurant', 'For Sale', 4),
('Traditional House Peja', 'Shija e vërtetë e ushqimit të shtëpisë.', 175000, '/images/restaurants/restaurant2.jpg', 'Pejë', 'Qendra', 22, 2, 320, 0, 'Restaurant', 'For Sale', 4);



INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Pejë', 'Qendra', 331), ('Pejë', 'Rugovë', 332), ('Pejë', 'Qendra', 333), ('Pejë', 'Qendra', 334), ('Pejë', 'Karagaç', 335),
('Pejë', 'Rugovë', 336), ('Pejë', 'Qendra', 337), ('Pejë', 'Qendra', 338), ('Pejë', 'Fidanishte', 339), ('Pejë', 'Qendra', 340);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(331,1),(331,2),(331,3),(331,5),(331,6),
(332,1),(332,2),(332,3),(332,5),(332,6),
(333,1),(333,2),(333,3),(333,5),(333,6),
(334,1),(334,2),(334,3),(334,5),(334,6),
(335,1),(335,2),(335,3),(335,5),(335,6),
(336,1),(336,2),(336,3),(336,5),(336,6),
(337,1),(337,2),(337,3),(337,5),(337,6),
(338,1),(338,2),(338,3),(338,5),(338,6),
(339,1),(339,2),(339,3),(339,5),(339,6),
(340,1),(340,2),(340,3),(340,5),(340,6);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Restorant Lybeteni', 'Restorant tradicional me hapsirë të madhe.', 180000, '/images/restaurants/restaurant5.jpg', 'Ferizaj', 'Qendra', 35, 2, 450, 1, 'Restaurant', 'For Sale', 4),
('Restorant Roma Ferizaj', 'Pica autentike me traditë shumëvjeçare.', 95000, '/images/restaurants/restaurant7.jpg', 'Ferizaj', 'Qendra', 18, 1, 160, 1, 'Restaurant', 'For Sale', 4),
('Steakhouse Restorant Ferizaj', 'Mishi më i mirë në skarë në qytet.', 210000, '/images/restaurants/restaurant10.jpg', 'Ferizaj', 'Bibaj', 25, 2, 320, 1, 'Restaurant', 'For Sale', 4),
('Restorant Fontana Ferizaj', 'Ambient me kopsht dhe ujëvarë artificiale.', 165000, '/images/restaurants/restaurant2.jpg', 'Ferizaj', 'Qendra', 30, 2, 400, 0, 'Restaurant', 'For Sale', 4),
('Fast Food Restorant Central Ferizaj', 'Lokacioni më i frekuentuar në qytet.', 75000, '/images/restaurants/restaurant8.jpg', 'Ferizaj', 'Qendra', 12, 1, 90, 0, 'Restaurant', 'For Sale', 4),
('Restorant Jezerc', 'Ushqim tradicional në mes të maleve.', 280000, '/images/restaurants/restaurant1.jpg', 'Ferizaj', 'Jezerc', 45, 3, 650, 1, 'Restaurant', 'For Sale', 4),
('Fish House Restorant Ferizaj', 'Specialitete peshku dhe prodhime deti.', 140000, '/images/restaurants/restaurant3.jpg', 'Ferizaj', 'Qendra', 20, 2, 250, 0, 'Restaurant', 'For Sale', 4),
('Bistro & Lounge Restorant Ferizaj', 'Ambient modern për çdo kohë të ditës.', 125000, '/images/restaurants/restaurant9.jpg', 'Ferizaj', 'Qendra', 15, 1, 180, 0, 'Restaurant', 'For Sale', 4),
('Restorant Garden', 'Ambient i gjelbëruar për dreka familjare.', 195000, '/images/restaurants/restaurant4.jpg', 'Ferizaj', 'Talinoc', 32, 2, 420, 1, 'Restaurant', 'For Sale', 4),
('Grill House Restorant Ferizaj', 'Specialitete të skarës dhe ushqim i shpejtë.', 88000, '/images/restaurants/restaurant6.jpg', 'Ferizaj', 'Qendra', 14, 1, 130, 0, 'Restaurant', 'For Sale', 4);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Ferizaj', 'Qendra', 341), ('Ferizaj', 'Qendra', 342), ('Ferizaj', 'Bibaj', 343), ('Ferizaj', 'Qendra', 344), ('Ferizaj', 'Qendra', 345),
('Ferizaj', 'Jezerc', 346), ('Ferizaj', 'Qendra', 347), ('Ferizaj', 'Qendra', 348), ('Ferizaj', 'Talinoc', 349), ('Ferizaj', 'Qendra', 350);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(341,1),(341,2),(341,3),(341,5),(341,6),
(342,1),(342,2),(342,3),(342,5),(342,6),
(343,1),(343,2),(343,3),(343,5),(343,6),
(344,1),(344,2),(344,3),(344,5),(344,6),
(345,1),(345,2),(345,3),(345,5),(345,6),
(346,1),(346,2),(346,3),(346,5),(346,6),
(347,1),(347,2),(347,3),(347,5),(347,6),
(348,1),(348,2),(348,3),(348,5),(348,6),
(349,1),(349,2),(349,3),(349,5),(349,6),
(350,1),(350,2),(350,3),(350,5),(350,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Restorant Vali Ranch', 'Restorant elitë me ambient përrallor.', 450000, '/images/restaurants/restaurant6.jpg', 'Gjilan', 'Përlepnicë', 60, 4, 1200, 1, 'Restaurant', 'For Sale', 4),
('Restorant Astoria', 'Pica italiane në zemër të Gjilanit.', 110000, '/images/restaurants/restaurant9.jpg', 'Gjilan', 'Qendra', 22, 2, 200, 1, 'Restaurant', 'For Sale', 4),
('Restorant Fontana Gjilan', 'Traditë dhe shije në çdo pjatë.', 145000, '/images/restaurants/restaurant1.jpg', 'Gjilan', 'Qendra', 30, 2, 380, 1, 'Restaurant', 'For Sale', 4),
('Steakhouse Restorant Gjilan', 'Mishi më i mirë i gatuar me mjeshtëri.', 190000, '/images/restaurants/restaurant4.jpg', 'Gjilan', 'Qendra', 25, 2, 300, 1, 'Restaurant', 'For Sale', 4),
('Fast Food Restorant 06 Gjilan', 'Ushqimi i shpejtë më i pëlqyer në qytet.', 65000, '/images/restaurants/restaurant2jpg', 'Gjilan', 'Qendra', 10, 1, 85, 0, 'Restaurant', 'For Sale', 4),
('Restorant Livoçi', 'Ambient i qetë buzë liqenit.', 220000, '/images/restaurants/restaurant10.jpg', 'Gjilan', 'Livoç', 40, 3, 550, 1, 'Restaurant', 'For Sale', 4),
('Traditional House Restorant Gjilan', 'Ushqime shtëpie me receta të vjetra.', 135000, '/images/restaurants/restaurant8.jpg', 'Gjilan', 'Qendra', 28, 2, 320, 0, 'Restaurant', 'For Sale', 4),
('Fish & Seafood Restorant Gjilan', 'Specialitete deti të freskëta çdo ditë.', 175000, '/images/restaurants/restaurant3.jpg', 'Gjilan', 'Qendra', 20, 2, 240, 0, 'Restaurant', 'For Sale', 4),
('Bistro Restorant Gjilani', 'Ambient modern për kafe dhe ushqim.', 95000, '/images/restaurants/restaurant7.jpg', 'Gjilan', 'Dardania', 18, 1, 150, 0, 'Restaurant', 'For Sale', 4),
('Grill Garden Restorant Gjilan', 'Kopsht i madh dhe specialitete skare.', 260000, '/images/restaurants/restaurant5.jpg', 'Gjilan', 'Rruga Qarkore', 50, 3, 750, 1, 'Restaurant', 'For Sale', 4);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjilan', 'Përlepnicë', 351), ('Gjilan', 'Qendra', 352), ('Gjilan', 'Qendra', 353), ('Gjilan', 'Qendra', 354), ('Gjilan', 'Qendra', 355),
('Gjilan', 'Livoç', 356), ('Gjilan', 'Qendra', 357), ('Gjilan', 'Qendra', 358), ('Gjilan', 'Dardania', 359), ('Gjilan', 'Rruga Qarkore', 360);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(351,1),(351,2),(351,3),(351,5),(351,6),
(352,1),(352,2),(352,3),(352,5),(352,6),
(353,1),(353,2),(353,3),(353,5),(353,6),
(354,1),(354,2),(354,3),(354,5),(354,6),
(355,1),(355,2),(355,3),(355,5),(355,6),
(356,1),(356,2),(356,3),(356,5),(356,6),
(357,1),(357,2),(357,3),(357,5),(357,6),
(358,1),(358,2),(358,3),(358,5),(358,6),
(359,1),(359,2),(359,3),(359,5),(359,6),
(360,1),(360,2),(360,3),(360,5),(360,6);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Restorant Palace Mitrovica', 'Kuzhinë ndërkombëtare me pamje nga lumi.', 210000, '/images/restaurants/restaurant7.jpg', 'Mitrovicë', 'Qendra', 30, 2, 400, 1, 'Restaurant', 'For Sale', 4),
('Ibar Riverside Bistro Restorant', 'Ambient modern buzë lumit Ibër.', 125000, '/images/restaurants/restaurant5.jpg', 'Mitrovicë', 'Qendra', 18, 1, 180, 1, 'Restaurant', 'For Sale', 4),
('Mitrovica Grill House', 'Specialitete mishi të pjekura në prush.', 95000, '/images/restaurants/restaurant8.jpg', 'Mitrovicë', 'Qendra', 20, 2, 220, 0, 'Restaurant', 'For Sale', 4),
('North Side Restorant&Pizzeria', 'Pica autentike në pjesën veriore të qytetit.', 88000, '/images/restaurants/restaurant6.jpg', 'Mitrovicë', 'Qendra', 15, 1, 140, 0, 'Restaurant', 'For Sale', 4),
('Bair Panorama Restaurant', 'Darkë me pamje panoramike të Mitrovicës.', 175000, '/images/restaurants/restaurant1.jpg', 'Mitrovicë', 'Bair', 35, 2, 450, 1, 'Restaurant', 'For Sale', 4),
('Tavnik Traditional Food Restorant', 'Ushqime shtëpie dhe gjellëra tradicionale.', 110000, '/images/restaurants/restaurant10.jpg', 'Mitrovicë', 'Tavnik', 25, 2, 300, 0, 'Restaurant', 'For Sale', 4),
('City Center Fast Food Restorant', 'Lokacioni më i frekuentuar për ushqim të shpejtë.', 55000, '/images/restaurants/restaurant2.jpg', 'Mitrovicë', 'Qendra', 10, 1, 70, 0, 'Restaurant', 'For Sale', 4),
('Bridge View Cafe & Rest Restorant', 'Ambient i qetë afër urës kryesore.', 140000, '/images/restaurants/restaurant9.jpg', 'Mitrovicë', 'Qendra', 22, 2, 250, 1, 'Restaurant', 'For Sale', 4),
('Industrial Zone Canteen Restorant', 'Pikë kyçe për dreka në zonën industriale.', 130000, '/images/restaurants/restaurant3.jpg', 'Mitrovicë', 'Zona Industriale', 40, 2, 500, 0, 'Restaurant', 'For Sale', 4),
('Grand Mitrovica Banquet Restorant', 'Sallë e madhe për ahengje dhe restorant.', 350000, '/images/restaurants/restaurant4.jpg', 'Mitrovicë', 'Qendra', 80, 4, 1200, 1, 'Restaurant', 'For Sale', 4);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Mitrovicë', 'Qendra', 361), ('Mitrovicë', 'Qendra', 362), ('Mitrovicë', 'Qendra', 363), ('Mitrovicë', 'Qendra', 364), ('Mitrovicë', 'Bair', 365),
('Mitrovicë', 'Tavnik', 366), ('Mitrovicë', 'Qendra', 367), ('Mitrovicë', 'Qendra', 368), ('Mitrovicë', 'Zona Industriale', 369), ('Mitrovicë', 'Qendra', 370);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(361,1),(361,2),(361,3),(361,5),(361,6),
(362,1),(362,2),(362,3),(362,5),(362,6),
(363,1),(363,2),(363,3),(363,5),(363,6),
(364,1),(364,2),(364,3),(364,5),(364,6),
(365,1),(365,2),(365,3),(365,5),(365,6),
(366,1),(366,2),(366,3),(366,5),(366,6),
(367,1),(367,2),(367,3),(367,5),(367,6),
(368,1),(368,2),(368,3),(368,5),(368,6),
(369,1),(369,2),(369,3),(369,5),(369,6),
(370,1),(370,2),(370,3),(370,5),(370,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Restorant Çarshia e Jupave', 'Eksperiencë gastronomike në zemër të historisë.', 320000, '/images/restaurants/restaurant8.jpg', 'Gjakovë', 'Çarshia e Vjetër', 45, 3, 600, 1, 'Restaurant', 'For Sale', 4),
('Pashtriku Traditional Restorant', 'Restoranti ikonë i qytetit të Gjakovës.', 280000, '/images/restaurants/restaurant4.jpg', 'Gjakovë', 'Qendra', 50, 3, 750, 1, 'Restaurant', 'For Sale', 4),
('Krena River Side Bistro Restorant', 'Ambient modern dhe i freskët buzë lumit.', 145000, '/images/restaurants/restaurant6.jpg', 'Gjakovë', 'Qendra', 22, 2, 240, 1, 'Restaurant', 'For Sale', 4),
('Old Bazaar Grill Restorant', 'Mishi më i mirë në skarë në Çarshi.', 115000, '/images/restaurants/restaurant2.jpg', 'Gjakovë', 'Çarshia e Vjetër', 18, 1, 180, 0, 'Restaurant', 'For Sale', 4),
('Shkugëza Forest Restorant', 'Darkë në mes të pishave dhe natyrës.', 260000, '/images/restaurants/restaurant5.jpg', 'Gjakovë', 'Shkugëz', 60, 4, 1000, 1, 'Restaurant', 'For Sale', 4),
('Blloku Modern Kitchen Restorant', 'Kuzhinë bashkëkohore me shije unike.', 190000, '/images/restaurants/restaurant7.jpg', 'Gjakovë', 'Blloku i Ri', 28, 2, 350, 1, 'Restaurant', 'For Sale', 4),
('Gjakova Steakhouse Restorant', 'Specialitete mishi të gatuara me pasion.', 220000, '/images/restaurants/restaurant9.jpg', 'Gjakovë', 'Qendra', 30, 2, 400, 1, 'Restaurant', 'For Sale', 4),
('Pizzeria&Restorant Bellini Gjakova', 'Pica italiane me receta origjinale.', 105000, '/images/restaurants/restaurant3.jpg', 'Gjakovë', 'Qendra', 20, 2, 200, 0, 'Restaurant', 'For Sale', 4),
('Traditional House Gjakova Restorant ', 'Shija e vërtetë e traditës gjakovare.', 155000, '/images/restaurants/restaurant1.jpg', 'Gjakovë', 'Çarshia e Vjetër', 25, 2, 320, 0, 'Restaurant', 'For Sale', 4),
('Grand Gjakova Restorant', 'Ambient luksoz për evente dhe dreka.', 380000, '/images/restaurants/restaurant9.jpg', 'Gjakovë', 'Blloku i Ri', 70, 4, 1100, 1, 'Restaurant', 'For Sale', 4);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjakovë', 'Çarshia e Vjetër', 371), ('Gjakovë', 'Qendra', 372), ('Gjakovë', 'Qendra', 373), ('Gjakovë', 'Çarshia e Vjetër', 374), ('Gjakovë', 'Shkugëz', 375),
('Gjakovë', 'Blloku i Ri', 376), ('Gjakovë', 'Qendra', 377), ('Gjakovë', 'Qendra', 378), ('Gjakovë', 'Çarshia e Vjetër', 379), ('Gjakovë', 'Blloku i Ri', 380);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(371,1),(371,2),(371,3),(371,5),(371,6),
(372,1),(372,2),(372,3),(372,5),(372,6),
(373,1),(373,2),(373,3),(373,5),(373,6),
(374,1),(374,2),(374,3),(374,5),(374,6),
(375,1),(375,2),(375,3),(375,5),(375,6),
(376,1),(376,2),(376,3),(376,5),(376,6),
(377,1),(377,2),(377,3),(377,5),(377,6),
(378,1),(378,2),(378,3),(378,5),(378,6),
(379,1),(379,2),(379,3),(379,5),(379,6),
(380,1),(380,2),(380,3),(380,5),(380,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Restorant Express FK', 'Shërbim i shpejtë dhe ushqim cilësor.', 85000, '/images/restaurants/restaurant9.jpg', 'Fushë Kosovë', 'Qendra', 15, 1, 120, 1, 'Restaurant', 'For Sale', 4),
('Restorant Roma FK', 'Pica autentike në zonën më të banuar.', 92000, '/images/restaurants/restaurant6.jpg', 'Fushë Kosovë', 'Dardania', 18, 1, 150, 1, 'Restaurant', 'For Sale', 4),
('Grill House FK Restorant', 'Specialitete mishi në skarë çdo ditë.', 78000, '/images/restaurants/restaurant10.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 20, 1, 180, 0, 'Restaurant', 'For Sale', 4),
('Industrial Zone Canteen FK Restorant', 'Ideale për dreka pune në zonën industriale.', 110000, '/images/restaurants/restaurant2.jpg', 'Fushë Kosovë', 'Zona Industriale', 35, 2, 400, 1, 'Restaurant', 'For Sale', 4),
('Restorant Family FK', 'Ambient i ngrohtë për dreka familjare.', 135000, '/images/restaurants/restaurant7.jpg', 'Fushë Kosovë', 'Qendra', 28, 2, 320, 0, 'Restaurant', 'For Sale', 4),
('Bistro & Coffee FK Restorant', 'Kombinim i kafesë me ushqime të lehta.', 65000, '/images/restaurants/restaurant3.jpg', 'Fushë Kosovë', 'Dardania', 12, 1, 100, 0, 'Restaurant', 'For Sale', 4),
('Fast Food King FK Restorant', 'Lokacioni më i frekuentuar për të rinj.', 55000, '/images/restaurants/restaurant5.jpg', 'Fushë Kosovë', 'Qendra', 10, 1, 80, 1, 'Restaurant', 'For Sale', 4),
('Restorant Panorama FK', 'Darkë me pamje nga tarraca e hapur.', 160000, '/images/restaurants/restaurant1.jpg', 'Fushë Kosovë', 'Qendra', 30, 2, 350, 1, 'Restaurant', 'For Sale', 4),
('Traditional Food FK Restorant', 'Shija e vërtetë e gatimeve tona.', 115000, '/images/restaurants/restaurant4.jpg', 'Fushë Kosovë', 'Bresje', 22, 2, 280, 0, 'Restaurant', 'For Sale', 4),
('Grand Restaurant FK', 'Sallë luksoze për evente dhe restorant.', 320000, '/images/restaurants/restaurant8.jpg', 'Fushë Kosovë', 'Qendra', 70, 4, 1000, 1, 'Restaurant', 'For Sale', 4);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Fushë Kosovë', 'Qendra', 381), ('Fushë Kosovë', 'Dardania', 382), ('Fushë Kosovë', 'Rruga e Pejës', 383), ('Fushë Kosovë', 'Zona Industriale', 384), ('Fushë Kosovë', 'Qendra', 385),
('Fushë Kosovë', 'Dardania', 386), ('Fushë Kosovë', 'Qendra', 387), ('Fushë Kosovë', 'Qendra', 388), ('Fushë Kosovë', 'Bresje', 389), ('Fushë Kosovë', 'Qendra', 390);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(381,1),(381,2),(381,3),(381,5),(381,6),
(382,1),(382,2),(382,3),(382,5),(382,6),
(383,1),(383,2),(383,3),(383,5),(383,6),
(384,1),(384,2),(384,3),(384,5),(384,6),
(385,1),(385,2),(385,3),(385,5),(385,6),
(386,1),(386,2),(386,3),(386,5),(386,6),
(387,1),(387,2),(387,3),(387,5),(387,6),
(388,1),(388,2),(388,3),(388,5),(388,6),
(389,1),(389,2),(389,3),(389,5),(389,6),
(390,1),(390,2),(390,3),(390,5),(390,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Restorant Besiana', 'Restoranti më i njohur në qendër të qytetit.', 145000, '/images/restaurants/restaurant10.jpg', 'Podujevë', 'Besiana', 30, 2, 400, 1, 'Restaurant', 'For Sale', 4),
('Llap Grill House Restorant', 'Mishi më i mirë në rajonin e Llapit.', 98000, '/images/restaurants/restaurant7.jpg', 'Podujevë', 'Qendra', 20, 1, 220, 1, 'Restaurant', 'For Sale', 4),
('Pizzeria&Restorant Roma Podujeva', 'Pica autentike me receta tradicionale.', 85000, '/images/restaurants/restaurant2.jpg', 'Podujevë', 'Besiana', 18, 1, 160, 0, 'Restaurant', 'For Sale', 4),
('Restorant Riverside Llap', 'Ambient i qetë buzë lumit Llap.', 180000, '/images/restaurants/restaurant6.jpg', 'Podujevë', 'Qendra', 35, 2, 450, 1, 'Restaurant', 'For Sale', 4),
('Fast Food Central Podujeva Restorant', 'Ushqim i shpejtë në lokacionin kyç.', 62000, '/images/restaurants/restaurant1.jpg', 'Podujevë', 'Qendra', 12, 1, 100, 0, 'Restaurant', 'For Sale', 4),
('Restorant Panorama Besiana', 'Darkë me pamje mbi qytetin e Podujevës.', 210000, '/images/restaurants/restaurant3.jpg', 'Podujevë', 'Besiana', 40, 2, 550, 1, 'Restaurant', 'For Sale', 4),
('Traditional House Podujeva Restorant', 'Gatime shtëpie me shije të vërtetë.', 125000, '/images/restaurants/restaurant8.jpg', 'Podujevë', 'Qendra', 25, 2, 320, 0, 'Restaurant', 'For Sale', 4),
('Bistro & Coffee Besiana Restorant', 'Ambient modern për kafe dhe ushqim.', 75000, '/images/restaurants/restaurant4.jpg', 'Podujevë', 'Besiana', 15, 1, 140, 0, 'Restaurant', 'For Sale', 4),
('Steakhouse 032 Restorant', 'Specialitete mishi për adhuruesit e vërtetë.', 165000, '/images/restaurants/restaurant15.jpg', 'Podujevë', 'Zona Industriale', 28, 2, 380, 1, 'Restaurant', 'For Sale', 4),
('Grand Restaurant Podujeva', 'Ambient luksoz për ahengje dhe dreka.', 350000, '/images/restaurants/restaurant9.jpg', 'Podujevë', 'Qendra', 75, 4, 1100, 1, 'Restaurant', 'For Sale', 4);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Podujevë', 'Besiana', 391), ('Podujevë', 'Qendra', 392), ('Podujevë', 'Besiana', 393), ('Podujevë', 'Qendra', 394), ('Podujevë', 'Qendra', 395),
('Podujevë', 'Besiana', 396), ('Podujevë', 'Qendra', 397), ('Podujevë', 'Besiana', 398), ('Podujevë', 'Zona Industriale', 399), ('Podujevë', 'Qendra', 400);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(391,1),(391,2),(391,3),(391,5),(391,6),
(392,1),(392,2),(392,3),(392,5),(392,6),
(393,1),(393,2),(393,3),(393,5),(393,6),
(394,1),(394,2),(394,3),(394,5),(394,6),
(395,1),(395,2),(395,3),(395,5),(395,6),
(396,1),(396,2),(396,3),(396,5),(396,6),
(397,1),(397,2),(397,3),(397,5),(397,6),
(398,1),(398,2),(398,3),(398,5),(398,6),
(399,1),(399,2),(399,3),(399,5),(399,6),
(400,1),(400,2),(400,3),(400,5),(400,6);



-- LOKALET

INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Qendër të Drenasit(Local)', 'Lokal modern me qasje direkte në rrugë.', 85000, '/images/commercial/local1.jpg', 'Drenas', 'Qendra', 0, 1, 60, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Zyre(Local)', 'Ideale për biznese ose administrata.', 65000, '/images/commercial/local2.jpg', 'Drenas', 'Qendra', 0, 1, 45, 0, 'Commercial', 'For Sale', 5),
('Lokal në Komoran(Local)', 'Lokacion kyç buzë rrugës kryesore.', 120000, '/images/commercial/local3.jpg', 'Drenas', 'Komoran', 0, 1, 100, 1, 'Commercial', 'For Sale', 5),
('Depo Industriale(Local)', 'Hapsirë e madhe për magazinim.', 150000, '/images/commercial/local4.jpg', 'Drenas', 'Zona Industriale', 0, 2, 500, 1, 'Commercial', 'For Sale', 5),
('Lokal afër Stacionit(Local)', 'I përshtatshëm për dyqan ose barnatore.', 55000, '/images/commercial/local5.jpg', 'Drenas', 'Qendra', 0, 1, 35, 0, 'Commercial', 'For Sale', 5),
('Hapsirë për Showroom(Local)', 'Dritare të mëdha xhami, dukshmëri e lartë.', 180000, '/images/commercial/local6.jpg', 'Drenas', 'Zona Industriale', 0, 1, 250, 1, 'Commercial', 'For Sale', 5),
('Lokal në katin përdhes(Local)', 'I gatshëm për punë, i renovuar.', 72000, '/images/commercial/local7.jpg', 'Drenas', 'Qendra', 0, 1, 50, 0, 'Commercial', 'For Sale', 5),
('Objekt Afarist Drenas(Local)', 'Objekt i plotë për aktivitete biznesi.', 350000, '/images/commercial/local8.jpg', 'Drenas', 'Gllogoc', 0, 4, 800, 1, 'Commercial', 'For Sale', 5),
('Lokal i vogël praktik(Local)', 'Ideale për kioskë ose zyre të vogël.', 28000, '/images/commercial/local9.jpg', 'Drenas', 'Qendra', 0, 1, 20, 0, 'Commercial', 'For Sale', 5),
('Hapsirë Komerciale Zabel(Local)', 'Qasje e lehtë për kamionë dhe transport.', 95000, '/images/commercial/local10.jpg', 'Drenas', 'Zabel', 0, 1, 150, 0, 'Commercial', 'For Sale', 5);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Drenas', 'Qendra', 401), ('Drenas', 'Qendra', 402), ('Drenas', 'Komoran', 403), ('Drenas', 'Zona Industriale', 404), ('Drenas', 'Qendra', 405),
('Drenas', 'Zona Industriale', 406), ('Drenas', 'Qendra', 407), ('Drenas', 'Gllogoc', 408), ('Drenas', 'Qendra', 409), ('Drenas', 'Zabel', 410);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(401,1),(401,2),
(402,1),(402,2),
(403,1),(403,2),
(404,1),(404,2),
(405,1),(405,2),
(406,1),(406,2),
(407,1),(407,2),
(408,1),(408,2),
(409,1),(409,2),
(410,1),(410,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Sheshin Nënë Tereza Local', 'Lokacioni më ekskluziv në Prishtinë.', 850000, '/images/commercial/local2.jpg', 'Prishtinë', 'Qendra', 0, 2, 120, 1, 'Commercial', 'For Sale', 5),
('Zyre Moderne në Pejton Local', 'Hapsirë e renovuar për kompani IT.', 180000, '/images/commercial/local4.jpg', 'Prishtinë', 'Pejton', 0, 1, 150, 1, 'Commercial', 'For Sale', 5),
('Lokal në Lakrishtë Local', 'Në qendrën e re të biznesit.', 250000, '/images/commercial/local9.jpg', 'Prishtinë', 'Lakrishtë', 0, 1, 85, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Supermarket Local', 'Sipërfaqe e madhe në katin përdhes.', 450000, '/images/commercial/local1.jpg', 'Prishtinë', 'Dardania', 0, 2, 400, 1, 'Commercial', 'For Sale', 5),
('Lokal në Rrugën B Local', 'Zonë me shumë lëvizje dhe biznese.', 320000, '/images/commercial/local7.jpg', 'Prishtinë', 'Rruga B', 0, 1, 95, 1, 'Commercial', 'For Sale', 5),
('Objekt Afarist Veternik Local', 'Ideale për spitale ose shkolla private.', 1200000, '/images/commercial/local3.jpg', 'Prishtinë', 'Veternik', 0, 6, 1500, 1, 'Commercial', 'For Sale', 5),
('Lokal në Ulpianë Local', 'Afër fakulteteve, i përshtatshëm për kafiteri.', 140000, '/images/commercial/local8.jpg', 'Prishtinë', 'Ulpiana', 0, 1, 70, 0, 'Commercial', 'For Sale', 5),
('Zyre në Dragodan Local', 'Pamje nga qyteti, ambient i qetë pune.', 110000, '/images/commercial/local4.jpg', 'Prishtinë', 'Arbëria', 0, 1, 90, 0, 'Commercial', 'For Sale', 5),
('Lokal në Aktash Local', 'I përshtatshëm për zyre ose studio.', 85000, '/images/commercial/local10.jpg', 'Prishtinë', 'Aktash', 0, 1, 55, 0, 'Commercial', 'For Sale', 5),
('Hapsirë Industriale Shkabaj Local', 'Depo moderne me lartësi 6 metra.', 280000, '/images/commercial/local7.jpg', 'Prishtinë', 'Shkabaj', 0, 2, 600, 0, 'Commercial', 'For Sale', 5);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prishtinë', 'Sheshi Nënë Tereza', 411), ('Prishtinë', 'Pejton', 412), ('Prishtinë', 'Lakrishtë', 413), ('Prishtinë', 'Dardania', 414), ('Prishtinë', 'Rruga B', 415),
('Prishtinë', 'Veternik', 416), ('Prishtinë', 'Ulpiana', 417), ('Prishtinë', 'Arbëria', 418), ('Prishtinë', 'Aktash', 419), ('Prishtinë', 'Shkabaj', 420);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(411,1),(411,2),
(412,1),(412,2),
(413,1),(413,2),
(414,1),(414,2),
(415,1),(415,2),
(416,1),(416,2),
(417,1),(417,2),
(418,1),(418,2),
(419,1),(419,2),
(420,1),(420,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Shadërvan(Local)', 'Lokacion unik në zonën më turistike.', 350000, '/images/commercial/local3.jpg', 'Prizren', 'Shadërvan', 0, 1, 80, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Zyre Ortakoll(Local)', 'Zyre moderne në lagje të qetë.', 95000, '/images/commercial/local7.jpg', 'Prizren', 'Ortakoll', 0, 1, 70, 0, 'Commercial', 'For Sale', 5),
('Lokal buzë Lumbardhit(Local)', 'Ideale për kafiteri ose restorant të vogël.', 220000, '/images/commercial/local5.jpg', 'Prizren', 'Qendra', 0, 1, 110, 1, 'Commercial', 'For Sale', 5),
('Showroom në Magjistrale(Local)', 'Dukshmëri e lartë për biznese.', 180000, '/images/commercial/local1.jpg', 'Prizren', 'Magjistralja', 0, 1, 300, 1, 'Commercial', 'For Sale', 5),
('Lokal në Bazhdarhane(Local)', 'Zonë me shumë qarkullim këmbësorësh.', 130000, '/images/commercial/local9.jpg', 'Prizren', 'Bazhdarhane', 0, 1, 65, 0, 'Commercial', 'For Sale', 5),
('Objekt Komercial Arbana(Local)', 'Përdhesë dhe një kat, i përshtatshëm për depo.', 250000, '/images/commercial/local2.jpg', 'Prizren', 'Arbana', 0, 2, 450, 0, 'Commercial', 'For Sale', 5),
('Lokal në Qendrën Tregtare(Local)', 'Në katin e parë të qendrës kryesore.', 75000, '/images/commercial/local4.jpg', 'Prizren', 'Qendra', 0, 1, 40, 0, 'Commercial', 'For Sale', 5),
('Hapsirë për Klinikë(Local)', 'E ndarë në disa dhoma pune.', 160000, '/images/commercial/local10.jpg', 'Prizren', 'Qendra', 0, 2, 120, 1, 'Commercial', 'For Sale', 5),
('Lokal në Jaglenicë(Local)', 'I përshtatshëm për dyqan lagjeje.', 45000, '/images/commercial/local6.jpg', 'Prizren', 'Jaglenicë', 0, 1, 55, 0, 'Commercial', 'For Sale', 5),
('Depo Moderne Lubizhdë(Local)', 'Qasje e lehtë për transport të rëndë.', 140000, '/images/commercial/local8.jpg', 'Prizren', 'Lubizhdë', 0, 1, 400, 0, 'Commercial', 'For Sale', 5);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prizren', 'Shadërvan', 421), ('Prizren', 'Ortakoll', 422), ('Prizren', 'Qendra', 423), ('Prizren', 'Magjistralja', 424), ('Prizren', 'Bazhdarhane', 425),
('Prizren', 'Arbana', 426), ('Prizren', 'Qendra', 427), ('Prizren', 'Qendra', 428), ('Prizren', 'Jaglenicë', 429), ('Prizren', 'Lubizhdë', 430);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(421,1),(421,2),
(422,1),(422,2),
(423,1),(423,2),
(424,1),(424,2),
(425,1),(425,2),
(426,1),(426,2),
(427,1),(427,2),
(428,1),(428,2),
(429,1),(429,2),
(430,1),(430,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Korzën e Pejës(Local)', 'Pozitë strategjike në shëtitoren kryesore.', 280000, '/images/commercial/local4.jpg', 'Pejë', 'Qendra', 0, 1, 90, 1, 'Commercial', 'For Sale', 5),
('Zyre në Qendër(Local)', 'Hapsirë moderne në katin e dytë.', 85000, '/images/commercial/local8.jpg', 'Pejë', 'Qendra', 0, 1, 65, 0, 'Commercial', 'For Sale', 5),
('Lokal afër Çarshisë(Local)', 'I përshtatshëm për argjendari ose suvenire.', 120000, '/images/commercial/local1.jpg', 'Pejë', 'Qendra', 0, 1, 45, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Showroom Pejë(Local)', 'Buzë rrugës kryesore për Prishtinë.', 210000, '/images/commercial/local10.jpg', 'Pejë', 'Zona Industriale', 0, 1, 350, 1, 'Commercial', 'For Sale', 5),
('Lokal në Karagaç(Local)', 'Zonë e banuar, i përshtatshëm për market.', 140000, '/images/commercial/local6.jpg', 'Pejë', 'Karagaç', 0, 1, 120, 0, 'Commercial', 'For Sale', 5),
('Objekt Afarist Vitomiricë(Local)', 'I përshtatshëm për prodhim ose depo.', 320000, '/images/commercial/local3.jpg', 'Pejë', 'Vitomiricë', 0, 3, 1000, 1, 'Commercial', 'For Sale', 5),
('Lokal në katin përdhes(Local)', 'I renovuar dhe gati për punë.', 95000, '/images/commercial/local9.jpg', 'Pejë', 'Fidanishte', 0, 1, 75, 0, 'Commercial', 'For Sale', 5),
('Hapsirë për Fitnes(Local)', 'Sipërfaqe e madhe pa shtylla brenda.', 175000, '/images/commercial/local5.jpg', 'Pejë', 'Qendra', 0, 2, 250, 0, 'Commercial', 'For Sale', 5),
('Lokal i vogël për Zyre(Local)', 'Ideale për agjenci ose kontabilitet.', 52000, '/images/commercial/local2.jpg', 'Pejë', 'Qendra', 0, 1, 35, 0, 'Commercial', 'For Sale', 5),
('Depo në periferi(Local)', 'Qasje e lehtë dhe siguri maksimale.', 110000, '/images/commercial/local7.jpg', 'Pejë', 'Zahaq', 0, 1, 500, 0, 'Commercial', 'For Sale', 5);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Pejë', 'Qendra', 431), ('Pejë', 'Qendra', 432), ('Pejë', 'Qendra', 433), ('Pejë', 'Zona Industriale', 434), ('Pejë', 'Karagaç', 435),
('Pejë', 'Vitomiricë', 436), ('Pejë', 'Fidanishte', 437), ('Pejë', 'Qendra', 438), ('Pejë', 'Qendra', 439), ('Pejë', 'Zahaq', 440);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(431,1),(431,2),
(432,1),(432,2),
(433,1),(433,2),
(434,1),(434,2),
(435,1),(435,2),
(436,1),(436,2),
(437,1),(437,2),
(438,1),(438,2),
(439,1),(439,2),
(440,1),(440,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Qendër të Ferizajt(Local)', 'Lokacion me frekuentim maksimal, i përshtatshëm për çdo biznes.', 180000, '/images/commercial/local5.jpg', 'Ferizaj', 'Qendra', 0, 1, 85, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Zyre Moderne(Local)', 'Në katin e dytë të një objekti të ri afarist.', 75000, '/images/commercial/local9.jpg', 'Ferizaj', 'Qendra', 0, 1, 60, 0, 'Commercial', 'For Sale', 5),
('Lokal në Rrugën e Prishtinës(Local)', 'Ideale për showroom ose ekspozitë.', 250000, '/images/commercial/local7.jpg', 'Ferizaj', 'Magjistralja', 0, 1, 200, 1, 'Commercial', 'For Sale', 5),
('Depo Industriale Bibaj(Local)', 'Hapsirë e madhe me qasje për kamionë.', 120000, '/images/commercial/local2.jpg', 'Ferizaj', 'Bibaj', 0, 1, 450, 0, 'Commercial', 'For Sale', 5),
('Lokal afër Gjykatës(Local)', 'I përshtatshëm për zyre avokatie ose noteri.', 95000, '/images/commercial/local6.jpg', 'Ferizaj', 'Qendra', 0, 1, 55, 0, 'Commercial', 'For Sale', 5),
('Objekt Afarist Prelez(Local)', 'Objekt i pavarur buzë magjistrales.', 450000, '/images/commercial/local1.jpg', 'Ferizaj', 'Prelez', 0, 4, 1000, 1, 'Commercial', 'For Sale', 5),
('Lokal në katin përdhes(Local)', 'Dritare të mëdha xhami, i renovuar.', 110000, '/images/commercial/local10.jpg', 'Ferizaj', 'Talinoc', 0, 1, 75, 0, 'Commercial', 'For Sale', 5),
('Hapsirë për Barnatore(Local)', 'Afër spitalit të qytetit.', 130000, '/images/commercial/local4.jpg', 'Ferizaj', 'Qendra', 0, 1, 40, 1, 'Commercial', 'For Sale', 5),
('Lokal i vogël për Shërbime(Local)', 'Ideale për floktari ose rrobaqepësi.', 48000, '/images/commercial/local3.jpg', 'Ferizaj', 'Qendra', 0, 1, 30, 0, 'Commercial', 'For Sale', 5),
('Hapsirë Komerciale Muhoc(Local)', 'I përshtatshëm për market ose depo të vogël.', 85000, '/images/commercial/local8jpg', 'Ferizaj', 'Muhoc', 0, 1, 120, 0, 'Commercial', 'For Sale', 5);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Ferizaj', 'Qendra', 441), ('Ferizaj', 'Qendra', 442), ('Ferizaj', 'Magjistralja', 443), ('Ferizaj', 'Bibaj', 444), ('Ferizaj', 'Qendra', 445),
('Ferizaj', 'Prelez', 446), ('Ferizaj', 'Talinoc', 447), ('Ferizaj', 'Qendra', 448), ('Ferizaj', 'Qendra', 449), ('Ferizaj', 'Muhoc', 450);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(441,1),(441,2),
(442,1),(442,2),
(443,1),(443,2),
(444,1),(444,2),
(445,1),(445,2),
(446,1),(446,2),
(447,1),(447,2),
(448,1),(448,2),
(449,1),(449,2),
(450,1),(450,2);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Qendër të Gjilanit(Local)', 'Në zonën më të frekuentuar të qytetit.', 160000, '/images/commercial/local6.jpg', 'Gjilan', 'Qendra', 0, 1, 70, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Zyre në Dardani(Local)', 'Zyre moderne në lagjen Dardania.', 68000, '/images/commercial/local10.jpg', 'Gjilan', 'Dardania', 0, 1, 55, 0, 'Commercial', 'For Sale', 5),
('Lokal në Rrugën Qarkore(Local)', 'Ideale për biznese me nevojë për qasje të lehtë.', 140000, '/images/commercial/local4.jpg', 'Gjilan', 'Rruga Qarkore', 0, 1, 110, 1, 'Commercial', 'For Sale', 5),
('Showroom në Magjistrale(Local)', 'Buzë rrugës Gjilan-Prishtinë.', 280000, '/images/commercial/local1.jpg', 'Gjilan', 'Bresalc', 0, 2, 400, 1, 'Commercial', 'For Sale', 5),
('Lokal afër Universitetit(Local)', 'I përshtatshëm për kopjotirë ose kafiteri.', 85000, '/images/commercial/local8.jpg', 'Gjilan', 'Qendra', 0, 1, 45, 0, 'Commercial', 'For Sale', 5),
('Objekt Industrial Livoç(Local)', 'Hapsirë e madhe për prodhim ose depo.', 380000, '/images/commercial/local5.jpg', 'Gjilan', 'Livoç', 0, 3, 1200, 1, 'Commercial', 'For Sale', 5),
('Lokal në katin përdhes(Local)', 'Pozitë e mirë, i renovuar kohët e fundit.', 105000, '/images/commercial/local9.jpg', 'Gjilan', 'Qendra', 0, 1, 80, 0, 'Commercial', 'For Sale', 5),
('Hapsirë për Klinikë Private(Local)', 'Në një zonë të qetë dhe me qasje të lehtë.', 195000, '/images/commercial/local7.jpg', 'Gjilan', 'Qendra', 0, 2, 150, 1, 'Commercial', 'For Sale', 5),
('Lokal i vogël për Dyqan(Local)', 'Ideale për butik ose shitore lagjeje.', 52000, '/images/commercial/local3jpg', 'Gjilan', 'Dardania', 0, 1, 35, 0, 'Commercial', 'For Sale', 5),
('Hapsirë Komerciale Pasjak(Local)', 'I përshtatshëm për aktivitete të ndryshme biznesi.', 78000, '/images/commercial/local2.jpg', 'Gjilan', 'Pasjak', 0, 1, 100, 0, 'Commercial', 'For Sale', 5);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjilan', 'Qendra', 451), ('Gjilan', 'Dardania', 452), ('Gjilan', 'Rruga Qarkore', 453), ('Gjilan', 'Bresalc', 454), ('Gjilan', 'Qendra', 455),
('Gjilan', 'Livoç', 456), ('Gjilan', 'Qendra', 457), ('Gjilan', 'Qendra', 458), ('Gjilan', 'Dardania', 459), ('Gjilan', 'Pasjak', 460);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(451,1),(451,2),
(452,1),(452,2),
(453,1),(453,2),
(454,1),(454,2),
(455,1),(455,2),
(456,1),(456,2),
(457,1),(457,2),
(458,1),(458,2),
(459,1),(459,2),
(460,1),(460,2);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Qendër të Mitrovicës(Local)', 'Në zonën më të frekuentuar afër urës.', 120000, '/images/commercial/local7.jpg', 'Mitrovicë', 'Qendra', 0, 1, 65, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Zyre Shipol(Local)', 'Zyre moderne në katin e parë.', 55000, '/images/commercial/local1.jpg', 'Mitrovicë', 'Shipol', 0, 1, 50, 0, 'Commercial', 'For Sale', 5),
('Lokal në Tavnik(Local)', 'I përshtatshëm për market ose dyqan.', 85000, '/images/commercial/local4.jpg', 'Mitrovicë', 'Tavnik', 0, 1, 75, 1, 'Commercial', 'For Sale', 5),
('Showroom në Magjistrale(Local)', 'Dukshmëri e lartë për biznese auto ose mobilie.', 220000, '/images/commercial/local8.jpg', 'Mitrovicë', 'Shupkovc', 0, 1, 350, 1, 'Commercial', 'For Sale', 5),
('Lokal afër Gjykatës(Local)', 'I përshtatshëm për avokatë ose noterë.', 72000, '/images/commercial/local3.jpg', 'Mitrovicë', 'Qendra', 0, 1, 45, 0, 'Commercial', 'For Sale', 5),
('Objekt Industrial Frashër(Local)', 'Hapsirë e madhe për depo ose prodhim.', 350000, '/images/commercial/local5.jpg', 'Mitrovicë', 'Frashër', 0, 3, 1000, 1, 'Commercial', 'For Sale', 5),
('Lokal në katin përdhes(Local)', 'I renovuar kohët e fundit, gati për punë.', 95000, '/images/commercial/local9.jpg', 'Mitrovicë', 'Qendra', 0, 1, 80, 0, 'Commercial', 'For Sale', 5),
('Hapsirë për Klinikë Bair(Local)', 'Në një zonë të qetë dhe me qasje të lehtë.', 140000, '/images/commercial/local2.jpg', 'Mitrovicë', 'Bair', 0, 2, 120, 1, 'Commercial', 'For Sale', 5),
('Lokal i vogël për Shërbime(Local)', 'Ideale për floktari ose rrobaqepësi.', 38000, '/images/commercial/local10.jpg', 'Mitrovicë', 'Qendra', 0, 1, 30, 0, 'Commercial', 'For Sale', 5),
('Hapsirë Komerciale Zhabar(Local)', 'I përshtatshëm për aktivitete të ndryshme biznesi.', 65000, '/images/commercial/local6.jpg', 'Mitrovicë', 'Zhabar', 0, 1, 90, 0, 'Commercial', 'For Sale', 5);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Mitrovicë', 'Qendra', 461), ('Mitrovicë', 'Shipol', 462), ('Mitrovicë', 'Tavnik', 463), ('Mitrovicë', 'Shupkovc', 464), ('Mitrovicë', 'Qendra', 465),
('Mitrovicë', 'Frashër', 466), ('Mitrovicë', 'Qendra', 467), ('Mitrovicë', 'Bair', 468), ('Mitrovicë', 'Qendra', 469), ('Mitrovicë', 'Zhabar', 470);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(461,1),(461,2),
(462,1),(462,2),
(463,1),(463,2),
(464,1),(464,2),
(465,1),(465,2),
(466,1),(466,2),
(467,1),(467,2),
(468,1),(468,2),
(469,1),(469,2),
(470,1),(470,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Çarshinë e Vjetër(Local)', 'Lokacion unik në zonën historike.', 180000, '/images/commercial/local8.jpg', 'Gjakovë', 'Çarshia e Vjetër', 0, 1, 60, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Zyre në Qendër(Local)', 'Zyre moderne në një nga objektet e reja.', 85000, '/images/commercial/local3.jpg', 'Gjakovë', 'Qendra', 0, 1, 70, 0, 'Commercial', 'For Sale', 5),
('Lokal në Bllokun e Ri(Local)', 'Zonë me zhvillim të shpejtë dhe shumë biznese.', 145000, '/images/commercial/local10.jpg', 'Gjakovë', 'Blloku i Ri', 0, 1, 95, 1, 'Commercial', 'For Sale', 5),
('Showroom në Rrugën e Gasit(Local)', 'Dukshmëri e lartë buzë rrugës kryesore.', 250000, '/images/commercial/local6.jpg', 'Gjakovë', 'Rruga e Gasit', 0, 1, 300, 1, 'Commercial', 'For Sale', 5),
('Lokal afër Spitalit(Local)', 'I përshtatshëm për barnatore ose laborator.', 110000, '/images/commercial/local1.jpg', 'Gjakovë', 'Qendra', 0, 1, 50, 0, 'Commercial', 'For Sale', 5),
('Objekt Afarist Shkugëz(Local)', 'Hapsirë e madhe për depo apo veprimtari industriale.', 310000, '/images/commercial/local9.jpg', 'Gjakovë', 'Shkugëz', 0, 3, 900, 1, 'Commercial', 'For Sale', 5),
('Lokal në katin përdhes(Local)', 'Dritare të mëdha xhami, lokacion shume i frekuentuar.', 98000, '/images/commercial/local5.jpg', 'Gjakovë', 'Qendra', 0, 1, 65, 0, 'Commercial', 'For Sale', 5),
('Hapsirë për Klinikë(Local)', 'E ndarë në ambiente pune me qasje praktike.', 165000, '/images/commercial/local4.jpg', 'Gjakovë', 'Blloku i Ri', 0, 2, 130, 1, 'Commercial', 'For Sale', 5),
('Lokal i vogël për Zyren tuaj(Local)', 'Ideale për agjenci apo shërbime kontabiliteti.', 42000, '/images/commercial/local2.jpg', 'Gjakovë', 'Qendra', 0, 1, 30, 0, 'Commercial', 'For Sale', 5),
('Depo Komerciale Brekoc(Local)', 'Qasje e lehtë për mjetet e transportit të rëndë.', 125000, '/images/commercial/local7.jpg', 'Gjakovë', 'Brekoc', 0, 1, 450, 0, 'Commercial', 'For Sale', 5);

-- Adresat
INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjakovë', 'Çarshia e Vjetër', 471), ('Gjakovë', 'Qendra', 472), ('Gjakovë', 'Blloku i Ri', 473), ('Gjakovë', 'Rruga e Gasit', 474), ('Gjakovë', 'Qendra', 475),
('Gjakovë', 'Shkugëz', 476), ('Gjakovë', 'Qendra', 477), ('Gjakovë', 'Blloku i Ri', 478), ('Gjakovë', 'Qendra', 479), ('Gjakovë', 'Brekoc', 480);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(471,1),(471,2),
(472,1),(472,2),
(473,1),(473,2),
(474,1),(474,2),
(475,1),(475,2),
(476,1),(476,2),
(477,1),(477,2),
(478,1),(478,2),
(479,1),(479,2),
(480,1),(480,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Qendër të Fushë Kosovës(Local)', 'Lokacion me frekuentim të lartë, i përshtatshëm për market.', 150000, '/images/commercial/local9.jpg', 'Fushë Kosovë', 'Qendra', 0, 1, 120, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Zyre në Dardani(Local)', 'Zyre moderne në një zonë me shumë ndërtime të reja.', 78000, '/images/commercial/local4.jpg', 'Fushë Kosovë', 'Dardania', 0, 1, 65, 0, 'Commercial', 'For Sale', 5),
('Lokal buzë Rrugës së Pejës(Local)', 'Ideale për showroom ose ekspozitë produktesh.', 220000, '/images/commercial/local7.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 0, 1, 180, 1, 'Commercial', 'For Sale', 5),
('Depo Industriale FK(Local)', 'Hapsirë e madhe me qasje për kamionë të rëndë.', 135000, '/images/commercial/local10.jpg', 'Fushë Kosovë', 'Zona Industriale', 0, 1, 500, 1, 'Commercial', 'For Sale', 5),
('Lokal afër Stacionit të Trenit(Local)', 'I përshtatshëm për dyqan ose zyre shërbimesh.', 65000, '/images/commercial/local2.jpg', 'Fushë Kosovë', 'Qendra', 0, 1, 50, 0, 'Commercial', 'For Sale', 5),
('Objekt Afarist Uglar(Local)', 'Objekt i pavarur, i përshtatshëm për institucione.', 480000, '/images/commercial/local5.jpg', 'Fushë Kosovë', 'Uglar', 0, 4, 1200, 1, 'Commercial', 'For Sale', 5),
('Lokal në katin përdhes(Local)', 'Dritare të mëdha xhami, dukshmëri e shkëlqyer.', 115000, '/images/commercial/local8.jpg', 'Fushë Kosovë', 'Dardania', 0, 1, 90, 0, 'Commercial', 'For Sale', 5),
('Hapsirë për Barnatore FK(Local)', 'Lokacion kyç afër qendrës mjekësore.', 95000, '/images/commercial/local1.jpg', 'Fushë Kosovë', 'Qendra', 0, 1, 45, 1, 'Commercial', 'For Sale', 5),
('Lokal i vogël për Zyre(Local)', 'Ideale për agjenci ose kontabilitet.', 42000, '/images/commercial/local6.jpg', 'Fushë Kosovë', 'Bresje', 0, 1, 35, 0, 'Commercial', 'For Sale', 5),
('Hapsirë Komerciale Miradi(Local)', 'I përshtatshëm për depo ose prodhim të lehtë.', 88000, '/images/commercial/local3.jpg', 'Fushë Kosovë', 'Miradi', 0, 1, 250, 0, 'Commercial', 'For Sale', 5);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Fushë Kosovë', 'Qendra', 481), ('Fushë Kosovë', 'Dardania', 482), ('Fushë Kosovë', 'Rruga e Pejës', 483), ('Fushë Kosovë', 'Zona Industriale', 484), ('Fushë Kosovë', 'Qendra', 485),
('Fushë Kosovë', 'Uglar', 486), ('Fushë Kosovë', 'Dardania', 487), ('Fushë Kosovë', 'Qendra', 488), ('Fushë Kosovë', 'Bresje', 489), ('Fushë Kosovë', 'Miradi', 490);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(481,1),(481,2),
(482,1),(482,2),
(483,1),(483,2),
(484,1),(484,2),
(485,1),(485,2),
(486,1),(486,2),
(487,1),(487,2),
(488,1),(488,2),
(489,1),(489,2),
(490,1),(490,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Lokal në Qendër të Podujevës(Local)', 'Lokacioni më i mirë në qytet, i përshtatshëm për butik.', 95000, '/images/commercial/local10.jpg', 'Podujevë', 'Qendra', 0, 1, 75, 1, 'Commercial', 'For Sale', 5),
('Hapsirë për Zyre Besiana(Local)', 'Zyre moderne në një nga objektet e reja.', 62000, '/images/commercial/local3.jpg', 'Podujevë', 'Besiana', 0, 1, 60, 0, 'Commercial', 'For Sale', 5),
('Lokal buzë Rrugës Magjistrale(Local)', 'Ideale për showroom auto ose mobilie.', 180000, '/images/commercial/local7.jpg', 'Podujevë', 'Besiana', 0, 1, 250, 1, 'Commercial', 'For Sale', 5),
('Depo Industriale Podujevë(Local)', 'Hapsirë e madhe për magazinim afër qytetit.', 110000, '/images/commercial/local5.jpg', 'Podujevë', 'Zona Industriale', 0, 1, 400, 1, 'Commercial', 'For Sale', 5),
('Lokal afër Shkollës(Local)', 'I përshtatshëm për librari ose kafiteri.', 55000, '/images/commercial/local8.jpg', 'Podujevë', 'Qendra', 0, 1, 45, 0, 'Commercial', 'For Sale', 5),
('Objekt Afarist Gllamnik(Local)', 'Objekt i pavarur buzë rrugës Prishtinë-Podujevë.', 350000, '/images/commercial/local1.jpg', 'Podujevë', 'Gllamnik', 0, 4, 900, 1, 'Commercial', 'For Sale', 5),
('Lokal në katin përdhes(Local)', 'I renovuar dhe gati për punë, qasje e lehtë.', 85000, '/images/commercial/local9.jpg', 'Podujevë', 'Besiana', 0, 1, 70, 0, 'Commercial', 'For Sale', 5),
('Hapsirë për Klinikë Private(Local)', 'Në një zonë të qetë dhe të përshtatshme.', 145000, '/images/commercial/local2.jpg', 'Podujevë', 'Besiana', 0, 2, 130, 1, 'Commercial', 'For Sale', 5),
('Lokal i vogël praktik(Local)', 'Ideale për zyre të vogël ose shërbime.', 38000, '/images/commercial/local6.jpg', 'Podujevë', 'Qendra', 0, 1, 30, 0, 'Commercial', 'For Sale', 5),
('Hapsirë Komerciale Siboc(Local)', 'I përshtatshëm për aktivitete të ndryshme biznesi.', 72000, '/images/commercial/local4.jpg', 'Podujevë', 'Siboc', 0, 1, 100, 0, 'Commercial', 'For Sale', 5);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Podujevë', 'Qendra', 491), ('Podujevë', 'Besiana', 492), ('Podujevë', 'Besiana', 493), ('Podujevë', 'Zona Industriale', 494), ('Podujevë', 'Qendra', 495),
('Podujevë', 'Gllamnik', 496), ('Podujevë', 'Besiana', 497), ('Podujevë', 'Besiana', 498), ('Podujevë', 'Qendra', 499), ('Podujevë', 'Siboc', 500);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(491,1),(491,2),
(492,1),(492,2),
(493,1),(493,2),
(494,1),(494,2),
(495,1),(495,2),
(496,1),(496,2),
(497,1),(497,2),
(498,1),(498,2),
(499,1),(499,2),
(500,1),(500,2);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Shtëpi Moderne në Drenas(House)', 'Shtëpi e re me kopsht të madh dhe rrethojë.', 125000, '/images/houses/house1.jpg', 'Drenas', 'Qendra', 4, 2, 220, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Komoran(House)', 'Ambient i qetë, afër shkollës fillore.', 95000, '/images/houses/house2.jpg', 'Drenas', 'Komoran', 3, 1, 180, 0, 'House', 'For Sale', 6),
('Vila në Zabel(House)', 'Shtëpi luksoze me dizajn modern dhe pishinë.', 180000, '/images/houses/house3.jpg', 'Drenas', 'Zabel', 5, 3, 300, 1, 'House', 'For Sale', 6),
('Shtëpi Tradicionale(House)', 'Shtëpi e mirëmbajtur me oborr të gjelbëruar.', 75000, '/images/houses/house4.jpg', 'Drenas', 'Gllogoc', 3, 1, 150, 0, 'House', 'For Sale', 6),
('Shtëpi dykatëshe në Qendër(House)', 'Ideale për familje të mëdha, qasje e lehtë.', 140000, '/images/houses/house5.jpg', 'Drenas', 'Qendra', 5, 2, 250, 1, 'House', 'For Sale', 6),
('Shtëpi e re në Çikatovë(House)', 'Ndërtim cilësor, izolim termik modern.', 110000, '/images/houses/house6.jpg', 'Drenas', 'Çikatovë', 4, 2, 200, 0, 'House', 'For Sale', 6),
('Shtëpi me Oborr të madh(House)', 'Sipërfaqe e mjaftueshme për kopshtari.', 88000, '/images/houses/house7.jpg', 'Drenas', 'Polluzhë', 3, 1, 160, 0, 'House', 'For Sale', 6),
('Vila Moderne Drenas(House)', 'Arkitekturë bashkëkohore, hapsirë e hapur.', 165000, '/images/houses/house8.jpg', 'Drenas', 'Qendra', 4, 2, 280, 1, 'House', 'For Sale', 6),
('Shtëpi në periferi(House)', 'Ajër i pastër dhe qetësi maksimale.', 82000, '/images/houses/house9.jpg', 'Drenas', 'Koritë', 3, 1, 140, 0, 'House', 'For Sale', 6),
('Shtëpi Ekskluzive(House)', 'Investim i lartë, materiale cilësore.', 195000, '/images/houses/house10.jpg', 'Drenas', 'Qendra', 5, 3, 350, 1, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Drenas', 'Qendra', 501), ('Drenas', 'Komoran', 502), ('Drenas', 'Zabel', 503), ('Drenas', 'Gllogoc', 504), ('Drenas', 'Qendra', 505),
('Drenas', 'Çikatovë', 506), ('Drenas', 'Polluzhë', 507), ('Drenas', 'Qendra', 508), ('Drenas', 'Koritë', 509), ('Drenas', 'Qendra', 510);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(501,1),(501,2),(501,3),(501,4),(501,5),(501,6),
(502,1),(502,2),(502,3),(502,4),(502,5),(502,6),
(503,1),(503,2),(503,3),(503,4),(503,5),(503,6),
(504,1),(504,2),(504,3),(504,4),(504,5),(504,6),
(505,1),(505,2),(505,3),(505,4),(505,5),(505,6),
(506,1),(506,2),(506,3),(506,4),(506,5),(506,6),
(507,1),(507,2),(507,3),(507,4),(507,5),(507,6),
(508,1),(508,2),(508,3),(508,4),(508,5),(508,6),
(509,1),(509,2),(509,3),(509,4),(509,5),(509,6),
(510,1),(510,2),(510,3),(510,4),(510,5),(510,6);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Vila në Veternik(House)', 'Shtëpi luksoze me pamje nga Prishtina.', 350000, '/images/houses/house2.jpg', 'Prishtinë', 'Veternik', 5, 3, 350, 1, 'House', 'For Sale', 6),
('Shtëpi në Çagllavicë(House)', 'Zonë elitare, lagje e mbyllur dhe e sigurt.', 280000, '/images/houses/house4.jpg', 'Prishtinë', 'Çagllavicë', 4, 2, 280, 1, 'House', 'For Sale', 6),
('Shtëpi Moderne në Taslixhe(House)', 'Lokacion shumë i kërkuar, dizajn unik.', 420000, '/images/houses/house9.jpg', 'Prishtinë', 'Taslixhe', 5, 3, 400, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Mat(House)', 'Hapsirë e bollshme dhe oborr i rregulluar.', 195000, '/images/houses/house6.jpg', 'Prishtinë', 'Mat', 4, 2, 240, 0, 'House', 'For Sale', 6),
('Vila në Sofali(House)', 'Afër parkut të Gërmisë, ajër i pastër.', 310000, '/images/houses/house8.jpg', 'Prishtinë', 'Sofali', 4, 2, 260, 1, 'House', 'For Sale', 6),
('Shtëpi në Dragodan(House)', 'Pamje spektakolare, hapsirë për zyre dhe banim.', 450000, '/images/houses/house3.jpg', 'Prishtinë', 'Arbëria', 6, 4, 450, 1, 'House', 'For Sale', 6),
('Shtëpi në Hajvali(House)', 'Afër liqenit, qetësi dhe komoditet.', 160000, '/images/houses/house10.jpg', 'Prishtinë', 'Hajvali', 3, 2, 180, 0, 'House', 'For Sale', 6),
('Vila Moderne në Bërnicë(House)', 'Lagje e re me vila moderne.', 240000, '/images/houses/house1.jpg', 'Prishtinë', 'Bërnicë', 4, 2, 220, 1, 'House', 'For Sale', 6),
('Shtëpi në Kolovicë(House)', 'Pozitë e lartë, shtëpi e re dhe moderne.', 175000, '/images/houses/house5.jpg', 'Prishtinë', 'Kolovicë', 4, 2, 210, 0, 'House', 'For Sale', 6),
('Shtëpi në Shkabaj(House)', 'Qasje e shpejtë në autostradë, oborr i madh.', 150000, '/images/houses/house7.jpg', 'Prishtinë', 'Shkabaj', 3, 2, 190, 0, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prishtinë', 'Veternik', 511), ('Prishtinë', 'Çagllavicë', 512), ('Prishtinë', 'Taslixhe', 513), ('Prishtinë', 'Mat', 514), ('Prishtinë', 'Sofali', 515),
('Prishtinë', 'Arbëria', 516), ('Prishtinë', 'Hajvali', 517), ('Prishtinë', 'Bërnicë', 518), ('Prishtinë', 'Kolovicë', 519), ('Prishtinë', 'Shkabaj', 520);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(511,1),(511,2),(511,3),(511,4),(511,5),(511,6),
(512,1),(512,2),(512,3),(512,4),(512,5),(512,6),
(513,1),(513,2),(513,3),(513,4),(513,5),(513,6),
(514,1),(514,2),(514,3),(514,4),(514,5),(514,6),
(515,1),(515,2),(515,3),(515,4),(515,5),(515,6),
(516,1),(516,2),(516,3),(516,4),(516,5),(516,6),
(517,1),(517,2),(517,3),(517,4),(517,5),(517,6),
(518,1),(518,2),(518,3),(518,4),(518,5),(518,6),
(519,1),(519,2),(519,3),(519,4),(519,5),(519,6),
(520,1),(520,2),(520,3),(520,4),(520,5),(520,6);



INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Shtëpi Tradicionale Prizrenase(House)', 'Shtëpi e renovuar me stil në zonën historike.', 145000, '/images/houses/house3.jpg', 'Prizren', 'Qendra', 4, 2, 180, 1, 'House', 'For Sale', 6),
('Vila Moderne në Ortakoll(House)', 'Shtëpi e re me dizajn bashkëkohor dhe kopsht.', 220000, '/images/houses/house9.jpg', 'Prizren', 'Ortakoll', 5, 3, 280, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Jaglenicë(House)', 'Lagje e qetë, ideale për familje me fëmijë.', 115000, '/images/houses/house6.jpg', 'Prizren', 'Jaglenicë', 4, 2, 200, 0, 'House', 'For Sale', 6),
('Vila në Prevallë(House)', 'Shtëpi malore, perfekte për pushime dhe rekreacion.', 165000, '/images/houses/house1.jpg', 'Prizren', 'Prevallë', 3, 2, 150, 1, 'House', 'For Sale', 6),
('Shtëpi me pamje nga Kalaja(House)', 'Pozitë e lartë me pamje mahnitëse të qytetit.', 185000, '/images/houses/house4.jpg', 'Prizren', 'Qendra', 4, 2, 220, 1, 'House', 'For Sale', 6),
('Shtëpi e re në Arbanë(House)', 'Ndërtim cilësor, oborr i madh dhe i rregulluar.', 130000, '/images/houses/house8.jpg', 'Prizren', 'Arbana', 4, 2, 210, 0, 'House', 'For Sale', 6),
('Shtëpi dykatëshe në Lubizhdë(House)', 'Hapsirë e bollshme, qasje e lehtë në magjistrale.', 140000, '/images/houses/house2.jpg', 'Prizren', 'Lubizhdë', 5, 2, 260, 0, 'House', 'For Sale', 6),
('Vila Luksoze Prizren(House)', 'Materiale premium, sistem smart-home.', 320000, '/images/houses/house10.jpg', 'Prizren', 'Qendra', 5, 3, 350, 1, 'House', 'For Sale', 6),
('Shtëpi në Korishë(House)', 'Ambient fshati me komoditet qyteti.', 95000, '/images/houses/house7.jpg', 'Prizren', 'Korishë', 3, 1, 160, 0, 'House', 'For Sale', 6),
('Shtëpi në Vlashnje(House)', 'Afër autostradës, oborr i gjerë dhe i gjelbëruar.', 105000, '/images/houses/house5.jpg', 'Prizren', 'Vlashnje', 4, 2, 190, 0, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Prizren', 'Qendra', 521), ('Prizren', 'Ortakoll', 522), ('Prizren', 'Jaglenicë', 523), ('Prizren', 'Prevallë', 524), ('Prizren', 'Qendra', 525),
('Prizren', 'Arbana', 526), ('Prizren', 'Lubizhdë', 527), ('Prizren', 'Qendra', 528), ('Prizren', 'Korishë', 529), ('Prizren', 'Vlashnje', 530);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(521,1),(521,2),(521,3),(521,4),(521,5),(521,6),
(522,1),(522,2),(522,3),(522,4),(522,5),(522,6),
(523,1),(523,2),(523,3),(523,4),(523,5),(523,6),
(524,1),(524,2),(524,3),(524,4),(524,5),(524,6),
(525,1),(525,2),(525,3),(525,4),(525,5),(525,6),
(526,1),(526,2),(526,3),(526,4),(526,5),(526,6),
(527,1),(527,2),(527,3),(527,4),(527,5),(527,6),
(528,1),(528,2),(528,3),(528,4),(528,5),(528,6),
(529,1),(529,2),(529,3),(529,4),(529,5),(529,6),
(530,1),(530,2),(530,3),(530,4),(530,5),(530,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Vila në Grykën e Rugovës(House)', 'Shtëpi përrallore në mes të natyrës dhe maleve.', 250000, '/images/houses/house4.jpg', 'Pejë', 'Rugovë', 4, 2, 200, 1, 'House', 'For Sale', 6),
('Shtëpi Moderne në Karagaç(House)', 'Zonë elitare afër parkut të qytetit.', 280000, '/images/houses/house10.jpg', 'Pejë', 'Karagaç', 5, 3, 320, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Fidanishte(House)', 'Lagje e qetë dhe e urbanizuar mirë.', 145000, '/images/houses/house1.jpg', 'Pejë', 'Fidanishte', 4, 2, 220, 0, 'House', 'For Sale', 6),
('Shtëpi e re në Vitomiricë(House)', 'Oborr i madh, shtëpi e re me izolim modern.', 120000, '/images/houses/house6.jpg', 'Pejë', 'Vitomiricë', 4, 2, 200, 0, 'House', 'For Sale', 6),
('Vila Panorama Pejë(House)', 'Pamje spektakolare mbi qytet dhe rrafshin e Dukagjinit.', 310000, '/images/houses/house3.jpg', 'Pejë', 'Brestovik', 5, 3, 300, 1, 'House', 'For Sale', 6),
('Shtëpi Tradicionale Pejane(House)', 'Shtëpi me kopsht të bukur në qendër të qytetit.', 160000, '/images/houses/house9.jpg', 'Pejë', 'Qendra', 4, 2, 180, 0, 'House', 'For Sale', 6),
('Shtëpi në Raushiq(House)', 'Ambient i qetë, ideale për jetesë familjare.', 95000, '/images/houses/house2.jpg', 'Pejë', 'Raushiq', 3, 1, 160, 0, 'House', 'For Sale', 6),
('Vila Moderne Pejë(House)', 'Arkitekturë unike, dritare të mëdha, ndriçim natyral.', 240000, '/images/houses/house5.jpg', 'Pejë', 'Qendra', 4, 2, 250, 1, 'House', 'For Sale', 6),
('Shtëpi në Zahaq(House)', 'Afër rrugës kryesore, qasje e lehtë dhe oborr i gjerë.', 110000, '/images/houses/house7.jpg', 'Pejë', 'Zahaq', 4, 2, 210, 0, 'House', 'For Sale', 6),
('Shtëpi Ekskluzive Karagaç(House)', 'Investim luksoz në lagjen më të mirë të Pejës.', 350000, '/images/houses/house8.jpg', 'Pejë', 'Karagaç', 6, 4, 400, 1, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Pejë', 'Rugovë', 531), ('Pejë', 'Karagaç', 532), ('Pejë', 'Fidanishte', 533), ('Pejë', 'Vitomiricë', 534), ('Pejë', 'Brestovik', 535),
('Pejë', 'Qendra', 536), ('Pejë', 'Raushiq', 537), ('Pejë', 'Qendra', 538), ('Pejë', 'Zahaq', 539), ('Pejë', 'Karagaç', 540);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(531,1),(531,2),(531,3),(531,4),(531,5),(531,6),
(532,1),(532,2),(532,3),(532,4),(532,5),(532,6),
(533,1),(533,2),(533,3),(533,4),(533,5),(533,6),
(534,1),(534,2),(534,3),(534,4),(534,5),(534,6),
(535,1),(535,2),(535,3),(535,4),(535,5),(535,6),
(536,1),(536,2),(536,3),(536,4),(536,5),(536,6),
(537,1),(537,2),(537,3),(537,4),(537,5),(537,6),
(538,1),(538,2),(538,3),(538,4),(538,5),(538,6),
(539,1),(539,2),(539,3),(539,4),(539,5),(539,6),
(540,1),(540,2),(540,3),(540,4),(540,5),(540,6);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Shtëpi Moderne në Ferizaj(House)', 'Shtëpi e re me arkitekturë moderne dhe oborr të rregulluar.', 135000, '/images/houses/house5.jpg', 'Ferizaj', 'Qendra', 4, 2, 220, 1, 'House', 'For Sale', 6),
('Vila në Jezerc(House)', 'Shtëpi malore me pamje mahnitëse, ideale për pushime.', 175000, '/images/houses/house1.jpg', 'Ferizaj', 'Jezerc', 3, 2, 160, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Talinoc(House)', 'Lagje e qetë, shtëpi e bollshme për familje.', 110000, '/images/houses/house9.jpg', 'Ferizaj', 'Talinoc', 4, 2, 200, 0, 'House', 'For Sale', 6),
('Shtëpi e re në Muhoc(House)', 'Ndërtim cilësor me materiale moderne dhe kopsht.', 125000, '/images/houses/house3.jpg', 'Ferizaj', 'Muhoc', 4, 2, 210, 0, 'House', 'For Sale', 6),
('Vila Luksoze Ferizaj(House)', 'Shtëpi ekskluzive me pishinë dhe sistem smart-home.', 290000, '/images/houses/house7.jpg', 'Ferizaj', 'Qendra', 5, 3, 350, 1, 'House', 'For Sale', 6),
('Shtëpi dykatëshe në Qendër(House)', 'Pozitë e shkëlqyer, afër të gjitha shërbimeve.', 155000, '/images/houses/house10.jpg', 'Ferizaj', 'Qendra', 5, 2, 260, 1, 'House', 'For Sale', 6),
('Shtëpi në periferi të qytetit(House)', 'Ajër i pastër, qetësi dhe oborr i gjerë.', 95000, '/images/houses/house8.jpg', 'Ferizaj', 'Prelez', 3, 1, 150, 0, 'House', 'For Sale', 6),
('Shtëpi Moderne Bibaj(House)', 'Afër magjistrales, shtëpi e re dhe funksionale.', 118000, '/images/houses/house2.jpg', 'Ferizaj', 'Bibaj', 4, 2, 190, 0, 'House', 'For Sale', 6),
('Shtëpi me dizajn unik(House)', 'Arkitekturë bashkëkohore, ndriçim natyral i lartë.', 160000, '/images/houses/house4.jpg', 'Ferizaj', 'Qendra', 4, 2, 230, 1, 'House', 'For Sale', 6),
('Vila Elegante Ferizaj(House)', 'Shtëpi luksoze në njërën nga lagjet më të mira.', 245000, '/images/houses/house6.jpg', 'Ferizaj', 'Qendra', 5, 3, 310, 1, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Ferizaj', 'Qendra', 541), ('Ferizaj', 'Jezerc', 542), ('Ferizaj', 'Talinoc', 543), ('Ferizaj', 'Muhoc', 544), ('Ferizaj', 'Qendra', 545),
('Ferizaj', 'Qendra', 546), ('Ferizaj', 'Prelez', 547), ('Ferizaj', 'Bibaj', 548), ('Ferizaj', 'Qendra', 549), ('Ferizaj', 'Qendra', 550);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(541,1),(541,2),(541,3),(541,4),(541,5),(541,6),
(542,1),(542,2),(542,3),(542,4),(542,5),(542,6),
(543,1),(543,2),(543,3),(543,4),(543,5),(543,6),
(544,1),(544,2),(544,3),(544,4),(544,5),(544,6),
(545,1),(545,2),(545,3),(545,4),(545,5),(545,6),
(546,1),(546,2),(546,3),(546,4),(546,5),(546,6),
(547,1),(547,2),(547,3),(547,4),(547,5),(547,6),
(548,1),(548,2),(548,3),(548,4),(548,5),(548,6),
(549,1),(549,2),(549,3),(549,4),(549,5),(549,6),
(550,1),(550,2),(550,3),(550,4),(550,5),(550,6);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Shtëpi Moderne në Gjilan(House)', 'Shtëpi e re në lagjen Dardania, dizajn bashkëkohor.', 130000, '/images/houses/house6.jpg', 'Gjilan', 'Dardania', 4, 2, 210, 1, 'House', 'For Sale', 6),
('Vila në Përlepnicë(House)', 'Afër liqenit, ambient i qetë dhe ajër i pastër.', 165000, '/images/houses/house2.jpg', 'Gjilan', 'Përlepnicë', 4, 2, 230, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Livoç(House)', 'Shtëpi e bollshme me oborr të madh dhe kopsht.', 115000, '/images/houses/house10.jpg', 'Gjilan', 'Livoç', 4, 2, 200, 0, 'House', 'For Sale', 6),
('Shtëpi e re në Malishevë(House)', 'Ndërtim cilësor, qasje e lehtë në rrugën kryesore.', 105000, '/images/houses/house4.jpg', 'Gjilan', 'Malishevë', 4, 2, 190, 0, 'House', 'For Sale', 6),
('Vila Luksoze Gjilan(House)', 'Shtëpi ekskluzive me materiale premium dhe pishinë.', 280000, '/images/houses/house7.jpg', 'Gjilan', 'Qendra', 5, 3, 340, 1, 'House', 'For Sale', 6),
('Shtëpi dykatëshe në Qarkore(House)', 'Pozitë e mirë, shtëpi e renovuar dhe komode.', 140000, '/images/houses/house1.jpg', 'Gjilan', 'Rruga Qarkore', 5, 2, 250, 1, 'House', 'For Sale', 6),
('Shtëpi në lagjen e qetë(House)', 'Ideale për jetesë familjare, larg zhurmës.', 98000, '/images/houses/house8.jpg', 'Gjilan', 'Pasjak', 3, 1, 160, 0, 'House', 'For Sale', 6),
('Vila Moderne Gjilan(House)', 'Arkitekturë moderne, hapsira të hapura dhe ndriçim.', 195000, '/images/houses/house3.jpg', 'Gjilan', 'Dardania', 4, 2, 260, 1, 'House', 'For Sale', 6),
('Shtëpi në periferi(House)', 'Oborr i gjerë, e përshtatshme për kopshtari.', 85000, '/images/houses/house5.jpg', 'Gjilan', 'Kufcë', 3, 1, 140, 0, 'House', 'For Sale', 6),
('Shtëpi Ekskluzive Gjilan(House)', 'Investim i lartë në njërën nga zonat më të mira.', 220000, '/images/houses/house9.jpg', 'Gjilan', 'Qendra', 5, 2, 300, 1, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjilan', 'Dardania', 551), ('Gjilan', 'Përlepnicë', 552), ('Gjilan', 'Livoç', 553), ('Gjilan', 'Malishevë', 554), ('Gjilan', 'Qendra', 555),
('Gjilan', 'Rruga Qarkore', 556), ('Gjilan', 'Pasjak', 557), ('Gjilan', 'Dardania', 558), ('Gjilan', 'Kufcë', 559), ('Gjilan', 'Qendra', 560);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(551,1),(551,2),(551,3),(551,4),(551,5),(551,6),
(552,1),(552,2),(552,3),(552,4),(552,5),(552,6),
(553,1),(553,2),(553,3),(553,4),(553,5),(553,6),
(554,1),(554,2),(554,3),(554,4),(554,5),(554,6),
(555,1),(555,2),(555,3),(555,4),(555,5),(555,6),
(556,1),(556,2),(556,3),(556,4),(556,5),(556,6),
(557,1),(557,2),(557,3),(557,4),(557,5),(557,6),
(558,1),(558,2),(558,3),(558,4),(558,5),(558,6),
(559,1),(559,2),(559,3),(559,4),(559,5),(559,6),
(560,1),(560,2),(560,3),(560,4),(560,5),(560,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Shtëpi Moderne në Shipol(House)', 'Shtëpi e re me dizajn bashkëkohor dhe oborr të rregulluar.', 115000, '/images/houses/house7.jpg', 'Mitrovicë', 'Shipol', 4, 2, 200, 1, 'House', 'For Sale', 6),
('Vila në Bair(House)', 'Pamje e mrekullueshme e qytetit, hapsirë e bollshme.', 145000, '/images/houses/house1.jpg', 'Mitrovicë', 'Bair', 5, 2, 250, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Tavnik(House)', 'Lagje e qetë, ideale për jetesë familjare.', 98000, '/images/houses/house4.jpg', 'Mitrovicë', 'Tavnik', 4, 2, 180, 0, 'House', 'For Sale', 6),
('Shtëpi e re në Shupkovc(House)', 'Ndërtim cilësor, qasje e lehtë në rrugën kryesore.', 105000, '/images/houses/house9.jpg', 'Mitrovicë', 'Shupkovc', 4, 2, 190, 0, 'House', 'For Sale', 6),
('Vila Luksoze Mitrovicë(House)', 'Shtëpi ekskluzive me materiale premium dhe kopsht.', 220000, '/images/houses/house7.jpg', 'Mitrovicë', 'Qendra', 5, 3, 320, 1, 'House', 'For Sale', 6),
('Shtëpi dykatëshe në Iliridë(House)', 'Hapsirë e madhe, e përshtatshme për dy familje.', 130000, '/images/houses/house3.jpg', 'Mitrovicë', 'Ilirida', 6, 3, 280, 1, 'House', 'For Sale', 6),
('Shtëpi në Zhabar(House)', 'Ambient i qetë, oborr i gjerë dhe i gjelbëruar.', 88000, '/images/houses/house8.jpg', 'Mitrovicë', 'Zhabar', 3, 1, 150, 0, 'House', 'For Sale', 6),
('Vila Moderne Mitrovicë(House)', 'Arkitekturë moderne, ndriçim natyral i lartë.', 175000, '/images/houses/house10.jpg', 'Mitrovicë', 'Qendra', 4, 2, 240, 1, 'House', 'For Sale', 6),
('Shtëpi në Tunelin e Parë(House)', 'Zonë malore, ajër i pastër dhe qetësi.', 75000, '/images/houses/house7.jpg', 'Mitrovicë', 'Tuneli i Parë', 3, 1, 140, 0, 'House', 'For Sale', 6),
('Shtëpi Ekskluzive Bair(House)', 'Investim i lartë në njërën nga zonat më të mira.', 195000, '/images/houses/house6.jpg', 'Mitrovicë', 'Bair', 5, 2, 300, 1, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Mitrovicë', 'Shipol', 561), ('Mitrovicë', 'Bair', 562), ('Mitrovicë', 'Tavnik', 563), ('Mitrovicë', 'Shupkovc', 564), ('Mitrovicë', 'Qendra', 565),
('Mitrovicë', 'Ilirida', 566), ('Mitrovicë', 'Zhabar', 567), ('Mitrovicë', 'Qendra', 568), ('Mitrovicë', 'Tuneli i Parë', 569), ('Mitrovicë', 'Bair', 570);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(561,1),(561,2),(561,3),(561,4),(561,5),(561,6),
(562,1),(562,2),(562,3),(562,4),(562,5),(562,6),
(563,1),(563,2),(563,3),(563,4),(563,5),(563,6),
(564,1),(564,2),(564,3),(564,4),(564,5),(564,6),
(565,1),(565,2),(565,3),(565,4),(565,5),(565,6),
(566,1),(566,2),(566,3),(566,4),(566,5),(566,6),
(567,1),(567,2),(567,3),(567,4),(567,5),(567,6),
(568,1),(568,2),(568,3),(568,4),(568,5),(568,6),
(569,1),(569,2),(569,3),(569,4),(569,5),(569,6),
(570,1),(570,2),(570,3),(570,4),(570,5),(570,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Vila në Shkugëz(House)', 'Shtëpi përrallore në mes të pishave dhe natyrës.', 240000, '/images/houses/house8.jpg', 'Gjakovë', 'Shkugëz', 4, 2, 220, 1, 'House', 'For Sale', 6),
('Shtëpi Tradicionale Gjakovare(House)', 'Shtëpi e renovuar me stil në Çarshinë e Vjetër.', 155000, '/images/houses/house3.jpg', 'Gjakovë', 'Çarshia e Vjetër', 4, 2, 180, 1, 'House', 'For Sale', 6),
('Shtëpi Moderne në Bllokun e Ri(House)', 'Dizajn bashkëkohor, lagje e re dhe moderne.', 185000, '/images/houses/house5.jpg', 'Gjakovë', 'Blloku i Ri', 5, 2, 260, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Meje(House)', 'Ambient i qetë, ideale për jetesë familjare.', 110000, '/images/houses/house9.jpg', 'Gjakovë', 'Meje', 4, 2, 200, 0, 'House', 'For Sale', 6),
('Vila Panorama Gjakovë(House)', 'Pamje e hapur mbi qytet, kopsht i rregulluar.', 210000, '/images/houses/house4.jpg', 'Gjakovë', 'Qendra', 5, 3, 300, 1, 'House', 'For Sale', 6),
('Shtëpi e re në Brekoc(House)', 'Ndërtim cilësor, hapsirë e bollshme dhe moderne.', 125000, '/images/houses/house8.jpg', 'Gjakovë', 'Brekoc', 4, 2, 210, 0, 'House', 'For Sale', 6),
('Shtëpi në Çarshinë e Vjetër(House)', 'Pozitë strategjike, shtëpi me traditë dhe komoditet.', 165000, '/images/houses/house2.jpg', 'Gjakovë', 'Çarshia e Vjetër', 4, 2, 190, 0, 'House', 'For Sale', 6),
('Vila Moderne Gjakovë(House)', 'Arkitekturë unike, dritare të mëdha, ndriçim.', 260000, '/images/houses/house7.jpg', 'Gjakovë', 'Qendra', 5, 3, 330, 1, 'House', 'For Sale', 6),
('Shtëpi në periferi(House)', 'Oborr i madh, e përshtatshme për fermë ose kopsht.', 95000, '/images/houses/house10.jpg', 'Gjakovë', 'Skivjan', 3, 1, 160, 0, 'House', 'For Sale', 6),
('Shtëpi Ekskluzive Blloku i Ri(House)', 'Investim luksoz në lagjen më të kërkuar.', 280000, '/images/houses/house1.jpg', 'Gjakovë', 'Blloku i Ri', 6, 3, 380, 1, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Gjakovë', 'Shkugëz', 571), ('Gjakovë', 'Çarshia e Vjetër', 572), ('Gjakovë', 'Blloku i Ri', 573), ('Gjakovë', 'Meje', 574), ('Gjakovë', 'Qendra', 575),
('Gjakovë', 'Brekoc', 576), ('Gjakovë', 'Çarshia e Vjetër', 577), ('Gjakovë', 'Qendra', 578), ('Gjakovë', 'Skivjan', 579), ('Gjakovë', 'Blloku i Ri', 580);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(571,1),(571,2),(571,3),(571,4),(571,5),(571,6),
(572,1),(572,2),(572,3),(572,4),(572,5),(572,6),
(573,1),(573,2),(573,3),(573,4),(573,5),(573,6),
(574,1),(574,2),(574,3),(574,4),(574,5),(574,6),
(575,1),(575,2),(575,3),(575,4),(575,5),(575,6),
(576,1),(576,2),(576,3),(576,4),(576,5),(576,6),
(577,1),(577,2),(577,3),(577,4),(577,5),(577,6),
(578,1),(578,2),(578,3),(578,4),(578,5),(578,6),
(579,1),(579,2),(579,3),(579,4),(579,5),(579,6),
(580,1),(580,2),(580,3),(580,4),(580,5),(580,6);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Shtëpi Moderne në Fushë Kosovë(House)', 'Shtëpi e re me dizajn bashkëkohor në lagjen Dardania.', 120000, '/images/houses/house9.jpg', 'Fushë Kosovë', 'Dardania', 4, 2, 210, 1, 'House', 'For Sale', 6),
('Vila në periferi të FK(House)', 'Ambient i qetë, shtëpi e bollshme me kopsht të madh.', 145000, '/images/houses/house5.jpg', 'Fushë Kosovë', 'Miradi', 5, 2, 260, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Bresje(House)', 'Lagje e urbanizuar, ideale për familje të mëdha.', 110000, '/images/houses/house1.jpg', 'Fushë Kosovë', 'Bresje', 4, 2, 200, 0, 'House', 'For Sale', 6),
('Shtëpi e re në Uglar(House)', 'Ndërtim cilësor, qasje e lehtë në autostradë.', 105000, '/images/houses/house7.jpg', 'Fushë Kosovë', 'Uglar', 4, 2, 190, 0, 'House', 'For Sale', 6),
('Vila Luksoze FK(House)', 'Shtëpi ekskluzive me materiale premium dhe pishinë.', 260000, '/images/houses/house3.jpg', 'Fushë Kosovë', 'Qendra', 5, 3, 340, 1, 'House', 'For Sale', 6),
('Shtëpi dykatëshe në Qendër(House)', 'Pozitë e mirë, shtëpi e renovuar dhe shumë komode.', 135000, '/images/houses/house10.jpg', 'Fushë Kosovë', 'Qendra', 5, 2, 250, 1, 'House', 'For Sale', 6),
('Shtëpi në lagjen e qetë FK(House)', 'Ideale për jetesë larg zhurmës, oborr i gjelbëruar.', 95000, '/images/houses/house8.jpg', 'Fushë Kosovë', 'Dardania', 3, 1, 160, 0, 'House', 'For Sale', 6),
('Vila Moderne FK(House)', 'Arkitekturë moderne, hapsira të hapura dhe ndriçim.', 185000, '/images/houses/house6.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 4, 2, 240, 1, 'House', 'For Sale', 6),
('Shtëpi në Kuzmin(House)', 'Oborr i gjerë, e përshtatshme për kopshtari ose fermë.', 82000, '/images/houses/house4.jpg', 'Fushë Kosovë', 'Kuzmin', 3, 1, 140, 0, 'House', 'For Sale', 6),
('Shtëpi Ekskluzive FK(House)', 'Investim i lartë në njërën nga zonat me zhvillim të shpejtë.', 210000, '/images/houses/house2.jpg', 'Fushë Kosovë', 'Qendra', 5, 2, 300, 1, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Fushë Kosovë', 'Dardania', 581), ('Fushë Kosovë', 'Miradi', 582), ('Fushë Kosovë', 'Bresje', 583), ('Fushë Kosovë', 'Uglar', 584), ('Fushë Kosovë', 'Qendra', 585),
('Fushë Kosovë', 'Qendra', 586), ('Fushë Kosovë', 'Dardania', 587), ('Fushë Kosovë', 'Rruga e Pejës', 588), ('Fushë Kosovë', 'Kuzmin', 589), ('Fushë Kosovë', 'Qendra', 590);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(581,1),(581,2),(581,3),(581,4),(581,5),(581,6),
(582,1),(582,2),(582,3),(582,4),(582,5),(582,6),
(583,1),(583,2),(583,3),(583,4),(583,5),(583,6),
(584,1),(584,2),(584,3),(584,4),(584,5),(584,6),
(585,1),(585,2),(585,3),(585,4),(585,5),(585,6),
(586,1),(586,2),(586,3),(586,4),(586,5),(586,6),
(587,1),(587,2),(587,3),(587,4),(587,5),(587,6),
(588,1),(588,2),(588,3),(588,4),(588,5),(588,6),
(589,1),(589,2),(589,3),(589,4),(589,5),(589,6),
(590,1),(590,2),(590,3),(590,4),(590,5),(590,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Shtëpi Moderne në Podujevë(House)', 'Shtëpi e re me dizajn bashkëkohor në lagjen Besiana.', 115000, '/images/houses/house10.jpg', 'Podujevë', 'Besiana', 4, 2, 200, 1, 'House', 'For Sale', 6),
('Vila në periferi të Podujevës(House)', 'Ambient i qetë, shtëpi e bollshme me kopsht të madh.', 135000, '/images/houses/house1.jpg', 'Podujevë', 'Besiana', 5, 2, 250, 1, 'House', 'For Sale', 6),
('Shtëpi Familjare në Qendër(House)', 'Lagje e urbanizuar, ideale për familje të mëdha.', 125000, '/images/houses/house9.jpg', 'Podujevë', 'Qendra', 4, 2, 220, 1, 'House', 'For Sale', 6),
('Shtëpi e re në Gllamnik(House)', 'Ndërtim cilësor, qasje e lehtë në rrugën magjistrale.', 110000, '/images/houses/house2.jpg', 'Podujevë', 'Gllamnik', 4, 2, 210, 0, 'House', 'For Sale', 6),
('Vila Luksoze Podujevë(House)', 'Shtëpi ekskluzive me materiale premium dhe kopsht.', 240000, '/images/houses/house8.jpg', 'Podujevë', 'Besiana', 5, 3, 320, 1, 'House', 'For Sale', 6),
('Shtëpi dykatëshe në Besianë(House)', 'Pozitë e mirë, shtëpi e renovuar dhe shumë komode.', 140000, '/images/houses/house3.jpg', 'Podujevë', 'Besiana', 5, 2, 260, 1, 'House', 'For Sale', 6),
('Shtëpi në lagjen e qetë Podujevë(House)', 'Ideale për jetesë larg zhurmës, oborr i gjelbëruar.', 92000, '/images/houses/house7.jpg', 'Podujevë', 'Besiana', 3, 1, 170, 0, 'House', 'For Sale', 6),
('Vila Moderne Besiana(House)', 'Arkitekturë moderne, hapsira të hapura dhe ndriçim.', 175000, '/images/houses/house4.jpg', 'Podujevë', 'Besiana', 4, 2, 230, 1, 'House', 'For Sale', 6),
('Shtëpi në Letanc(House)', 'Oborr i gjerë, e përshtatshme për kopshtari ose fermë.', 85000, '/images/houses/house6.jpg', 'Podujevë', 'Letanc', 3, 1, 150, 0, 'House', 'For Sale', 6),
('Shtëpi Ekskluzive Podujevë(House)', 'Investim i lartë në njërën nga zonat më të kërkuara.', 200000, '/images/houses/house5.jpg', 'Podujevë', 'Qendra', 5, 2, 300, 1, 'House', 'For Sale', 6);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Podujevë', 'Besiana', 591), ('Podujevë', 'Besiana', 592), ('Podujevë', 'Qendra', 593), ('Podujevë', 'Gllamnik', 594), ('Podujevë', 'Besiana', 595),
('Podujevë', 'Besiana', 596), ('Podujevë', 'Besiana', 597), ('Podujevë', 'Besiana', 598), ('Podujevë', 'Letanc', 599), ('Podujevë', 'Qendra', 600);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(591,1),(591,2),(591,3),(591,4),(591,5),(591,6),
(592,1),(592,2),(592,3),(592,4),(592,5),(592,6),
(593,1),(593,2),(593,3),(593,4),(593,5),(593,6),
(594,1),(594,2),(594,3),(594,4),(594,5),(594,6),
(595,1),(595,2),(595,3),(595,4),(595,5),(595,6),
(596,1),(596,2),(596,3),(596,4),(596,5),(596,6),
(597,1),(597,2),(597,3),(597,4),(597,5),(597,6),
(598,1),(598,2),(598,3),(598,4),(598,5),(598,6),
(599,1),(599,2),(599,3),(599,4),(599,5),(599,6),
(600,1),(600,2),(600,3),(600,4),(600,5),(600,6);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Cafe House Drenas', 'Ambient modern dhe i ngrohtë në qendër.', 45000, '/images/cafes/caffe1.jpg', 'Drenas', 'Qendra', 0, 1, 60, 1, 'Cafe', 'For Sale', 7),
('Bistro Cafe Drenas', 'Kafiteri dhe ushqime të lehta, lokacion kyç.', 55000, '/images/cafes/caffe2.jpg', 'Drenas', 'Qendra', 0, 1, 75, 0, 'Cafe', 'For Sale', 7),
('Garden Cafe Komoran', 'Kafiteri me kopsht të bukur dhe ambient të qetë.', 62000, '/images/cafes/caffe3.jpg', 'Drenas', 'Komoran', 0, 1, 100, 1, 'Cafe', 'For Sale', 7),
('Corner Cafe', 'Kafiteri e vogël dhe praktike në cep të rrugës.', 35000, '/images/cafes/caffe4.jpg', 'Drenas', 'Qendra', 0, 1, 40, 0, 'Cafe', 'For Sale', 7),
('Lounge Cafe Drenas', 'Ambient luksoz për takime biznesi.', 85000, '/images/cafes/caffe5.jpg', 'Drenas', 'Qendra', 0, 1, 120, 1, 'Cafe', 'For Sale', 7),
('Retro Cafe', 'Stil unik retro dhe muzikë e mirë.', 48000, '/images/cafes/caffe6.jpg', 'Drenas', 'Qendra', 0, 1, 65, 0, 'Cafe', 'For Sale', 7),
('Express Cafe Drenas', 'Ideale për kafe të shpejtë në mëngjes.', 32000, '/images/cafes/caffe7.jpg', 'Drenas', 'Qendra', 0, 1, 35, 0, 'Cafe', 'For Sale', 7),
('Sky Bar Cafe Drenas', 'Kafiteri në katin e fundit me pamje nga qyteti.', 75000, '/images/cafes/caffe8.jpg', 'Drenas', 'Qendra', 0, 1, 90, 1, 'Cafe', 'For Sale', 7),
('Family Cafe Drenas', 'Ambient i përshtatshëm për familje dhe fëmijë.', 52000, '/images/cafes/caffe9.jpg', 'Drenas', 'Gllogoc', 0, 1, 80, 0, 'Cafe', 'For Sale', 7),
('Art Cafe Drenas', 'Kombinim i kafesë me galeri arti.', 58000, '/images/cafes/caffe10.jpg', 'Drenas', 'Qendra', 0, 1, 70, 0, 'Cafe', 'For Sale', 7);

INSERT INTO Addresses(City, Street, PropertyId) VALUES
('Drenas', 'Qendra', 601), ('Drenas', 'Qendra', 602), ('Drenas', 'Komoran', 603), ('Drenas', 'Qendra', 604), ('Drenas', 'Qendra', 605),
('Drenas', 'Qendra', 606), ('Drenas', 'Qendra', 607), ('Drenas', 'Qendra', 608), ('Drenas', 'Gllogoc', 609), ('Drenas', 'Qendra', 610);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(601,1),(601,2),(601,3),(601,5),(601,6),
(602,1),(602,2),(602,3),(602,5),(602,6),
(603,1),(603,2),(603,3),(603,5),(603,6),
(604,1),(604,2),(604,3),(604,5),(604,6),
(605,1),(605,2),(605,3),(605,5),(605,6),
(606,1),(606,2),(606,3),(606,5),(606,6),
(607,1),(607,2),(607,3),(607,5),(607,6),
(608,1),(608,2),(608,3),(608,5),(608,6),
(609,1),(609,2),(609,3),(609,5),(609,6),
(610,1),(610,2),(610,3),(610,5),(610,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Book Cafe Prishtina', 'Kombinim i librit me kafenë në qendër.', 120000, '/images/cafes/caffe2.jpg', 'Prishtinë', 'Qendra', 0, 1, 100, 1, 'Cafe', 'For Sale', 7),
('Lounge Bar Cafe Pejton', 'Ambient ekskluziv në njërën nga lagjet më të mira.', 180000, '/images/cafes/caffe4.jpg', 'Prishtinë', 'Pejton', 0, 2, 150, 1, 'Cafe', 'For Sale', 7),
('Cafe & More Dardania', 'Kafiteri shumë e frekuentuar në Dardani.', 95000, '/images/cafes/caffe6.jpg', 'Prishtinë', 'Dardania', 0, 1, 85, 1, 'Cafe', 'For Sale', 7),
('Urban Cafe Prishtina', 'Stil industrial dhe ambient modern.', 110000, '/images/cafes/caffe8.jpg', 'Prishtinë', 'Blloku', 0, 1, 90, 0, 'Cafe', 'For Sale', 7),
('Garden Cafe Arbëria', 'Kafiteri me tarracë dhe pamje nga qyteti.', 140000, '/images/cafes/caffe10.jpg', 'Prishtinë', 'Arbëria', 0, 1, 120, 1, 'Cafe', 'For Sale', 7),
('Vintage Cafe Prishtina', 'Ambient nostalgjik me dekor unik.', 85000, '/images/cafes/3', 'Prishtinë', 'Qendra', 0, 1, 75, 0, 'Cafe', 'For Sale', 7),
('Artistic Cafe Prishtina', 'Vendi i takimit për artistët e qytetit.', 72000, '/images/cafes/caffe5.jpg', 'Prishtinë', 'Ulpiana', 0, 1, 65, 0, 'Cafe', 'For Sale', 7),
('Sky Lounge Cafe Prishtina', 'Kafiteri luksoze në katin e lartë të një kulle.', 250000, '/images/cafes/caffe1.jpg', 'Prishtinë', 'Lakrishtë', 0, 2, 200, 1, 'Cafe', 'For Sale', 7),
('Bistro Cafe Prishtina', 'Kafe dhe ushqim i shpejtë cilësor.', 68000, '/images/cafes/caffe7.jpg', 'Prishtinë', 'Aktash', 0, 1, 60, 0, 'Cafe', 'For Sale', 7),
('Corner Cafe Prishtina', 'Lokacion kyç në rrugën më të frekuentuar.', 130000, '/images/cafes/caffe9.jpg', 'Prishtinë', 'Sheshi Nënë Tereza', 0, 1, 55, 1, 'Cafe', 'For Sale', 7);

-- Adresat
INSERT INTO Addresses(City, Street,PropertyId) VALUES
('Prishtinë', 'Qendra',611), ('Prishtinë', 'Pejton',612), ('Prishtinë', 'Dardania',613), ('Prishtinë', 'Blloku',614), ('Prishtinë', 'Arbëria',615),
('Prishtinë', 'Qendra',616), ('Prishtinë', 'Ulpiana',617), ('Prishtinë', 'Lakrishtë',618), ('Prishtinë', 'Aktash',619), ('Prishtinë', 'Sheshi Nënë Tereza',620);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(611,1),(611,2),(611,3),(611,5),(611,6),
(612,1),(612,2),(612,3),(612,5),(612,6),
(613,1),(613,2),(613,3),(613,5),(613,6),
(614,1),(614,2),(614,3),(614,5),(614,6),
(615,1),(615,2),(615,3),(615,5),(615,6),
(616,1),(616,2),(616,3),(616,5),(616,6),
(617,1),(617,2),(617,3),(617,5),(617,6),
(618,1),(618,2),(618,3),(618,5),(618,6),
(619,1),(619,2),(619,3),(619,5),(619,6),
(620,1),(620,2),(620,3),(620,5),(620,6);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Shadërvani Cafe Bar', 'Kafiteri tradicionale në zemër të Shadërvanit.', 85000, '/images/cafes/3', 'Prizren', 'Shadërvan', 0, 1, 70, 1, 'Cafe', 'For Sale', 7),
('Lumbardhi View Cafe', 'Ambient i mrekullueshëm buzë lumit.', 95000, '/images/cafes/caffe6.jpg', 'Prizren', 'Qendra', 0, 1, 85, 1, 'Cafe', 'For Sale', 7),
('Old Town Cafe', 'Stil antik dhe atmosferë e ngrohtë.', 68000, '/images/cafes/caffe9.jpg', 'Prizren', 'Qendra e Vjetër', 0, 1, 60, 0, 'Cafe', 'For Sale', 7),
('Castle Hill Cafe', 'Pamje mahnitëse nga rruga për në Kala.', 110000, '/images/cafes/caffe1.jpg', 'Prizren', 'Kalaja', 0, 1, 100, 1, 'Cafe', 'For Sale', 7),
('Modern Bistro Cafe Prizren', 'Kombinim i kafesë me kuzhinë moderne.', 78000, '/images/cafes/caffe2.jpg', 'Prizren', 'Ortakoll', 0, 1, 80, 0, 'Cafe', 'For Sale', 7),
('Retro Lounge Cafe Prizren', 'Ambient unik me muzikë jazz dhe blues.', 55000, '/images/cafes/caffe6.jpg', 'Prizren', 'Bazhdarhane', 0, 1, 65, 0, 'Cafe', 'For Sale', 7),
('Art Cafe Prizren', 'Vendi i takimit për komunitetin artistik.', 62000, '/images/cafes/caffe4.jpg', 'Prizren', 'Qendra', 0, 1, 75, 0, 'Cafe', 'For Sale', 7),
('Family Cafe Prizren', 'Hapsirë e bollshme me kënd lojrash.', 88000, '/images/cafes/caffe10.jpg', 'Prizren', 'Qendra', 0, 1, 120, 1, 'Cafe', 'For Sale', 7),
('Express Cafe Prizren', 'Ideale për një pushim të shpejtë.', 42000, '/images/cafes/caffe8.jpg', 'Prizren', 'Qendra', 0, 1, 45, 0, 'Cafe', 'For Sale', 7),
('Sky Bar Cafe Prizren', 'Kafiteri në tarracë me pamje panoramike.', 130000, '/images/cafes/caffe5.jpg', 'Prizren', 'Qendra', 0, 1, 150, 1, 'Cafe', 'For Sale', 7);

-- Adresat
INSERT INTO Addresses(City, Street,PropertyId) VALUES
('Prizren', 'Shadërvan',621), ('Prizren', 'Qendra',622), ('Prizren', 'Qendra e Vjetër',623), ('Prizren', 'Kalaja',624), ('Prizren', 'Ortakoll',625),
('Prizren', 'Bazhdarhane',626), ('Prizren', 'Qendra',627), ('Prizren', 'Qendra',628), ('Prizren', 'Qendra',629), ('Prizren', 'Qendra',630);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(621,1),(621,2),(621,3),(621,5),(621,6),
(622,1),(622,2),(622,3),(622,5),(622,6),
(623,1),(623,2),(623,3),(623,5),(623,6),
(624,1),(624,2),(624,3),(624,5),(624,6),
(625,1),(625,2),(625,3),(625,5),(625,6),
(626,1),(626,2),(626,3),(626,5),(626,6),
(627,1),(627,2),(627,3),(627,5),(627,6),
(628,1),(628,2),(628,3),(628,5),(628,6),
(629,1),(629,2),(629,3),(629,5),(629,6),
(630,1),(630,2),(630,3),(630,5),(630,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Korza Cafe Peja', 'Në shëtitoren më të frekuentuar të qytetit.', 92000, '/images/cafes/caffe4.jpg', 'Pejë', 'Qendra', 0, 1, 80, 1, 'Cafe', 'For Sale', 7),
('Rugova Valley Cafe', 'Kafiteri me pamje nga malet e Rugovës.', 115000, '/images/cafes/caffe6.jpg', 'Pejë', 'Rugovë', 0, 1, 120, 1, 'Cafe', 'For Sale', 7),
('Modern Bistro Cafe Peja', 'Ambient bashkëkohor dhe shërbim cilësor.', 75000, '/images/cafes/9', 'Pejë', 'Qendra', 0, 1, 90, 0, 'Cafe', 'For Sale', 7),
('Karagaç Park Cafe', 'Kafiteri e qetë afër parkut të qytetit.', 68000, '/images/cafes/caffe1.jpg', 'Pejë', 'Karagaç', 0, 1, 100, 1, 'Cafe', 'For Sale', 7),
('Old Bazaar Cafe Peja', 'Atmosferë tradicionale në Çarshinë e Vjetër.', 58000, '/images/cafes/caffe7.jpg', 'Pejë', 'Qendra', 0, 1, 65, 0, 'Cafe', 'For Sale', 7),
('Art & Cafe Peja', 'Kombinim i kafesë me ekspozita arti.', 62000, '/images/cafes/caffe5.jpg', 'Pejë', 'Fidanishte', 0, 1, 75, 0, 'Cafe', 'For Sale', 7),
('Sky Lounge Cafe Peja', 'Kafiteri moderne në katin e fundit.', 125000, '/images/cafes/caffe8.jpg', 'Pejë', 'Qendra', 0, 1, 140, 1, 'Cafe', 'For Sale', 7),
('Express Cafe Peja', 'Lokacion kyç për kafe të shpejtë.', 38000, '/images/cafes/caffe2.jpg', 'Pejë', 'Qendra', 0, 1, 40, 0, 'Cafe', 'For Sale', 7),
('Family Corner Cafe Peja', 'Ambient i ngrohtë për çdo moshë.', 52000, '/images/cafes/caffe6.jpg', 'Pejë', 'Karagaç', 0, 1, 85, 0, 'Cafe', 'For Sale', 7),
('Boutique Cafe Peja', 'Dizajn unik dhe kafe artizanale.', 82000, '/images/cafes/caffe3.jpg', 'Pejë', 'Qendra', 0, 1, 70, 1, 'Cafe', 'For Sale', 7);

-- Adresat
INSERT INTO Addresses(City, Street,PropertyId) VALUES
('Pejë', 'Qendra',631), ('Pejë', 'Rugovë',632), ('Pejë', 'Qendra',633), ('Pejë', 'Karagaç',634), ('Pejë', 'Qendra',635),
('Pejë', 'Fidanishte',636), ('Pejë', 'Qendra',637), ('Pejë', 'Qendra',638), ('Pejë', 'Karagaç',639), ('Pejë', 'Qendra',640);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(631,1),(631,2),(631,3),(631,5),(631,6),
(632,1),(632,2),(632,3),(632,5),(632,6),
(633,1),(633,2),(633,3),(633,5),(633,6),
(634,1),(634,2),(634,3),(634,5),(634,6),
(635,1),(635,2),(635,3),(635,5),(635,6),
(636,1),(636,2),(636,3),(636,5),(636,6),
(637,1),(637,2),(637,3),(637,5),(637,6),
(638,1),(638,2),(638,3),(638,5),(638,6),
(639,1),(639,2),(639,3),(639,5),(639,6),
(640,1),(640,2),(640,3),(640,5),(640,6);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('City Cafe Ferizaj', 'Kafiteri moderne në zemër të qytetit.', 48000, '/images/cafes/caffe5.jpg', 'Ferizaj', 'Qendra', 0, 1, 65, 1, 'Cafe', 'For Sale', 7),
('Lounge Bar Cafe Ferizaj', 'Ambient luksoz me tarracë të hapur.', 85000, '/images/cafes/caffe10.jpg', 'Ferizaj', 'Qendra', 0, 1, 110, 1, 'Cafe', 'For Sale', 7),
('Retro Cafe Ferizaj', 'Stil unik dhe atmosferë nostalgjike.', 52000, '/images/cafes/caffe1.jpg', 'Ferizaj', 'Qendra', 0, 1, 70, 0, 'Cafe', 'For Sale', 7),
('Corner Cafe FK', 'Lokacion kyç afër stacionit të trenit.', 42000, '/images/cafes/caffe6.jpg', 'Ferizaj', 'Qendra', 0, 1, 50, 0, 'Cafe', 'For Sale', 7),
('Modern Bistro Cafe Ferizaj', 'Kombinim i kafesë me ushqime të lehta.', 68000, '/images/cafes/caffe4.jpg', 'Ferizaj', 'Qendra', 0, 1, 85, 1, 'Cafe', 'For Sale', 7),
('Art Cafe Ferizaj', 'Ambient i qetë për adhuruesit e artit.', 55000, '/images/cafes.caffe8.jpg', 'Ferizaj', 'Qendra', 0, 1, 75, 0, 'Cafe', 'For Sale', 7),
('Sky Bar Cafe Ferizaj', 'Kafiteri në katin e fundit me pamje panoramike.', 115000, '/images/cafes/caffe3.jpg', 'Ferizaj', 'Qendra', 0, 1, 130, 1, 'Cafe', 'For Sale', 7),
('Express Cafe Ferizaj', 'Ideale për një pushim të shpejtë pune.', 35000, '/images/cafes/caffe9.jpg', 'Ferizaj', 'Qendra', 0, 1, 40, 0, 'Cafe', 'For Sale', 7),
('Family Cafe Ferizaj', 'Ambient i ngrohtë dhe i sigurt për fëmijë.', 58000, '/images/cafes/caffe7.jpg', 'Ferizaj', 'Talinoc', 0, 1, 90, 0, 'Cafe', 'For Sale', 7),
('Boutique Cafe Ferizaj', 'Dizajn unik dhe kafe cilësore.', 72000, '/images/cafes/caffe2.jpg', 'Ferizaj', 'Qendra', 0, 1, 80, 1, 'Cafe', 'For Sale', 7);

-- Adresat
INSERT INTO Addresses(City, Street,PropertyId) VALUES
('Ferizaj', 'Qendra',641), ('Ferizaj', 'Qendra',642), ('Ferizaj', 'Qendra',643), ('Ferizaj', 'Qendra',644), ('Ferizaj', 'Qendra',645),
('Ferizaj', 'Qendra',646), ('Ferizaj', 'Qendra',647), ('Ferizaj', 'Qendra',648), ('Ferizaj', 'Talinoc',649), ('Ferizaj', 'Qendra',650);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(641,1),(641,2),(641,3),(641,5),(641,6),
(642,1),(642,2),(642,3),(642,5),(642,6),
(643,1),(643,2),(643,3),(643,5),(643,6),
(644,1),(644,2),(644,3),(644,5),(644,6),
(645,1),(645,2),(645,3),(645,5),(645,6),
(646,1),(646,2),(646,3),(646,5),(646,6),
(647,1),(647,2),(647,3),(647,5),(647,6),
(648,1),(648,2),(648,3),(648,5),(648,6),
(649,1),(649,2),(649,3),(649,5),(649,6),
(650,1),(650,2),(650,3),(650,5),(650,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Crystal Cafe Gjilan', 'Ambient modern dhe shumë elegant.', 55000, '/images/cafes/caffe6.jpg', 'Gjilan', 'Qendra', 0, 1, 75, 1, 'Cafe', 'For Sale', 7),
('Lounge Bar Cafe Gjilan', 'Vendi më i frekuentuar për takime.', 92000, '/images/cafes/caffe3.jpg', 'Gjilan', 'Qendra', 0, 1, 120, 1, 'Cafe', 'For Sale', 7),
('Retro Cafe Gjilan', 'Atmosferë e viteve 80 me muzikë të mirë.', 48000, '/images/cafes/caffe9.jpg', 'Gjilan', 'Qendra', 0, 1, 65, 0, 'Cafe', 'For Sale', 7),
('Corner Cafe Gjilan', 'Lokacion strategjik në qendër të qytetit.', 45000, '/images/cafes/caffe1.jpg', 'Gjilan', 'Qendra', 0, 1, 55, 1, 'Cafe', 'For Sale', 7),
('Modern Bistro Cafe Gjilan', 'Ushqim i shpejtë dhe kafe cilësore.', 75000, '/images/cafes/caffe5.jpg', 'Gjilan', 'Dardania', 0, 1, 95, 1, 'Cafe', 'For Sale', 7),
('Art Cafe Gjilan', 'Ambient i frymëzuar nga arti dhe kultura.', 52000, '/images/cafes/caffe8.jpg', 'Gjilan', 'Qendra', 0, 1, 70, 0, 'Cafe', 'For Sale', 7),
('Sky Bar Cafe Gjilan', 'Kafiteri në katin e lartë me pamje të bukur.', 125000, '/images/cafes/caffe10.jpg', 'Gjilan', 'Rruga Qarkore', 0, 1, 140, 1, 'Cafe', 'For Sale', 7),
('Express Cafe Gjilan', 'Pikë ideale për një kafe të shpejtë.', 32000, '/images/cafes/caffe2.jpg', 'Gjilan', 'Qendra', 0, 1, 40, 0, 'Cafe', 'For Sale', 7),
('Family Cafe Gjilan', 'Ambient i qetë për dreka familjare.', 62000, '/images/cafes/caffe4.jpg', 'Gjilan', 'Livoç', 0, 1, 100, 0, 'Cafe', 'For Sale', 7),
('Boutique Cafe Gjilan', 'Dizajn ekskluziv dhe atmosferë unike.', 78000, '/images/cafes/caffe7.jpg', 'Gjilan', 'Dardania', 0, 1, 80, 1, 'Cafe', 'For Sale', 7);

-- Adresat
INSERT INTO Addresses(City, Street,PropertyId) VALUES
('Gjilan', 'Qendra',651), ('Gjilan', 'Qendra',652), ('Gjilan', 'Qendra',653), ('Gjilan', 'Qendra',654), ('Gjilan', 'Dardania',655),
('Gjilan', 'Qendra',656), ('Gjilan', 'Rruga Qarkore',657), ('Gjilan', 'Qendra',658), ('Gjilan', 'Livoç',659), ('Gjilan', 'Dardania',660);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(651,1),(651,2),(651,3),(651,5),(651,6),
(652,1),(652,2),(652,3),(652,5),(652,6),
(653,1),(653,2),(653,3),(653,5),(653,6),
(654,1),(654,2),(654,3),(654,5),(654,6),
(655,1),(655,2),(655,3),(655,5),(655,6),
(656,1),(656,2),(656,3),(656,5),(656,6),
(657,1),(657,2),(657,3),(657,5),(657,6),
(658,1),(658,2),(658,3),(658,5),(658,6),
(659,1),(659,2),(659,3),(659,5),(659,6),
(660,1),(660,2),(660,3),(660,5),(660,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Ibar View Cafe', 'Kafiteri me pamje mahnitëse nga lumi Ibër.', 65000, '/images/cafes/caffe7.jpg', 'Mitrovicë', 'Qendra', 0, 1, 80, 1, 'Cafe', 'For Sale', 7),
('North Cafe Mitrovica', 'Ambient i qetë dhe modern në pjesën veriore.', 45000, '/images/cafes/caffe9.jpg', 'Mitrovicë', 'Qendra', 0, 1, 60, 0, 'Cafe', 'For Sale', 7),
('Bridge Cafe', 'Lokacion kyç afër urës kryesore të qytetit.', 55000, '/images/cafes/caffe5.jpg', 'Mitrovicë', 'Qendra', 0, 1, 70, 1, 'Cafe', 'For Sale', 7),
('Bair Panorama Cafe', 'Kafiteri në kodrën e Bairit me pamje mbi qytet.', 75000, '/images/cafes/caffe3.jpg', 'Mitrovicë', 'Bair', 0, 1, 100, 1, 'Cafe', 'For Sale', 7),
('Tavnik Bistro Cafe', 'Ambient modern dhe shërbim cilësor në Tavnik.', 58000, '/images/cafes/caffe1.jpg', 'Mitrovicë', 'Tavnik', 0, 1, 75, 0, 'Cafe', 'For Sale', 7),
('Retro Cafe Mitrovica', 'Stil unik retro dhe atmosferë shumë e ngrohtë.', 42000, '/images/cafes/caffe8.jpg', 'Mitrovicë', 'Qendra', 0, 1, 55, 0, 'Cafe', 'For Sale', 7),
('Art Cafe Mitrovica', 'Vendi i takimit për artistët dhe studentët.', 50000, '/images/cafes/caffe10.jpg', 'Mitrovicë', 'Qendra', 0, 1, 65, 0, 'Cafe', 'For Sale', 7),
('Sky Bar Cafe Mitrovica', 'Kafiteri luksoze në katin e fundit me tarracë.', 120000, '/images/cafes/caffe4.jpg', 'Mitrovicë', 'Qendra', 0, 1, 150, 1, 'Cafe', 'For Sale', 7),
('Express Cafe Shipol', 'Ideale për një kafe të shpejtë në lagjen Shipol.', 32000, '/images/cafes/caffe2.jpg', 'Mitrovicë', 'Shipol', 0, 1, 40, 0, 'Cafe', 'For Sale', 7),
('Lounge 028 Cafe', 'Ambient modern për takime dhe biseda.', 88000, '/images/cafes/caffe6.jpg', 'Mitrovicë', 'Qendra', 0, 1, 110, 1, 'Cafe', 'For Sale', 7);

-- Adresat
INSERT INTO Addresses(City, Street,PropertyId) VALUES
('Mitrovicë', 'Qendra',661), ('Mitrovicë', 'Qendra',662), ('Mitrovicë', 'Qendra',663), ('Mitrovicë', 'Bair',664), ('Mitrovicë', 'Tavnik',665),
('Mitrovicë', 'Qendra',666), ('Mitrovicë', 'Qendra',667), ('Mitrovicë', 'Qendra',668), ('Mitrovicë', 'Shipol',669), ('Mitrovicë', 'Qendra',670);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(661,1),(661,2),(661,3),(661,5),(661,6),
(662,1),(662,2),(662,3),(662,5),(662,6),
(663,1),(663,2),(663,3),(663,5),(663,6),
(664,1),(664,2),(664,3),(664,5),(664,6),
(665,1),(665,2),(665,3),(665,5),(665,6),
(666,1),(666,2),(666,3),(666,5),(666,6),
(667,1),(667,2),(667,3),(667,5),(667,6),
(668,1),(668,2),(668,3),(668,5),(668,6),
(669,1),(669,2),(669,3),(669,5),(669,6),
(670,1),(670,2),(670,3),(670,5),(670,6);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Old Bazaar Cafe', 'Kafiteri me stil tradicional në Çarshinë e Vjetër.', 75000, '/images/cafes/caffe8.jpg', 'Gjakovë', 'Çarshia e Vjetër', 0, 1, 90, 1, 'Cafe', 'For Sale', 7),
('Krena Riverside Cafe', 'Ambient i mrekullueshëm buzë lumit Krena.', 85000, '/images/cafes/caffe10.jpg', 'Gjakovë', 'Qendra', 0, 1, 100, 1, 'Cafe', 'For Sale', 7),
('Modern Bistro Cafe Gjakova', 'Dizajn bashkëkohor dhe kafe cilësore.', 62000, '/images/cafes/caffe2.jpg', 'Gjakovë', 'Qendra', 0, 1, 75, 0, 'Cafe', 'For Sale', 7),
('Shkugëza Forest Cafe', 'Kafiteri në mes të pishave, ajër i pastër.', 95000, '/images/cafes/caffe6.jpg', 'Gjakovë', 'Shkugëz', 0, 1, 130, 1, 'Cafe', 'For Sale', 7),
('Blloku Cafe', 'Lokacion shumë i frekuentuar në Bllokun e Ri.', 72000, '/images/cafes/caffe4.jpg', 'Gjakovë', 'Blloku i Ri', 0, 1, 85, 1, 'Cafe', 'For Sale', 7),
('Retro Gjakova Cafe', 'Ambient nostalgjik me dekor unik gjakovar.', 55000, '/images/cafes/caffe1.jpg', 'Gjakovë', 'Çarshia e Vjetër', 0, 1, 65, 0, 'Cafe', 'For Sale', 7),
('Art & Cafe Gjakova', 'Kombinim i kafesë me galeri dhe kulturë.', 68000, '/images/cafes/caffe3.jpg', 'Gjakovë', 'Qendra', 0, 1, 80, 0, 'Cafe', 'For Sale', 7),
('Sky Lounge Cafe Gjakova', 'Kafiteri moderne në katin e fundit me tarracë.', 130000, '/images/cafes/caffe5.jpg', 'Gjakovë', 'Blloku i Ri', 0, 1, 160, 1, 'Cafe', 'For Sale', 7),
('Express Cafe Gjakova', 'Ideale për një pushim të shpejtë në qendër.', 38000, '/images/cafes/caffe7.jpg', 'Gjakovë', 'Qendra', 0, 1, 45, 0, 'Cafe', 'For Sale', 7),
('Family Cafe Gjakova', 'Ambient i ngrohtë dhe i sigurt për familje.', 60000, '/images/cafes/caffe9.jpg', 'Gjakovë', 'Qendra', 0, 1, 95, 0, 'Cafe', 'For Sale', 7);

-- Adresat
INSERT INTO Addresses(City, Street,PropertyId) VALUES
('Gjakovë', 'Çarshia e Vjetër',671), ('Gjakovë', 'Qendra',672), ('Gjakovë', 'Qendra',673), ('Gjakovë', 'Shkugëz',674), ('Gjakovë', 'Blloku i Ri',675),
('Gjakovë', 'Çarshia e Vjetër',676), ('Gjakovë', 'Qendra',677), ('Gjakovë', 'Blloku i Ri',678), ('Gjakovë', 'Qendra',679), ('Gjakovë', 'Qendra',680);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(671,1),(671,2),(671,3),(671,5),(671,6),
(672,1),(672,2),(672,3),(672,5),(672,6),
(673,1),(673,2),(673,3),(673,5),(673,6),
(674,1),(674,2),(674,3),(674,5),(674,6),
(675,1),(675,2),(675,3),(675,5),(675,6),
(676,1),(676,2),(676,3),(676,5),(676,6),
(677,1),(677,2),(677,3),(677,5),(677,6),
(678,1),(678,2),(678,3),(678,5),(678,6),
(679,1),(679,2),(679,3),(679,5),(679,6),
(680,1),(680,2),(680,3),(680,5),(680,6);





INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Central Cafe FK', 'Kafiteri moderne në zonën më të frekuentuar.', 52000, '/images/cafes/caffe9.jpg', 'Fushë Kosovë', 'Qendra', 0, 1, 70, 1, 'Cafe', 'For Sale', 7),
('Dardania Lounge&Cafe', 'Ambient luksoz dhe tarracë e hapur në Dardani.', 88000, '/images/cafes/caffe1.jpg', 'Fushë Kosovë', 'Dardania', 0, 1, 110, 1, 'Cafe', 'For Sale', 7),
('Express Cafe FK', 'Ideale për një kafe të shpejtë në rrugën e Pejës.', 35000, '/images/cafes/caffe6.jpg', 'Fushë Kosovë', 'Rruga e Pejës', 0, 1, 45, 0, 'Cafe', 'For Sale', 7),
('Bistro FK Cafe', 'Kombinim i kafesë me ushqime të shpejta cilësore.', 65000, '/images/cafes/caffe3.jpg', 'Fushë Kosovë', 'Qendra', 0, 1, 85, 1, 'Cafe', 'For Sale', 7),
('Corner Cafe FK', 'Lokacion strategjik në udhëkryqin kryesor.', 48000, '/images/cafes/caffe2.jpg', 'Fushë Kosovë', 'Qendra', 0, 1, 60, 0, 'Cafe', 'For Sale', 7),
('Sky Bar FK Cafe', 'Kafiteri në katin e fundit me pamje nga qyteti.', 110000, '/images/cafes/caffe5.jpg', 'Fushë Kosovë', 'Qendra', 0, 1, 140, 1, 'Cafe', 'For Sale', 7),
('Retro FK Cafe', 'Stil unik dhe atmosferë shumë e ngrohtë.', 42000, '/images/cafes/caffe10.jpg', 'Fushë Kosovë', 'Dardania', 0, 1, 55, 0, 'Cafe', 'For Sale', 7),
('Family Cafe FK', 'Ambient i qetë dhe i sigurt për familje.', 58000, '/images/cafes/caffe7.jpg', 'Fushë Kosovë', 'Bresje', 0, 1, 90, 0, 'Cafe', 'For Sale', 7),
('Art Cafe FK', 'Vendi i takimit për komunitetin kreativ.', 55000, '/images/cafes/caffe4.jpg', 'Fushë Kosovë', 'Dardania', 0, 1, 75, 0, 'Cafe', 'For Sale', 7),
('Grand Cafe FK', 'Ambient luksoz dhe hapsirë e bollshme.', 125000, '/images/cafes/caffe8.jpg', 'Fushë Kosovë', 'Qendra', 0, 1, 160, 1, 'Cafe', 'For Sale', 7);

-- Adresat
INSERT INTO Addresses(City, Street,PropertyId) VALUES
('Fushë Kosovë', 'Qendra',681), ('Fushë Kosovë', 'Dardania',682), ('Fushë Kosovë', 'Rruga e Pejës',683), ('Fushë Kosovë', 'Qendra',684), ('Fushë Kosovë', 'Qendra',685),
('Fushë Kosovë', 'Qendra',686), ('Fushë Kosovë', 'Dardania',687), ('Fushë Kosovë', 'Bresje',688), ('Fushë Kosovë', 'Dardania',689), ('Fushë Kosovë', 'Qendra',690);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(681,1),(681,2),(681,3),(681,5),(681,6),
(682,1),(682,2),(682,3),(682,5),(682,6),
(683,1),(683,2),(683,3),(683,5),(683,6),
(684,1),(684,2),(684,3),(684,5),(684,6),
(685,1),(685,2),(685,3),(685,5),(685,6),
(686,1),(686,2),(686,3),(686,5),(686,6),
(687,1),(687,2),(687,3),(687,5),(687,6),
(688,1),(688,2),(688,3),(688,5),(688,6),
(689,1),(689,2),(689,3),(689,5),(689,6),
(690,1),(690,2),(690,3),(690,5),(690,6);




INSERT INTO Properties 
(Title, Description, Price, ImageUrl, City, AddressLine, Bedrooms, Bathrooms, Area, IsFeatured, PropertyType, Status, CategoryId)
VALUES
('Besiana Cafe', 'Kafiteria më e frekuentuar në qendër të qytetit.', 48000, '/images/cafes/caffe10.jpg', 'Podujevë', 'Besiana', 0, 1, 65, 1, 'Cafe', 'For Sale', 7),
('Llap Riverside Cafe', 'Ambient i mrekullueshëm buzë lumit Llap.', 75000, '/images/cafes/caffe8.jpg', 'Podujevë', 'Qendra', 0, 1, 95, 1, 'Cafe', 'For Sale', 7),
('Central Bistro Cafe Podujeva', 'Kombinim i modernes me shërbimin cilësor.', 62000, '/images/cafes/caffe6.jpg', 'Podujevë', 'Qendra', 0, 1, 80, 0, 'Cafe', 'For Sale', 7),
('Sky Lounge Cafe Podujeva', 'Kafiteri në katin e fundit me tarracë të hapur.', 115000, '/images/cafes/caffe2.jpg', 'Podujevë', 'Besiana', 0, 1, 140, 1, 'Cafe', 'For Sale', 7),
('Retro Cafe Podujeva', 'Stil unik dhe atmosferë shumë nostalgjike.', 45000, '/images/cafes/caffe4.jpg', 'Podujevë', 'Qendra', 0, 1, 60, 0, 'Cafe', 'For Sale', 7),
('Family Cafe Podujeva', 'Ambient i ngrohtë dhe i sigurt për fëmijë.', 55000, '/images/cafes/caffe1.jpg', 'Podujevë', 'Besiana', 0, 1, 85, 0, 'Cafe', 'For Sale', 7),
('Art Cafe Podujeva', 'Ambient i frymëzuar nga arti dhe kultura lokale.', 52000, '/images/cafes/caffe5.jpg', 'Podujevë', 'Qendra', 0, 1, 70, 0, 'Cafe', 'For Sale', 7),
('Express Cafe Podujeva', 'Ideale për një kafe të shpejtë në mëngjes.', 32000, '/images/cafes/caffe3.jpg', 'Podujevë', 'Besiana', 0, 1, 40, 0, 'Cafe', 'For Sale', 7),
('Corner Cafe Podujeva', 'Lokacion strategjik në qendër të Besianës.', 42000, '/images/cafes/caffe7.jpg', 'Podujevë', 'Besiana', 0, 1, 55, 1, 'Cafe', 'For Sale', 7),
('Grand Cafe Podujeva', 'Ambient luksoz dhe hapsirë e bollshme për takime.', 120000, '/images/cafes/caffe9.jpg', 'Podujevë', 'Qendra', 0, 1, 150, 1, 'Cafe', 'For Sale', 7);

-- Adresat
INSERT INTO Addresses(City, Street,PropertyId) VALUES
('Podujevë', 'Besiana',691), ('Podujevë', 'Qendra',692), ('Podujevë', 'Qendra',693), ('Podujevë', 'Besiana',694), ('Podujevë', 'Qendra',695),
('Podujevë', 'Besiana',696), ('Podujevë', 'Qendra',697), ('Podujevë', 'Besiana',698), ('Podujevë', 'Besiana',699), ('Podujevë', 'Qendra',700);

INSERT INTO PropertyFeatures(PropertyId, FeatureId) VALUES
(691,1),(691,2),(691,3),(691,5),(691,6),
(692,1),(692,2),(692,3),(692,5),(692,6),
(693,1),(693,2),(693,3),(693,5),(693,6),
(694,1),(694,2),(694,3),(694,5),(694,6),
(695,1),(695,2),(695,3),(695,5),(695,6),
(696,1),(696,2),(696,3),(696,5),(696,6),
(697,1),(697,2),(697,3),(697,5),(697,6),
(698,1),(698,2),(698,3),(698,5),(698,6),
(699,1),(699,2),(699,3),(699,5),(699,6),
(700,1),(700,2),(700,3),(700,5),(700,6);



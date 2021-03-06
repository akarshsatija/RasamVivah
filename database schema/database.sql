SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[format_date]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE function [dbo].[format_date] 
   (@inputdate datetime ,@format varchar(500))
returns varchar(500)
as
begin
declare @year varchar(4)				--YYYY
declare @shortyear varchar(4)			--Yr
declare @quarter varchar(4)				--QQ
declare @month varchar(2)				--MM
declare @week varchar(2)				--WW
declare @day varchar(2)					--DD
declare @24hours varchar(2)				--24HH
declare @12hours varchar(2)				--HH
declare @minutes varchar(2)				--MI
declare @seconds varchar(2)				--SS
declare @milliseconds varchar(3)		--MS
declare @dayname varchar(15)			--DAY
declare @monthname varchar(15)			--MONTH
declare @shortmonthname varchar(15)	    --MON
declare @AMPM	 varchar(15)			--AMPM

declare @UNIXPOSIX	 varchar(15)		--UNIXPOSIX
					--UCASE
					--LCASE

					
declare @formatteddate varchar(500)		


--Assign current date and time to 
if (@inputdate is NULL or @inputdate ='''')
begin
--set @inputdate = getdate()
set @inputdate = ''1/1/2001 00:00:00 AM''

end

if (@format is NULL or @format ='''')
begin
set @format =''YYYY-MM-DD 12HH:MI:SS AMPM''
end

--set all values

set @year		= convert(varchar(4),year(@inputdate))
set @shortyear	= right(@year,2)
set @quarter	= convert(varchar(1),datepart(QQ,(@inputdate)))
set @month		= right(''0''+convert(varchar(2),month(@inputdate)),2)
set @week		= right(''0''+convert(varchar(2),datepart(ww,(@inputdate))),2)
set @day		= right(''0''+convert(varchar(2),day(@inputdate)),2)
set @24hours	= right(''0''+convert(varchar(2),datepart(hh,@inputdate)),2)

set @UNIXPOSIX	= convert(varchar(15),datediff(ss,convert(datetime,''01/01/1970 00:00:000''),@inputdate))

if datepart(hh,@inputdate) >12
begin
set @12hours      = right(''0''+convert(varchar(2),datepart(hh,@inputdate)) -12,2)
end
else
begin
set @12hours      = right(''0''+convert(varchar(2),datepart(hh,@inputdate)) ,2)
end

if datepart(hh,@inputdate) >11 
begin
set @AMPM =''PM''
end
else
begin
set @AMPM =''AM''
end

set @minutes      = right(''0''+convert(varchar(2),datepart(n,@inputdate)),2)
set @seconds      = right(''0''+convert(varchar(2),datepart(ss,@inputdate)),2)
set @milliseconds = convert(varchar(3),datepart(ms,@inputdate))

set @dayname      = datename(weekday,@inputdate)
set @monthname    = datename(mm,@inputdate)
set @shortmonthname= left(datename(mm,@inputdate),3)
set @formatteddate = @format
set @formatteddate=replace(@formatteddate,''MONTH'',@monthname)
set @formatteddate=replace(@formatteddate,''MON'',@shortmonthname)
set @formatteddate=replace(@formatteddate,''AMPM'',@AMPM)

set @formatteddate=replace(@formatteddate,''YYYY'',@year)
set @formatteddate=replace(@formatteddate,''Yr'',@shortyear)
set @formatteddate=replace(@formatteddate,''QQ'',@quarter)
set @formatteddate=replace(@formatteddate,''WW'',@week)
set @formatteddate=replace(@formatteddate,''MM'',@month)
set @formatteddate=replace(@formatteddate,''DD'',@Day)
set @formatteddate=replace(@formatteddate,''24HH'',@24hours)
set @formatteddate=replace(@formatteddate,''12HH'',@12hours)
set @formatteddate=replace(@formatteddate,''Mi'',@minutes)
set @formatteddate=replace(@formatteddate,''SS'',@seconds)
set @formatteddate=replace(@formatteddate,''MS'',@milliseconds)

set @formatteddate=replace(@formatteddate,''DAY'',@dayname)
set @formatteddate=replace(@formatteddate,''UNIXPOSIX'',@UNIXPOSIX)

if charindex(''ucase'',@formatteddate)<>0
begin
set @formatteddate=replace(@formatteddate,''ucase'','''')
set @formatteddate=upper(@formatteddate)
end

if charindex(''lcase'',@formatteddate)<>0
begin
set @formatteddate=replace(@formatteddate,''lcase'','''')
set @formatteddate=lower(@formatteddate)
end


return @formatteddate
end
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getmydate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[getmydate]
(@inputdate as datetime)
RETURNS DATETIME
AS
BEGIN

DECLARE @NEWDT AS DATETIME

if (@inputdate is NULL or @inputdate ='''')
begin
--set @inputdate = getdate()
set @inputdate = getdate()

end

SET @NEWDT = DATEADD(mi,30,(DATEADD(hh, 12, @inputdate)))

RETURN @NEWDT
END' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetAge]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[fn_GetAge]
(@in_DOB AS datetime,@now as datetime)

returns int

as

begin

DECLARE @age int

IF cast(datepart(m,@now) as int) > cast(datepart(m,@in_DOB) as int)

SET @age = cast(datediff(yyyy,@in_DOB,@now) as int)

else

IF cast(datepart(m,@now) as int) = cast(datepart(m,@in_DOB) as int)

IF datepart(d,@now) >= datepart(d,@in_DOB)

SET @age = cast(datediff(yyyy,@in_DOB,@now) as int)

ELSE

SET @age = cast(datediff(yyyy,@in_DOB,@now) as int) -1

ELSE

SET @age = cast(datediff(yyyy,@in_DOB,@now) as int) - 1

RETURN @age

end
' 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[logins]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[logins](
	[id] [bigint] IDENTITY(1000000,1) NOT NULL,
	[emailid] [varchar](50) NOT NULL,
	[pass] [varchar](50) NOT NULL,
	[username] [varchar](10) NULL,
	[created_at] [datetime] NOT NULL CONSTRAINT [DF_logins_type]  DEFAULT (getdate()),
 CONSTRAINT [PK_logins] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[admins]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[admins](
	[id] [bigint] IDENTITY(1000000,1) NOT NULL,
	[emailid] [varchar](50) NOT NULL,
	[pass] [varchar](50) NOT NULL,
	[username] [varchar](10) NULL,
 CONSTRAINT [PK_admins] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[p_details]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[p_details](
	[id] [bigint] NOT NULL,
	[fname] [varchar](50) NOT NULL,
	[mname] [varchar](50) NULL,
	[lname] [varchar](50) NOT NULL,
	[dob] [datetime] NOT NULL,
	[gender] [bit] NOT NULL,
	[mobile] [bigint] NOT NULL,
	[m_status] [int] NOT NULL,
	[mother_tongue] [int] NOT NULL,
	[address] [text] NOT NULL,
	[city] [varchar](50) NOT NULL,
	[state] [int] NULL,
	[country] [int] NOT NULL,
	[create_profile] [int] NOT NULL CONSTRAINT [DF_p_details_create_profile]  DEFAULT ((1)),
	[have_children] [int] NOT NULL CONSTRAINT [DF_p_details_have_children]  DEFAULT ((1)),
 CONSTRAINT [PK_p_details] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pref_mthr_tongue]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[pref_mthr_tongue](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[mthr_tongue] [varchar](50) NOT NULL,
 CONSTRAINT [PK_pref_mthr_tongue] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pref_m_status]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[pref_m_status](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[m_status] [int] NOT NULL,
 CONSTRAINT [PK_pref_m_status] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[physical]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[physical](
	[id] [bigint] NOT NULL,
	[height] [int] NULL,
	[weight] [int] NULL,
	[body_type] [int] NULL,
	[smoke] [int] NULL,
	[drink] [int] NULL,
	[diet] [int] NULL,
	[complexion] [int] NULL,
	[other] [text] NULL,
	[challenged] [int] NULL,
	[blood_group] [int] NULL,
	[HIV] [bit] NULL,
 CONSTRAINT [PK_physical] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[partner]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[partner](
	[id] [bigint] NOT NULL,
	[age_u] [int] NULL,
	[age_l] [int] NULL,
	[height_u] [varchar](50) NULL,
	[height_l] [varchar](50) NULL,
	[income_u] [int] NULL,
	[income_l] [int] NULL,
	[other] [text] NULL,
 CONSTRAINT [PK_partner] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[family]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[family](
	[id] [bigint] NOT NULL,
	[f_values] [int] NULL,
	[f_type] [int] NULL,
	[f_status] [int] NULL,
	[father_occ] [int] NULL,
	[mother_occ] [int] NULL,
	[brothers] [int] NULL,
	[sisters] [int] NULL,
	[liv_with] [bit] NULL,
	[other] [text] NULL,
	[residency_status] [int] NULL,
 CONSTRAINT [PK_family] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Its  DB for matrimonial website' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'family'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[education]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[education](
	[id] [bigint] NOT NULL,
	[highest_deg] [int] NULL,
	[work_status] [int] NULL,
	[work_area] [int] NULL,
	[other] [text] NULL,
	[work_prefer] [int] NULL,
	[Annual_salary] [int] NULL,
 CONSTRAINT [PK_education] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[conv_users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[conv_users](
	[convid] [bigint] IDENTITY(1,1) NOT NULL,
	[user1] [bigint] NOT NULL,
	[user2] [bigint] NOT NULL,
 CONSTRAINT [PK_conv_users] PRIMARY KEY CLUSTERED 
(
	[convid] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[album]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[album](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[imgdatetime] [datetime] NOT NULL CONSTRAINT [DF_album_imgdatetime]  DEFAULT (getdate()),
 CONSTRAINT [PK_album] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[notifications]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[notifications](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[notif_time] [datetime] NOT NULL CONSTRAINT [DF_notification_notif_time]  DEFAULT (getdate()),
	[notif_text] [text] NOT NULL,
	[status_read] [bit] NOT NULL CONSTRAINT [DF_notification_status_read]  DEFAULT ((0)),
	[notif_type] [int] NULL,
	[notif_link] [varchar](80) NULL,
 CONSTRAINT [PK_notifications] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[miscellaneous]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[miscellaneous](
	[id] [bigint] NOT NULL,
	[hobbies] [text] NULL,
	[interest] [text] NULL,
	[car] [bit] NULL,
	[house] [bit] NULL,
 CONSTRAINT [PK_miscellaneous] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[horoscope]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[horoscope](
	[id] [bigint] NOT NULL,
	[birth_time] [datetime] NULL,
	[gotra_paternal] [varchar](50) NULL,
	[gotra_maternal] [varchar](50) NULL,
	[ancestral_origin] [varchar](50) NULL,
	[manglik] [int] NULL,
	[nakshatra] [int] NULL,
	[moon_sign] [int] NULL,
	[sun_sign] [int] NULL,
	[horoscope_match] [int] NULL,
	[file_name] [varchar](100) NULL,
	[file_ext] [varchar](5) NULL,
 CONSTRAINT [PK_horoscope] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[visitor]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[visitor](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[prof_id] [bigint] NOT NULL,
	[visitor_id] [bigint] NOT NULL,
	[v_date] [datetime] NOT NULL CONSTRAINT [DF_visitor_v_date]  DEFAULT (getdate()),
 CONSTRAINT [PK_visitor] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[userinfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[userinfo](
	[id] [bigint] NOT NULL,
	[active] [bit] NOT NULL CONSTRAINT [DF_userinfo_active]  DEFAULT ((1)),
	[last_login] [datetime] NOT NULL CONSTRAINT [DF_userinfo_last_login]  DEFAULT (getdate()),
	[sed] [datetime] NOT NULL CONSTRAINT [DF_userinfo_sed]  DEFAULT (((1)/(1))/(1990)),
	[email_verified] [varchar](10) NOT NULL CONSTRAINT [DF_userinfo_email_verified]  DEFAULT (right(CONVERT([varchar](50),newid(),(0)),(10))),
	[mob_verified] [varchar](10) NOT NULL CONSTRAINT [DF_userinfo_mob_verified]  DEFAULT (right(CONVERT([varchar](50),newid(),(0)),(10))),
	[approved] [bit] NOT NULL CONSTRAINT [DF_userinfo_approved]  DEFAULT ((0)),
	[prof_stat] [int] NULL,
	[prof_img] [varchar](50) NULL,
 CONSTRAINT [PK_userinfo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[shortlist]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[shortlist](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[prof_id] [bigint] NOT NULL,
	[shortlisted_id] [bigint] NOT NULL,
	[s_date] [datetime] NOT NULL CONSTRAINT [DF_shortlist_v_date]  DEFAULT (getdate()),
 CONSTRAINT [PK_shortlist] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[saved_searches]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[saved_searches](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[search_name] [varchar](20) NOT NULL,
	[search_link] [text] NOT NULL,
	[created_at] [datetime] NOT NULL CONSTRAINT [DF_saved_searches_created_at]  DEFAULT (getdate()),
 CONSTRAINT [PK_saved_searches] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[request]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[request](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[sender] [bigint] NOT NULL,
	[receiver] [bigint] NOT NULL,
	[answer] [int] NOT NULL CONSTRAINT [DF_request_answer]  DEFAULT ((0)),
	[r_date] [datetime] NOT NULL CONSTRAINT [DF_request_r_date]  DEFAULT (getdate()),
 CONSTRAINT [PK_request] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[membership]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[membership](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[m_date] [datetime] NOT NULL CONSTRAINT [DF_memberships_m_date]  DEFAULT (getdate()),
	[months_added] [int] NOT NULL,
	[admin] [bigint] NOT NULL,
	[comment] [text] NOT NULL,
 CONSTRAINT [PK_membership] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[religion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[religion](
	[id] [bigint] NOT NULL,
	[caste] [int] NULL,
	[religion] [int] NULL,
	[sub1] [varchar](50) NULL,
	[sub2] [varchar](50) NULL,
	[sub3] [varchar](50) NULL,
	[sub4] [varchar](50) NULL,
 CONSTRAINT [PK_religion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pref_religion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[pref_religion](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[religion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_pref_religion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[messages]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[messages](
	[msgid] [bigint] IDENTITY(1,1) NOT NULL,
	[sender] [bigint] NOT NULL,
	[msgtime] [datetime] NOT NULL CONSTRAINT [DF_messages_msgtime]  DEFAULT (getdate()),
	[msgtext] [text] NOT NULL,
	[convid] [bigint] NOT NULL,
	[status_read] [bit] NOT NULL CONSTRAINT [DF_messages_status_read]  DEFAULT ((0)),
 CONSTRAINT [PK_messages] PRIMARY KEY CLUSTERED 
(
	[msgid] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_pref_mthr_tongue_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[pref_mthr_tongue]'))
ALTER TABLE [dbo].[pref_mthr_tongue]  WITH CHECK ADD  CONSTRAINT [FK_pref_mthr_tongue_logins] FOREIGN KEY([user_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_pref_m_status_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[pref_m_status]'))
ALTER TABLE [dbo].[pref_m_status]  WITH CHECK ADD  CONSTRAINT [FK_pref_m_status_logins] FOREIGN KEY([user_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_physical_physical]') AND parent_object_id = OBJECT_ID(N'[dbo].[physical]'))
ALTER TABLE [dbo].[physical]  WITH CHECK ADD  CONSTRAINT [FK_physical_physical] FOREIGN KEY([id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_partner_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[partner]'))
ALTER TABLE [dbo].[partner]  WITH CHECK ADD  CONSTRAINT [FK_partner_logins] FOREIGN KEY([id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_logins_family]') AND parent_object_id = OBJECT_ID(N'[dbo].[family]'))
ALTER TABLE [dbo].[family]  WITH CHECK ADD  CONSTRAINT [FK_logins_family] FOREIGN KEY([id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_education_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[education]'))
ALTER TABLE [dbo].[education]  WITH CHECK ADD  CONSTRAINT [FK_education_logins] FOREIGN KEY([id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_conv_users_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[conv_users]'))
ALTER TABLE [dbo].[conv_users]  WITH CHECK ADD  CONSTRAINT [FK_conv_users_logins] FOREIGN KEY([user2])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_conv_users_logins1]') AND parent_object_id = OBJECT_ID(N'[dbo].[conv_users]'))
ALTER TABLE [dbo].[conv_users]  WITH CHECK ADD  CONSTRAINT [FK_conv_users_logins1] FOREIGN KEY([user1])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_album_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[album]'))
ALTER TABLE [dbo].[album]  WITH CHECK ADD  CONSTRAINT [FK_album_logins] FOREIGN KEY([user_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_notifications_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[notifications]'))
ALTER TABLE [dbo].[notifications]  WITH CHECK ADD  CONSTRAINT [FK_notifications_logins] FOREIGN KEY([user_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_miscellaneous_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[miscellaneous]'))
ALTER TABLE [dbo].[miscellaneous]  WITH CHECK ADD  CONSTRAINT [FK_miscellaneous_logins] FOREIGN KEY([id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_horoscope_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[horoscope]'))
ALTER TABLE [dbo].[horoscope]  WITH CHECK ADD  CONSTRAINT [FK_horoscope_logins] FOREIGN KEY([id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_visitor_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[visitor]'))
ALTER TABLE [dbo].[visitor]  WITH CHECK ADD  CONSTRAINT [FK_visitor_logins] FOREIGN KEY([prof_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_visitor_logins1]') AND parent_object_id = OBJECT_ID(N'[dbo].[visitor]'))
ALTER TABLE [dbo].[visitor]  WITH CHECK ADD  CONSTRAINT [FK_visitor_logins1] FOREIGN KEY([visitor_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_userinfo_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[userinfo]'))
ALTER TABLE [dbo].[userinfo]  WITH CHECK ADD  CONSTRAINT [FK_userinfo_logins] FOREIGN KEY([id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_shortlist_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[shortlist]'))
ALTER TABLE [dbo].[shortlist]  WITH CHECK ADD  CONSTRAINT [FK_shortlist_logins] FOREIGN KEY([prof_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_shortlist_logins1]') AND parent_object_id = OBJECT_ID(N'[dbo].[shortlist]'))
ALTER TABLE [dbo].[shortlist]  WITH CHECK ADD  CONSTRAINT [FK_shortlist_logins1] FOREIGN KEY([shortlisted_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_saved_searches_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[saved_searches]'))
ALTER TABLE [dbo].[saved_searches]  WITH CHECK ADD  CONSTRAINT [FK_saved_searches_logins] FOREIGN KEY([user_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_request_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[request]'))
ALTER TABLE [dbo].[request]  WITH CHECK ADD  CONSTRAINT [FK_request_logins] FOREIGN KEY([receiver])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_request_logins1]') AND parent_object_id = OBJECT_ID(N'[dbo].[request]'))
ALTER TABLE [dbo].[request]  WITH CHECK ADD  CONSTRAINT [FK_request_logins1] FOREIGN KEY([sender])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_membership_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[membership]'))
ALTER TABLE [dbo].[membership]  WITH CHECK ADD  CONSTRAINT [FK_membership_logins] FOREIGN KEY([user_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_logins_religion]') AND parent_object_id = OBJECT_ID(N'[dbo].[religion]'))
ALTER TABLE [dbo].[religion]  WITH CHECK ADD  CONSTRAINT [FK_logins_religion] FOREIGN KEY([id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_pref_religion_logins]') AND parent_object_id = OBJECT_ID(N'[dbo].[pref_religion]'))
ALTER TABLE [dbo].[pref_religion]  WITH CHECK ADD  CONSTRAINT [FK_pref_religion_logins] FOREIGN KEY([user_id])
REFERENCES [dbo].[logins] ([id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_messages_conv_users]') AND parent_object_id = OBJECT_ID(N'[dbo].[messages]'))
ALTER TABLE [dbo].[messages]  WITH CHECK ADD  CONSTRAINT [FK_messages_conv_users] FOREIGN KEY([convid])
REFERENCES [dbo].[conv_users] ([convid])

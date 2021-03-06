
/* Need to test in prod server
SELECT (MAX(cast(RIGHT(wonumber, LEN(wonumber) - 3) as INT))+1) FROM    workorders

SELECT (MAX(cast(RIGHT(WPID, LEN(WPID) - 4) as INT))+1) FROM    dailyreports

SELECT (MAX(cast(RIGHT(PIID, LEN(PIID) - 4) as INT))+1) FROM    reports01

SELECT (MAX(cast(RIGHT(SNID, LEN(SNID) - 4) as INT))+1) FROM    reports02


CREATE TABLE [dbo].[xref](
 [uuid] [nvarchar](50) NOT NULL,
 [username] [nvarchar](50) NULL,
 [propertyid] [nvarchar](50) NULL,
 [redirect2page] [nvarchar](50) NULL,
 CONSTRAINT [PK_xref] PRIMARY KEY CLUSTERED 
(
 [uuid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
*/
alter Procedure [dbo].[prAllVendorList]
as
Begin
	SELECT  vendorid, name
FROM         vendors

End

Go

Alter Procedure PIXREF
	@BatchID as nvarchar(100),
	@UserID as nvarchar(100),
	@PropertyID as nvarchar(100),
	@RedirectPage as nvarchar(100)
	AS
BEGIN
	Insert into xref(uuid,username,propertyid,redirect2page) values(@BatchID,@UserID,@PropertyID,@RedirectPage);

END
GO


Alter Procedure DeleteRecord
@PropertyID as nvarchar(100),
@UniqueID as nvarchar(100),
@Category as nvarchar(100)

AS
BEGIN
		IF @Category='Work Order'
		BEGIN
		      Update workorders Set approvalstatus=5 Where propertyid=@PropertyID AND wonumber=@UniqueID
			--Delete from workorders Where propertyid=@PropertyID AND wonumber=@UniqueID
			--Delete from workorders_cost Where wonumber=@UniqueID
		END

		IF @Category='Property Inspection'
		BEGIN
			Update reports01 Set approvalstatus=5 Where propertyid=@PropertyID AND batchnumber=@UniqueID	
			--Delete from reports01 Where propertyid=@PropertyID AND batchnumber=@UniqueID			
		END

		IF @Category='Snow Removal'
		BEGIN
			Update reports02 Set approvalstatus=5 Where propertyid=@PropertyID AND batchnumber=@UniqueID	
			--Delete from reports02 Where propertyid=@PropertyID AND batchnumber=@UniqueID
		END		
		Select 'Deleted'
END

GO

Alter  Procedure prServiceLogInfo
@WOID as nvarchar(100),
@UserID as nvarchar(100)

AS
BEGIN
Select WOID,Serviselog,(Select fullname from users Where username=Serviselog.UserName) AS 'UserName', convert(varchar, LogDate, 100) as 'LogDate' from ServiseLog Where WOID=@WOID
END

GO

/*CREATE TABLE [dbo].[ServiseLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[WOID] [nvarchar](50) NULL,
	[Serviselog] [varchar](max) NULL,
	[UserName] [varchar](50) NULL,
	[LogDate] [datetime] NULL,
 CONSTRAINT [PK_ServiseLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO*/

--//Pleaase create/or confirm column SNID as nvarchar(100) of snow table :reports02
--//Pleaase create/or confirm column PIID as nvarchar(100) of PropertyInspection table :reports01

ALTER Procedure [dbo].[prSnowRemoval] 
@Action nvarchar(100),@propertyid nvarchar(100),	@dateperformed nvarchar(100),	@dateentered nvarchar(100),	@timeentered nvarchar(100),	@username nvarchar(100),	@approvalstatus nvarchar(100),	@batchnumber nvarchar(100),	@siteconditions_accumulationinches nvarchar(100),	@siteconditions_accumulationtype nvarchar(100),	@siteconditions_drifting nvarchar(100),	@siteconditions_ice nvarchar(100),	@siteconditions_traffic nvarchar(100),	@weatherconditions_currentprecipitation nvarchar(100),	@weatherconditions_currentconditions nvarchar(100),	@plowingandclearing_roadsandlotsplowingstatus nvarchar(100),	@plowingandclearing_entranceexit nvarchar(100),	@plowingandclearing_handicap nvarchar(100),	@plowingandclearing_roadandroadways nvarchar(100),	@plowingandclearing_roadandroadwaysfront nvarchar(100),	@plowingandclearing_roadandroadwaysrear nvarchar(100),	@plowingandclearing_roadandroadwaysside nvarchar(100),	@plowingandclearing_roadandroadwaysother nvarchar(100),	@plowingandclearing_parkingspotsareas nvarchar(100),	@plowingandclearing_loadingdocks nvarchar(100),	@plowingandclearing_drivethru nvarchar(100),	@plowingandclearing_ramps nvarchar(100),	@plowingandclearing_deliveryarea nvarchar(100),	@plowingandclearing_comments nvarchar(100),	@walksclearing_clearsidewalksstatus nvarchar(100),	@walksclearing_entrancedoors nvarchar(100),	@walksclearing_servicedoors nvarchar(100),	@walksclearing_ramps nvarchar(100),	@walksclearing_steps nvarchar(100),	@walksclearing_gfbidblock nvarchar(100),	@walksclearing_privatewalks nvarchar(100),	@walksclearing_citywalks nvarchar(100),	@walksclearing_comments nvarchar(100),	@walksclearing_snowremoval nvarchar(100),	@walksclearing_stackingonsite nvarchar(100),	@walksclearing_stackingonsitehrs nvarchar(100),	@walksclearing_removal nvarchar(100),	@walksclearing_removalhrs nvarchar(100),	@walksclearing_snowfield nvarchar(100),	@deicingandantiicing_roadsandlotsdeicingstatus nvarchar(100),	@deicingandantiicing_entranceexit nvarchar(100),	@deicingandantiicing_handicap nvarchar(100),	@deicingandantiicing_roadandroadways nvarchar(100),	@deicingandantiicing_roadandroadwaysfront nvarchar(100),	@deicingandantiicing_roadandroadwaysrear nvarchar(100),	@deicingandantiicing_roadandroadwaysside nvarchar(100),	@deicingandantiicing_roadandroadwaysother nvarchar(100),	@deicingandantiicing_parkingspotsareas nvarchar(100),	@deicingandantiicing_loadingdocks nvarchar(100),	@deicingandantiicing_drivethru nvarchar(100),	@deicingandantiicing_ramps nvarchar(100),	@deicingandantiicing_deliveryarea nvarchar(100),	@deicingandantiicing_comments nvarchar(100),	@deicingandantiicing_materialsusedsalt nvarchar(100),	@deicingandantiicing_saltbags nvarchar(100),	@deicingandantiicing_saltlbs nvarchar(100),	@deicingandantiicing_materialsusedcalcium nvarchar(100),	@deicingandantiicing_calciumbags nvarchar(100),	@deicingandantiicing_calciumlbs nvarchar(100),	@walksdeicing_deicesidewalksstatus nvarchar(100),	@walksdeicing_entrancedoors nvarchar(100),	@walksdeicing_servicedoors nvarchar(100),	@walksdeicing_ramps nvarchar(100),	@walksdeicing_steps nvarchar(100),	@walksdeicing_privatewalks nvarchar(100),	@walksdeicing_citywalks nvarchar(100),	@walksdeicing_comments nvarchar(100),	@walksdeicing_materialsusedblend nvarchar(100),	@walksdeicing_blendbags nvarchar(100),	@walksdeicing_blendlbs nvarchar(100),	@walksdeicing_materialsusedcalcium nvarchar(100),	@walksdeicing_calciumbags nvarchar(100),	@walksdeicing_calciumlbs nvarchar(100),	@walksdeicing_noserviceperformedsitecheckonly nvarchar(100),	@liquidantiicinglog_applicator nvarchar(100),	@liquidantiicinglog_trucknumber nvarchar(100),	@liquidantiicinglog_timein nvarchar(100),	@liquidantiicinglog_timeout nvarchar(100),	@liquidantiicinglog_goundtemperaturein nvarchar(100),	@liquidantiicinglog_goundtemperatureout nvarchar(100),	@liquidantiicinglog_airtemperaturein nvarchar(100),	@liquidantiicinglog_airtemperatureinout nvarchar(100),	@liquidantiicinglog_siteconditions nvarchar(100),	@liquidantiicinglog_surfaceswet nvarchar(100),	@liquidantiicinglog_surfacesdry nvarchar(100),	@liquidantiicinglog_fallingsnowice nvarchar(100),	@liquidantiicinglog_fallingsnowrain nvarchar(100),	@liquidantiicinglog_materialtypeapplied nvarchar(100),	@liquidantiicinglog_amountintankgallonsstart nvarchar(100),	@liquidantiicinglog_amountintankgallonsstop nvarchar(100),	@liquidantiicinglog_totalgallonsused nvarchar(100),	@liquidantiicinglog_areastreated nvarchar(100),	@liquidantiicinglog_tipsnozzlesused nvarchar(100),	@liquidantiicinglog_groundspeed nvarchar(100),	@liquidantiicinglog_trafficconditions nvarchar(100),	@liquidantiicinglog_notes nvarchar(100),	@vendorname nvarchar(100),	@timearrival nvarchar(100),	@timedeparture nvarchar(100),	@pic1 nvarchar(100),	@pic2 nvarchar(100),	@pic3 nvarchar(100),	@pic4 nvarchar(100),	@pic5 nvarchar(100)
AS
BEGIN
    IF @Action='New Item'
	BEGIN
		declare @SNID as nvarchar(100)
		Set @SNID=(Select dbo.GetRecordID('Snow Removal','SR'))
		Insert into reports02(SNID,propertyid,	dateperformed,	dateentered,	timeentered,	username,	approvalstatus,	batchnumber,	siteconditions_accumulationinches,	siteconditions_accumulationtype,	siteconditions_drifting,	siteconditions_ice,	siteconditions_traffic,	weatherconditions_currentprecipitation,	weatherconditions_currentconditions,	plowingandclearing_roadsandlotsplowingstatus,	plowingandclearing_entranceexit,	plowingandclearing_handicap,	plowingandclearing_roadandroadways,	plowingandclearing_roadandroadwaysfront,	plowingandclearing_roadandroadwaysrear,	plowingandclearing_roadandroadwaysside,	plowingandclearing_roadandroadwaysother,	plowingandclearing_parkingspotsareas,	plowingandclearing_loadingdocks,	plowingandclearing_drivethru,	plowingandclearing_ramps,	plowingandclearing_deliveryarea,	plowingandclearing_comments,	walksclearing_clearsidewalksstatus,	walksclearing_entrancedoors,	walksclearing_servicedoors,	walksclearing_ramps,	walksclearing_steps,	walksclearing_gfbidblock,	walksclearing_privatewalks,	walksclearing_citywalks,	walksclearing_comments,	walksclearing_snowremoval,	walksclearing_stackingonsite,	walksclearing_stackingonsitehrs,	walksclearing_removal,	walksclearing_removalhrs,	walksclearing_snowfield,	deicingandantiicing_roadsandlotsdeicingstatus,	deicingandantiicing_entranceexit,	deicingandantiicing_handicap,	deicingandantiicing_roadandroadways,	deicingandantiicing_roadandroadwaysfront,	deicingandantiicing_roadandroadwaysrear,	deicingandantiicing_roadandroadwaysside,	deicingandantiicing_roadandroadwaysother,	deicingandantiicing_parkingspotsareas,	deicingandantiicing_loadingdocks,	deicingandantiicing_drivethru,	deicingandantiicing_ramps,	deicingandantiicing_deliveryarea,	deicingandantiicing_comments,	deicingandantiicing_materialsusedsalt,	deicingandantiicing_saltbags,	deicingandantiicing_saltlbs,	deicingandantiicing_materialsusedcalcium,	deicingandantiicing_calciumbags,	deicingandantiicing_calciumlbs,	walksdeicing_deicesidewalksstatus,	walksdeicing_entrancedoors,	walksdeicing_servicedoors,	walksdeicing_ramps,	walksdeicing_steps,	walksdeicing_privatewalks,	walksdeicing_citywalks,	walksdeicing_comments,	walksdeicing_materialsusedblend,	walksdeicing_blendbags,	walksdeicing_blendlbs,	walksdeicing_materialsusedcalcium,	walksdeicing_calciumbags,	walksdeicing_calciumlbs,	walksdeicing_noserviceperformedsitecheckonly,	liquidantiicinglog_applicator,	liquidantiicinglog_trucknumber,	liquidantiicinglog_timein,	liquidantiicinglog_timeout,	liquidantiicinglog_goundtemperaturein,	liquidantiicinglog_goundtemperatureout,	liquidantiicinglog_airtemperaturein,	liquidantiicinglog_airtemperatureinout,	liquidantiicinglog_siteconditions,	liquidantiicinglog_surfaceswet,	liquidantiicinglog_surfacesdry,	liquidantiicinglog_fallingsnowice,	liquidantiicinglog_fallingsnowrain,	liquidantiicinglog_materialtypeapplied,	liquidantiicinglog_amountintankgallonsstart,	liquidantiicinglog_amountintankgallonsstop,	liquidantiicinglog_totalgallonsused,	liquidantiicinglog_areastreated,	liquidantiicinglog_tipsnozzlesused,	liquidantiicinglog_groundspeed,	liquidantiicinglog_trafficconditions,	liquidantiicinglog_notes,	vendorname,	timearrival,	timedeparture,	pic1,	pic2,	pic3,	pic4,	pic5)
			Values(@SNID,@propertyid,	@dateperformed,	@dateentered,	@timeentered,	@username,	@approvalstatus,	@batchnumber,	@siteconditions_accumulationinches,	@siteconditions_accumulationtype,	@siteconditions_drifting,	@siteconditions_ice,	@siteconditions_traffic,	@weatherconditions_currentprecipitation,	@weatherconditions_currentconditions,	@plowingandclearing_roadsandlotsplowingstatus,	@plowingandclearing_entranceexit,	@plowingandclearing_handicap,	@plowingandclearing_roadandroadways,	@plowingandclearing_roadandroadwaysfront,	@plowingandclearing_roadandroadwaysrear,	@plowingandclearing_roadandroadwaysside,	@plowingandclearing_roadandroadwaysother,	@plowingandclearing_parkingspotsareas,	@plowingandclearing_loadingdocks,	@plowingandclearing_drivethru,	@plowingandclearing_ramps,	@plowingandclearing_deliveryarea,	@plowingandclearing_comments,	@walksclearing_clearsidewalksstatus,	@walksclearing_entrancedoors,	@walksclearing_servicedoors,	@walksclearing_ramps,	@walksclearing_steps,	@walksclearing_gfbidblock,	@walksclearing_privatewalks,	@walksclearing_citywalks,	@walksclearing_comments,	@walksclearing_snowremoval,	@walksclearing_stackingonsite,	@walksclearing_stackingonsitehrs,	@walksclearing_removal,	@walksclearing_removalhrs,	@walksclearing_snowfield,	@deicingandantiicing_roadsandlotsdeicingstatus,	@deicingandantiicing_entranceexit,	@deicingandantiicing_handicap,	@deicingandantiicing_roadandroadways,	@deicingandantiicing_roadandroadwaysfront,	@deicingandantiicing_roadandroadwaysrear,	@deicingandantiicing_roadandroadwaysside,	@deicingandantiicing_roadandroadwaysother,	@deicingandantiicing_parkingspotsareas,	@deicingandantiicing_loadingdocks,	@deicingandantiicing_drivethru,	@deicingandantiicing_ramps,	@deicingandantiicing_deliveryarea,	@deicingandantiicing_comments,	@deicingandantiicing_materialsusedsalt,	@deicingandantiicing_saltbags,	@deicingandantiicing_saltlbs,	@deicingandantiicing_materialsusedcalcium,	@deicingandantiicing_calciumbags,	@deicingandantiicing_calciumlbs,	@walksdeicing_deicesidewalksstatus,	@walksdeicing_entrancedoors,	@walksdeicing_servicedoors,	@walksdeicing_ramps,	@walksdeicing_steps,	@walksdeicing_privatewalks,	@walksdeicing_citywalks,	@walksdeicing_comments,	@walksdeicing_materialsusedblend,	@walksdeicing_blendbags,	@walksdeicing_blendlbs,	@walksdeicing_materialsusedcalcium,	@walksdeicing_calciumbags,	@walksdeicing_calciumlbs,	@walksdeicing_noserviceperformedsitecheckonly,	@liquidantiicinglog_applicator,	@liquidantiicinglog_trucknumber,	@liquidantiicinglog_timein,	@liquidantiicinglog_timeout,	@liquidantiicinglog_goundtemperaturein,	@liquidantiicinglog_goundtemperatureout,	@liquidantiicinglog_airtemperaturein,	@liquidantiicinglog_airtemperatureinout,	@liquidantiicinglog_siteconditions,	@liquidantiicinglog_surfaceswet,	@liquidantiicinglog_surfacesdry,	@liquidantiicinglog_fallingsnowice,	@liquidantiicinglog_fallingsnowrain,	@liquidantiicinglog_materialtypeapplied,	@liquidantiicinglog_amountintankgallonsstart,	@liquidantiicinglog_amountintankgallonsstop,	@liquidantiicinglog_totalgallonsused,	@liquidantiicinglog_areastreated,	@liquidantiicinglog_tipsnozzlesused,	@liquidantiicinglog_groundspeed,	@liquidantiicinglog_trafficconditions,	@liquidantiicinglog_notes,	@vendorname,	@timearrival,	@timedeparture,	@pic1,	@pic2,	@pic3,	@pic4,	@pic5)
	END
	 IF @Action='Update'
	BEGIN
		Update reports02 Set dateperformed=@dateperformed,	dateentered=@dateentered,	timeentered=@timeentered,	username=@username,	approvalstatus=@approvalstatus,	siteconditions_accumulationinches=@siteconditions_accumulationinches,	siteconditions_accumulationtype=@siteconditions_accumulationtype,	siteconditions_drifting=@siteconditions_drifting,	siteconditions_ice=@siteconditions_ice,	siteconditions_traffic=@siteconditions_traffic,	weatherconditions_currentprecipitation=@weatherconditions_currentprecipitation,	weatherconditions_currentconditions=@weatherconditions_currentconditions,	plowingandclearing_roadsandlotsplowingstatus=@plowingandclearing_roadsandlotsplowingstatus,	plowingandclearing_entranceexit=@plowingandclearing_entranceexit,	plowingandclearing_handicap=@plowingandclearing_handicap,	plowingandclearing_roadandroadways=@plowingandclearing_roadandroadways,	plowingandclearing_roadandroadwaysfront=@plowingandclearing_roadandroadwaysfront,	plowingandclearing_roadandroadwaysrear=@plowingandclearing_roadandroadwaysrear,	plowingandclearing_roadandroadwaysside=@plowingandclearing_roadandroadwaysside,	plowingandclearing_roadandroadwaysother=@plowingandclearing_roadandroadwaysother,	plowingandclearing_parkingspotsareas=@plowingandclearing_parkingspotsareas,	plowingandclearing_loadingdocks=@plowingandclearing_loadingdocks,	plowingandclearing_drivethru=@plowingandclearing_drivethru,	plowingandclearing_ramps=@plowingandclearing_ramps,	plowingandclearing_deliveryarea=@plowingandclearing_deliveryarea,	plowingandclearing_comments=@plowingandclearing_comments,	walksclearing_clearsidewalksstatus=@walksclearing_clearsidewalksstatus,	walksclearing_entrancedoors=@walksclearing_entrancedoors,	walksclearing_servicedoors=@walksclearing_servicedoors,	walksclearing_ramps=@walksclearing_ramps,	walksclearing_steps=@walksclearing_steps,	walksclearing_gfbidblock=@walksclearing_gfbidblock,	walksclearing_privatewalks=@walksclearing_privatewalks,	walksclearing_citywalks=@walksclearing_citywalks,	walksclearing_comments=@walksclearing_comments,	walksclearing_snowremoval=@walksclearing_snowremoval,	walksclearing_stackingonsite=@walksclearing_stackingonsite,	walksclearing_stackingonsitehrs=@walksclearing_stackingonsitehrs,	walksclearing_removal=@walksclearing_removal,	walksclearing_removalhrs=@walksclearing_removalhrs,	walksclearing_snowfield=@walksclearing_snowfield,	deicingandantiicing_roadsandlotsdeicingstatus=@deicingandantiicing_roadsandlotsdeicingstatus,	deicingandantiicing_entranceexit=@deicingandantiicing_entranceexit,	deicingandantiicing_handicap=@deicingandantiicing_handicap,	deicingandantiicing_roadandroadways=@deicingandantiicing_roadandroadways,	deicingandantiicing_roadandroadwaysfront=@deicingandantiicing_roadandroadwaysfront,	deicingandantiicing_roadandroadwaysrear=@deicingandantiicing_roadandroadwaysrear,	deicingandantiicing_roadandroadwaysside=@deicingandantiicing_roadandroadwaysside,	deicingandantiicing_roadandroadwaysother=@deicingandantiicing_roadandroadwaysother,	deicingandantiicing_parkingspotsareas=@deicingandantiicing_parkingspotsareas,	deicingandantiicing_loadingdocks=@deicingandantiicing_loadingdocks,	deicingandantiicing_drivethru=@deicingandantiicing_drivethru,	deicingandantiicing_ramps=@deicingandantiicing_ramps,	deicingandantiicing_deliveryarea=@deicingandantiicing_deliveryarea,	deicingandantiicing_comments=@deicingandantiicing_comments,	deicingandantiicing_materialsusedsalt=@deicingandantiicing_materialsusedsalt,	deicingandantiicing_saltbags=@deicingandantiicing_saltbags,	deicingandantiicing_saltlbs=@deicingandantiicing_saltlbs,	deicingandantiicing_materialsusedcalcium=@deicingandantiicing_materialsusedcalcium,	deicingandantiicing_calciumbags=@deicingandantiicing_calciumbags,	deicingandantiicing_calciumlbs=@deicingandantiicing_calciumlbs,	walksdeicing_deicesidewalksstatus=@walksdeicing_deicesidewalksstatus,	walksdeicing_entrancedoors=@walksdeicing_entrancedoors,	walksdeicing_servicedoors=@walksdeicing_servicedoors,	walksdeicing_ramps=@walksdeicing_ramps,	walksdeicing_steps=@walksdeicing_steps,	walksdeicing_privatewalks=@walksdeicing_privatewalks,	walksdeicing_citywalks=@walksdeicing_citywalks,	walksdeicing_comments=@walksdeicing_comments,	walksdeicing_materialsusedblend=@walksdeicing_materialsusedblend,	walksdeicing_blendbags=@walksdeicing_blendbags,	walksdeicing_blendlbs=@walksdeicing_blendlbs,	walksdeicing_materialsusedcalcium=@walksdeicing_materialsusedcalcium,	walksdeicing_calciumbags=@walksdeicing_calciumbags,	walksdeicing_calciumlbs=@walksdeicing_calciumlbs,	walksdeicing_noserviceperformedsitecheckonly=@walksdeicing_noserviceperformedsitecheckonly,	liquidantiicinglog_applicator=@liquidantiicinglog_applicator,	liquidantiicinglog_trucknumber=@liquidantiicinglog_trucknumber,	liquidantiicinglog_timein=@liquidantiicinglog_timein,	liquidantiicinglog_timeout=@liquidantiicinglog_timeout,	liquidantiicinglog_goundtemperaturein=@liquidantiicinglog_goundtemperaturein,	liquidantiicinglog_goundtemperatureout=@liquidantiicinglog_goundtemperatureout,	liquidantiicinglog_airtemperaturein=@liquidantiicinglog_airtemperaturein,	liquidantiicinglog_airtemperatureinout=@liquidantiicinglog_airtemperatureinout,	liquidantiicinglog_siteconditions=@liquidantiicinglog_siteconditions,	liquidantiicinglog_surfaceswet=@liquidantiicinglog_surfaceswet,	liquidantiicinglog_surfacesdry=@liquidantiicinglog_surfacesdry,	liquidantiicinglog_fallingsnowice=@liquidantiicinglog_fallingsnowice,	liquidantiicinglog_fallingsnowrain=@liquidantiicinglog_fallingsnowrain,	liquidantiicinglog_materialtypeapplied=@liquidantiicinglog_materialtypeapplied,	liquidantiicinglog_amountintankgallonsstart=@liquidantiicinglog_amountintankgallonsstart,	liquidantiicinglog_amountintankgallonsstop=@liquidantiicinglog_amountintankgallonsstop,	liquidantiicinglog_totalgallonsused=@liquidantiicinglog_totalgallonsused,	liquidantiicinglog_areastreated=@liquidantiicinglog_areastreated,	liquidantiicinglog_tipsnozzlesused=@liquidantiicinglog_tipsnozzlesused,	liquidantiicinglog_groundspeed=@liquidantiicinglog_groundspeed,	liquidantiicinglog_trafficconditions=@liquidantiicinglog_trafficconditions,	liquidantiicinglog_notes=@liquidantiicinglog_notes,	vendorname=@vendorname,	timearrival=@timearrival,	timedeparture=@timedeparture
		Where batchnumber=@batchnumber AND propertyid=@propertyid
	END
END


GO

ALTER Procedure prGetSnowRemovalInfo
@propertyid nvarchar(100),
@batchnumber nvarchar(100),
@UserID nvarchar(100)
AS
BEGIN
	--Select reports02.*,users.fullname as fullname from reports02,users where batchnumber=@batchnumber AND propertyid=@propertyid AND reports02.username=users.username
	Select reports02.*,users.fullname as fullname,properties.displayname as propertyName,properties.address1 as Address from reports02,users,properties where batchnumber=@batchnumber AND reports02.propertyid=@propertyid AND reports02.propertyid=properties.propertyid AND reports02.username=users.username
END

GO
Alter Procedure prGetRecordID
@CategoryName nvarchar(200),
@StartChar nvarchar(20)
AS
BEGIN
	declare @CountValue as nvarchar(100);
	declare @yearVal as nvarchar(10);
	set @yearVal=(select Right(Year(getDate()),2))
	select dbo.GetRecordID(@CategoryName,@StartChar);
END
GO
ALTER function [dbo].[GetRecordID](
@CategoryName nvarchar(200),
@StartChar nvarchar(20))
RETURNS  nvarchar(100)
AS
BEGIN
	declare @CountValue as nvarchar(100);
	declare @yearVal as nvarchar(10);
	set @yearVal=(select Right(Year(getDate()),2))
	IF @CategoryName='Work Order'
		BEGIN
			set @CountValue=(SELECT RIGHT('0000' + CONVERT(VARCHAR,(SELECT (MAX(cast(RIGHT(wonumber, LEN(wonumber) - 3) as INT))+1) FROM workorders)),4))
			Set @StartChar='U'
		END
	IF @CategoryName='Work Request'
		BEGIN
			set @CountValue=(SELECT RIGHT('0000' + CONVERT(VARCHAR,(SELECT (MAX(cast(RIGHT(WPID, LEN(WPID) - 4) as INT))+1) FROM dailyreports)),4))
			Set @StartChar='WP'
		END
	IF @CategoryName='Property Inspection'
		BEGIN
			set @CountValue=(SELECT RIGHT('0000' + CONVERT(VARCHAR,(SELECT (MAX(cast(RIGHT(PIID, LEN(PIID) - 4) as INT))+1) FROM reports01)),4))
			Set @StartChar='PI'
		END
	IF @CategoryName='Snow Removal'
		BEGIN
			set @CountValue=(SELECT RIGHT('0000' + CONVERT(VARCHAR,(SELECT (MAX(cast(RIGHT(SNID, LEN(SNID) - 4) as INT))+1) FROM reports02)),4))
			Set @StartChar='SR'
		END
	return @StartChar+@yearVal+@CountValue
END
GO


Alter procedure [dbo].[prCategoryWiseMasterInfoForUnisource]
	@PropertyCategory nvarchar(200),
	@PropertyID nvarchar(100),
	@FromDate nvarchar(100),
	@ToDate nvarchar(100),
	@ApplicationStatus nvarchar(100),
  @UserName nvarchar(200) as
Begin
if @PropertyCategory='Total Work Order'
		Begin
			Select wonumber as ID,
				   workorders.propertyid as PropertyID,
				   wonumber as WorkOrderNumber, 
				   CASE
						WHEN dateentered is null THEN ' '
						ELSE dateentered
					END as SubmittedDate,
				   dateperformed as PerformedDate, 
				   properties.displayname as PropertyName,
				   CAST(CASE approvalstatus
						WHEN 8 THEN 'Open'
						WHEN 9 THEN 'Closed'
						WHEN 5 THEN 'Deleted'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'ApprovalStatus',
					CASE
						WHEN worktobedone is null THEN ' '
						ELSE worktobedone
					END as 'Comments',
					CASE
						WHEN wonumber is null THEN '<a href="/DataEntry/WorkOrder?category=edit&propertyID='+workorders.propertyid+'&specificID='+wonumber+'">RefID<a>'
						ELSE '<a href="/DataEntry/WorkOrder?category=edit&propertyID='+workorders.propertyid+'&specificID='+wonumber+'">'+wonumber+'<a>'
					END as 'RefLink',
					'' as 'HazardMaintenance'
					FROM workorders, properties 
					WHERE workorders.propertyid=properties.propertyid AND workorders.propertyid in (SELECT propertyid FROM usersaccess WHERE username =@UserName) AND workorders.approvalstatus <>5 AND dateentered>=@FromDate AND dateentered<=@ToDate AND approvalstatus like @ApplicationStatus Order by dateentered desc, wonumber desc
	End	
	if @PropertyCategory='Work Order'
		Begin
			Select wonumber as ID,
				   workorders.propertyid as PropertyID,
				   wonumber as WorkOrderNumber, 
				   CASE
						WHEN dateentered is null THEN ' '
						ELSE dateentered
					END as SubmittedDate,
				   dateperformed as PerformedDate, 
				   properties.displayname as PropertyName,
				   CAST(CASE approvalstatus
						WHEN 8 THEN 'Open'
						WHEN 9 THEN 'Closed'
						WHEN 5 THEN 'Deleted'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'ApprovalStatus',
					CASE
						WHEN worktobedone is null THEN ' '
						ELSE worktobedone
					END as 'Comments',
					CASE
						WHEN wonumber is null THEN '<a href="/DataEntry/WorkOrder?category=edit&propertyID='+workorders.propertyid+'&specificID='+wonumber+'">RefID<a>'
						ELSE '<a href="/DataEntry/WorkOrder?category=edit&propertyID='+workorders.propertyid+'&specificID='+wonumber+'">'+wonumber+'<a>'
					END as 'RefLink',
					'' as 'HazardMaintenance'
					FROM workorders, properties 
					WHERE workorders.propertyid=properties.propertyid AND workorders.propertyid=@PropertyID AND workorders.approvalstatus <>5 AND dateentered>=@FromDate AND dateentered<=@ToDate AND approvalstatus like @ApplicationStatus Order by dateentered desc, wonumber desc
	End	
	
	if @PropertyCategory='Total Work Request'
		Begin
			Select 
			CASE  
				WHEN WPID IS NULL THEN 'RefID'
				ELSE WPID
			END  as 'ID',
			dailyreports.propertyid as PropertyID,
			batchnumber as 'WorkOrderNumber',
			CASE
				WHEN dateentered is null THEN ' '
				ELSE dateentered
			END as SubmittedDate,
			dateperformed as PerformedDate,
		    properties.displayname as PropertyName,
			CAST(CASE approvalstatus
						WHEN 0 THEN 'Pending'
						WHEN 1 THEN 'Posted to PM'						
						WHEN 2 THEN 'Rejected'
						WHEN 3 THEN 'Work Order Created'
						WHEN 4 THEN 'Defer to Later Date'
						WHEN 5 THEN 'Assign to Vendor'
						ELSE 'Undefined'
				END
			as nvarchar(200)) as 'ApprovalStatus',
			CASE
				WHEN reporttext is null THEN ' '
				ELSE reporttext
			END as 'Comments',			
			CASE
					WHEN WPID is null THEN '<a href="/DataEntry/WorkRequest?category=edit&propertyID='+dailyreports.propertyid+'&specificID='+batchnumber+'">RefID<a>'
					ELSE '<a href="/DataEntry/WorkRequest?category=edit&propertyID='+dailyreports.propertyid+'&specificID='+batchnumber+'">'+WPID+'<a>'
			END as 'RefLink',
			CASE
						WHEN hazard=1 AND maintenance=0 THEN '<div class="hazard-div"><img class="unisourceWP" src="../Content/imgs/haz.png" /><br />Haz. Exist</div>'
						WHEN hazard=1 AND maintenance=1 THEN '<div class="hazard-div"><img class="unisourceWP" src="../Content/imgs/haz.png" /><br />Haz. Exist</div><div class="maintenance-div"><img class="unisourceWP" src="../Content/imgs/maint.png" /><br />Maint Req.</div>'
						WHEN hazard=0 AND maintenance=1 THEN '<div class="maintenance-div"><img class="unisourceWP" src="../Content/imgs/maint.png" /><br />Maint Req.</div>'
						WHEN hazard=0 AND maintenance=0 THEN ''
						ELSE ''
			END AS 'HazardMaintenance' 
		   from dailyreports, properties where dailyreports.propertyid=properties.propertyid AND dailyreports.propertyid in (select propertyid from usersaccess where username =@UserName) AND
		   dailyreports.approvalstatus NOT IN(
		   CASE 
			WHEN 1<>(Select uniadmin from users where username=@UserName) then '0'
			ELSE '100'
		   END
		  ) AND dailyreports.approvalstatus NOT IN(
		   CASE 
			WHEN 1<>(Select uniadmin from users where username=@UserName) then '2'
			ELSE '100'
		   END
		  ) AND dateentered>=@FromDate AND dateentered<=@ToDate AND approvalstatus like @ApplicationStatus Order by dateentered desc, WPID desc
		End
		

	if @PropertyCategory='Work Request'
		Begin
			Select 
			CASE  
				WHEN WPID IS NULL THEN 'RefID'
				ELSE WPID
			END  as 'ID',
			dailyreports.propertyid as PropertyID,
			batchnumber as 'WorkOrderNumber',
			CASE
				WHEN dateentered is null THEN ' '
				ELSE dateentered
			END as SubmittedDate,
			dateperformed as PerformedDate,
		    properties.displayname as PropertyName,
			CAST(CASE approvalstatus
						WHEN 0 THEN 'Pending'
						WHEN 1 THEN 'Posted to PM'						
						WHEN 2 THEN 'Rejected'
						WHEN 3 THEN 'Work Order Created'
						WHEN 4 THEN 'Defer to Later Date'
						WHEN 5 THEN 'Assign to Vendor'
						ELSE 'Undefined'
				END
			as nvarchar(200)) as 'ApprovalStatus',
			CASE
				WHEN reporttext is null THEN ' '
				ELSE reporttext
			END as 'Comments',
			CASE
					WHEN WPID is null THEN '<a href="/DataEntry/WorkRequest?category=edit&propertyID='+dailyreports.propertyid+'&specificID='+batchnumber+'">RefID<a>'
					ELSE '<a href="/DataEntry/WorkRequest?category=edit&propertyID='+dailyreports.propertyid+'&specificID='+batchnumber+'">'+WPID+'<a>'
			END as 'RefLink',
			CASE
						WHEN hazard=1 AND maintenance=0 THEN '<div class="hazard-div"><img class="unisourceWP" src="../Content/imgs/haz.png" /><br />Haz. Exist</div>'
						WHEN hazard=1 AND maintenance=1 THEN '<div class="hazard-div"><img class="unisourceWP" src="../Content/imgs/haz.png" /><br />Haz. Exist</div><div class="maintenance-div"><img class="unisourceWP" src="../Content/imgs/maint.png" /><br />Maint Req.</div>'
						WHEN hazard=0 AND maintenance=1 THEN '<div class="maintenance-div"><img class="unisourceWP" src="../Content/imgs/maint.png" /><br />Maint Req.</div>'
						WHEN hazard=0 AND maintenance=0 THEN ''
						ELSE ''
			END AS 'HazardMaintenance' 
		   from dailyreports, properties where dailyreports.propertyid=properties.propertyid AND dailyreports.propertyid=@PropertyID AND 
		   dailyreports.approvalstatus NOT IN(
		   CASE 
			WHEN 1<>(Select uniadmin from users where username=@UserName) then '0'
			ELSE '100'
		   END
		  ) AND dailyreports.approvalstatus NOT IN(
		   CASE 
			WHEN 1<>(Select uniadmin from users where username=@UserName) then '2'
			ELSE '100'
		   END
		  ) AND dateentered>=@FromDate AND dateentered<=@ToDate AND approvalstatus like @ApplicationStatus Order by dateentered desc,WPID desc
		End

		if @PropertyCategory='Total Snow Removal'
		Begin
			Select  
				reports02.propertyid as ID,
				reports02.propertyid as PropertyID,
				batchnumber as WorkOrderNumber,
				CASE
					WHEN dateentered is null THEN ' '
					ELSE dateentered
				END as SubmittedDate,
				dateperformed as PerformedDate,
				properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 2 THEN 'Rejected'
						WHEN 1 THEN 'Approved'
						WHEN 0 THEN 'Pending'
						ELSE 'Undefined'
				END	as nvarchar(200)) as 'ApprovalStatus',
				'' as 'Comments',
				CASE
					WHEN SNID is null THEN '<a href="/DataEntry/SnowReport?category=edit&propertyID='+reports02.propertyid+'&specificID='+batchnumber+'">RefID<a>'
					ELSE '<a href="/DataEntry/SnowReport?category=edit&propertyID='+reports02.propertyid+'&specificID='+batchnumber+'">'+SNID+'<a>'
				END as 'RefLink',
			'' as 'HazardMaintenance'
			FROM reports02, properties WHERE reports02.propertyid=properties.propertyid AND reports02.propertyid in (select propertyid from usersaccess where username =@UserName) AND
			reports02.approvalstatus NOT IN('5',
			   CASE 
				WHEN 1<>(Select uniadmin from users where username=@UserName) then '0'
				ELSE '100'
			   END
			  )AND reports02.approvalstatus NOT IN(
			   CASE 
				WHEN 1<>(Select uniadmin from users where username=@UserName) then '2'
				ELSE '100'
			   END
			  )  AND dateentered>=@FromDate AND dateentered<=@ToDate AND approvalstatus like @ApplicationStatus Order by dateentered desc, SNID desc
		End

		if @PropertyCategory='Snow Removal'
		Begin
			Select  
				reports02.propertyid as ID,
				reports02.propertyid as PropertyID,
				batchnumber as WorkOrderNumber,
				CASE
					WHEN dateentered is null THEN ' '
					ELSE dateentered
				END as SubmittedDate,
				dateperformed as PerformedDate,
				properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 2 THEN 'Rejected'
						WHEN 1 THEN 'Approved'
						WHEN 0 THEN 'Pending'
						ELSE 'Undefined'
				END	as nvarchar(200)) as 'ApprovalStatus',
				'' as 'Comments',
				CASE
					WHEN SNID is null THEN '<a href="/DataEntry/SnowReport?category=edit&propertyID='+reports02.propertyid+'&specificID='+batchnumber+'">RefID<a>'
					ELSE '<a href="/DataEntry/SnowReport?category=edit&propertyID='+reports02.propertyid+'&specificID='+batchnumber+'">'+SNID+'<a>'
				END as 'RefLink',
			'' as 'HazardMaintenance'
			from reports02, properties where reports02.propertyid=properties.propertyid AND reports02.propertyid =@PropertyID AND
			reports02.approvalstatus NOT IN('5',
			   CASE 
				WHEN 1<>(Select uniadmin from users where username=@UserName) then '0'
				ELSE '100'
			   END
			  )AND reports02.approvalstatus NOT IN(
			   CASE 
				WHEN 1<>(Select uniadmin from users where username=@UserName) then '2'
				ELSE '100'
			   END
			  )   AND dateentered>=@FromDate AND dateentered<=@ToDate AND approvalstatus like @ApplicationStatus Order by dateentered desc, SNID desc
		End

	if @PropertyCategory='Total Property Inspections'
		Begin
			Select  
				reports01.propertyid as ID,
				reports01.propertyid as PropertyID,
				batchnumber as WorkOrderNumber,
				CASE
					WHEN dateentered is null THEN ' '
					ELSE dateentered
				END as SubmittedDate,
				dateperformed as PerformedDate, 
				properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 1 THEN 'Approved'
						WHEN 0 THEN 'Pending'
						WHEN 2 THEN 'Rejected'
						ELSE 'Undefined'
				END	as nvarchar(200)) as 'ApprovalStatus',
				'' as 'Comments',
				CASE
					WHEN PIID is null THEN '<a href="/DataEntry/InspectionReport?category=edit&propertyID='+reports01.propertyid+'&specificID='+batchnumber+'">RefID<a>'
					ELSE '<a href="/DataEntry/InspectionReport?category=edit&propertyID='+reports01.propertyid+'&specificID='+batchnumber+'">'+PIID+'<a>'
				END as 'RefLink',
			'' as 'HazardMaintenance'
		  from reports01, properties where reports01.propertyid=properties.propertyid AND reports01.propertyid in (select propertyid from usersaccess where username =@UserName) AND 
		  reports01.approvalstatus NOT IN('5',
			   CASE 
				WHEN 1<>(Select uniadmin from users where username=@UserName) then '0'
				ELSE '100'
			   END
			  )AND reports01.approvalstatus NOT IN(
			   CASE 
				WHEN 1<>(Select uniadmin from users where username=@UserName) then '2'
				ELSE '100'
			   END
			  )  AND dateentered>=@FromDate AND dateentered<=@ToDate AND approvalstatus like @ApplicationStatus Order by dateentered desc, PIID desc
		End

		if @PropertyCategory='Property Inspections'
		Begin
			Select  
				reports01.propertyid as ID,
				reports01.propertyid as PropertyID,
				batchnumber as WorkOrderNumber,
				CASE
					WHEN dateentered is null THEN ' '
					ELSE dateentered
				END as SubmittedDate,
				dateperformed as PerformedDate, 
				properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 1 THEN 'Approved'
						WHEN 0 THEN 'Pending'
						WHEN 2 THEN 'Rejected'
						ELSE 'Undefined'
				END	as nvarchar(200)) as 'ApprovalStatus',
				'' as 'Comments',
				CASE
					WHEN PIID is null THEN '<a href="/DataEntry/InspectionReport?category=edit&propertyID='+reports01.propertyid+'&specificID='+batchnumber+'">RefID<a>'
					ELSE '<a href="/DataEntry/InspectionReport?category=edit&propertyID='+reports01.propertyid+'&specificID='+batchnumber+'">'+PIID+'<a>'
				END as 'RefLink',
			'' as 'HazardMaintenance'
		  from reports01, properties where reports01.propertyid=properties.propertyid AND reports01.propertyid =@PropertyID AND
		   reports01.approvalstatus NOT IN('5',
			   CASE 
				WHEN 1<>(Select uniadmin from users where username=@UserName) then '0'
				ELSE '100'
			   END
			  )AND reports01.approvalstatus NOT IN(
			   CASE 
				WHEN 1<>(Select uniadmin from users where username=@UserName) then '2'
				ELSE '100'
			   END
			  ) AND dateentered>=@FromDate AND dateentered<=@ToDate AND approvalstatus like @ApplicationStatus Order by dateentered desc, PIID desc
		End
	End


GO



GO





Alter Procedure [dbo].[PIPropertyInspection]
@action as nvarchar(100), @propertyid as nvarchar(200) ,	@dateentered as nvarchar(200) ,	@dateperformed as nvarchar(200) ,	@timeentered as nvarchar(200) ,	@username as nvarchar(200) ,	@approvalstatus as nvarchar(200) ,	@batchnumber as nvarchar(200) ,	@exteriorlandscaping_mowingofgrass as nvarchar(200) ,	@exteriorlandscaping_edgingaroundcurbs as nvarchar(200) ,	@exteriorlandscaping_removalofweeds as nvarchar(200) ,	@exteriorlandscaping_trimmingofshrubs as nvarchar(200) ,	@exteriorlandscaping_wateringifnecessary as nvarchar(200) ,	@exteriorlandscaping_conditionofirrigationsystem as nvarchar(200) ,	@exteriorlandscaping_conditionofplants as nvarchar(200) ,	@exteriorlandscaping_islandtrashremoval as nvarchar(200) ,	@exteriorlandscaping_cleanlinessoffencelines as nvarchar(200) ,	@exteriorlandscaping_conditionofretentionpond as nvarchar(200) ,	@exteriorlandscaping_conditionofvacantoutlots as nvarchar(200) ,	@exteriorlandscaping_conditionofislandcurbing as nvarchar(200) ,	@exteriorlandscaping_sightlinevisibility as nvarchar(200) ,	@exteriorlighting_parkinglotlights as nvarchar(200) ,	@exteriorlighting_wallpacks as nvarchar(200) ,	@exteriorlighting_canopylights as nvarchar(200) ,	@exteriorlighting_sidewalklights as nvarchar(200) ,	@exteriorlighting_pylonsigns as nvarchar(200) ,	@exteriorlighting_timeclocksettings as nvarchar(200) ,	@exteriorlighting_stockofbulbs as nvarchar(200) ,	@exteriorlighting_conditionoflightpoles as nvarchar(200) ,	@buildingexterior_exteriormasonry as nvarchar(200) ,	@buildingexterior_tuckpointing as nvarchar(200) ,	@buildingexterior_guttersanddownspouts as nvarchar(200) ,	@buildingexterior_conditionofbollards as nvarchar(200) ,	@buildingexterior_sidewalks as nvarchar(200) ,	@buildingexterior_graffiti as nvarchar(200) ,	@buildingexterior_conditionofpayphones as nvarchar(200) ,	@buildingexterior_conditionofbikeracks as nvarchar(200) ,	@buildingexterior_conditionofcanopies as nvarchar(200) ,	@buildingexterior_cleanlinessoffascia as nvarchar(200) ,	@buildingexterior_cleanlinessofskylights as nvarchar(200) ,	@buildingexterior_conditionofsupportcolumns as nvarchar(200) ,	@buildingexterior_conditionofsidewalkbenches as nvarchar(200) ,	@buildingexterior_conditionofreardoorslabeled as nvarchar(200) ,	@buildingexterior_conditionoftrashcans as nvarchar(200) ,	@nonpublicareas_servicecorridorlighting as nvarchar(200) ,	@nonpublicareas_servicecorridorfloorswalls as nvarchar(200) ,	@nonpublicareas_conditionoffireextinguishers as nvarchar(200) ,	@nonpublicareas_trashroomsdumpsterareas as nvarchar(200) ,	@nonpublicareas_conditionofdockareas as nvarchar(200) ,	@nonpublicareas_conditionofmanagementoffice as nvarchar(200) ,	@nonpublicareas_cleanlinessofoffices as nvarchar(200) ,	@parkinglots_cleanliness as nvarchar(200) ,	@parkinglots_asphaltrepairs as nvarchar(200) ,	@parkinglots_illegaldumping as nvarchar(200) ,	@parkinglots_parkingbumpercondition as nvarchar(200) ,	@parkinglots_shoppingcartscollected as nvarchar(200) ,	@parkinglots_cartcorralcondition as nvarchar(200) ,	@parkinglots_striping as nvarchar(200) ,	@parkinglots_crackfilling as nvarchar(200) ,	@parkinglots_handicappedareas as nvarchar(200) ,	@parkinglots_curbs as nvarchar(200) ,	@parkinglots_sewercaps as nvarchar(200) ,	@parkinglots_conditionoftrafficsigns as nvarchar(200) ,	@parkinglots_cleanlinessofdumpsterareas as nvarchar(200) ,	@parkinglots_removalofabandonedcars as nvarchar(200) ,	@parkinglots_vegitationgrowthincracks as nvarchar(200) ,	@vacantstores_presentationofspaceforreleasingactivity as nvarchar(200) ,	@vacantstores_makesurelockswork as nvarchar(200) ,	@vacantstores_checkforroofleaks as nvarchar(200) ,	@vacantstores_installationofleasingsigns as nvarchar(200) ,	@vacantstores_cleanlinessofstorefront as nvarchar(200) ,	@vacantstores_cleanlinessofinterior as nvarchar(200) ,	@vacantstores_cleaningofwindows as nvarchar(200) ,	@vacantstores_otherdamagesobserved as nvarchar(200) ,	@maintenanceshop_conditionoffloor as nvarchar(200) ,	@maintenanceshop_cleanlinessappearanceofshop as nvarchar(200) ,	@maintenanceshop_storageofflammables as nvarchar(200) ,	@maintenanceshop_organizationoftoolssupplies as nvarchar(200) ,	@maintenanceshop_cleanlinessoftruckandequipment as nvarchar(200) ,	@maintenanceshop_labelingofkeysinkeybox as nvarchar(200) ,	@maintenanceshop_conditionofhvacequipment as nvarchar(200) ,	@maintenanceshop_allvacantandllkeysinlockbox as nvarchar(200) ,	@mechanicelectricalrooms_riserroomcleanliness as nvarchar(200) ,	@mechanicelectricalrooms_riserroompressureschecked as nvarchar(200) ,	@mechanicelectricalrooms_valveschainedinopenposition as nvarchar(200) ,	@mechanicelectricalrooms_mapscurrent as nvarchar(200) ,	@mechanicelectricalrooms_doorslabeled as nvarchar(200) ,	@mechanicelectricalrooms_hotworkpermitsign as nvarchar(200) ,	@mechanicelectricalrooms_shutdownproceduresign as nvarchar(200) ,	@mechanicelectricalrooms_checkforcurrentinspectiontags as nvarchar(200) ,	@mechanicelectricalrooms_signinspectionlog as nvarchar(200) ,	@tenantdetails_storefrontclean as nvarchar(200) ,	@tenantdetails_storefrontsignscleanandlit as nvarchar(200) ,	@tenantdetails_windowscleanedanddisplayed as nvarchar(200) ,	@tenantdetails_windowcracksfailures as nvarchar(200) ,	@interiorlandscaping_conditionofplantmaterial as nvarchar(200) ,	@interiorlandscaping_conditionofplanterboxes as nvarchar(200) ,	@interiorlandscaping_conditionoffloorgrates as nvarchar(200) ,	@interiorlighting_skylights as nvarchar(200) ,	@interiorlighting_diffusers as nvarchar(200) ,	@interiorlighting_fluorescents as nvarchar(200) ,	@interiorlighting_incandescent as nvarchar(200) ,	@interiorlighting_spotlights as nvarchar(200) ,	@interiorlighting_exitemergencylights as nvarchar(200) ,	@buildinginterior_mallentrances as nvarchar(200) ,	@buildinginterior_storefronts as nvarchar(200) ,	@buildinginterior_flooring as nvarchar(200) ,	@buildinginterior_generalcleanliness as nvarchar(200) ,	@buildinginterior_drinkingfountains as nvarchar(200) ,	@buildinginterior_trashreceptacles as nvarchar(200) ,	@buildinginterior_railings as nvarchar(200) ,	@buildinginterior_cleanlinessofrestrooms as nvarchar(200) ,	@buildinginterior_directoriescleanandup as nvarchar(200) ,	@buildinginterior_basementswatertrashunauthentry as nvarchar(200)
AS
BEGIN
	IF @action='New'
	BEGIN
		declare @PIID as nvarchar(100)
		Set @PIID=(Select dbo.GetRecordID('Property Inspection','PI'))
		Insert into reports01(PIID,propertyid,	dateentered,	dateperformed,	timeentered,	username,	approvalstatus,	batchnumber,	exteriorlandscaping_mowingofgrass,	exteriorlandscaping_edgingaroundcurbs,	exteriorlandscaping_removalofweeds,	exteriorlandscaping_trimmingofshrubs,	exteriorlandscaping_wateringifnecessary,	exteriorlandscaping_conditionofirrigationsystem,	exteriorlandscaping_conditionofplants,	exteriorlandscaping_islandtrashremoval,	exteriorlandscaping_cleanlinessoffencelines,	exteriorlandscaping_conditionofretentionpond,	exteriorlandscaping_conditionofvacantoutlots,	exteriorlandscaping_conditionofislandcurbing,	exteriorlandscaping_sightlinevisibility,	exteriorlighting_parkinglotlights,	exteriorlighting_wallpacks,	exteriorlighting_canopylights,	exteriorlighting_sidewalklights,	exteriorlighting_pylonsigns,	exteriorlighting_timeclocksettings,	exteriorlighting_stockofbulbs,	exteriorlighting_conditionoflightpoles,	buildingexterior_exteriormasonry,	buildingexterior_tuckpointing,	buildingexterior_guttersanddownspouts,	buildingexterior_conditionofbollards,	buildingexterior_sidewalks,	buildingexterior_graffiti,	buildingexterior_conditionofpayphones,	buildingexterior_conditionofbikeracks,	buildingexterior_conditionofcanopies,	buildingexterior_cleanlinessoffascia,	buildingexterior_cleanlinessofskylights,	buildingexterior_conditionofsupportcolumns,	buildingexterior_conditionofsidewalkbenches,	buildingexterior_conditionofreardoorslabeled,	buildingexterior_conditionoftrashcans,	nonpublicareas_servicecorridorlighting,	nonpublicareas_servicecorridorfloorswalls,	nonpublicareas_conditionoffireextinguishers,	nonpublicareas_trashroomsdumpsterareas,	nonpublicareas_conditionofdockareas,	nonpublicareas_conditionofmanagementoffice,	nonpublicareas_cleanlinessofoffices,	parkinglots_cleanliness,	parkinglots_asphaltrepairs,	parkinglots_illegaldumping,	parkinglots_parkingbumpercondition,	parkinglots_shoppingcartscollected,	parkinglots_cartcorralcondition,	parkinglots_striping,	parkinglots_crackfilling,	parkinglots_handicappedareas,	parkinglots_curbs,	parkinglots_sewercaps,	parkinglots_conditionoftrafficsigns,	parkinglots_cleanlinessofdumpsterareas,	parkinglots_removalofabandonedcars,	parkinglots_vegitationgrowthincracks,	vacantstores_presentationofspaceforreleasingactivity,	vacantstores_makesurelockswork,	vacantstores_checkforroofleaks,	vacantstores_installationofleasingsigns,	vacantstores_cleanlinessofstorefront,	vacantstores_cleanlinessofinterior,	vacantstores_cleaningofwindows,	vacantstores_otherdamagesobserved,	maintenanceshop_conditionoffloor,	maintenanceshop_cleanlinessappearanceofshop,	maintenanceshop_storageofflammables,	maintenanceshop_organizationoftoolssupplies,	maintenanceshop_cleanlinessoftruckandequipment,	maintenanceshop_labelingofkeysinkeybox,	maintenanceshop_conditionofhvacequipment,	maintenanceshop_allvacantandllkeysinlockbox,	mechanicelectricalrooms_riserroomcleanliness,	mechanicelectricalrooms_riserroompressureschecked,	mechanicelectricalrooms_valveschainedinopenposition,	mechanicelectricalrooms_mapscurrent,	mechanicelectricalrooms_doorslabeled,	mechanicelectricalrooms_hotworkpermitsign,	mechanicelectricalrooms_shutdownproceduresign,	mechanicelectricalrooms_checkforcurrentinspectiontags,	mechanicelectricalrooms_signinspectionlog,	tenantdetails_storefrontclean,	tenantdetails_storefrontsignscleanandlit,	tenantdetails_windowscleanedanddisplayed,	tenantdetails_windowcracksfailures,	interiorlandscaping_conditionofplantmaterial,	interiorlandscaping_conditionofplanterboxes,	interiorlandscaping_conditionoffloorgrates,	interiorlighting_skylights,	interiorlighting_diffusers,	interiorlighting_fluorescents,	interiorlighting_incandescent,	interiorlighting_spotlights,	interiorlighting_exitemergencylights,	buildinginterior_mallentrances,	buildinginterior_storefronts,	buildinginterior_flooring,	buildinginterior_generalcleanliness,	buildinginterior_drinkingfountains,	buildinginterior_trashreceptacles,	buildinginterior_railings,	buildinginterior_cleanlinessofrestrooms,	buildinginterior_directoriescleanandup,	buildinginterior_basementswatertrashunauthentry) 
		values(@PIID,@propertyid,	@dateentered,	@dateperformed,	@timeentered,	@username,	@approvalstatus,	@batchnumber,	@exteriorlandscaping_mowingofgrass,	@exteriorlandscaping_edgingaroundcurbs,	@exteriorlandscaping_removalofweeds,	@exteriorlandscaping_trimmingofshrubs,	@exteriorlandscaping_wateringifnecessary,	@exteriorlandscaping_conditionofirrigationsystem,	@exteriorlandscaping_conditionofplants,	@exteriorlandscaping_islandtrashremoval,	@exteriorlandscaping_cleanlinessoffencelines,	@exteriorlandscaping_conditionofretentionpond,	@exteriorlandscaping_conditionofvacantoutlots,	@exteriorlandscaping_conditionofislandcurbing,	@exteriorlandscaping_sightlinevisibility,	@exteriorlighting_parkinglotlights,	@exteriorlighting_wallpacks,	@exteriorlighting_canopylights,	@exteriorlighting_sidewalklights,	@exteriorlighting_pylonsigns,	@exteriorlighting_timeclocksettings,	@exteriorlighting_stockofbulbs,	@exteriorlighting_conditionoflightpoles,	@buildingexterior_exteriormasonry,	@buildingexterior_tuckpointing,	@buildingexterior_guttersanddownspouts,	@buildingexterior_conditionofbollards,	@buildingexterior_sidewalks,	@buildingexterior_graffiti,	@buildingexterior_conditionofpayphones,	@buildingexterior_conditionofbikeracks,	@buildingexterior_conditionofcanopies,	@buildingexterior_cleanlinessoffascia,	@buildingexterior_cleanlinessofskylights,	@buildingexterior_conditionofsupportcolumns,	@buildingexterior_conditionofsidewalkbenches,	@buildingexterior_conditionofreardoorslabeled,	@buildingexterior_conditionoftrashcans,	@nonpublicareas_servicecorridorlighting,	@nonpublicareas_servicecorridorfloorswalls,	@nonpublicareas_conditionoffireextinguishers,	@nonpublicareas_trashroomsdumpsterareas,	@nonpublicareas_conditionofdockareas,	@nonpublicareas_conditionofmanagementoffice,	@nonpublicareas_cleanlinessofoffices,	@parkinglots_cleanliness,	@parkinglots_asphaltrepairs,	@parkinglots_illegaldumping,	@parkinglots_parkingbumpercondition,	@parkinglots_shoppingcartscollected,	@parkinglots_cartcorralcondition,	@parkinglots_striping,	@parkinglots_crackfilling,	@parkinglots_handicappedareas,	@parkinglots_curbs,	@parkinglots_sewercaps,	@parkinglots_conditionoftrafficsigns,	@parkinglots_cleanlinessofdumpsterareas,	@parkinglots_removalofabandonedcars,	@parkinglots_vegitationgrowthincracks,	@vacantstores_presentationofspaceforreleasingactivity,	@vacantstores_makesurelockswork,	@vacantstores_checkforroofleaks,	@vacantstores_installationofleasingsigns,	@vacantstores_cleanlinessofstorefront,	@vacantstores_cleanlinessofinterior,	@vacantstores_cleaningofwindows,	@vacantstores_otherdamagesobserved,	@maintenanceshop_conditionoffloor,	@maintenanceshop_cleanlinessappearanceofshop,	@maintenanceshop_storageofflammables,	@maintenanceshop_organizationoftoolssupplies,	@maintenanceshop_cleanlinessoftruckandequipment,	@maintenanceshop_labelingofkeysinkeybox,	@maintenanceshop_conditionofhvacequipment,	@maintenanceshop_allvacantandllkeysinlockbox,	@mechanicelectricalrooms_riserroomcleanliness,	@mechanicelectricalrooms_riserroompressureschecked,	@mechanicelectricalrooms_valveschainedinopenposition,	@mechanicelectricalrooms_mapscurrent,	@mechanicelectricalrooms_doorslabeled,	@mechanicelectricalrooms_hotworkpermitsign,	@mechanicelectricalrooms_shutdownproceduresign,	@mechanicelectricalrooms_checkforcurrentinspectiontags,	@mechanicelectricalrooms_signinspectionlog,	@tenantdetails_storefrontclean,	@tenantdetails_storefrontsignscleanandlit,	@tenantdetails_windowscleanedanddisplayed,	@tenantdetails_windowcracksfailures,	@interiorlandscaping_conditionofplantmaterial,	@interiorlandscaping_conditionofplanterboxes,	@interiorlandscaping_conditionoffloorgrates,	@interiorlighting_skylights,	@interiorlighting_diffusers,	@interiorlighting_fluorescents,	@interiorlighting_incandescent,	@interiorlighting_spotlights,	@interiorlighting_exitemergencylights,	@buildinginterior_mallentrances,	@buildinginterior_storefronts,	@buildinginterior_flooring,	@buildinginterior_generalcleanliness,	@buildinginterior_drinkingfountains,	@buildinginterior_trashreceptacles,	@buildinginterior_railings,	@buildinginterior_cleanlinessofrestrooms,	@buildinginterior_directoriescleanandup,@buildinginterior_basementswatertrashunauthentry)
	END
	IF @action='Update'
	BEGIN
		UPDATE reports01 SET
					approvalstatus=@approvalstatus,exteriorlandscaping_mowingofgrass = @exteriorlandscaping_mowingofgrass,	exteriorlandscaping_edgingaroundcurbs = @exteriorlandscaping_edgingaroundcurbs,	exteriorlandscaping_removalofweeds = @exteriorlandscaping_removalofweeds,	exteriorlandscaping_trimmingofshrubs = @exteriorlandscaping_trimmingofshrubs,	exteriorlandscaping_wateringifnecessary = @exteriorlandscaping_wateringifnecessary,	exteriorlandscaping_conditionofirrigationsystem = @exteriorlandscaping_conditionofirrigationsystem,	exteriorlandscaping_conditionofplants = @exteriorlandscaping_conditionofplants,	exteriorlandscaping_islandtrashremoval = @exteriorlandscaping_islandtrashremoval,	exteriorlandscaping_cleanlinessoffencelines = @exteriorlandscaping_cleanlinessoffencelines,	exteriorlandscaping_conditionofretentionpond = @exteriorlandscaping_conditionofretentionpond,	exteriorlandscaping_conditionofvacantoutlots = @exteriorlandscaping_conditionofvacantoutlots,	exteriorlandscaping_conditionofislandcurbing = @exteriorlandscaping_conditionofislandcurbing,	exteriorlandscaping_sightlinevisibility = @exteriorlandscaping_sightlinevisibility,	exteriorlighting_parkinglotlights = @exteriorlighting_parkinglotlights,	exteriorlighting_wallpacks = @exteriorlighting_wallpacks,	exteriorlighting_canopylights = @exteriorlighting_canopylights,	exteriorlighting_sidewalklights = @exteriorlighting_sidewalklights,	exteriorlighting_pylonsigns = @exteriorlighting_pylonsigns,	exteriorlighting_timeclocksettings = @exteriorlighting_timeclocksettings,	exteriorlighting_stockofbulbs = @exteriorlighting_stockofbulbs,	exteriorlighting_conditionoflightpoles = @exteriorlighting_conditionoflightpoles,	buildingexterior_exteriormasonry = @buildingexterior_exteriormasonry,	buildingexterior_tuckpointing = @buildingexterior_tuckpointing,	buildingexterior_guttersanddownspouts = @buildingexterior_guttersanddownspouts,	buildingexterior_conditionofbollards = @buildingexterior_conditionofbollards,	buildingexterior_sidewalks = @buildingexterior_sidewalks,	buildingexterior_graffiti = @buildingexterior_graffiti,	buildingexterior_conditionofpayphones = @buildingexterior_conditionofpayphones,	buildingexterior_conditionofbikeracks = @buildingexterior_conditionofbikeracks,	buildingexterior_conditionofcanopies = @buildingexterior_conditionofcanopies,	buildingexterior_cleanlinessoffascia = @buildingexterior_cleanlinessoffascia,	buildingexterior_cleanlinessofskylights = @buildingexterior_cleanlinessofskylights,	buildingexterior_conditionofsupportcolumns = @buildingexterior_conditionofsupportcolumns,	buildingexterior_conditionofsidewalkbenches = @buildingexterior_conditionofsidewalkbenches,	buildingexterior_conditionofreardoorslabeled = @buildingexterior_conditionofreardoorslabeled,	buildingexterior_conditionoftrashcans = @buildingexterior_conditionoftrashcans,	nonpublicareas_servicecorridorlighting = @nonpublicareas_servicecorridorlighting,	nonpublicareas_servicecorridorfloorswalls = @nonpublicareas_servicecorridorfloorswalls,	nonpublicareas_conditionoffireextinguishers = @nonpublicareas_conditionoffireextinguishers,	nonpublicareas_trashroomsdumpsterareas = @nonpublicareas_trashroomsdumpsterareas,	nonpublicareas_conditionofdockareas = @nonpublicareas_conditionofdockareas,	nonpublicareas_conditionofmanagementoffice = @nonpublicareas_conditionofmanagementoffice,	nonpublicareas_cleanlinessofoffices = @nonpublicareas_cleanlinessofoffices,	parkinglots_cleanliness = @parkinglots_cleanliness,	parkinglots_asphaltrepairs = @parkinglots_asphaltrepairs,	parkinglots_illegaldumping = @parkinglots_illegaldumping,	parkinglots_parkingbumpercondition = @parkinglots_parkingbumpercondition,	parkinglots_shoppingcartscollected = @parkinglots_shoppingcartscollected,	parkinglots_cartcorralcondition = @parkinglots_cartcorralcondition,	parkinglots_striping = @parkinglots_striping,	parkinglots_crackfilling = @parkinglots_crackfilling,	parkinglots_handicappedareas = @parkinglots_handicappedareas,	parkinglots_curbs = @parkinglots_curbs,	parkinglots_sewercaps = @parkinglots_sewercaps,	parkinglots_conditionoftrafficsigns = @parkinglots_conditionoftrafficsigns,	parkinglots_cleanlinessofdumpsterareas = @parkinglots_cleanlinessofdumpsterareas,	parkinglots_removalofabandonedcars = @parkinglots_removalofabandonedcars,	parkinglots_vegitationgrowthincracks = @parkinglots_vegitationgrowthincracks,	vacantstores_presentationofspaceforreleasingactivity = @vacantstores_presentationofspaceforreleasingactivity,	vacantstores_makesurelockswork = @vacantstores_makesurelockswork,	vacantstores_checkforroofleaks = @vacantstores_checkforroofleaks,	vacantstores_installationofleasingsigns = @vacantstores_installationofleasingsigns,	vacantstores_cleanlinessofstorefront = @vacantstores_cleanlinessofstorefront,	vacantstores_cleanlinessofinterior = @vacantstores_cleanlinessofinterior,	vacantstores_cleaningofwindows = @vacantstores_cleaningofwindows,	vacantstores_otherdamagesobserved = @vacantstores_otherdamagesobserved,	maintenanceshop_conditionoffloor = @maintenanceshop_conditionoffloor,	maintenanceshop_cleanlinessappearanceofshop = @maintenanceshop_cleanlinessappearanceofshop,	maintenanceshop_storageofflammables = @maintenanceshop_storageofflammables,	maintenanceshop_organizationoftoolssupplies = @maintenanceshop_organizationoftoolssupplies,	maintenanceshop_cleanlinessoftruckandequipment = @maintenanceshop_cleanlinessoftruckandequipment,	maintenanceshop_labelingofkeysinkeybox = @maintenanceshop_labelingofkeysinkeybox,	maintenanceshop_conditionofhvacequipment = @maintenanceshop_conditionofhvacequipment,	maintenanceshop_allvacantandllkeysinlockbox = @maintenanceshop_allvacantandllkeysinlockbox,	mechanicelectricalrooms_riserroomcleanliness = @mechanicelectricalrooms_riserroomcleanliness,	mechanicelectricalrooms_riserroompressureschecked = @mechanicelectricalrooms_riserroompressureschecked,	mechanicelectricalrooms_valveschainedinopenposition = @mechanicelectricalrooms_valveschainedinopenposition,	mechanicelectricalrooms_mapscurrent = @mechanicelectricalrooms_mapscurrent,	mechanicelectricalrooms_doorslabeled = @mechanicelectricalrooms_doorslabeled,	mechanicelectricalrooms_hotworkpermitsign = @mechanicelectricalrooms_hotworkpermitsign,	mechanicelectricalrooms_shutdownproceduresign = @mechanicelectricalrooms_shutdownproceduresign,	mechanicelectricalrooms_checkforcurrentinspectiontags = @mechanicelectricalrooms_checkforcurrentinspectiontags,	mechanicelectricalrooms_signinspectionlog = @mechanicelectricalrooms_signinspectionlog,	tenantdetails_storefrontclean = @tenantdetails_storefrontclean,	tenantdetails_storefrontsignscleanandlit = @tenantdetails_storefrontsignscleanandlit,	tenantdetails_windowscleanedanddisplayed = @tenantdetails_windowscleanedanddisplayed,	tenantdetails_windowcracksfailures = @tenantdetails_windowcracksfailures,	interiorlandscaping_conditionofplantmaterial = @interiorlandscaping_conditionofplantmaterial,	interiorlandscaping_conditionofplanterboxes = @interiorlandscaping_conditionofplanterboxes,	interiorlandscaping_conditionoffloorgrates = @interiorlandscaping_conditionoffloorgrates,	interiorlighting_skylights = @interiorlighting_skylights,	interiorlighting_diffusers = @interiorlighting_diffusers,	interiorlighting_fluorescents = @interiorlighting_fluorescents,	interiorlighting_incandescent = @interiorlighting_incandescent,	interiorlighting_spotlights = @interiorlighting_spotlights,	interiorlighting_exitemergencylights = @interiorlighting_exitemergencylights,	buildinginterior_mallentrances = @buildinginterior_mallentrances,	buildinginterior_storefronts = @buildinginterior_storefronts,	buildinginterior_flooring = @buildinginterior_flooring,	buildinginterior_generalcleanliness = @buildinginterior_generalcleanliness,	buildinginterior_drinkingfountains = @buildinginterior_drinkingfountains,	buildinginterior_trashreceptacles = @buildinginterior_trashreceptacles,	buildinginterior_railings = @buildinginterior_railings,	buildinginterior_cleanlinessofrestrooms = @buildinginterior_cleanlinessofrestrooms,	buildinginterior_directoriescleanandup = @buildinginterior_directoriescleanandup,	buildinginterior_basementswatertrashunauthentry = @buildinginterior_basementswatertrashunauthentry
		WHERE propertyid=@propertyid AND batchnumber=@batchnumber;
	END

END
GO






GO
Alter Procedure prGetPropertyInspection
@PropertyID as nvarchar(200),
@BatchID as nvarchar(200),
@UserID as nvarchar(200)
AS
BEGIN
	--Select * from reports01 where propertyid=@PropertyID AND batchnumber=@BatchID
	Select reports01.*,properties.displayname as PropertyName,properties.address1 as PropertyAddress,(Select fullname from users where username=reports01.username) as RequestBy from reports01,properties where reports01.propertyid=properties.propertyid AND reports01.propertyid=@PropertyID AND batchnumber=@BatchID
END
Go



ALTER Procedure [dbo].[prGetWorkOrderInfo]
@BatchNumber as nvarchar(100)
AS
BEGIN
	--Select *, (Select WPID from dailyreports where dailyreports.batchnumber=workorders.dailyreport_batchnumber) as WPREFID from workorders where wonumber=@BatchNumber 
	Select workorders.*,properties.displayname as PropertyName,properties.address1 as Address,properties.clientcode as ClientMode,(Select WPID from dailyreports where dailyreports.batchnumber=workorders.dailyreport_batchnumber) as WPREFID,(select  name from vendors where vendors.vendorid= workorders.vendorid) as vendorname from workorders,properties where wonumber=@BatchNumber AND workorders.propertyid= properties.propertyid
END

GO
Alter  Procedure [dbo].[pIWorkOrderForRaymour]
	@wonumber nvarchar(100),
	@propertyid nvarchar(100),
	@dateperformed nvarchar(100),
	@timeperformed nvarchar(100),
	@dateentered nvarchar(100),
	@timeentered nvarchar(100),
	@approvalstatus nvarchar(2),
	@worktobedone nvarchar(4000),
	@request_name nvarchar(100),
	@request_email nvarchar(100),
	@request_phone nvarchar(100),
	@workcompleted nvarchar(600),
	@business_unit nvarchar(100),
	@company_unit nvarchar(100),
	@DNEcost nvarchar(100),
	@UNIcost nvarchar(100),
	@UNIcontractor_cost nvarchar(100),
	@batchnumber nvarchar(100),
	@POID as nvarchar(100),
	@username nvarchar(100)
	
AS
BEGIN
declare @CategoryName as nvarchar(max);
declare @ObjectAccount as nvarchar(100);
set @ObjectAccount=@company_unit;
set @CategoryName=@business_unit;

declare @BSUnit as nvarchar(100);
declare @CompanyUnit nvarchar(100);
declare @taxRate numeric(18,2);
Select @BSUnit=business_unit,@CompanyUnit=company_unit,@taxRate=tax_rate from properties where propertyid=@propertyid

Insert into [workorders] (wonumber,propertyid,dateperformed,timeperformed,dateentered,timeentered,approvalstatus,worktobedone,request_name,request_email,request_phone,workcompleted,business_unit,company_unit,DNEcost,UNIcost,UNIcontractor_cost,UNItax,POID,username) 
	values (@wonumber,@propertyid,@dateperformed,@timeperformed,@dateentered,@timeentered,@approvalstatus,@worktobedone,@request_name,@request_email,@request_phone,@workcompleted,@BSUnit,@CompanyUnit,@DNEcost,@UNIcost,@UNIcontractor_cost,@taxRate,@POID,@username);
	
	Insert into workorders_cost (wonumber, category, business_unit, object_account)
	values ( @wonumber,@CategoryName,@BSUnit, @ObjectAccount)

END


GO
GO
ALTER Procedure [dbo].[pIWorkOrder]
	@wonumber nvarchar(100),
	@propertyid nvarchar(100),
	@dateperformed nvarchar(100),
	@timeperformed nvarchar(100),
	@dateentered nvarchar(100),
	@timeentered nvarchar(100),
	@approvalstatus nvarchar(2),
	@worktobedone nvarchar(4000),
	@request_name nvarchar(100),
	@request_email nvarchar(100),
	@request_phone nvarchar(100),
	@workcompleted nvarchar(600),
	@business_unit nvarchar(100),
	@company_unit nvarchar(100),
	@DNEcost nvarchar(100),
	@UNIcost nvarchar(100),
	@UNIcontractor_cost nvarchar(100),
	@batchnumber nvarchar(100),
	@username nvarchar(100)
	
AS
BEGIN
declare @CategoryName as nvarchar(max);
declare @ObjectAccount as nvarchar(100);
set @ObjectAccount=@company_unit;
set @CategoryName=@business_unit;

declare @BSUnit as nvarchar(100);
declare @CompanyUnit nvarchar(100);
declare @taxRate numeric(18,2);
Select @BSUnit=business_unit,@CompanyUnit=company_unit,@taxRate=tax_rate from properties where propertyid=@propertyid

Insert into [workorders] (wonumber,propertyid,dateperformed,timeperformed,dateentered,timeentered,approvalstatus,worktobedone,request_name,request_email,request_phone,workcompleted,business_unit,company_unit,DNEcost,UNIcost,UNIcontractor_cost,UNItax,username) 
	values (@wonumber,@propertyid,@dateperformed,@timeperformed,@dateentered,@timeentered,@approvalstatus,@worktobedone,@request_name,@request_email,@request_phone,@workcompleted,@BSUnit,@CompanyUnit,@DNEcost,@UNIcost,@UNIcontractor_cost,@taxRate,@username);
	
	Insert into workorders_cost (wonumber, category, business_unit, object_account)
	values ( @wonumber,@CategoryName,@BSUnit, @ObjectAccount)

END


GO


ALTER Procedure [dbo].[pIWorkOrderFromWorkProposal]
	@wonumber nvarchar(100),
	@propertyid nvarchar(100),
	@dateperformed nvarchar(100),
	@timeperformed nvarchar(100),
	@dateentered nvarchar(100),
	@timeentered nvarchar(100),
	@approvalstatus nvarchar(2),
	@worktobedone nvarchar(4000),
	@request_name nvarchar(100),
	@request_email nvarchar(100),
	@request_phone nvarchar(100),
	@workcompleted nvarchar(600),
	@business_unit nvarchar(100),
	@company_unit nvarchar(100),
	@DNEcost nvarchar(100),
	@UNIcost nvarchar(100),
	@UNIcontractor_cost nvarchar(100),
	@batchnumber_workrequest nvarchar(100),
	@batchnumber nvarchar(100),
	@POID as nvarchar(100),
	@username nvarchar(100)	
AS
BEGIN
declare @CategoryName as nvarchar(max);
declare @ObjectAccount as nvarchar(100);
set @ObjectAccount=@company_unit;
set @CategoryName=@business_unit;

declare @BSUnit as nvarchar(100)
declare @CompanyUnit nvarchar(100);
declare @taxRate numeric(18,2);
Select @BSUnit=business_unit,@CompanyUnit=company_unit from properties where propertyid=@propertyid

select @taxRate=taxrate from dailyreports Where batchnumber=@batchnumber_workrequest

Insert into [workorders] (wonumber,propertyid,dateperformed,timeperformed,dateentered,timeentered,approvalstatus,worktobedone,request_name,request_email,request_phone,workcompleted,business_unit,company_unit,DNEcost,UNIcost,UNIcontractor_cost,dailyreport_batchnumber,UNItax,POID,username) 
	values (@wonumber,@propertyid,@dateperformed,@timeperformed,@dateentered,@timeentered,@approvalstatus,@worktobedone,@request_name,@request_email,@request_phone,@workcompleted,@BSUnit,@CompanyUnit,@DNEcost,@UNIcost,@UNIcontractor_cost,@batchnumber_workrequest,@taxRate,@POID,@username);

Insert into workorders_cost (wonumber, category, business_unit, object_account)
	values ( @wonumber,@CategoryName,@BSUnit, @ObjectAccount)
	
update dailyreports set approvalstatus='3' where batchnumber=@batchnumber_workrequest;
	
END

GO


Alter Procedure [dbo].[pIdailyReports]
@wPID nvarchar(100),
@propertyid nvarchar(100),
@dateperformed nvarchar(50),
@TimePerform nvarchar(50),
@dateentered nvarchar(50),
@timeentered nvarchar(50),
@guid nvarchar(100),
@ApprovalStatus nvarchar(2),
@ReportHeader nvarchar(200),
@ReportText nvarchar(4000),
@hazard nvarchar(2),
@maintenance nvarchar(2),
@pic1 nvarchar(100),@pic2 nvarchar(100),@pic3 nvarchar(100),@pic4 nvarchar(100),@pic5 nvarchar(100),
@costestimate nvarchar(20),
@costtotal nvarchar(20),
@taxrate nvarchar(20),
@userID nvarchar(50)
AS
BEGIN
declare @WorkPID as nvarchar(100)
Set @WorkPID=(Select dbo.GetRecordID('Work Request','WR'))
 INSERT into dailyreports(WPID,propertyid,dateperformed,timeperformed,dateentered,timeentered,BatchNumber,approvalstatus,reportheader,reporttext,hazard,maintenance,pic1,pic2,pic3,pic4,pic5,costestimate,costtotal,taxrate,username) 
 values (@WorkPID,@PropertyID,@DatePerformed,@TimePerform,@DateEntered,@TimeEntered,@guid,@ApprovalStatus,@ReportHeader,@ReportText,@Hazard,@Maintenance,@pic1,@pic2,@pic3,@pic4,@pic5,@CostEstimate,@CostTotal,@taxrate,@UserID)
END


GO
/****** Object:  StoredProcedure [dbo].[pIWorkOrder]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[prActualPPPvsGoal]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



GO
/****** Object:  StoredProcedure [dbo].[prAllPropertiesUserWise]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[prAllPropertiesUserWise]
@UserID nvarchar(100)
AS
Begin
	SELECT propertyid, displayname, region, address1, address2, zip, emailalerts, archived, emailalerts_wo, clientcode, emailalerts_wo_progress, business_unit, company_unit, propertymanager, city, state, gps_latitude, gps_longitude, tax_auth, tax_rate, 
				 emailalerts_wo_edit
	FROM   properties where propertyid in (select propertyid  from usersaccess where username=@UserID)

End

GO
/****** Object:  StoredProcedure [dbo].[prCategoryWiseMasterInfoV2]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Palash

ALTER procedure [dbo].[prCategoryWiseMasterInfoV2]
	@PropertyCategory nvarchar(200),
	@PropertyID nvarchar(100),
  @UserName nvarchar(200) as
Begin	
	if @PropertyCategory='Work Order'
		Begin
			Select wonumber as ID, wonumber as WorkOrderNumber, dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 8 THEN 'Open'
						WHEN 9 THEN 'Closed'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus','' as 'Comments' from workorders, properties where workorders.propertyid=properties.propertyid AND workorders.propertyid=@PropertyID Order by SubmittedDate,timeperformed desc
		End
	if @PropertyCategory='Work Request'
		Begin
			Select CASE  
			WHEN WPID IS NULL THEN 'RefID'
			ELSE WPID
			END  as 'ID', batchnumber as WorkOrderNumber, dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
					CAST(CASE approvalstatus
						WHEN 0 THEN 'Pending'
						WHEN 1 THEN 'Posted to PM'						
						WHEN 2 THEN 'Rejected'
						WHEN 3 THEN 'Work Order Created'
						WHEN 4 THEN 'Defer to Later Date'
						WHEN 5 THEN 'Assign to Vendor'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus',reporttext as Comments from dailyreports, properties where dailyreports.propertyid=properties.propertyid AND dailyreports.propertyid=@PropertyID Order by SubmittedDate, timeperformed desc
		End
	
	if @PropertyCategory='Snow Removal'
		Begin
			Select reports02.propertyid as ID, batchnumber as WorkOrderNumber,dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 1 THEN 'Approved'
						WHEN 0 THEN 'Pending'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus','' as 'Comments' from reports02, properties where reports02.propertyid=properties.propertyid AND reports02.propertyid=@PropertyID Order by SubmittedDate desc
		End
	if @PropertyCategory='Property Inspections'
		Begin
			Select reports01.propertyid as ID, batchnumber as WorkOrderNumber,dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 1 THEN 'Approved'
						WHEN 0 THEN 'Pending'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus','' as 'Comments' from reports01, properties where reports01.propertyid=properties.propertyid AND reports01.propertyid=@PropertyID Order by SubmittedDate desc
	End
	if @PropertyCategory='Total Work Order'
		Begin
			Select top 1000 wonumber as ID, wonumber as WorkOrderNumber, dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 8 THEN 'Open'
						WHEN 9 THEN 'Closed'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus','' as 'Comments' from workorders, properties where workorders.propertyid=properties.propertyid AND workorders.propertyid in (select propertyid from usersaccess where username =@UserName) Order by SubmittedDate desc
	End
	if @PropertyCategory='Total Work Request'
		Begin
			Select top 1000 CASE  
			WHEN WPID IS NULL THEN 'RefID'
			ELSE WPID
			END  as 'ID', batchnumber as WorkOrderNumber, dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 0 THEN 'Pending'
						WHEN 1 THEN 'Posted to PM'						
						WHEN 2 THEN 'Rejected'
						WHEN 3 THEN 'Work Order Created'
						WHEN 4 THEN 'Defer to Later Date'
						WHEN 5 THEN 'Assign to Vendor'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus','' as 'Comments' from dailyreports, properties where dailyreports.propertyid=properties.propertyid AND dailyreports.propertyid in (select propertyid from usersaccess where username =@UserName) Order by SubmittedDate desc
		End
	
	if @PropertyCategory='Total Snow Removal'
		Begin
			Select top 1000 reports02.propertyid as ID, batchnumber as WorkOrderNumber,dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 1 THEN 'Approved'
						WHEN 0 THEN 'Pending'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus','' as 'Comments' from reports02, properties where reports02.propertyid=properties.propertyid AND reports02.propertyid in (select propertyid from usersaccess where username =@UserName) Order by SubmittedDate desc
		End
	if @PropertyCategory='Total Property Inspections'
		Begin
			Select top 1000 reports01.propertyid as ID, batchnumber as WorkOrderNumber,dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 1 THEN 'Approved'
						WHEN 0 THEN 'Pending'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus','' as 'Comments'  from reports01, properties where reports01.propertyid=properties.propertyid AND reports01.propertyid in (select propertyid from usersaccess where username =@UserName) Order by SubmittedDate desc
	End
	if @PropertyCategory='Open Work Order'
		Begin
			Select wonumber as ID,wonumber as WorkOrderNumber, dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 8 THEN 'Open'
						WHEN 9 THEN 'Closed'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus','' as 'Comments' from workorders, properties where workorders.propertyid=properties.propertyid AND workorders.propertyid=@PropertyID AND workorders.approvalstatus='8' Order by SubmittedDate desc
	End
	if @PropertyCategory='Close Work Order'
		Begin
			Select wonumber as ID, wonumber as WorkOrderNumber, dateentered as SubmittedDate,dateperformed as PerformedDate, properties.displayname as PropertyName,
				CAST(CASE approvalstatus
						WHEN 8 THEN 'Open'
						WHEN 9 THEN 'Closed'
						ELSE 'Undefined'
					END
					as nvarchar(200))
					as 'approvalstatus','' as 'Comments' from workorders, properties where workorders.propertyid=properties.propertyid AND workorders.propertyid=@PropertyID AND workorders.approvalstatus='9' Order by SubmittedDate desc
	End
End








GO

ALTER Procedure [dbo].[prGetAllServices]
@PropertyID nvarchar(100),
@UserID nvarchar(100)
AS
Begin
	declare @BusinessUnit nvarchar(100);
	Set @BusinessUnit=(Select business_unit from properties where propertyid=@PropertyID)
	IF isNull(@BusinessUnit,'') =''
		BEGIN
			Select 'ALL WORK ORDER ITEMS' as categorygroup,'ALL WORK ORDER ITEMS' as category,'9999' as object_account,'9999 - ALL WORK ORDER ITEMS' as service 
		END
	ELSE
		BEGIN
			Select *,object_account+' - '+category as service from categories_brixmor
		END

END

GO
/****** Object:  StoredProcedure [dbo].[prGetDailyReportInfo]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[prGetDailyReportInfo]
@BatchNumber nvarchar(200),
@UserID nvarchar(100)
AS
Begin
Select dailyreports.*,properties.displayname as PropertyName,properties.address1 as Address,(Select Count(*) from workorders Where dailyreport_batchnumber =@BatchNumber )  as WorkOrderStatus,(Select wonumber from workorders Where dailyreport_batchnumber =@BatchNumber )  as WorkOrderID  from dailyreports,properties where dailyreports.propertyid=properties.propertyid AND  batchnumber=@BatchNumber
End

GO
/****** Object:  StoredProcedure [dbo].[prGetUserInformation]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[prGetUserInformation]
@UserID as nvarchar(100),
@Type nvarchar(100) 
AS
BEGIN

IF @Type='User'
	BEGIN
	SELECT [username]
		  ,[allowsubmitform1]
		  ,[allowsubmitform2]
		  ,[allowdailyreportuploads]
		  ,[allowreportstatuschange]
		  ,[alloweditlogins]
		  ,[alloweditprops]
		  ,[allowsoftwaredownload]
		  ,[viewreports1]
		  ,[viewreports2]
		  ,[viewreports3]
		  ,[fullname]
		  ,[emailaddress]
		  ,[phonenumber]
		  ,[allowenterworkorder]
		  ,[alloweditworkorder]
		  ,[allowshowcost]
		  ,[allowviewvendors]
		  ,[allowviewpropdatasheets]
		  ,[clientcode]
		  ,[alloweditbrixmorwo]
		  ,[allowedapprovebrixinvoices]
		  ,[allowedapprovebrixinvoices_ondemand]
		  ,[allowedapprovebrixinvoices_viewonly]
		  ,[forcestartpage]
		  ,[onlyallowiosaudits]
		  ,[uniadmin]
		  ,[univendor]
	  FROM [dbo].[users] Where username =@UserID
	  END
  END









/****** Object:  StoredProcedure [dbo].[prIndividualPropertyInfo]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[prIndividualPropertyInfo]
	@PropertyID nvarchar(100),
	@UserID nvarchar(100)
AS
BEGIN
	Select propertyid,displayname,region,address1,zip,propertymanager,state, 
		(Select count(wo.propertyid) from workorders wo where wo.propertyid = p.propertyid) as 'WorkOrder' ,
		(Select count(snow.propertyid) from dailyreports snow where snow.propertyid = p.propertyid) as 'WorkRequst',
		(Select count(inspection.propertyid) from reports01 inspection where inspection.propertyid = p.propertyid) as 'PropertyInspection',
		(Select count(report.propertyid) from reports02 report where report.propertyid = p.propertyid) as 'SnowReport',
		(Select Count(*) from workorders where approvalstatus=8 and workorders.propertyid=p.propertyid) as OpenWorkOder,
		(Select Count(*)  from workorders where approvalstatus=9 and workorders.propertyid=p.propertyid) as CloseWorkOder
from properties p where propertyid=@PropertyID
END



GO
/****** Object:  StoredProcedure [dbo].[prIndividualPropertyInfoV2]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[prIndividualPropertyInfoV2]
 @PropertyID nvarchar(100),
 @UserID nvarchar(100)
AS
BEGIN
 Select propertyid,displayname,region,address1,zip,propertymanager,state,gps_latitude,gps_longitude, 
  (SELECT TOP 1 sweeping_frequency FROM properties_recurringwork WHERE type = 'sweeping' and propertyid=@PropertyID) as 'Recurringwork',
  (Select count(wo.propertyid) from workorders wo where wo.propertyid = p.propertyid) as 'WorkOrder' ,
  (SELECT TOP 1 dateentered FROM workorders WHERE propertyid=@PropertyID  ORDER BY dateentered DESC) as 'WorkOrderEntryDate',
  (Select count(snow.propertyid) from dailyreports snow where snow.propertyid = p.propertyid) as 'WorkRequst',
  (SELECT TOP 1 dateentered FROM dailyreports WHERE propertyid=@PropertyID  ORDER BY dateentered DESC) as 'WorkRequestEntryDate',
  (Select count(inspection.propertyid) from reports01 inspection where inspection.propertyid = p.propertyid) as 'PropertyInspection',
  (SELECT TOP 1 dateentered FROM reports01 WHERE propertyid=@PropertyID  ORDER BY dateentered DESC) as 'PropertyInspectionEntryDate',
  (Select count(report.propertyid) from reports02 report where report.propertyid = p.propertyid) as 'SnowReport',
  (SELECT TOP 1 dateentered FROM reports02 WHERE propertyid=@PropertyID  ORDER BY dateentered DESC) as 'SnowReportEntryDate',
  (Select Count(*) from workorders where approvalstatus=8 and workorders.propertyid=p.propertyid) as OpenWorkOder,
  (Select Count(*)  from workorders where approvalstatus=9 and workorders.propertyid=p.propertyid) as CloseWorkOder
from properties p where propertyid=@PropertyID
END

select * from properties
GO
/****** Object:  StoredProcedure [dbo].[prPropertyDataPropertyWise]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[prPropertyDataPropertyWise]
@PropertyID nvarchar(200),
@UserID nvarchar(200)
AS
BEGIN

Select properties_datasheet.propertyid,property_type,
	date_property_acquired,
	current_owner,
	original_architect,
	original_developer,
	original_engineers,
	year_built,
	original_gla,
	renovation_expansion,
	current_gla,
	acres_building,
	acres_parkinglot,
	acres_project_total,
	outparcel_tenants,
	acres_maintained,
	percent_acres_bedding_plants,
	number_dormant_months_year,
	parkinglot_number_of_poles,
	parkinglot_number_of_fixtures,
	parkinglot_type_of_fixture,
	parkinglot_location_of_controls,
	parkinglot_other,
	parkinglot_other_lighting,
	parkinglot_other_lighting_controls,
	roof,
	parking_spaces,
	parking_spaces_handicapped,
	parking_ratio,
	parking_sealcoat_overlay,
	building_fire_sprinkler,
	building_hvac,
	building_construction,
	building_key_notes,
	lockbox_location_01,
	lockbox_code_01,
	lockbox_location_02,
	lockbox_code_02,
	lockbox_location_03,
	lockbox_code_03,
	marketing_fund,
	marketing_contracted_to,
	utility_electric_text,
	utility_electric_provider,
	utility_electric_phone,
	utility_gas_text,
	utility_gas_provider,
	utility_gas_phone,
	utility_water_sewer_text,
	utility_water_sewer_provider,
	utility_water_sewer_phone,
	utility_telephone_text,
	utility_telephone_provider,
	utility_telephone_phone,
	municipal_police_text,
	municipal_police_provider,
	municipal_police_phone,
	municipal_fire_text,
	municipal_fire_provider,
	municipal_fire_phone,
	municipal_buildingdept_text,
	municipal_buildingdept_provider,
	municipal_buildingdept_phone,
	municipal_publicworks_text,
	municipal_publicworks_provider,
	municipal_publicworks_phone,
	municipal_highwaydept_text,
	municipal_highwaydept_provider,
	municipal_highwaydept_phone,
	vendor_cardaccess_provider,
	vendor_cardaccess_contact,
	vendor_cardaccess_notes,
	vendor_door_repair_provider,
	vendor_door_repair_contact,
	vendor_door_repair_notes,
	vendor_eifs_provider,
	vendor_eifs_contact,
	vendor_eifs_notes,
	vendor_electrical_provider,
	vendor_electrical_contact,
	vendor_electrical_notes,
	vendor_elevator_provider,
	vendor_elevator_contact,
	vendor_elevator_notes,
	vendor_enviro_cleanup_provider,
	vendor_enviro_cleanup_contact,
	vendor_enviro_cleanup_notes,
	vendor_exterminator_provider,
	vendor_exterminator_contact,
	vendor_exterminator_notes,
	vendor_facade_provider,
	vendor_facade_contact,
	vendor_facade_notes,
	vendor_fire_alarm_monitor_provider,
	vendor_fire_alarm_monitor_contact,
	vendor_fire_alarm_monitor_notes,
	vendor_fire_alarm_repair_provider,
	vendor_fire_alarm_repair_contact,
	vendor_fire_alarm_repair_notes,
	vendor_generator_provider,
	vendor_generator_contact,
	vendor_generator_notes,
	vendor_glass_boardup_provider,
	vendor_glass_boardup_contact,
	vendor_glass_boardup_notes,
	vendor_graffitti_vandal_provider,
	vendor_graffitti_vandal_contact,
	vendor_graffitti_vandal_notes,
	vendor_hvac_repair_provider,
	vendor_hvac_repair_contact,
	vendor_hvac_repair_notes,
	vendor_handrail_provider,
	vendor_handrail_contact,
	vendor_handrail_notes,
	vendor_irrigation_provider,
	vendor_irrigation_contact,
	vendor_irrigation_notes,
	vendor_janitorial_provider,
	vendor_janitorial_contact,
	vendor_janitorial_notes,
	vendor_landscaping_provider,
	vendor_landscaping_contact,
	vendor_landscaping_notes,
	vendor_locksmith_provider,
	vendor_locksmith_contact,
	vendor_locksmith_notes,
	vendor_masonry_provider,
	vendor_masonry_contact,
	vendor_masonry_notes,
	vendor_oil_supply_provider,
	vendor_oil_supply_contact,
	vendor_oil_supply_notes,
	vendor_plot_light_repair_provider,
	vendor_plot_light_repair_contact,
	vendor_plot_light_repair_notes,
	vendor_plot_sweeping_provider,
	vendor_plot_sweeping_contact,
	vendor_plot_sweeping_notes,
	vendor_painting_provider,
	vendor_painting_contact,
	vendor_painting_notes,
	vendor_payphone_provider,
	vendor_payphone_contact,
	vendor_payphone_notes,
	vendor_plumbing_provider,
	vendor_plumbing_contact,
	vendor_plumbing_notes,
	vendor_retentionpond_provider,
	vendor_retentionpond_contact,
	vendor_retentionpond_notes,
	vendor_roof_repair_provider,
	vendor_roof_repair_contact,
	vendor_roof_repair_notes,
	vendor_security_provider,
	vendor_security_contact,
	vendor_security_notes,
	vendor_sewer_septic_drain_clearing_provider,
	vendor_sewer_septic_drain_clearing_contact,
	vendor_sewer_septic_drain_clearing_notes,
	vendor_sewer_septic_plumbing_provider,
	vendor_sewer_septic_plumbing_contact,
	vendor_sewer_septic_plumbing_notes,
	vendor_sidewalk_provider,
	vendor_sidewalk_contact,
	vendor_sidewalk_notes,
	vendor_signage_provider,
	vendor_signage_contact,
	vendor_signage_notes,
	vendor_smoke_water_restore_provider,
	vendor_smoke_water_restore_contact,
	vendor_smoke_water_restore_notes,
	vendor_snow_removal_provider,
	vendor_snow_removal_contact,
	vendor_snow_removal_notes,
	vendor_towing_provider,
	vendor_towing_contact,
	vendor_towing_notes,
	vendor_trashremoval_provider,
	vendor_trashremoval_contact,
	vendor_trashremoval_notes,
	vendor_flooring_provider,
	vendor_flooring_contact,
	vendor_flooring_notes,
	vendor_comments,
	properties.displayname
from properties_datasheet, properties where properties_datasheet.propertyid=properties.propertyid AND properties_datasheet.propertyid=@PropertyID;

END

GO
/****** Object:  StoredProcedure [dbo].[prRecognizedVsPotential]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






GO
/****** Object:  StoredProcedure [dbo].[prTotalItemsUserWise]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[prTotalItemsUserWise]
 @UserID nvarchar(100)
 AS
 BEGIN
	Select sum(WorkOrder) as TotalWOrkOrder, sum(WorkRequst) as TotalWorkRequest,Sum(PropertyInspection) as TotalPropertyInspection , sum(SnowReport) as TotalSnowReport from vwMasterTable where propertyid in (select propertyid from usersaccess where username =@UserID) 
END

GO
/****** Object:  StoredProcedure [dbo].[prUserInfo]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[prUserLogin]    Script Date: 6/2/2016 5:16:32 PM ******/

ALTER Procedure [dbo].[prUserLogin]
	@UserID nvarchar(100),
	@Password nvarchar(100)
AS
BEGIN
	Select count(*) as CountLogin from users where username=@UserID AND password=@Password
END


GO
/****** Object:  StoredProcedure [dbo].[prUserLoginV2]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[prUserLoginV2]
	@UserID nvarchar(100),
	@Password nvarchar(100)
AS
BEGIN
SELECT username, password, allowsubmitform1, allowsubmitform2, allowdailyreportuploads, allowreportstatuschange, alloweditlogins, alloweditprops, allowsoftwaredownload, viewreports1, viewreports2, 
                         viewreports3, fullname, emailaddress, phonenumber, allowenterworkorder, alloweditworkorder, allowshowcost, allowviewvendors, allowviewpropdatasheets, clientcode, alloweditbrixmorwo, 
                         allowedapprovebrixinvoices, allowedapprovebrixinvoices_ondemand, allowedapprovebrixinvoices_viewonly, forcestartpage, onlyallowiosaudits, uniadmin, univendor
FROM users where username=@UserID AND password=@Password
END



GO
/****** Object:  StoredProcedure [dbo].[prUserWiseMasterInfo]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[prUserWiseMasterInfo]  @UserName nvarchar(200) as
Begin
	Select * from vwMasterTable where propertyid in (select propertyid from usersaccess where username =@UserName)
End


GO
/****** Object:  StoredProcedure [dbo].[prUserWiseProperty]    Script Date: 6/2/2016 5:16:32 PM ******/

Alter procedure [dbo].[prUserWiseProperty]
@UserID as nvarchar(100)
AS
Begin
Select p.propertyid,p.displayname,p.address1,p.address2,p.region,p.city,p.propertymanager,p.state from properties p
End
GO

ALTER Procedure [dbo].[pUDailyReports]
@propertyid nvarchar(100),
@batchnumber nvarchar(100),
@reportheader nvarchar(400),
@reporttext nvarchar(4000),
@hazard nvarchar(2),
@maintenance nvarchar(2),
@costestimate nvarchar(10),
@taxrate nvarchar(10),
@costtotal nvarchar(10),
@approvalstatus nvarchar(2),
@notes nvarchar(400),
@UserID nvarchar(100)
AS
BEGIN
Update dailyreports 
	Set 
		reportheader=@reportheader,
		reporttext=@reporttext,
		hazard=@hazard,
		maintenance=@maintenance,
		costestimate=@costestimate,
		taxrate=@taxrate,
		costtotal=@costtotal,
		approvalstatus=@approvalstatus,
		notes=@notes
	Where batchnumber=@batchnumber
END

GO
/****** Object:  StoredProcedure [dbo].[pUPropertiesDataSheet]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER Procedure [dbo].[pUPropertiesDataSheet]
@propertyid nvarchar(100),	@property_type nvarchar(100),	@date_property_acquired nvarchar(100),	@current_owner nvarchar(100),	@original_architect nvarchar(100),	@original_developer nvarchar(100),	@original_engineers nvarchar(100),	@year_built nvarchar(100),	@original_gla nvarchar(100),	@renovation_expansion nvarchar(100),	@current_gla nvarchar(100),	@acres_building nvarchar(100),	@acres_parkinglot nvarchar(100),	@acres_project_total nvarchar(100),	@outparcel_tenants nvarchar(100),	@acres_maintained nvarchar(100),	@percent_acres_bedding_plants nvarchar(100),	@number_dormant_months_year nvarchar(100),	@parkinglot_number_of_poles nvarchar(100),	@parkinglot_number_of_fixtures nvarchar(100),	@parkinglot_type_of_fixture nvarchar(100),	@parkinglot_location_of_controls nvarchar(100),	@parkinglot_other nvarchar(100),	@parkinglot_other_lighting nvarchar(100),	@parkinglot_other_lighting_controls nvarchar(100),	@roof nvarchar(100),	@parking_spaces nvarchar(100),	@parking_spaces_handicapped nvarchar(100),	@parking_ratio nvarchar(100),	@parking_sealcoat_overlay nvarchar(100),	@building_fire_sprinkler nvarchar(100),	@building_hvac nvarchar(100),	@building_construction nvarchar(100),	@building_key_notes nvarchar(100),	@lockbox_location_01 nvarchar(100),	@lockbox_code_01 nvarchar(100),	@lockbox_location_02 nvarchar(100),	@lockbox_code_02 nvarchar(100),	@lockbox_location_03 nvarchar(100),	@lockbox_code_03 nvarchar(100),	@marketing_fund nvarchar(100),	@marketing_contracted_to nvarchar(100),	@utility_electric_text nvarchar(100),	@utility_electric_provider nvarchar(100),	@utility_electric_phone nvarchar(100),	@utility_gas_text nvarchar(100),	@utility_gas_provider nvarchar(100),	@utility_gas_phone nvarchar(100),	@utility_water_sewer_text nvarchar(100),	@utility_water_sewer_provider nvarchar(100),	@utility_water_sewer_phone nvarchar(100),	@utility_telephone_text nvarchar(100),	@utility_telephone_provider nvarchar(100),	@utility_telephone_phone nvarchar(100),	@municipal_police_text nvarchar(100),	@municipal_police_provider nvarchar(100),	@municipal_police_phone nvarchar(100),	@municipal_fire_text nvarchar(100),	@municipal_fire_provider nvarchar(100),	@municipal_fire_phone nvarchar(100),	@municipal_buildingdept_text nvarchar(100),	@municipal_buildingdept_provider nvarchar(100),	@municipal_buildingdept_phone nvarchar(100),	@municipal_publicworks_text nvarchar(100),	@municipal_publicworks_provider nvarchar(100),	@municipal_publicworks_phone nvarchar(100),	@municipal_highwaydept_text nvarchar(100),	@municipal_highwaydept_provider nvarchar(100),	@municipal_highwaydept_phone nvarchar(100),	@vendor_cardaccess_provider nvarchar(100),	@vendor_cardaccess_contact nvarchar(100),	@vendor_cardaccess_notes nvarchar(100),	@vendor_door_repair_provider nvarchar(100),	@vendor_door_repair_contact nvarchar(100),	@vendor_door_repair_notes nvarchar(100),	@vendor_eifs_provider nvarchar(100),	@vendor_eifs_contact nvarchar(100),	@vendor_eifs_notes nvarchar(100),	@vendor_electrical_provider nvarchar(100),	@vendor_electrical_contact nvarchar(100),	@vendor_electrical_notes nvarchar(100),	@vendor_elevator_provider nvarchar(100),	@vendor_elevator_contact nvarchar(100),	@vendor_elevator_notes nvarchar(100),	@vendor_enviro_cleanup_provider nvarchar(100),	@vendor_enviro_cleanup_contact nvarchar(100),	@vendor_enviro_cleanup_notes nvarchar(100),	@vendor_exterminator_provider nvarchar(100),	@vendor_exterminator_contact nvarchar(100),	@vendor_exterminator_notes nvarchar(100),	@vendor_facade_provider nvarchar(100),	@vendor_facade_contact nvarchar(100),	@vendor_facade_notes nvarchar(100),	@vendor_fire_alarm_monitor_provider nvarchar(100),	@vendor_fire_alarm_monitor_contact nvarchar(100),	@vendor_fire_alarm_monitor_notes nvarchar(100),	@vendor_fire_alarm_repair_provider nvarchar(100),	@vendor_fire_alarm_repair_contact nvarchar(100),	@vendor_fire_alarm_repair_notes nvarchar(100),	@vendor_generator_provider nvarchar(100),	@vendor_generator_contact nvarchar(100),	@vendor_generator_notes nvarchar(100),	@vendor_glass_boardup_provider nvarchar(100),	@vendor_glass_boardup_contact nvarchar(100),	@vendor_glass_boardup_notes nvarchar(100),	@vendor_graffitti_vandal_provider nvarchar(100),	@vendor_graffitti_vandal_contact nvarchar(100),	@vendor_graffitti_vandal_notes nvarchar(100),	@vendor_hvac_repair_provider nvarchar(100),	@vendor_hvac_repair_contact nvarchar(100),	@vendor_hvac_repair_notes nvarchar(100),	@vendor_handrail_provider nvarchar(100),	@vendor_handrail_contact nvarchar(100),	@vendor_handrail_notes nvarchar(100),	@vendor_irrigation_provider nvarchar(100),	@vendor_irrigation_contact nvarchar(100),	@vendor_irrigation_notes nvarchar(100),	@vendor_janitorial_provider nvarchar(100),	@vendor_janitorial_contact nvarchar(100),	@vendor_janitorial_notes nvarchar(100),	@vendor_landscaping_provider nvarchar(100),	@vendor_landscaping_contact nvarchar(100),	@vendor_landscaping_notes nvarchar(100),	@vendor_locksmith_provider nvarchar(100),	@vendor_locksmith_contact nvarchar(100),	@vendor_locksmith_notes nvarchar(100),	@vendor_masonry_provider nvarchar(100),	@vendor_masonry_contact nvarchar(100),	@vendor_masonry_notes nvarchar(100),	@vendor_oil_supply_provider nvarchar(100),	@vendor_oil_supply_contact nvarchar(100),	@vendor_oil_supply_notes nvarchar(100),	@vendor_plot_light_repair_provider nvarchar(100),	@vendor_plot_light_repair_contact nvarchar(100),	@vendor_plot_light_repair_notes nvarchar(100),	@vendor_plot_sweeping_provider nvarchar(100),	@vendor_plot_sweeping_contact nvarchar(100),	@vendor_plot_sweeping_notes nvarchar(100),	@vendor_painting_provider nvarchar(100),	@vendor_painting_contact nvarchar(100),	@vendor_painting_notes nvarchar(100),	@vendor_payphone_provider nvarchar(100),	@vendor_payphone_contact nvarchar(100),	@vendor_payphone_notes nvarchar(100),	@vendor_plumbing_provider nvarchar(100),	@vendor_plumbing_contact nvarchar(100),	@vendor_plumbing_notes nvarchar(100),	@vendor_retentionpond_provider nvarchar(100),	@vendor_retentionpond_contact nvarchar(100),	@vendor_retentionpond_notes nvarchar(100),	@vendor_roof_repair_provider nvarchar(100),	@vendor_roof_repair_contact nvarchar(100),	@vendor_roof_repair_notes nvarchar(100),	@vendor_security_provider nvarchar(100),	@vendor_security_contact nvarchar(100),	@vendor_security_notes nvarchar(100),	@vendor_sewer_septic_drain_clearing_provider nvarchar(100),	@vendor_sewer_septic_drain_clearing_contact nvarchar(100),	@vendor_sewer_septic_drain_clearing_notes nvarchar(100),	@vendor_sewer_septic_plumbing_provider nvarchar(100),	@vendor_sewer_septic_plumbing_contact nvarchar(100),	@vendor_sewer_septic_plumbing_notes nvarchar(100),	@vendor_sidewalk_provider nvarchar(100),	@vendor_sidewalk_contact nvarchar(100),	@vendor_sidewalk_notes nvarchar(100),	@vendor_signage_provider nvarchar(100),	@vendor_signage_contact nvarchar(100),	@vendor_signage_notes nvarchar(100),	@vendor_smoke_water_restore_provider nvarchar(100),	@vendor_smoke_water_restore_contact nvarchar(100),	@vendor_smoke_water_restore_notes nvarchar(100),	@vendor_snow_removal_provider nvarchar(100),	@vendor_snow_removal_contact nvarchar(100),	@vendor_snow_removal_notes nvarchar(100),	@vendor_towing_provider nvarchar(100),	@vendor_towing_contact nvarchar(100),	@vendor_towing_notes nvarchar(100),	@vendor_trashremoval_provider nvarchar(100),	@vendor_trashremoval_contact nvarchar(100),	@vendor_trashremoval_notes nvarchar(100),	@vendor_flooring_provider nvarchar(100),	@vendor_flooring_contact nvarchar(100),	@vendor_flooring_notes nvarchar(100),	@vendor_comments nvarchar(100)
AS
BEGIN
UPDATE [dbo].[properties_datasheet]
   SET 
property_type = @property_type,
date_property_acquired = @date_property_acquired,
current_owner = @current_owner,
original_architect = @original_architect,
original_developer = @original_developer,	
original_engineers = @original_engineers,
year_built = @year_built,	
original_gla = @original_gla,
renovation_expansion = @renovation_expansion,
current_gla = @current_gla,	
acres_building = @acres_building,
acres_parkinglot = @acres_parkinglot,
acres_project_total = @acres_project_total,
outparcel_tenants = @outparcel_tenants,
acres_maintained = @acres_maintained,
percent_acres_bedding_plants = @percent_acres_bedding_plants,
number_dormant_months_year = @number_dormant_months_year,
parkinglot_number_of_poles = @parkinglot_number_of_poles,
parkinglot_number_of_fixtures = @parkinglot_number_of_fixtures,
parkinglot_type_of_fixture = @parkinglot_type_of_fixture,
parkinglot_location_of_controls = @parkinglot_location_of_controls,
parkinglot_other = @parkinglot_other,
parkinglot_other_lighting = @parkinglot_other_lighting,
parkinglot_other_lighting_controls = @parkinglot_other_lighting_controls,
roof = @roof,
parking_spaces = @parking_spaces,
parking_spaces_handicapped = @parking_spaces_handicapped,
parking_ratio = @parking_ratio,
parking_sealcoat_overlay = @parking_sealcoat_overlay,
building_fire_sprinkler = @building_fire_sprinkler,
building_hvac = @building_hvac,
building_construction = @building_construction,
building_key_notes = @building_key_notes,
lockbox_location_01 = @lockbox_location_01,
lockbox_code_01 = @lockbox_code_01,	
lockbox_location_02 = @lockbox_location_02,
lockbox_code_02 = @lockbox_code_02,	
lockbox_location_03 = @lockbox_location_03,
lockbox_code_03 = @lockbox_code_03,
marketing_fund = @marketing_fund,	
marketing_contracted_to = @marketing_contracted_to,	
vendor_comments = @vendor_comments,	
utility_electric_provider=@utility_electric_provider,
utility_electric_phone = @utility_electric_phone,
utility_gas_provider = @utility_gas_provider,
utility_gas_phone=@utility_gas_phone,
utility_water_sewer_provider = @utility_water_sewer_provider,
utility_water_sewer_phone =@utility_water_sewer_phone,
utility_telephone_provider = @utility_telephone_provider,
utility_telephone_phone=@utility_telephone_phone,
municipal_police_provider = @municipal_police_provider,
municipal_police_phone=@municipal_police_phone,	
municipal_fire_provider = @municipal_fire_provider,
municipal_fire_phone = @municipal_fire_phone,
municipal_buildingdept_provider = @municipal_buildingdept_provider,
municipal_buildingdept_phone = @municipal_buildingdept_phone,	
municipal_publicworks_provider = @municipal_publicworks_provider,
municipal_publicworks_phone = @municipal_publicworks_phone,	
municipal_highwaydept_provider = @municipal_highwaydept_provider,
municipal_highwaydept_phone = @municipal_highwaydept_phone,	
vendor_cardaccess_provider = @vendor_cardaccess_provider,	
vendor_cardaccess_contact = @vendor_cardaccess_contact,
vendor_cardaccess_notes = @vendor_cardaccess_notes,	
vendor_door_repair_provider = @vendor_door_repair_provider,	
vendor_door_repair_contact = @vendor_door_repair_contact,	
vendor_door_repair_notes = @vendor_door_repair_notes,
vendor_eifs_provider = @vendor_eifs_provider,
vendor_eifs_contact = @vendor_eifs_contact,
vendor_eifs_notes = @vendor_eifs_notes,	
vendor_electrical_provider = @vendor_electrical_provider,	
vendor_electrical_contact = @vendor_electrical_contact,	
vendor_electrical_notes = @vendor_electrical_notes,	
vendor_elevator_provider = @vendor_elevator_provider,	
vendor_elevator_contact = @vendor_elevator_contact,	
vendor_elevator_notes = @vendor_elevator_notes,	
vendor_enviro_cleanup_provider = @vendor_enviro_cleanup_provider,	
vendor_enviro_cleanup_contact = @vendor_enviro_cleanup_contact,	
vendor_enviro_cleanup_notes = @vendor_enviro_cleanup_notes,	
vendor_exterminator_provider = @vendor_exterminator_provider,	
vendor_exterminator_contact = @vendor_exterminator_contact,	
vendor_exterminator_notes = @vendor_exterminator_notes,	
vendor_facade_provider = @vendor_facade_provider,	
vendor_facade_contact = @vendor_facade_contact,	
vendor_facade_notes = @vendor_facade_notes,	
vendor_fire_alarm_monitor_provider = @vendor_fire_alarm_monitor_provider,
vendor_fire_alarm_monitor_contact = @vendor_fire_alarm_monitor_contact,
vendor_fire_alarm_monitor_notes = @vendor_fire_alarm_monitor_notes,	
vendor_fire_alarm_repair_provider = @vendor_fire_alarm_repair_provider,
vendor_fire_alarm_repair_contact = @vendor_fire_alarm_repair_contact,
vendor_fire_alarm_repair_notes = @vendor_fire_alarm_repair_notes,
vendor_generator_provider = @vendor_generator_provider,	
vendor_generator_contact = @vendor_generator_contact,	
vendor_generator_notes = @vendor_generator_notes,	
vendor_glass_boardup_provider = @vendor_glass_boardup_provider,
vendor_glass_boardup_contact = @vendor_glass_boardup_contact,	
vendor_glass_boardup_notes = @vendor_glass_boardup_notes,	
vendor_graffitti_vandal_provider = @vendor_graffitti_vandal_provider,	
vendor_graffitti_vandal_contact = @vendor_graffitti_vandal_contact,	
vendor_graffitti_vandal_notes = @vendor_graffitti_vandal_notes,	
vendor_hvac_repair_provider = @vendor_hvac_repair_provider,	
vendor_hvac_repair_contact = @vendor_hvac_repair_contact,	
vendor_hvac_repair_notes = @vendor_hvac_repair_notes,	
vendor_handrail_provider = @vendor_handrail_provider,	
vendor_handrail_contact = @vendor_handrail_contact,	
vendor_handrail_notes = @vendor_handrail_notes,	
vendor_irrigation_provider = @vendor_irrigation_provider,	
vendor_irrigation_contact = @vendor_irrigation_contact,	
vendor_irrigation_notes = @vendor_irrigation_notes,	
vendor_janitorial_provider = @vendor_janitorial_provider,	
vendor_janitorial_contact = @vendor_janitorial_contact,	
vendor_janitorial_notes = @vendor_janitorial_notes,	
vendor_landscaping_provider = @vendor_landscaping_provider,	
vendor_landscaping_contact = @vendor_landscaping_contact,	
vendor_landscaping_notes = @vendor_landscaping_notes,	
vendor_locksmith_provider = @vendor_locksmith_provider,	
vendor_locksmith_contact = @vendor_locksmith_contact,	
vendor_locksmith_notes = @vendor_locksmith_notes,	
vendor_masonry_provider = @vendor_masonry_provider,
vendor_masonry_contact = @vendor_masonry_contact,
vendor_masonry_notes = @vendor_masonry_notes,	
vendor_oil_supply_provider = @vendor_oil_supply_provider,	
vendor_oil_supply_contact = @vendor_oil_supply_contact,	
vendor_oil_supply_notes = @vendor_oil_supply_notes,	
vendor_plot_light_repair_provider = @vendor_plot_light_repair_provider,	
vendor_plot_light_repair_contact = @vendor_plot_light_repair_contact,	
vendor_plot_light_repair_notes = @vendor_plot_light_repair_notes,	
vendor_plot_sweeping_provider = @vendor_plot_sweeping_provider,	
vendor_plot_sweeping_contact = @vendor_plot_sweeping_contact,	
vendor_plot_sweeping_notes = @vendor_plot_sweeping_notes,	
vendor_painting_provider = @vendor_painting_provider,	
vendor_painting_contact = @vendor_painting_contact,	
vendor_painting_notes = @vendor_painting_notes,	
vendor_payphone_provider = @vendor_payphone_provider,	
vendor_payphone_contact = @vendor_payphone_contact,	
vendor_payphone_notes = @vendor_payphone_notes,	
vendor_plumbing_provider = @vendor_plumbing_provider,	
vendor_plumbing_contact = @vendor_plumbing_contact,
vendor_plumbing_notes = @vendor_plumbing_notes,
vendor_retentionpond_provider = @vendor_retentionpond_provider,
vendor_retentionpond_contact = @vendor_retentionpond_contact,
vendor_retentionpond_notes = @vendor_retentionpond_notes,
vendor_roof_repair_provider = @vendor_roof_repair_provider,	
vendor_roof_repair_contact = @vendor_roof_repair_contact,	
vendor_roof_repair_notes = @vendor_roof_repair_notes,	
vendor_security_provider = @vendor_security_provider,	
vendor_security_contact = @vendor_security_contact,	
vendor_security_notes = @vendor_security_notes,
vendor_sewer_septic_drain_clearing_provider = @vendor_sewer_septic_drain_clearing_provider,	
vendor_sewer_septic_drain_clearing_contact = @vendor_sewer_septic_drain_clearing_contact,	
vendor_sewer_septic_drain_clearing_notes = @vendor_sewer_septic_drain_clearing_notes,	
vendor_sewer_septic_plumbing_provider = @vendor_sewer_septic_plumbing_provider,
vendor_sewer_septic_plumbing_contact = @vendor_sewer_septic_plumbing_contact,
vendor_sewer_septic_plumbing_notes = @vendor_sewer_septic_plumbing_notes,
vendor_sidewalk_provider = @vendor_sidewalk_provider,	
vendor_sidewalk_contact = @vendor_sidewalk_contact,	
vendor_sidewalk_notes = @vendor_sidewalk_notes,	
vendor_signage_provider = @vendor_signage_provider,	
vendor_signage_contact = @vendor_signage_contact,
vendor_signage_notes = @vendor_signage_notes,	
vendor_smoke_water_restore_provider = @vendor_smoke_water_restore_provider,
vendor_smoke_water_restore_contact = @vendor_smoke_water_restore_contact,
vendor_smoke_water_restore_notes = @vendor_smoke_water_restore_notes,
vendor_snow_removal_provider = @vendor_snow_removal_provider,	
vendor_snow_removal_contact = @vendor_snow_removal_contact,	
vendor_snow_removal_notes = @vendor_snow_removal_notes,	
vendor_towing_provider = @vendor_towing_provider,
vendor_towing_contact = @vendor_towing_contact,	
vendor_towing_notes = @vendor_towing_notes,	
vendor_trashremoval_provider = @vendor_trashremoval_provider,	
vendor_trashremoval_contact = @vendor_trashremoval_contact,	
vendor_trashremoval_notes = @vendor_trashremoval_notes,
vendor_flooring_provider = @vendor_flooring_provider,	
vendor_flooring_contact = @vendor_flooring_contact,	
vendor_flooring_notes = @vendor_flooring_notes
Where propertyid=@propertyid


END


GO
/****** Object:  StoredProcedure [dbo].[pUWorkOrder]    Script Date: 6/2/2016 5:16:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter Procedure [dbo].[pUWorkOrder]
@wonumber nvarchar(100),	
@propertyid nvarchar(100),	
@approvalstatus nvarchar(100),	
@worktobedone nvarchar(4000),	
@request_name nvarchar(100),	
@request_email nvarchar(100),	
@request_phone nvarchar(100),	
@workcompleted nvarchar(900),	
@DNEcost nvarchar(100),	
@UNIcost nvarchar(100),	
@UNIcontractor_cost nvarchar(100),	
@final_approval_username nvarchar(100),	
@date_estimatedcompletion nvarchar(100),	
@date_completion nvarchar(100),	
@UNI125percent nvarchar(100),	
@UNItax nvarchar(100),
@ServiseLog nvarchar(4000),
@LogDate DateTime,
@closedate nvarchar(100),
@UserID nvarchar(100),
@vendorid nvarchar(100),		
@poid nvarchar(50)
AS
BEGIN
IF  @ServiseLog IS NOT null AND @ServiseLog <> ''
	BEGIN
		Insert into ServiseLog (WOID,Serviselog,UserName,LogDate) Values (@wonumber,@ServiseLog,@UserID,@LogDate)
	END

	Select * from ServiseLog

Update workorders Set
	approvalstatus = @approvalstatus,	
	worktobedone = @worktobedone,	
	request_name = @request_name,	
	request_email = @request_email,	
	request_phone = @request_phone,	
	workcompleted = @workcompleted,	
	DNEcost = @DNEcost,	
	UNIcost = @UNIcost,	
	UNIcontractor_cost = @UNIcontractor_cost,	
	final_approval_username = @final_approval_username,	
	date_estimatedcompletion = @date_estimatedcompletion,	
	date_completion = @date_completion,	
	UNI125percent = @UNI125percent,	
	UNItax = @UNItax,
	dateperformed=@closedate,
	vendorid=@vendorid,
	POID=@poid 		
Where wonumber=@wonumber

Update workorders_cost Set unisource_cost=@UNIcost, customer_cost=@UNIcontractor_cost Where wonumber=@wonumber

END

GO

--Alter view [dbo].[vwMasterTable] as
--Select	p.propertyid,p.displayname as 'PropertyName',p.region,p.city,p.state,p.address1,p.address2,p.zip,propertymanager,
--        (Select count(wo.propertyid) from workorders wo where wo.propertyid = p.propertyid) as 'WorkOrder' ,
--		(Select count(snow.propertyid) from dailyreports snow where snow.propertyid = p.propertyid) as 'WorkRequst',
--		(Select count(inspection.propertyid) from reports01 inspection where inspection.propertyid = p.propertyid) as 'PropertyInspection',
--		(Select count(report.propertyid) from reports02 report where report.propertyid = p.propertyid) as 'SnowReport'			
--From properties p

ALTER view [dbo].[vwMasterTable] as
Select	p.propertyid,p.displayname as 'PropertyName',p.region,p.city,p.state,p.address1,p.address2,p.zip,propertymanager,
        (Select count(wo.propertyid) from workorders wo where wo.propertyid = p.propertyid AND wo.approvalstatus<>5) as 'WorkOrder' ,
		(Select count(snow.propertyid) from dailyreports snow where snow.propertyid = p.propertyid AND snow.approvalstatus<>5)  as 'WorkRequst',
		(Select count(inspection.propertyid) from reports01 inspection where inspection.propertyid = p.propertyid AND inspection.approvalstatus<>5) as 'PropertyInspection',
		(Select count(report.propertyid) from reports02 report where report.propertyid = p.propertyid AND report.approvalstatus<>5) as 'SnowReport'			
From properties p
GO
USE [sohail]
GO

/****** Object:  StoredProcedure [dbo].[InsertKPI]    Script Date: 15-08-2025 11:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- Create the updated procedure
ALTER PROCEDURE [dbo].[InsertKPI]
    @KPI_ID VARCHAR(100),
    @KPI_or_Standalone_Metric VARCHAR(100),
    @KPI_Name VARCHAR(50),
    @KPI_Short_Description VARCHAR(500),
    @KPI_Impact VARCHAR(500),
    @Numerator_Description VARCHAR(500),
    @Denominator_Description VARCHAR(500),
    @Unit VARCHAR(10),
    @Datasource VARCHAR(100),
    @OrderWithinSecton VARCHAR(10),
	@Objective_Subjective NVARCHAR(50),
    @Comments NVARCHAR(MAX),
    @Active VARCHAR(10),
    @FLAG_DIVISINAL VARCHAR(10),
    @FLAG_VENDOR VARCHAR(10),
    @FLAG_ENGAGEMENTID VARCHAR(10),
    @FLAG_CONTRACTID VARCHAR(10),
    @FLAG_COSTCENTRE VARCHAR(10),
    @FLAG_DEUBALvl4 VARCHAR(10),
    @FLAG_HRID VARCHAR(10),
    @FLAG_REQUESTID VARCHAR(10),
    -- Add parameters for the new columns
    @test1 VARCHAR(255) = NULL, -- Added parameter with default NULL
    @test2 VARCHAR(255) = NULL  -- Added parameter with default NULL
AS
BEGIN
    -- Prevent extra result sets from interfering with SELECT statements
    SET NOCOUNT ON;

    INSERT INTO KPITable 
    (
        [KPI ID],
        [KPI or Standalone Metric],
        [KPI Name],
        [KPI Short Description],
        [KPI Impact],
        [Numerator Description],
        [Denominator Description],
        [Unit],
        [Datasource],
        [OrderWithinSecton],
        [Active],
        [FLAG_DIVISINAL],
        [FLAG_VENDOR],
        [FLAG_ENGAGEMENTID],
        [FLAG_CONTRACTID],
        [FLAG_COSTCENTRE],
        [FLAG_DEUBALvl4],
        [FLAG_HRID],
        [FLAG_REQUESTID],
        -- Include the new columns in the INSERT list
        [test1],
        [test2],
		[Objective/Subjective],
        Comments
    )
    VALUES
    (
        @KPI_ID,
        @KPI_or_Standalone_Metric,
        @KPI_Name,
        @KPI_Short_Description,
        @KPI_Impact,
        @Numerator_Description,
        @Denominator_Description,
        @Unit,
        @Datasource,
        @OrderWithinSecton,
        @Active,
        @FLAG_DIVISINAL,
        @FLAG_VENDOR,
        @FLAG_ENGAGEMENTID,
        @FLAG_CONTRACTID,
        @FLAG_COSTCENTRE,
        @FLAG_DEUBALvl4,
        @FLAG_HRID,
        @FLAG_REQUESTID,
        -- Include the new parameter values in the VALUES list
        @test1,
        @test2,
		@Objective_Subjective,
        @Comments
    );
END;
GO



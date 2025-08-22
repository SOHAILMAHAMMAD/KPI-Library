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





Search Export as expected changes in store proc 

USE [sohail]
GO

ALTER PROCEDURE [dbo].[GetAllKPITable]
    @Status CHAR(1) = NULL,
    @SortColumn NVARCHAR(50) = NULL,
    @SortDirection NVARCHAR(4) = NULL,
    @Search NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Set default sort column
    IF @SortColumn IS NULL OR LTRIM(RTRIM(@SortColumn)) = ''
        SET @SortColumn = '[KPI or Standalone Metric]';

    -- Validate SortDirection
    IF @SortDirection IS NULL OR UPPER(LTRIM(RTRIM(@SortDirection))) NOT IN ('ASC', 'DESC')
        SET @SortDirection = 'ASC';

    DECLARE @sql NVARCHAR(MAX);

    -- Build dynamic SQL
    SET @sql = N'
    SELECT
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
        [Objective/Subjective],
        [Comments],
        [Active],
        [FLAG_DIVISINAL],
        [FLAG_VENDOR],
        [FLAG_ENGAGEMENTID],
        [FLAG_CONTRACTID],
        [FLAG_COSTCENTRE],
        [FLAG_DEUBALvl4],
        [FLAG_HRID],
        [FLAG_REQUESTID],
        [test1],
        [test2]
    FROM dbo.KPITable
    WHERE (@Status IS NULL OR Active = @Status)
      AND (@Search IS NULL 
           OR [KPI ID] LIKE ''%'' + @Search + ''%''
           OR [KPI Name] LIKE ''%'' + @Search + ''%''
           OR [KPI or Standalone Metric] LIKE ''%'' + @Search + ''%''
           OR [KPI Short Description] LIKE ''%'' + @Search + ''%'')
    ORDER BY ' + QUOTENAME(PARSENAME(@SortColumn, 1)) + ' ' + @SortDirection +
             CASE
                 WHEN REPLACE(REPLACE(@SortColumn, '[', ''), ']', '') <> 'OrderWithinSecton'
                 THEN ', [OrderWithinSecton] ASC'
                 ELSE ''
             END + ';';

    -- Execute dynamic SQL
    EXEC sp_executesql @sql,
        N'@Status CHAR(1), @SortColumn NVARCHAR(50), @SortDirection NVARCHAR(4), @Search NVARCHAR(100)',
        @Status, @SortColumn, @SortDirection, @Search;
END
GO


Update Store Proc 
USE [sohail]
GO

/****** Object:  StoredProcedure [dbo].[UpdateKPIByID]    Script Date: 16-08-2025 00:09:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- Alter the existing procedure to include test1 and test2
ALTER PROCEDURE [dbo].[UpdateKPIByID]
    @OriginalKPIID NVARCHAR(100), -- old value
    @KPI_ID NVARCHAR(100),        -- new value
    @KPI_or_Standalone_Metric NVARCHAR(255),
    @KPI_Name NVARCHAR(255),
    @KPI_Short_Description NVARCHAR(255),
    @KPI_Impact NVARCHAR(255),
    @Numerator_Description NVARCHAR(255),
    @Denominator_Description NVARCHAR(255),
    @Unit NVARCHAR(50),
    @Datasource NVARCHAR(255),
    @OrderWithinSecton INT,
    @Active CHAR(1),
    @FLAG_DIVISINAL CHAR(1),
    @FLAG_VENDOR CHAR(1),
    @FLAG_ENGAGEMENTID CHAR(1),
    @FLAG_CONTRACTID CHAR(1),
    @FLAG_COSTCENTRE CHAR(1),
    @FLAG_DEUBALvl4 CHAR(1),
    @FLAG_HRID CHAR(1),
    @FLAG_REQUESTID CHAR(1),
    -- Add parameters for the new columns
    @test1 NVARCHAR(255) = NULL, -- Added parameter with default NULL
    @test2 NVARCHAR(255) = NULL, -- Added parameter with default NULL
	@Objective_Subjective NVARCHAR(50) = NULL,
    @Comments NVARCHAR(MAX)
AS
BEGIN
    -- Prevent extra result sets from interfering with SELECT statements
    SET NOCOUNT ON;

    UPDATE KPITable
    SET 
        [KPI ID] = @KPI_ID,
        [KPI or Standalone Metric] = @KPI_or_Standalone_Metric,
        [KPI Name] = @KPI_Name,
        [KPI Short Description] = @KPI_Short_Description,
        [KPI Impact] = @KPI_Impact,
        [Numerator Description] = @Numerator_Description,
        [Denominator Description] = @Denominator_Description,
        [Unit] = @Unit,
        [Datasource] = @Datasource,
        [OrderWithinSecton] = @OrderWithinSecton,
        [Active] = @Active,
        [FLAG_DIVISINAL] = @FLAG_DIVISINAL,
        [FLAG_VENDOR] = @FLAG_VENDOR,
        [FLAG_ENGAGEMENTID] = @FLAG_ENGAGEMENTID,
        [FLAG_CONTRACTID] = @FLAG_CONTRACTID,
        [FLAG_COSTCENTRE] = @FLAG_COSTCENTRE,
        [FLAG_DEUBALvl4] = @FLAG_DEUBALvl4,
        [FLAG_HRID] = @FLAG_HRID,
        [FLAG_REQUESTID] = @FLAG_REQUESTID,
        -- Include the new columns in the SET clause
        [test1] = @test1,
        [test2] = @test2,
		[Objective/Subjective] = @Objective_Subjective,
        Comments = @Comments
    WHERE [KPI ID] = @OriginalKPIID;

END;
GO


function validateDuplicateMetricKPIName() {
    var metricEl = document.getElementById(METRIC_INPUT_ID);
    var kpiNameEl = document.getElementById(KPI_NAME_INPUT_ID);
    var kpiIdEl = document.getElementById(KPI_ID_INPUT_ID);

    var metricVal = metricEl ? metricEl.value.trim() : '';
    var kpiNameVal = kpiNameEl ? kpiNameEl.value.trim() : '';
    var kpiIdVal = kpiIdEl ? kpiIdEl.value.trim() : '';

    // If empty inputs, clear error immediately
    if (!metricVal || !kpiNameVal) {
        showFieldError(DUPLICATE_NAME_LABEL_ID, KPI_NAME_INPUT_ID, '');
        return;
    }

    var payload = JSON.stringify({
        fieldType: "KPI_Name_Metric",
        value1: kpiNameVal,
        value2: metricVal,
        originalKpiId: kpiIdVal // to exclude current KPI during edit if needed
    });

        fetch('<%= ResolveUrl("Default.aspx/ValidateKPIField") %>', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=utf-8' },
            body: payload,
            credentials: 'same-origin'
        })
            .then(function (response) { return response.json(); })
            .then(function (data) {
                var errorMessage = data && data.d ? data.d : '';
                if (errorMessage) {
                    showFieldError(DUPLICATE_NAME_LABEL_ID, KPI_NAME_INPUT_ID, errorMessage);
                } else {
                    showFieldError(DUPLICATE_NAME_LABEL_ID, KPI_NAME_INPUT_ID, '');
                }
            })
            .catch(function () {
                showFieldError(DUPLICATE_NAME_LABEL_ID, KPI_NAME_INPUT_ID, '');
            });
    }

    // Attach event listeners on DOM ready - like order validation
    document.addEventListener('DOMContentLoaded', function () {
        var metricEl = document.getElementById(METRIC_INPUT_ID);
        var kpiNameEl = document.getElementById(KPI_NAME_INPUT_ID);

        if (metricEl) {
            metricEl.addEventListener('blur', validateDuplicateMetricKPIName);
            metricEl.addEventListener('change', validateDuplicateMetricKPIName);
        }
        if (kpiNameEl) {
            kpiNameEl.addEventListener('blur', validateDuplicateMetricKPIName);
            kpiNameEl.addEventListener('change', validateDuplicateMetricKPIName);
            kpiNameEl.addEventListener('keyup', function (e) {
                if (e.key === 'Enter') return;
                clearTimeout(kpiNameEl.__t);
                kpiNameEl.__t = setTimeout(validateDuplicateMetricKPIName, 300);
            });
        }
    });

<WebMethod()>
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
Public Shared Function ValidateKPIField(fieldType As String, value1 As String, value2 As String) As String
    ' value2 is optional, used for metric/name checks
    Try
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("MyDatabase").ConnectionString)
            conn.Open()
            Select Case fieldType
                Case "KPI_ID"
                    Using cmd As New SqlCommand("SELECT COUNT(*) FROM KPITable WHERE [KPI ID] = @KPI_ID", conn)
                        cmd.Parameters.AddWithValue("@KPI_ID", value1.Trim())
                        If Convert.ToInt32(cmd.ExecuteScalar()) > 0 Then
                            Return "Duplicate KPI ID not allowed."
                        End If
                    End Using
                Case "KPI_Name_Metric"
                    Using cmd As New SqlCommand("SELECT COUNT(*) FROM KPITable WHERE [KPI Name] = @KPIName AND [KPI or Standalone Metric] = @Metric", conn)
                        cmd.Parameters.AddWithValue("@KPIName", value1.Trim())
                        cmd.Parameters.AddWithValue("@Metric", value2.Trim())
                        If Convert.ToInt32(cmd.ExecuteScalar()) > 0 Then
                            Return "Duplicate KPI Name for this Metric is not allowed."
                        End If
                    End Using
                Case "Order_Metric"
                    Dim orderNum As Integer
                    If Not Integer.TryParse(value1, orderNum) OrElse orderNum < 1 OrElse orderNum > 999 Then
                        Return "Order must be a number between 1 and 999."
                    End If
                    Using cmd As New SqlCommand("SELECT COUNT(*) FROM KPITable WHERE OrderWithinSecton = @Order AND [KPI or Standalone Metric] = @Metric", conn)
                        cmd.Parameters.AddWithValue("@Order", orderNum)
                        cmd.Parameters.AddWithValue("@Metric", value2.Trim())
                        If Convert.ToInt32(cmd.ExecuteScalar()) > 0 Then
                            Return "Duplicate Order for this Metric is not allowed."
                        End If
                    End Using
            End Select
        End Using
        Return "" ' No error
    Catch ex As Exception
        Return "Error: " & ex.Message
    End Try
End Function


<div style=" text-align:left;margin-bottom: 10px;">
<!-- Export Button -->
<button type="button" id="btnExportCSV" onclick="exportTableToCSV('KPIs_<%= DateTime.Now.ToString("yyyyMMdd_HHmmss") %>.csv')" class="btn-add" style="margin-right: 10px;">Export to CSV</button>
        </div>

// Client-Side CSV Export Function
 function exportTableToCSV(filename) {
     var csv = [];
     var table = document.getElementById('<%= GridView1.ClientID %>'); // Get the GridView table

     if (!table) {
         alert("Could not find the data table to export.");
         console.error("Table element not found for export.");
         return;
     }

     // Get all rows in the table (including header)
     var rows = table.querySelectorAll("tr");
     for (var i = 0; i < rows.length; i++) {
         var row = [], cols = rows[i].querySelectorAll("td, th"); // Get cells (data & header)
         for (var j = 1; j < cols.length; j++) {
             // Get cell text and clean it for CSV
             let cellData = cols[j].innerText !== undefined ? cols[j].innerText : cols[j].textContent;

             // Remove sorting arrows ▲ ▼
             cellData = cellData.replace(/[▲▼]/g, '').trim();

             // Escape double quotes by doubling them
             cellData = cellData.replace(/"/g, '""');

             // If data contains comma, newline, or quote, enclose it in double quotes
             if (cellData.indexOf(',') >= 0 || cellData.indexOf('\n') >= 0 || cellData.indexOf('"') >= 0) {
                 cellData = '"' + cellData + '"';
             }

             row.push(cellData);
         }
         csv.push(row.join(",")); // Join cells with comma
     }

     // Create CSV string
     var csvString = csv.join("\n");

     // Add UTF-8 BOM for better Excel compatibility
     var BOM = "\uFEFF";

     // Create a Blob and trigger download
     var blob = new Blob([BOM + csvString], { type: 'text/csv;charset=utf-8;' });
     if (navigator.msSaveBlob) { // For IE
         navigator.msSaveBlob(blob, filename);
     } else {
         var link = document.createElement("a");
         if (link.download !== undefined) { // Feature detection
             // Create a link and trigger download
             var url = URL.createObjectURL(blob);
             link.setAttribute("href", url);
             link.setAttribute("download", filename);
             link.style.visibility = 'hidden';
             document.body.appendChild(link);
             link.click();
             document.body.removeChild(link);
         } else {
             // Fallback: Open in new window (less ideal)
             alert("Your browser might not support direct downloads. The CSV data will open in a new tab. Please copy and save it.");
             window.open(URL.createObjectURL(blob));
         }
     }
 }


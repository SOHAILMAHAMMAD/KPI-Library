Imports System.Data.SqlClient
Imports System.Web.Script.Services
Imports System.Web.Services
Imports System.Security.Permissions
Imports System.Text.RegularExpressions



Public Class _Default
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            chkShowActive.Checked = True
            SqlDataSource1.SelectParameters("Status").DefaultValue = "Y"
            toggleLabel.InnerText = "Active KPI's:"
            SortColumn = "KPI or Standalone Metric"
            SortDirection = "ASC"
            SqlDataSource1.SelectParameters("SortColumn").DefaultValue = SortColumn
            SqlDataSource1.SelectParameters("SortDirection").DefaultValue = SortDirection
            ' Ensure the GridView is bound to the SqlDataSource
            GridView1.DataBind()

        End If
    End Sub

    Private Property SortColumn As String
        Get
            Return If(ViewState("SortColumn"), "KPI or Standalone Metric")
        End Get
        Set(value As String)
            ViewState("SortColumn") = value
        End Set
    End Property

    Private Property SortDirection As String
        Get
            Return If(ViewState("SortDirection"), "ASC")
        End Get
        Set(value As String)
            ViewState("SortDirection") = value
        End Set
    End Property

    Protected Sub chkShowActive_CheckedChanged(sender As Object, e As EventArgs)
        If chkShowActive.Checked Then
            SqlDataSource1.SelectParameters("Status").DefaultValue = "Y"
            toggleLabel.InnerText = "Active KPI's:"
        Else
            SqlDataSource1.SelectParameters("Status").DefaultValue = "N"
            toggleLabel.InnerText = "Inactive KPI's:"
        End If
        GridView1.DataBind()
    End Sub



    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Dim originalKPIID As String = hfKPIID.Value.Trim()
        Dim orderValue As Integer = 0
        Dim valid As Boolean = True

        ' Clean and normalize inputs
        Dim kpiID As String = CleanInput(txtKPIID.Text)
        Dim metric As String = CleanInput(txtMetric.Text)
        Dim kpiName As String = CleanInput(txtKPIName.Text)
        Dim shortDesc As String = CleanInput(txtShortDesc.Text)
        Dim impact As String = CleanInput(txtImpact.Text)
        Dim numerator As String = CleanInput(txtNumerator.Text)
        Dim denom As String = CleanInput(txtDenom.Text)
        Dim unit As String = CleanInput(txtUnit.Text)
        Dim datasource As String = CleanInput(txtDatasource.Text)
        Dim orderText As String = CleanInput(txtOrder.Text)
        Dim test1Value As String = CleanInput(txtTest1.Text)
        Dim test2Value As String = CleanInput(txtTest2.Text)

        ' Reset all error labels
        lblKPIError.Visible = False
        lblOrderError.Visible = False
        lblDuplicateMetricKPIError.Visible = False

        ' Basic field validation
        If String.IsNullOrWhiteSpace(kpiID) OrElse String.IsNullOrWhiteSpace(metric) OrElse
           String.IsNullOrWhiteSpace(kpiName) OrElse String.IsNullOrWhiteSpace(shortDesc) OrElse
           String.IsNullOrWhiteSpace(impact) OrElse String.IsNullOrWhiteSpace(numerator) OrElse
           String.IsNullOrWhiteSpace(denom) OrElse String.IsNullOrWhiteSpace(unit) OrElse
           String.IsNullOrWhiteSpace(datasource) OrElse String.IsNullOrWhiteSpace(orderText) Then

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal_" & Guid.NewGuid().ToString(), "showPopup();", True)
            Return
        End If

        ' Order Validation
        If Not Integer.TryParse(orderText, orderValue) OrElse orderValue < 1 OrElse orderValue > 999 Then
            lblOrderError.Text = "Order must be between 1 and 999."
            lblOrderError.Visible = True
            valid = False
        Else
            ' Check for duplicate order within same metric
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("MyDatabase").ConnectionString)
                conn.Open()
                Using cmd As New SqlCommand("
                    SELECT COUNT(*) FROM KPITable 
                    WHERE [KPI or Standalone Metric] = @Metric 
                      AND OrderWithinSecton = @Order 
                      AND [KPI ID] <> @OriginalKPIID", conn)
                    cmd.Parameters.AddWithValue("@Metric", metric)
                    cmd.Parameters.AddWithValue("@Order", orderValue)
                    cmd.Parameters.AddWithValue("@OriginalKPIID", originalKPIID)
                    Dim count = Convert.ToInt32(cmd.ExecuteScalar())
                    If count > 0 Then
                        lblOrderError.Text = "No duplicate order allowed for same metric."
                        lblOrderError.Visible = True
                        valid = False
                    End If
                End Using
            End Using
        End If

        ' KPI ID uniqueness validation (if new or modified)
        If hfIsEdit.Value <> "true" OrElse kpiID <> originalKPIID Then
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("MyDatabase").ConnectionString)
                conn.Open()
                Using cmd As New SqlCommand("SELECT COUNT(*) FROM KPITable WHERE [KPI ID] = @KPI_ID", conn)
                    cmd.Parameters.AddWithValue("@KPI_ID", kpiID)
                    Dim count = Convert.ToInt32(cmd.ExecuteScalar())
                    If count > 0 Then
                        lblKPIError.Visible = True
                        lblKPIError.Text = "KPI ID already exists"
                        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowKPIError_" & Guid.NewGuid().ToString(),
                            "showKPIError('KPI ID already exists');", True)
                        System.Diagnostics.Debug.WriteLine("KPI ID validation failed: " & kpiID)
                        valid = False
                    End If
                End Using
            End Using
        End If

        ' KPI Name uniqueness per metric
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("MyDatabase").ConnectionString)
            conn.Open()
            Using cmd As New SqlCommand("
                SELECT COUNT(*) FROM KPITable 
                WHERE [KPI or Standalone Metric] = @Metric 
                  AND [KPI Name] = @KPIName 
                  AND [KPI ID] <> @OriginalKPIID", conn)
                cmd.Parameters.AddWithValue("@Metric", metric)
                cmd.Parameters.AddWithValue("@KPIName", kpiName)
                cmd.Parameters.AddWithValue("@OriginalKPIID", originalKPIID)
                Dim count = Convert.ToInt32(cmd.ExecuteScalar())
                If count > 0 Then
                    lblDuplicateMetricKPIError.Text = "No duplicate names should be given to a single metric."
                    lblDuplicateMetricKPIError.Visible = True
                    valid = False
                End If
            End Using
        End Using

        ' If validation failed, show modal and return
        If Not valid Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal_" & Guid.NewGuid().ToString(), "showPopup();", True)
            Return
        End If

        ' If we reach here, validation passed - proceed with save
        Try
            If hfIsEdit.Value = "true" Then
                ' Update existing record
                SqlDataSource1.UpdateParameters("OriginalKPIID").DefaultValue = originalKPIID
                SqlDataSource1.UpdateParameters("KPI_ID").DefaultValue = kpiID
                SqlDataSource1.UpdateParameters("KPI_or_Standalone_Metric").DefaultValue = metric
                SqlDataSource1.UpdateParameters("KPI_Name").DefaultValue = kpiName
                SqlDataSource1.UpdateParameters("KPI_Short_Description").DefaultValue = shortDesc
                SqlDataSource1.UpdateParameters("KPI_Impact").DefaultValue = impact
                SqlDataSource1.UpdateParameters("Numerator_Description").DefaultValue = numerator
                SqlDataSource1.UpdateParameters("Denominator_Description").DefaultValue = denom
                SqlDataSource1.UpdateParameters("Unit").DefaultValue = unit
                SqlDataSource1.UpdateParameters("Datasource").DefaultValue = datasource
                SqlDataSource1.UpdateParameters("OrderWithinSecton").DefaultValue = orderValue.ToString()
                SqlDataSource1.UpdateParameters("test1").DefaultValue = test1Value
                SqlDataSource1.UpdateParameters("test2").DefaultValue = test2Value
                SqlDataSource1.UpdateParameters("Active").DefaultValue = If(chkActive.Checked, "Y", "N")
                SqlDataSource1.UpdateParameters("FLAG_DIVISINAL").DefaultValue = If(chkFlagDivisinal.Checked, "Y", "N")
                SqlDataSource1.UpdateParameters("FLAG_VENDOR").DefaultValue = If(chkFlagVendor.Checked, "Y", "N")
                SqlDataSource1.UpdateParameters("FLAG_ENGAGEMENTID").DefaultValue = If(chkFlagEngagement.Checked, "Y", "N")
                SqlDataSource1.UpdateParameters("FLAG_CONTRACTID").DefaultValue = If(chkFlagContract.Checked, "Y", "N")
                SqlDataSource1.UpdateParameters("FLAG_COSTCENTRE").DefaultValue = If(chkFlagCostcentre.Checked, "Y", "N")
                SqlDataSource1.UpdateParameters("FLAG_DEUBALvl4").DefaultValue = If(chkFlagDeuballvl4.Checked, "Y", "N")
                SqlDataSource1.UpdateParameters("FLAG_HRID").DefaultValue = If(chkFlagHRID.Checked, "Y", "N")
                SqlDataSource1.UpdateParameters("FLAG_REQUESTID").DefaultValue = If(chkFlagRequest.Checked, "Y", "N")
                SqlDataSource1.Update()
            Else
                ' Insert new record
                SqlDataSource1.InsertParameters("KPI_ID").DefaultValue = kpiID
                SqlDataSource1.InsertParameters("KPI_or_Standalone_Metric").DefaultValue = metric
                SqlDataSource1.InsertParameters("KPI_Name").DefaultValue = kpiName
                SqlDataSource1.InsertParameters("KPI_Short_Description").DefaultValue = shortDesc
                SqlDataSource1.InsertParameters("KPI_Impact").DefaultValue = impact
                SqlDataSource1.InsertParameters("Numerator_Description").DefaultValue = numerator
                SqlDataSource1.InsertParameters("Denominator_Description").DefaultValue = denom
                SqlDataSource1.InsertParameters("Unit").DefaultValue = unit
                SqlDataSource1.InsertParameters("Datasource").DefaultValue = datasource
                SqlDataSource1.InsertParameters("OrderWithinSecton").DefaultValue = orderValue.ToString()
                SqlDataSource1.InsertParameters("test1").DefaultValue = test1Value
                SqlDataSource1.InsertParameters("test2").DefaultValue = test2Value
                SqlDataSource1.InsertParameters("Active").DefaultValue = If(chkActive.Checked, "Y", "N")
                SqlDataSource1.InsertParameters("FLAG_DIVISINAL").DefaultValue = If(chkFlagDivisinal.Checked, "Y", "N")
                SqlDataSource1.InsertParameters("FLAG_VENDOR").DefaultValue = If(chkFlagVendor.Checked, "Y", "N")
                SqlDataSource1.InsertParameters("FLAG_ENGAGEMENTID").DefaultValue = If(chkFlagEngagement.Checked, "Y", "N")
                SqlDataSource1.InsertParameters("FLAG_CONTRACTID").DefaultValue = If(chkFlagContract.Checked, "Y", "N")
                SqlDataSource1.InsertParameters("FLAG_COSTCENTRE").DefaultValue = If(chkFlagCostcentre.Checked, "Y", "N")
                SqlDataSource1.InsertParameters("FLAG_DEUBALvl4").DefaultValue = If(chkFlagDeuballvl4.Checked, "Y", "N")
                SqlDataSource1.InsertParameters("FLAG_HRID").DefaultValue = If(chkFlagHRID.Checked, "Y", "N")
                SqlDataSource1.InsertParameters("FLAG_REQUESTID").DefaultValue = If(chkFlagRequest.Checked, "Y", "N")
                SqlDataSource1.Insert()
            End If

            ' Success - clear form and refresh grid
            ClearForm()
            GridView1.DataBind()

            Dim message As String = If(hfIsEdit.Value = "true", "Updated Successfully!", " Updated Successfully!")
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowSuccess", $"alert('{message}');", True)
        Catch ex As Exception
            ' Handle any database errors
            System.Diagnostics.Debug.WriteLine("Error saving KPI: " & ex.Message & " StackTrace: " & ex.StackTrace)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModalError_" & Guid.NewGuid().ToString(),
                "showPopup(); alert('Error saving KPI: " & ex.Message.Replace("'", "\'") & "');", True)
        End Try
    End Sub

    Private Function CleanInput(text As String) As String
        If String.IsNullOrWhiteSpace(text) Then Return ""
        Return Regex.Replace(text.Trim(), "\s{2,}", " ")
    End Function

    Protected Sub GridView1_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "EditKPI" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            LoadEditData(index)
        ElseIf e.CommandName = "CustomSort" Then
            Dim args = e.CommandArgument.ToString().Split("|"c)
            If args.Length = 2 Then
                SortColumn = args(0)
                SortDirection = args(1)
                SqlDataSource1.SelectParameters("SortColumn").DefaultValue = SortColumn
                SqlDataSource1.SelectParameters("SortDirection").DefaultValue = SortDirection
                GridView1.DataBind()
            End If
        End If
    End Sub

    Private Sub LoadEditData(rowIndex As Integer)
        Dim row As GridViewRow = GridView1.Rows(rowIndex)
        Dim kpiId As String = row.Cells(1).Text.Trim()

        hfIsEdit.Value = "true"
        hfKPIID.Value = kpiId
        lblFormTitle.Text = "Edit KPI"
        txtKPIID.Text = kpiId
        txtKPIID.Enabled = True

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("MyDatabase").ConnectionString)
            conn.Open()
            Using cmd As New SqlCommand("SELECT * FROM KPITable WHERE [KPI ID] = @KPI_ID", conn)
                cmd.Parameters.AddWithValue("@KPI_ID", kpiId)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtMetric.Text = reader("KPI or Standalone Metric").ToString()
                        txtKPIName.Text = reader("KPI Name").ToString()
                        txtShortDesc.Text = reader("KPI Short Description").ToString()
                        txtImpact.Text = reader("KPI Impact").ToString()
                        txtNumerator.Text = reader("Numerator Description").ToString()
                        txtDenom.Text = reader("Denominator Description").ToString()
                        txtUnit.Text = reader("Unit").ToString()
                        txtDatasource.Text = reader("Datasource").ToString()
                        txtOrder.Text = reader("OrderWithinSecton").ToString()
                        txtTest1.Text = reader("Test1").ToString()
                        txtTest2.Text = reader("Test2").ToString()
                        chkActive.Checked = reader("Active").ToString().ToUpper() = "Y"
                        chkFlagDivisinal.Checked = reader("FLAG_DIVISINAL").ToString().ToUpper() = "Y"
                        chkFlagVendor.Checked = reader("FLAG_VENDOR").ToString().ToUpper() = "Y"
                        chkFlagEngagement.Checked = reader("FLAG_ENGAGEMENTID").ToString().ToUpper() = "Y"
                        chkFlagContract.Checked = reader("FLAG_CONTRACTID").ToString().ToUpper() = "Y"
                        chkFlagCostcentre.Checked = reader("FLAG_COSTCENTRE").ToString().ToUpper() = "Y"
                        chkFlagDeuballvl4.Checked = reader("FLAG_DEUBALvl4").ToString().ToUpper() = "Y"
                        chkFlagHRID.Checked = reader("FLAG_HRID").ToString().ToUpper() = "Y"
                        chkFlagRequest.Checked = reader("FLAG_REQUESTID").ToString().ToUpper() = "Y"
                    End If
                End Using
            End Using
        End Using

        ' Hide error labels when loading edit data
        lblKPIError.Visible = False
        lblOrderError.Visible = False
        lblDuplicateMetricKPIError.Visible = False

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal_" & Guid.NewGuid().ToString(), "showPopup(); hideKPIError();", True)
    End Sub

    Private Sub ClearForm()
        hfIsEdit.Value = "false"
        hfKPIID.Value = ""
        lblFormTitle.Text = "Add KPI"
        txtKPIID.Text = ""
        txtMetric.Text = ""
        txtKPIName.Text = ""
        txtShortDesc.Text = ""
        txtImpact.Text = ""
        txtNumerator.Text = ""
        txtDenom.Text = ""
        txtUnit.Text = ""
        txtDatasource.Text = ""
        txtOrder.Text = ""
        txtTest1.Text = ""
        txtTest2.Text = ""
        txtKPIID.Enabled = True

        chkActive.Checked = False
        chkFlagDivisinal.Checked = False
        chkFlagVendor.Checked = False
        chkFlagEngagement.Checked = False
        chkFlagContract.Checked = False
        chkFlagCostcentre.Checked = False
        chkFlagDeuballvl4.Checked = False
        chkFlagHRID.Checked = False
        chkFlagRequest.Checked = False

        ' Hide all error labels
        lblKPIError.Visible = False
        lblOrderError.Visible = False
        lblDuplicateMetricKPIError.Visible = False
    End Sub

    Protected Sub btnAddKPI_Click(sender As Object, e As EventArgs)
        ClearForm()
        lblFormTitle.Text = "Add KPI"
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal_" & Guid.NewGuid().ToString(), "showPopup(); hideKPIError();", True)
    End Sub

    <WebMethod(EnableSession:=False)>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function CheckKPIExists(kpiID As String) As Boolean
        Try
            ' Clean the input
            If String.IsNullOrWhiteSpace(kpiID) Then
                System.Diagnostics.Debug.WriteLine("CheckKPIExists: Empty or null KPI ID")
                Return False
            End If

            kpiID = kpiID.Trim()
            System.Diagnostics.Debug.WriteLine("CheckKPIExists: Checking KPI ID: " & kpiID)

            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("MyDatabase").ConnectionString)
                Using cmd As New SqlCommand("SELECT COUNT(*) FROM KPITable WHERE [KPI ID] = @KPI_ID", conn)
                    cmd.Parameters.AddWithValue("@KPI_ID", kpiID)
                    conn.Open()
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    System.Diagnostics.Debug.WriteLine("CheckKPIExists: Result for " & kpiID & ": " & (count > 0))
                    Return count > 0
                End Using
            End Using
        Catch ex As Exception
            ' Log detailed error information
            System.Diagnostics.Debug.WriteLine("CheckKPIExists Error: " & ex.Message & " StackTrace: " & ex.StackTrace)
            Return False ' Allow server-side validation to handle
        End Try
    End Function

    Protected Sub GridView1_RowCreated(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowCreated
        If e.Row.RowType = DataControlRowType.Header Then
            For i As Integer = 0 To GridView1.Columns.Count - 1
                Dim tf = TryCast(GridView1.Columns(i), TemplateField)
                If tf IsNot Nothing AndAlso Not String.IsNullOrEmpty(tf.SortExpression) Then
                    Dim cell = e.Row.Cells(i)
                    Dim lblSort As Label = Nothing
                    Select Case tf.SortExpression
                        Case "KPI or Standalone Metric"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortMetric"), Label)
                        Case "KPI Name"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortKPIName"), Label)
                        Case "KPI ID"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortKPIID"), Label)
                        Case "KPI Short Description"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortShortDesc"), Label)
                        Case "KPI Impact"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortImpact"), Label)
                        Case "Numerator Description"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortNum"), Label)
                        Case "Denominator Description"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortDen"), Label)
                        Case "Unit"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortUnit"), Label)
                        Case "Datasource"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortDS"), Label)
                        Case "OrderWithinSecton"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortOrder"), Label)
                        Case "Active"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortActive"), Label)
                        Case "FLAG_DIVISINAL"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortDiv"), Label)
                        Case "FLAG_VENDOR"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortVendor"), Label)
                        Case "FLAG_ENGAGEMENTID"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortEng"), Label)
                        Case "FLAG_CONTRACTID"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortContract"), Label)
                        Case "FLAG_COSTCENTRE"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortCC"), Label)
                        Case "FLAG_DEUBALvl4"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortLvl4"), Label)
                        Case "FLAG_HRID"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortHRID"), Label)
                        Case "FLAG_REQUESTID"
                            lblSort = TryCast(cell.FindControl("lblCurrentSortReq"), Label)
                    End Select
                    If lblSort IsNot Nothing AndAlso tf.SortExpression = SortColumn Then
                        lblSort.Text = If(SortDirection = "DESC", "▲", "▼")
                    ElseIf lblSort IsNot Nothing Then
                        lblSort.Text = ""
                    End If
                End If
            Next
        End If
    End Sub



End Class

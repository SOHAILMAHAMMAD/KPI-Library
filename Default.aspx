<%@ Page Title="Home Page" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="KPILibrary._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

   <style>
        .modal {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            width: 800px;
            height: 500px;
            overflow-y: auto;
            background-color: #fff;
            transform: translate(-50%, -50%);
            border-radius: 12px;
            padding: 20px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            z-index: 1000;
        }
        .close-btn { float: right; font-size: 20px; font-weight: bold; cursor: pointer; }
        .error-span { color: red; font-size: 12px; margin-left: 10px; }
        .toggle-switch { position: relative; display: inline-block; width: 40px; height: 20px; }
        .toggle-switch input { opacity: 0; width: 0; height: 0; }
        .slider {
            position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0;
            background-color: #ccc; transition: .4s; border-radius: 20px;
        }
        .toggle-switch input:checked + .slider { background-color: #2196F3; }
        .slider:before {
            position: absolute; content: ""; height: 16px; width: 16px; left: 2px; bottom: 2px;
            background-color: white; transition: .4s; border-radius: 50%;
        }
        .toggle-switch input:checked + .slider:before { transform: translateX(20px); }
        .btn-add, .btn-edit { padding: 6px 12px; border: none; border-radius: 4px; color: white; cursor: pointer; }
        .btn-add { background-color: #4CAF50; }
        .btn-edit { background-color: #2196F3; }
        table { width: 100%; border-collapse: collapse; }
        table td, table th { padding: 8px; border: 1px solid #ccc; }
        .grid-style { border-collapse: collapse; width: 100%; }
        .grid-style td, .grid-style th { border: 1px solid #ddd; padding: 8px; }
        .grid-style th { background-color: #f2f2f2; }
        .modal input[type="text"], .modal textarea {
            width: 520px; max-width: none !important; box-sizing: border-box;
        }
    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        function showPopup() {
            document.getElementById('kpiModal').style.display = 'block'; 
        }
        function hidePopup() {
            document.getElementById('kpiModal').style.display = 'none';
        }

        function checkKPIID() {
            var kpiID = document.getElementById('<%= txtKPIID.ClientID %>').value;
            kpiID = kpiID.replace(/\s{2,}/g, ' ').trim(); // Normalize spaces
            document.getElementById('<%= txtKPIID.ClientID %>').value = kpiID; // Update textbox

            if (kpiID === "") return;

            $.ajax({
                type: "POST",
                url: "Default.aspx/CheckKPIExists",
                data: JSON.stringify({ kpiID: kpiID }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                xhrFields: {
                    withCredentials: true
                },
                success: function (response) {
                    var exists = response.d;
                    var lbl = document.getElementById("lblKPIError"); // Hardcoded ID for dynamic label

                    // If label doesn't exist and we need to show message, create it
                    if (exists && !lbl) {
                        lbl = document.createElement("label");
                        lbl.id = "lblKPIError";
                        lbl.textContent = "KPI ID already exists.";
                        lbl.style.color = "red";
                        lbl.style.fontSize = "12px";
                        lbl.style.display = "block";

                        // Insert after the input field
                        var inputField = document.getElementById('<%= txtKPIID.ClientID %>');
                         if (inputField) {
                             inputField.parentNode.insertBefore(lbl, inputField.nextSibling);
                         } else {
                             document.body.appendChild(lbl); // fallback
                         }
                     }

                     // Show or hide the label based on result
                     if (exists && lbl) {
                         lbl.style.display = "block";
                     } else if (lbl) {
                         lbl.style.display = "none";
                     }
                 },
                 error: function (xhr, status, error) {
                     console.log("AJAX error: ", xhr.status, error);
                 }
             });
        }

                

    </script>

    <div id="kpiModal" class="modal">


        <span class="close-btn" onclick="hidePopup()">&times;</span>
        <h3><asp:Label ID="lblFormTitle" runat="server" Text="Add KPI" /></h3>

        <table>
            <tr><td>KPI ID:</td><td><asp:TextBox ID="txtKPIID" runat="server" onkeyup="checkKPIID()" /><asp:Label ID="lblKPIError" runat="server" CssClass="error-span" Visible="False" Text="KPI ID already exists"  /></td></tr>
            <tr><td>Order:</td><td><asp:TextBox ID="txtOrder" runat="server" /><asp:Label ID="lblOrderError" runat="server" CssClass="error-span" Visible="False" Text="Please add numbers between 1–999" /></td></tr>
            <tr><td>Metric:</td><td><asp:TextBox ID="txtMetric" runat="server" /></td></tr>
            <tr><td>Name:</td><td><asp:TextBox ID="txtKPIName" runat="server" /><asp:Label ID="lblDuplicateMetricKPIError" runat="server" CssClass="error-span" Visible="False" /></td></tr>
            

            <tr><td>Short Desc:</td><td><asp:TextBox ID="txtShortDesc" runat="server" TextMode="MultiLine" Rows="3" /></td></tr>
            <tr><td>Impact:</td><td><asp:TextBox ID="txtImpact" runat="server" TextMode="MultiLine" Rows="3" /></td></tr>
            <tr><td>Numerator:</td><td><asp:TextBox ID="txtNumerator" runat="server" TextMode="MultiLine" Rows="3" /></td></tr>
            <tr><td>Denominator:</td><td><asp:TextBox ID="txtDenom" runat="server" TextMode="MultiLine" Rows="3" /></td></tr>
            <tr><td>Unit:</td><td><asp:TextBox ID="txtUnit" runat="server" /></td></tr>
            <tr><td>Datasource:</td><td><asp:TextBox ID="txtDatasource" runat="server" /></td></tr>
            <tr><td>Active:</td><td><label class="toggle-switch"><asp:CheckBox ID="chkActive" runat="server" /><span class="slider"></span></label></td></tr>
            <tr><td>FLAG_DIVISINAL:</td><td><label class="toggle-switch"><asp:CheckBox ID="chkFlagDivisinal" runat="server" /><span class="slider"></span></label></td></tr>
            <tr><td>FLAG_VENDOR:</td><td><label class="toggle-switch"><asp:CheckBox ID="chkFlagVendor" runat="server" /><span class="slider"></span></label></td></tr>
            <tr><td>FLAG_ENGAGEMENTID:</td><td><label class="toggle-switch"><asp:CheckBox ID="chkFlagEngagement" runat="server" /><span class="slider"></span></label></td></tr>
            <tr><td>FLAG_CONTRACTID:</td><td><label class="toggle-switch"><asp:CheckBox ID="chkFlagContract" runat="server" /><span class="slider"></span></label></td></tr>
            <tr><td>FLAG_COSTCENTRE:</td><td><label class="toggle-switch"><asp:CheckBox ID="chkFlagCostcentre" runat="server" /><span class="slider"></span></label></td></tr>
            <tr><td>FLAG_DEUBALvl4:</td><td><label class="toggle-switch"><asp:CheckBox ID="chkFlagDeuballvl4" runat="server" /><span class="slider"></span></label></td></tr>
            <tr><td>FLAG_HRID:</td><td><label class="toggle-switch"><asp:CheckBox ID="chkFlagHRID" runat="server" /><span class="slider"></span></label></td></tr>
            <tr><td>FLAG_REQUESTID:</td><td><label class="toggle-switch"><asp:CheckBox ID="chkFlagRequest" runat="server" /><span class="slider"></span></label></td></tr>
            <tr><td colspan="2" style="text-align:center;"><asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" CssClass="btn-add" /></td></tr>
        </table>
        <asp:HiddenField ID="hfIsEdit" runat="server" />
        <asp:HiddenField ID="hfKPIID" runat="server" />
    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:MyDatabase %>"
        SelectCommand="dbo.GetAllKPITable"
        SelectCommandType="StoredProcedure"
        InsertCommand="dbo.InsertKPI"
        InsertCommandType="StoredProcedure"
        UpdateCommand="dbo.UpdateKPIByID"
        UpdateCommandType="StoredProcedure">
        <InsertParameters>
            <asp:Parameter Name="KPI_ID" />
            <asp:Parameter Name="KPI_or_Standalone_Metric" />
            <asp:Parameter Name="KPI_Name" />
            <asp:Parameter Name="KPI_Short_Description" />
            <asp:Parameter Name="KPI_Impact" />
            <asp:Parameter Name="Numerator_Description" />
            <asp:Parameter Name="Denominator_Description" />
            <asp:Parameter Name="Unit" />
            <asp:Parameter Name="Datasource" />
            <asp:Parameter Name="OrderWithinSecton" />
            <asp:Parameter Name="Active" />
            <asp:Parameter Name="FLAG_DIVISINAL" />
            <asp:Parameter Name="FLAG_VENDOR" />
            <asp:Parameter Name="FLAG_ENGAGEMENTID" />
            <asp:Parameter Name="FLAG_CONTRACTID" />
            <asp:Parameter Name="FLAG_COSTCENTRE" />
            <asp:Parameter Name="FLAG_DEUBALvl4" />
            <asp:Parameter Name="FLAG_HRID" />
            <asp:Parameter Name="FLAG_REQUESTID" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="OriginalKPIID" Type="String" />

            <asp:Parameter Name="KPI_ID" />
            <asp:Parameter Name="KPI_or_Standalone_Metric" />
            <asp:Parameter Name="KPI_Name" />
            <asp:Parameter Name="KPI_Short_Description" />
            <asp:Parameter Name="KPI_Impact" />
            <asp:Parameter Name="Numerator_Description" />
            <asp:Parameter Name="Denominator_Description" />
            <asp:Parameter Name="Unit" />
            <asp:Parameter Name="Datasource" />
            <asp:Parameter Name="OrderWithinSecton" />
            <asp:Parameter Name="Active" />
            <asp:Parameter Name="FLAG_DIVISINAL" />
            <asp:Parameter Name="FLAG_VENDOR" />
            <asp:Parameter Name="FLAG_ENGAGEMENTID" />
            <asp:Parameter Name="FLAG_CONTRACTID" />
            <asp:Parameter Name="FLAG_COSTCENTRE" />
            <asp:Parameter Name="FLAG_DEUBALvl4" />
            <asp:Parameter Name="FLAG_HRID" />
            <asp:Parameter Name="FLAG_REQUESTID" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" CssClass="grid-style" OnRowCommand="GridView1_RowCommand">
        <Columns>
            <asp:TemplateField>
                <HeaderTemplate>
                    <asp:Button ID="btnAddKPI" runat="server" Text="+ Add KPI" CssClass="btn-add" OnClick="btnAddKPI_Click" />
                </HeaderTemplate>

                <ItemTemplate>
                    <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="EditKPI" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn-edit" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="KPI ID" HeaderText="KPI ID" />
            <asp:BoundField DataField="KPI or Standalone Metric" HeaderText="Metric" />
            <asp:BoundField DataField="KPI Name" HeaderText="Name" />
            <asp:BoundField DataField="KPI Short Description" HeaderText="Short Desc" />
            <asp:BoundField DataField="KPI Impact" HeaderText="Impact" />
            <asp:BoundField DataField="Numerator Description" HeaderText="Numerator" />
            <asp:BoundField DataField="Denominator Description" HeaderText="Denominator" />
            <asp:BoundField DataField="Unit" HeaderText="Unit" />
            <asp:BoundField DataField="Datasource" HeaderText="Datasource" />
            <asp:BoundField DataField="OrderWithinSecton" HeaderText="Order" />
            <asp:TemplateField HeaderText="Active"><ItemTemplate><%# If(Eval("Active").ToString() = "Y", "YES", "NO") %></ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="FLAG DIVISINAL"><ItemTemplate><%# If(Eval("FLAG_DIVISINAL").ToString() = "Y", "YES", "NO") %></ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="FLAG VENDOR"><ItemTemplate><%# If(Eval("FLAG_VENDOR").ToString() = "Y", "YES", "NO") %></ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="FLAG ENGAGEMENTID"><ItemTemplate><%# If(Eval("FLAG_ENGAGEMENTID").ToString() = "Y", "YES", "NO") %></ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="FLAG CONTRACTID"><ItemTemplate><%# If(Eval("FLAG_CONTRACTID").ToString() = "Y", "YES", "NO") %></ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="FLAG COSTCENTRE"><ItemTemplate><%# If(Eval("FLAG_COSTCENTRE").ToString() = "Y", "YES", "NO") %></ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="FLAG DEUBALvl4"><ItemTemplate><%# If(Eval("FLAG_DEUBALvl4").ToString() = "Y", "YES", "NO") %></ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="FLAG HRID"><ItemTemplate><%# If(Eval("FLAG_HRID").ToString() = "Y", "YES", "NO") %></ItemTemplate></asp:TemplateField>
            <asp:TemplateField HeaderText="FLAG REQUESTID"><ItemTemplate><%# If(Eval("FLAG_REQUESTID").ToString() = "Y", "YES", "NO") %></ItemTemplate></asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>

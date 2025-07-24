<%@ Page Title="KPI Management" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="KPILibrary._Default" %>
<%@ Import Namespace="System.Web.Services" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
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
    box-sizing: border-box;
}

.close-btn {
    float: right;
    font-size: 20px;
    font-weight: bold;
    cursor: pointer;
}

.error-span {
    color: red;
    font-size: 12px;
    margin-left: 10px;
    display: none;
    font-weight: bold;
}

.error-span.show {
    display: inline;
}

.toggle-switch {
    position: relative;
    display: inline-block;
    width: 40px;
    height: 20px;
}

.toggle-switch input {
    opacity: 0;
    width: 0;
    height: 0;
}

.slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    transition: .4s;
    border-radius: 20px;
}

.toggle-switch input:checked + .slider {
    background-color: #2196F3;
}

.slider:before {
    position: absolute;
    content: "";
    height: 16px;
    width: 16px;
    left: 2px;
    bottom: 2px;
    background-color: white;
    transition: .4s;
    border-radius: 50%;
}

.toggle-switch input:checked + .slider:before {
    transform: translateX(20px);
}

.btn-add, .btn-edit {
    padding: 6px 12px;
    border: none;
    border-radius: 4px;
    color: white;
    cursor: pointer;
}

.btn-add {
    background-color: #4CAF50;
}

.btn-edit {
    background-color: #2196F3;
}


table {
    width: 100%;
    border-collapse: collapse;
}

table td, table th {
    padding: 8px;
    border: 1px solid #ccc;
}

.grid-style {
    border-collapse: collapse;
    width: 100%;
    table-layout: auto;
}

.grid-style td,
.grid-style th {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
    white-space: nowrap;
}


.grid-style th {
    position: sticky;
    top: 50px; 
    background-color: #f2f2f2;
    z-index: 998;
}

/* Table scroll area */
.grid-scroll-container {
    max-height: calc(100vh - 110px); 
    overflow-y: auto;
    border: 1px solid #ddd;
    border-radius: 4px;
    position: relative;
}

.modal input[type="text"],
.modal textarea {
    width: 100%;
    box-sizing: border-box;
}


.search-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    background: white;
    padding: 10px 20px;
    display: flex;
    gap: 10px;
    align-items: center;
    z-index: 1000;
    border-bottom: 1px solid #ddd;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
    height: 60px;
    box-sizing: border-box;
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 20px;
    background: white;
    border-bottom: 1px solid #eee;
    position: fixed;
    top: 60px; 
    left: 0;
    right: 0;
    z-index: 999;
    height: 50px;
    box-sizing: border-box;
}

.page-title {
    font-size: 24px;
    font-weight: bold;
    color: #333;
}

.grid-container {
    padding: 20px;
    margin-top: 110px; 
}

.search-box {
    padding: 10px 15px;
    border: 1px solid #e0e0e0;
    border-radius: 30px;
    width: 220px;
    font-size: 14px;
    background: #f9f9f9;
    transition: all 0.3s;
    box-sizing: border-box;
}

.search-box:focus {
    width: 250px;
    transition: width 0.3s ease-in-out;
}

.search-button,
.clear-button {
    padding: 8px 16px;
    border: none;
    border-radius: 30px;
    color: white;
    cursor: pointer;
    font-size: 14px;
    font-weight: 600;
    transition: all 0.3s;
    display: flex;
    align-items: center;
    justify-content: center;
}

.search-button {
    background-color: #2196F3;
}

.search-button:hover {
    background-color: #0b7dda;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(33, 150, 243, 0.3);
}

.clear-button {
    background-color: #f44336;
}

.clear-button:hover {
    background-color: #d32f2f;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(244, 67, 54, 0.3);
}

@media (max-width: 1200px) {
    .search-container {
        top: 0;
        right: 10px;
    }
}

@media (max-width: 768px) {
    .search-container {
        flex-direction: column;
        align-items: stretch;
    }

    .search-box,
    .search-button,
    .clear-button {
        width: 100%;
    }
.grid-container {
    padding: 20px 0px; /* Removed horizontal padding */
    margin-top: 110px;
}

    .grid-style th {
        top: 110px;
    }
}

</style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
    let lblKPIError = null;
    let inputField = null;
    let isCheckingKPI = false;

    function showPopup() {
        document.getElementById('kpiModal').style.display = 'block';
    }

    function hidePopup() {
        document.getElementById('kpiModal').style.display = 'none';
        document.getElementById("<%= lblOrderError.ClientID %>").style.display = "none";
        document.getElementById("<%= lblDuplicateMetricKPIError.ClientID %>").style.display = "none";
        document.getElementById("<%= lblKPIError.ClientID %>").style.display = "none";
    }

    function showElement(element) {
        if (element) {
            element.classList.add('show');
        }
    }

    function hideElement(element) {
        if (element) {
            element.classList.remove('show');
        }
    }

    function debounce(func, delay) {
        let timer;
        return function () {
            clearTimeout(timer);
            timer = setTimeout(() => {
                func.apply(this, arguments);
            }, delay);
        };
    }

    function createKPIErrorLabel() {
        const inputField = document.getElementById('<%=txtKPIID.ClientID%>');
        if (!inputField) {
            console.error("Cannot create error label: Input field not found");
            return null;
        }

        const errorSpan = document.createElement('span');
        errorSpan.id = 'dynamicKPIError';
        errorSpan.className = 'error-span';
        errorSpan.innerText = "KPI ID already exists";
        inputField.parentNode.appendChild(errorSpan);
        console.log("Dynamic error label created");
        return errorSpan;
    }

    function checkKPIID() {
        if (isCheckingKPI) {
            return;
        }

        if (!inputField) {
            inputField = document.getElementById('<%=txtKPIID.ClientID%>');
        }
        if (!lblKPIError) {
            lblKPIError = document.getElementById('<%=lblKPIError.ClientID%>');
            if (!lblKPIError) {
                lblKPIError = document.getElementById('dynamicKPIError') || createKPIErrorLabel();
            }
        }

        if (!inputField || !lblKPIError) {
            console.error("Input field or error label not found");
            return;
        }

        var kpiID = inputField.value.trim().replace(/\s{2,}/g, ' ');
        inputField.value = kpiID;

        if (kpiID === "") {
            hideElement(lblKPIError);
            return;
        }

        var isEdit = document.getElementById('<%=hfIsEdit.ClientID%>');
        var originalKPIID = document.getElementById('<%=hfKPIID.ClientID%>');
        if (isEdit && originalKPIID && isEdit.value === "true" && kpiID === originalKPIID.value) {
            hideElement(lblKPIError);
            return;
        }

        isCheckingKPI = true;

        $.ajax({
            type: "POST",
            url: "Default.aspx/CheckKPIExists",
            data: JSON.stringify({ kpiID: kpiID }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            timeout: 10000,
            success: function (response) {
                console.log("AJAX Response:", response);
                if (response.d === true) {
                    lblKPIError.innerText = "KPI ID already exists!";
                    showElement(lblKPIError);
                } else {
                    hideElement(lblKPIError);
                }
                isCheckingKPI = false;
            },
            error: function (xhr, status, error) {
                console.error("AJAX error:", xhr.status, xhr.responseText, error);
                isCheckingKPI = false;
            }
        });
    }

    // ✅ Updated to allow insert even if AJAX check fails (e.g., 401 Unauthorized)
    function validateBeforeSubmit() {
        if (!inputField) {
            inputField = document.getElementById('<%=lblKPIError.ClientID%>');
        }
        if (!lblKPIError) {
            lblKPIError = document.getElementById('<%=txtKPIID.ClientID%>');
            if (!lblKPIError) {
                lblKPIError = document.getElementById('dynamicKPIError') || createKPIErrorLabel();
            }
        }

        if (!inputField || !lblKPIError) {
            console.error("Input field or error label not found during submission");
            return true; // Let it pass instead of blocking
        }

        var kpiID = inputField.value.trim().replace(/\s{2,}/g, ' ');
        inputField.value = kpiID;

        var isEdit = document.getElementById('<%=txtKPIID.ClientID%>');
        var originalKPIID = document.getElementById('<%=hfKPIID.ClientID%>');
        if (isEdit && originalKPIID && isEdit.value === "true" && kpiID === originalKPIID.value) {
            hideElement(lblKPIError);
            return true;
        }

        if (lblKPIError.classList.contains('show')) {
            showElement(lblKPIError);
            return false;
        }

        let isValid = true;
        $.ajax({
            type: "POST",
            url: "Default.aspx/CheckKPIExists",
            data: JSON.stringify({ kpiID: kpiID }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (response) {
                if (response.d === true) {
                    lblKPIError.innerText = "KPI ID already exists";
                    showElement(lblKPIError);
                    isValid = false;
                } else {
                    hideElement(lblKPIError);
                }
            },
            error: function (xhr, status, error) {
                console.warn("AJAX validation failed. Bypassing check and allowing submission.");
                hideElement(lblKPIError); // Hide error if present
                isValid = true; // Allow insert even on error
            }
        });

        return isValid;
    }

    $(document).ready(function () {
        console.log("Document ready, initializing KPI ID validation");

        inputField = document.getElementById('<%=txtKPIID.ClientID%>');
        lblKPIError = document.getElementById('<%=lblKPIError.ClientID%>');
        if (!lblKPIError) {
            lblKPIError = document.getElementById('dynamicKPIError') || createKPIErrorLabel();
        }

        console.log("Input field found:", inputField !== null);
        console.log("Error label found:", lblKPIError !== null);

        if (inputField && lblKPIError) {
            $(inputField).off('input.kpivalidation blur.kpivalidation');
            $(inputField).on('input.kpivalidation', debounce(checkKPIID, 500));
            $(inputField).on('blur.kpivalidation', checkKPIID);
            console.log("Event listeners attached for KPI ID validation");
        } else {
            console.error("Failed to initialize: Input or error label missing");
        }

        if (lblKPIError) {
            hideElement(lblKPIError);
        }

        var submitButton = document.getElementById('<%=hfIsEdit.ClientID%>');
        if (submitButton) {
            $(submitButton).off('click.kpivalidation').on('click.kpivalidation', function (e) {
                if (!validateBeforeSubmit()) {
                    e.preventDefault();
                    showPopup();
                    return false;
                }
            });
        }
    });

    function showKPIError(message) {
        if (!lblKPIError) {
            lblKPIError = document.getElementById('<%=hfKPIID.ClientID%>');
            if (!lblKPIError) {
                lblKPIError = document.getElementById('dynamicKPIError') || createKPIErrorLabel();
            }
        }
        if (lblKPIError) {
            lblKPIError.innerText = message || "KPI ID already exists";
            showElement(lblKPIError);
        }
    }

    function hideKPIError() {
        if (!lblKPIError) {
            lblKPIError = document.getElementById('<%=txtKPIID.ClientID = lblKPIError.ClientID%>');
            if (!lblKPIError) {
                lblKPIError = document.getElementById('dynamicKPIError') || createKPIErrorLabel();
            }
        }
        if (lblKPIError) {
            hideElement(lblKPIError);
        }
    }
    // Enhanced filter function
    function filterGrid() {
        var input = document.getElementById('<%= txtSearch.ClientID %>');
        var filter = input.value.toLowerCase();
        var grid = document.getElementById('<%= GridView1.ClientID %>');
        var rows = grid.getElementsByTagName('tr');

        // Start from 1 to skip header row
        for (var i = 1; i < rows.length; i++) {
            var cells = rows[i].getElementsByTagName('td');
            var showRow = false;

            // Skip action column (index 0) and check all other columns
            for (var j = 1; j < cells.length; j++) {
                var cellText = cells[j].textContent || cells[j].innerText;
                if (cellText.toLowerCase().indexOf(filter) > -1) {
                    showRow = true;
                    break;
                }
            }

            rows[i].style.display = showRow ? "" : "none";
        }
    }

    // Optimized clear filter
    function clearFilter() {
        var input = document.getElementById('<%= txtSearch.ClientID %>');
        input.value = "";
        filterGrid(); // Reuse filter function to show all
    }
    
    // Press Enter to search
    $(document).ready(function() {
        $('#<%=txtSearch.ClientID%>').keypress(function(e) {
            if (e.which == 13) {
                filterGrid();
                return false; // Prevent form submission
            }
        });
        
        // Auto focus search when typing anywhere
        $(document).keypress(function(e) {
            // Only focus if not already focused and not in modal
            if ($('#<%=txtSearch.ClientID%>').is(':focus') || $('#kpiModal').is(':visible')) return;
            
            // Focus search box when user starts typing
            if (e.which >= 48 || e.which == 32) { // Numbers, letters or space
                $('#<%=txtSearch.ClientID%>').focus();
            }
        });
    });
</script>

  

    <div id="kpiModal" class="modal">
        <span class="close-btn" onclick="hidePopup()">×</span>
        <h3><asp:Label ID="lblFormTitle" runat="server" Text="Add KPI" /></h3>

        <table>
            <tr><td>KPI ID:</td><td><asp:TextBox ID="txtKPIID" runat="server" /><asp:Label ID="lblKPIError" runat="server" CssClass="error-span" Text="KPI ID already exists" ForeColor="Red" Visible="false" /></td></tr>
            <tr><td>Order:</td><td><asp:TextBox ID="txtOrder" runat="server" /><asp:Label ID="lblOrderError" runat="server"   Text="Please add numbers between 1–999" ForeColor="Red" Style="color: red;font-size: 12px; margin-top:5px;display:block;"  /></td></tr>
            <tr><td>Metric:</td><td><asp:TextBox ID="txtMetric" runat="server" /></td></tr>
            <tr><td>Name:</td><td><asp:TextBox ID="txtKPIName" runat="server" /><asp:Label ID="lblDuplicateMetricKPIError" runat="server"   ForeColor="Red" Style="color: red;font-size: 12px; margin-top:5px;display:block;"  /></td></tr>
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
     <div class="kpi-table-scroll">
        <!-- New search container -->
        <div class="search-container">
            <asp:TextBox ID="txtSearch" runat="server" 
                CssClass="search-box" 
                placeholder="Search by KPI ID, Name, or Metric..." />
            <asp:Button ID="btnSearch" runat="server" Text="Search" 
                OnClientClick="filterGrid(); return false;" 
                CssClass="search-button" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" 
                OnClientClick="clearFilter(); return false;" 
                CssClass="clear-button" />
        </div>
        
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSource1" CssClass="grid-style" 
            OnRowCommand="GridView1_RowCommand"
            HeaderStyle-CssClass="grid-header">
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
    </div>  
    
</asp:Content>

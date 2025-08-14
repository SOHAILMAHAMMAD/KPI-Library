<%@ Page Title="KPI Management" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="KPILibrary._Default" %>
<%@ Import Namespace="System.Web.Services" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
       /* Modal Popup - Centered, Smooth, Responsive */
/* === MODAL POPUP === */
.modal {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    width: 800px;
    height: 500px;
    max-height: 80vh;
    overflow-y: auto;
    background-color: #fff;
    transform: translate(-50%, -50%);
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    z-index: 1000;
    box-sizing: border-box;
}

.close-btn {
    float: right;
    font-size: 24px;
    font-weight: bold;
    cursor: pointer;
    color: #aaa;
    line-height: 1;
}

.close-btn:hover {
    color: #000;
}

/* === ERROR LABELS === */
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

/* === TOGGLE SWITCH (Modern & Compact) === */
.toggle-switch {
    position: relative;
    display: inline-block;
    width: 50px;
    height: 24px;
    margin: 0 8px;
    vertical-align: middle;
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
    transition: 0.3s;
    border-radius: 12px;
}

.slider:before {
    content: "";
    position: absolute;
    height: 18px;
    width: 18px;
    left: 3px;
    bottom: 3px;
    background-color: white;
    transition: 0.3s;
    border-radius: 50%;
}

.toggle-switch input:checked + .slider {
    background-color: #2196F3;
}

.toggle-switch input:checked + .slider:before {
    transform: translateX(26px);
}

/* === BUTTONS === */
.btn-add, .btn-edit {
    padding: 6px 12px;
    border: none;
    border-radius: 4px;
    color: white;
    cursor: pointer;
    font-weight: 600;
    transition: background 0.2s;
}

.btn-add {
    background-color: #4CAF50;
}

.btn-add:hover {
    background-color: #45a049;
}

/* === EDIT BUTTON (Enhanced) === */
.btn-edit {
    padding: 6px 14px;
    font-size: 13px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    background-color: #2196F3;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(33, 150, 243, 0.2);
}

.btn-edit:hover {
    background-color: #0b7dda;
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(33, 150, 243, 0.3);
}

.btn-edit:active {
    transform: translateY(0);
    box-shadow: 0 1px 2px rgba(33, 150, 243, 0.2);
}


/* === DELETE BUTTON (Enhanced) === */
.btn-delete {
    padding: 6px 14px;
    font-size: 13px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    background-color: #f44336;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(244, 67, 54, 0.2);
}

.btn-delete:hover {
    background-color: #d32f2f;
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(244, 67, 54, 0.3);
}

.btn-delete:active {
    transform: translateY(0);
    box-shadow: 0 1px 2px rgba(244, 67, 54, 0.2);
}
/* === TABLE STYLES === */
table {
    width: 100%;
    border-collapse: collapse;
}

table td, table th {
    padding: 8px;
    border: 1px solid #ddd;
    text-align: left;
    white-space: nowrap;
}

.grid-style {
    border-collapse: collapse;
    width: 100%;
    table-layout: auto;
}

.grid-style th {
    position: sticky;
    top: 50px;
    background-color: #f2f2f2;
    z-index: 998;
    font-weight: 600;
    color: #333;
}

/* === TABLE SCROLL CONTAINER === */
.grid-scroll-container {
    max-height: calc(100vh - 110px);
    overflow-y: auto;
    border: 1px solid #ddd;
    border-radius: 4px;
}

/* === MODAL INPUTS === */
.modal input[type="text"],
.modal textarea {
    width: 100%;
    box-sizing: border-box;
}

/* === SEARCH CONTAINER (Fixed, Sticky) === */
.search-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    background: white;
    padding: 12px 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    z-index: 1000;
    border-bottom: 1px solid #e0e0e0;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    height: 60px;
    box-sizing: border-box;
}

.search-box {
    flex: 1;
    max-width: 300px;
    padding: 10px 15px;
    border: 1px solid #d0d0d0;
    border-radius: 30px;
    font-size: 14px;
    background: #f9f9f9;
    transition: all 0.3s ease;
}

.search-box:focus {
    outline: none;
    width: 280px;
    border-color: #2196F3;
    background: white;
    box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.1);
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
    transition: all 0.2s ease;
    min-width: 90px;
}

.search-button {
    background-color: #2196F3;
}

.search-button:hover {
    background-color: #0b7dda;
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(33, 150, 243, 0.2);
}

.clear-button {
    background-color: #f44336;
}

.clear-button:hover {
    background-color: #d32f2f;
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(244, 67, 54, 0.2);
}

/* === PAGE HEADER (Below Search) === */
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

/* === GRID CONTAINER (Main Table Area) === */
.grid-container {
    padding: 20px;
    margin-top: 110px;
}

/* === SORTABLE HEADERS (Clean & Interactive) === */
.sortable-header {
    position: relative;
    display: inline-block;
    cursor: default;
}

.sortable-header .sort-arrows {
    opacity: 0;
    transition: opacity 0.2s;
    margin-left: 6px;
}

.sortable-header:hover .sort-arrows {
    opacity: 1;
}

.arrow-icon {
    background: none;
    border: none;
    font-size: 14px;
    color: #666;
    cursor: pointer;
    padding: 0 2px;
    text-decoration: none;
}

.arrow-icon:hover {
    color: #2196F3;
}

.sort-indicator {
    font-weight: bold;
    color: darkorange;
    margin-left: 4px;
}

/* === RESPONSIVE DESIGN === */
@media (max-width: 768px) {
    .search-container {
        flex-direction: column;
        align-items: stretch;
        padding: 12px;
        gap: 8px;
    }

    .search-box,
    .search-button,
    .clear-button {
        width: 100%;
        max-width: none;
        margin: 0;
    }

    .toggle-switch {
        margin: 0 0 0 10px;
    }

    .grid-container {
        padding: 15px 10px;
        margin-top: 120px;
    }

    .grid-style th {
        top: 120px;
        font-size: 13px;
        padding: 6px 8px;
    }

    .modal {
        width: 90vw;
        height: 75vh;
        padding: 15px;
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
            lblKPIError = document.getElementById('<%=lblKPIError.ClientID%>');
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
        $('#<%=txtKPIID.ClientID%>').keypress(function(e) {
            if (e.which == 13) {
                filterGrid();
                return false; // Prevent form submission
            }
        });
        
        // Auto focus search when typing anywhere
        $(document).keypress(function(e) {
            // Only focus if not already focused and not in modal
            if ($('#<%=txtKPIID.ClientID%>').is(':focus') || $('#kpiModal').is(':visible')) return;
            
            // Focus search box when user starts typing
            if (e.which >= 48 || e.which == 32) { // Numbers, letters or space
                $('#<%=hfKPIID.ClientID%>').focus();
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
            <tr><td>Test 1:</td><td><asp:TextBox ID="txtTest1" runat="server" TextMode="MultiLine" Rows="3"  /></td></tr>
            <tr><td>Test 2:</td><td><asp:TextBox ID="txtTest2" runat="server" TextMode="MultiLine" Rows="3" /></td></tr>
             <tr>
        <td>Objective/Subjective:</td>
        <td>
            <asp:DropDownList ID="ddlObjectiveSubjective" runat="server" CssClass="form-control">
                <asp:ListItem Value="" Text="-- Select --" Selected="True"></asp:ListItem>
                <asp:ListItem Value="Objective" Text="Objective"></asp:ListItem>
                <asp:ListItem Value="Subjective" Text="Subjective"></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>

    <!-- Comments as Multi-line Textbox -->
    <tr>
        <td>Comments:</td>
        <td>
            <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" Rows="3" Columns="50" 
                         placeholder=" comments..." />
        </td>
    </tr>
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

         <SelectParameters>
        <asp:Parameter Name="Status" Type="String" DefaultValue="Y" />
        <asp:Parameter Name="SortColumn" Type="String" DefaultValue="KPI or Standalone Metric" />
        <asp:Parameter Name="SortDirection" Type="String" DefaultValue="ASC" />
        </SelectParameters>
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
             <asp:Parameter Name="test1" />
             <asp:Parameter Name="test2" />
            <asp:Parameter Name="Objective_Subjective" />
            <asp:Parameter Name="Comments" />
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
            <asp:Parameter Name="test1" />
            <asp:Parameter Name="test2" />
            <asp:Parameter Name="Objective_Subjective" />
            <asp:Parameter Name="Comments" />
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
            <asp:Button ID="btnExport" runat="server" Text="Export to Excel" 
        CssClass="search-button" OnClick="btnExport_Click" 
        style="background-color: #4CAF50;" />
            <span id="toggleLabel" runat="server" style="font-weight:bold; margin-left: 20px;">Active</span>
    <label class="toggle-switch" style="vertical-align:middle;">
        <asp:CheckBox ID="chkShowActive" runat="server" AutoPostBack="true" OnCheckedChanged="chkShowActive_CheckedChanged" />
        <span class="slider"></span>
    </label>
        </div>

         </div>

          <div class="grid-container">

           
        
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" CssClass="grid-style" OnRowCommand="GridView1_RowCommand"
    OnRowCreated="GridView1_RowCreated" DataKeyNames="KPI ID" ShowHeaderWhenEmpty="true"  EmptyDataText="No records found" EmptyDataRowStyle-CssClass="empty-row" EmptyDataRowStyle-HorizontalAlign="Center" EmptyDataRowStyle-ForeColor="#999"> 
         <Columns>
<asp:TemplateField>
    <HeaderTemplate>
        <asp:Button ID="btnAddKPI" runat="server" Text="+ Add KPI" CssClass="btn-add" OnClick="btnAddKPI_Click" />
    </HeaderTemplate>
    <ItemTemplate>
        <asp:Button ID="btnEdit" runat="server" Text="Edit"
            CommandName="EditKPI"
            CommandArgument='<%# Container.DataItemIndex %>'
            CssClass="btn-edit" />
        &nbsp;
        <asp:Button ID="btnDelete" runat="server" Text="Delete"
            CommandName="DeleteKPI"
            CommandArgument='<%# Container.DataItemIndex %>'
            OnClientClick="return confirm('Are you sure you want to delete this KPI? This action cannot be undone.');"
            CssClass="btn-delete" />
    </ItemTemplate>
</asp:TemplateField>
    <asp:TemplateField HeaderText="Metric" SortExpression="KPI or Standalone Metric">
        <HeaderTemplate>
            <div class="sortable-header">
                Metric
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpMetric" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI or Standalone Metric|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownMetric" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI or Standalone Metric|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortMetric" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("KPI or Standalone Metric") %></ItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="KPI Name" SortExpression="KPI Name">
        <HeaderTemplate>
            <div class="sortable-header">
                KPI Name
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpKPIName" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI Name|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownKPIName" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI Name|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortKPIName" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("KPI Name") %></ItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="KPI ID" SortExpression="KPI ID">
        <HeaderTemplate>
            <div class="sortable-header">
                KPI ID
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpKPIID" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI ID|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownKPIID" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI ID|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortKPIID" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("KPI ID") %></ItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="Short Description" SortExpression="KPI Short Description">
        <HeaderTemplate>
            <div class="sortable-header">
                Short Description
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpShortDesc" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI Short Description|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownShortDesc" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI Short Description|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortShortDesc" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("KPI Short Description") %></ItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="Impact" SortExpression="KPI Impact">
        <HeaderTemplate>
            <div class="sortable-header">
                Impact
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpImpact" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI Impact|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownImpact" runat="server" CommandName="CustomSort"
                        CommandArgument="KPI Impact|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortImpact" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("KPI Impact") %></ItemTemplate>
    </asp:TemplateField>

    <asp:TemplateField HeaderText="Numerator" SortExpression="Numerator Description">
        <HeaderTemplate>
            <div class="sortable-header">
                Numerator
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpNum" runat="server" CommandName="CustomSort"
                        CommandArgument="Numerator Description|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownNum" runat="server" CommandName="CustomSort"
                        CommandArgument="Numerator Description|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortNum" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("Numerator Description") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Denominator" SortExpression="Denominator Description">
        <HeaderTemplate>
            <div class="sortable-header">
                Denominator
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpDen" runat="server" CommandName="CustomSort"
                        CommandArgument="Denominator Description|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownDen" runat="server" CommandName="CustomSort"
                        CommandArgument="Denominator Description|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortDen" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("Denominator Description") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Unit" SortExpression="Unit">
        <HeaderTemplate>
            <div class="sortable-header">
                Unit
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpUnit" runat="server" CommandName="CustomSort"
                        CommandArgument="Unit|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownUnit" runat="server" CommandName="CustomSort"
                        CommandArgument="Unit|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortUnit" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("Unit") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Datasource" SortExpression="Datasource">
        <HeaderTemplate>
            <div class="sortable-header">
                Datasource
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpDS" runat="server" CommandName="CustomSort"
                        CommandArgument="Datasource|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownDS" runat="server" CommandName="CustomSort"
                        CommandArgument="Datasource|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortDS" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("Datasource") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="Order" SortExpression="OrderWithinSecton">
        <HeaderTemplate>
            <div class="sortable-header">
                Order
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpOrder" runat="server" CommandName="CustomSort"
                        CommandArgument="OrderWithinSecton|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownOrder" runat="server" CommandName="CustomSort"
                        CommandArgument="OrderWithinSecton|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortOrder" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# Eval("OrderWithinSecton") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="test1" SortExpression="test1">
    <HeaderTemplate>
        <div class="sortable-header">
            test1
            <span class="sort-arrows">
                <asp:LinkButton ID="btnSortUptest1" runat="server" CommandName="CustomSort"
                    CommandArgument="test1|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                <asp:LinkButton ID="btnSortDowntest1" runat="server" CommandName="CustomSort"
                    CommandArgument="test1|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
            </span>
            <asp:Label ID="lblCurrentSorttest1" runat="server" CssClass="sort-indicator"></asp:Label>
        </div>
    </HeaderTemplate>
    <ItemTemplate>
        <%# Eval("test1") %>
    </ItemTemplate>
</asp:TemplateField>
    <asp:TemplateField HeaderText="test2" SortExpression="test2">
    <HeaderTemplate>
        <div class="sortable-header">
            test2
            <span class="sort-arrows">
                <asp:LinkButton ID="btnSortUptest2" runat="server" CommandName="CustomSort"
                    CommandArgument="test2|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                <asp:LinkButton ID="btnSortDowntest2" runat="server" CommandName="CustomSort"
                    CommandArgument="test2|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
            </span>
            <asp:Label ID="lblCurrentSorttest2" runat="server" CssClass="sort-indicator"></asp:Label>
        </div>
    </HeaderTemplate>
    <ItemTemplate>
        <%# Eval("test2") %>
    </ItemTemplate>
</asp:TemplateField>

             <asp:TemplateField HeaderText="Objective/Subjective" SortExpression="Objective/Subjective">
    <HeaderTemplate>
        <div class="sortable-header">
            Objective/Subjective
            <span class="sort-arrows">
                <asp:LinkButton ID="btnSortUpObjSub" runat="server" CommandName="CustomSort"
                    CommandArgument="Objective/Subjective|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                <asp:LinkButton ID="btnSortDownObjSub" runat="server" CommandName="CustomSort"
                    CommandArgument="Objective_or_Subjective|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
            </span>
            <asp:Label ID="lblCurrentSortObjSub" runat="server" CssClass="sort-indicator"></asp:Label>
        </div>
    </HeaderTemplate>
    <ItemTemplate>
        <%# Eval("Objective/Subjective") %>
    </ItemTemplate>
</asp:TemplateField>

             <asp:TemplateField HeaderText="Comments" SortExpression="Comments">
    <HeaderTemplate>
        <div class="sortable-header">
            Comments
            <span class="sort-arrows">
                <asp:LinkButton ID="btnSortUpComments" runat="server" CommandName="CustomSort"
                    CommandArgument="Comments|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                <asp:LinkButton ID="btnSortDownComments" runat="server" CommandName="CustomSort"
                    CommandArgument="Comments|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
            </span>
            <asp:Label ID="lblCurrentSortComments" runat="server" CssClass="sort-indicator"></asp:Label>
        </div>
    </HeaderTemplate>
    <ItemTemplate>
        <%# Eval("Comments") %>
    </ItemTemplate>
</asp:TemplateField>

    <asp:TemplateField HeaderText="Active" SortExpression="Active">
        <HeaderTemplate>
            <div class="sortable-header">
                Active
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpActive" runat="server" CommandName="CustomSort"
                        CommandArgument="Active|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownActive" runat="server" CommandName="CustomSort"
                        CommandArgument="Active|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortActive" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# If(Eval("Active").ToString() = "Y", "YES", "NO") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="FLAG DIVISINAL" SortExpression="FLAG_DIVISINAL">
        <HeaderTemplate>
            <div class="sortable-header">
                FLAG DIVISINAL
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpDiv" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_DIVISINAL|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownDiv" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_DIVISINAL|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortDiv" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# If(Eval("FLAG_DIVISINAL").ToString() = "Y", "YES", "NO") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="FLAG VENDOR" SortExpression="FLAG_VENDOR">
        <HeaderTemplate>
            <div class="sortable-header">
                FLAG VENDOR
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpVendor" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_VENDOR|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownVendor" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_VENDOR|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortVendor" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# If(Eval("FLAG_VENDOR").ToString() = "Y", "YES", "NO") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="FLAG ENGAGEMENTID" SortExpression="FLAG_ENGAGEMENTID">
        <HeaderTemplate>
            <div class="sortable-header">
                FLAG ENGAGEMENTID
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpEng" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_ENGAGEMENTID|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownEng" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_ENGAGEMENTID|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortEng" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# If(Eval("FLAG_ENGAGEMENTID").ToString() = "Y", "YES", "NO") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="FLAG CONTRACTID" SortExpression="FLAG_CONTRACTID">
        <HeaderTemplate>
            <div class="sortable-header">
                FLAG CONTRACTID
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpContract" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_CONTRACTID|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownContract" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_CONTRACTID|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortContract" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# If(Eval("FLAG_CONTRACTID").ToString() = "Y", "YES", "NO") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="FLAG COSTCENTRE" SortExpression="FLAG_COSTCENTRE">
        <HeaderTemplate>
            <div class="sortable-header">
                FLAG COSTCENTRE
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpCC" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_COSTCENTRE|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownCC" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_COSTCENTRE|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortCC" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# If(Eval("FLAG_COSTCENTRE").ToString() = "Y", "YES", "NO") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="FLAG DEUBALvl4" SortExpression="FLAG_DEUBALvl4">
        <HeaderTemplate>
            <div class="sortable-header">
                FLAG DEUBALvl4
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpLvl4" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_DEUBALvl4|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownLvl4" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_DEUBALvl4|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortLvl4" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# If(Eval("FLAG_DEUBALvl4").ToString() = "Y", "YES", "NO") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="FLAG HRID" SortExpression="FLAG_HRID">
        <HeaderTemplate>
            <div class="sortable-header">
                FLAG HRID
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpHRID" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_HRID|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownHRID" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_HRID|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortHRID" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# If(Eval("FLAG_HRID").ToString() = "Y", "YES", "NO") %></ItemTemplate>
    </asp:TemplateField>
    <asp:TemplateField HeaderText="FLAG REQUESTID" SortExpression="FLAG_REQUESTID">
        <HeaderTemplate>
            <div class="sortable-header">
                FLAG REQUESTID
                <span class="sort-arrows">
                    <asp:LinkButton ID="btnSortUpReq" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_REQUESTID|DESC" CssClass="arrow-icon" ToolTip="Sort Descending">&#9650;</asp:LinkButton>
                    <asp:LinkButton ID="btnSortDownReq" runat="server" CommandName="CustomSort"
                        CommandArgument="FLAG_REQUESTID|ASC" CssClass="arrow-icon" ToolTip="Sort Ascending">&#9660;</asp:LinkButton>
                </span>
                <asp:Label ID="lblCurrentSortReq" runat="server" CssClass="sort-indicator"></asp:Label>
            </div>
        </HeaderTemplate>
        <ItemTemplate><%# If(Eval("FLAG_REQUESTID").ToString() = "Y", "YES", "NO") %></ItemTemplate>
    </asp:TemplateField>
</Columns>

    </asp:GridView>
    </div> 
         <div id="noDataMessage" runat="server" visible="false" style="text-align: center; padding: 20px; color: #666; font-size: 16px;">
        <h3>No data found.</h3>
    </div>
         <div id="Div1" runat="server" visible="false" style="text-align: center; padding: 20px; color: #666; font-size: 16px;">
    <h3>No data found.</h3>
</div>

    
    
</asp:Content>

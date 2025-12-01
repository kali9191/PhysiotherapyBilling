<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BillGenerator.aspx.cs" Inherits="BillingApplication.BillGenerator" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Physiotherapy Billing</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            position: relative;
            overflow-x: hidden;
        }

        
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 40% 20%, rgba(255, 255, 255, 0.05) 0%, transparent 50%);
            animation: float 15s ease-in-out infinite;
            pointer-events: none;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        .form {
            min-height: 100vh;
            padding: 40px 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container { 
            max-width: 900px;
            width: 100%;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            animation: slideIn 0.6s ease-out;
        }
        .two-column {
            display: flex;
            gap: 20px;
        }

        .two-column .form-group {
            flex: 1;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header-section {
            text-align: center;
            margin-bottom: 35px;
        }

        h2 { 
            color: #ffffff;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }

        .subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 14px;
            font-weight: 300;
        }

        .refresh-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            width: auto;
            padding: 12px 20px;
            background: rgba(255, 152, 0, 0.25);
            backdrop-filter: blur(10px);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 50px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .refresh-btn:hover {
            background: rgba(255, 152, 0, 0.4);
            transform: rotate(180deg);
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.4);
        }

        .refresh-btn i {
            font-size: 16px;
            transition: transform 0.3s ease;
        }

        .form-group {
            margin-bottom: 24px;
            animation: fadeIn 0.6s ease-out backwards;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .form-group:nth-child(6) { animation-delay: 0.6s; }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        label { 
            font-weight: 600;
            display: block;
            margin-bottom: 8px;
            color: #ffffff;
            font-size: 14px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
        }

        label span {
            color: #ff6b6b;
        }

        .input, input[type="text"], select {
            width: 100%;
            padding: 14px 18px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            color: #ffffff;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .input::placeholder,
        input[type="text"]::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .input:focus,
        input[type="text"]:focus,
        select:focus {
            outline: none;
            border-color: rgba(255, 255, 255, 0.6);
            background: rgba(255, 255, 255, 0.25);
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='white' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 18px center;
            padding-right: 45px;
        }

        select option {
            background: rgba(102, 126, 234, 0.95);
            color: white;
            padding: 10px;
        }

        .date-range-container {
            display: flex;
            align-items: flex-end;
            gap: 12px;
            margin-top: 8px;
        }

        .date-input-wrapper {
            flex: 1;
        }

        .input-box {
            width: 100%;
            padding: 14px 18px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            color: #ffffff;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .input-box::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .input-box:focus {
            outline: none;
            border-color: rgba(255, 255, 255, 0.6);
            background: rgba(255, 255, 255, 0.25);
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
        }

        .small-btn {
            background: rgba(76, 175, 80, 0.3);
            backdrop-filter: blur(10px);
            color: white;
            padding: 14px 24px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .small-btn:hover {
            background: rgba(76, 175, 80, 0.5);
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.4);
            transform: translateY(-2px);
        }

        #lstSelectedDates {
            width: 100%;
            min-height: 120px;
            padding: 12px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            color: #ffffff;
            font-size: 14px;
            margin-top: 12px;
        }

        #lstSelectedDates option {
            padding: 8px;
            margin: 4px 0;
            border-radius: 6px;
            background: rgba(255, 255, 255, 0.2);
        }

        #lstSelectedDates option:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 12px;
        }

        .btn-group .small-btn {
            flex: 1;
            background: rgba(244, 67, 54, 0.3);
        }

        .btn-group .small-btn:hover {
            background: rgba(244, 67, 54, 0.5);
            box-shadow: 0 4px 15px rgba(244, 67, 54, 0.4);
        }

        .large-btn {
            background: linear-gradient(135deg, rgba(76, 175, 80, 0.4), rgba(56, 142, 60, 0.4));
            backdrop-filter: blur(10px);
            color: white;
            padding: 16px 32px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 700;
            width: 100%;
            margin-top: 30px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .large-btn:hover {
            background: linear-gradient(135deg, rgba(76, 175, 80, 0.6), rgba(56, 142, 60, 0.6));
            box-shadow: 0 6px 25px rgba(76, 175, 80, 0.5);
            transform: translateY(-3px);
        }

        .large-btn:active {
            transform: translateY(-1px);
        }

        .error-message {
            color: #ff6b6b;
            font-size: 13px;
            margin-top: 6px;
            display: block;
            font-weight: 500;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
        }

        
        .flatpickr-calendar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .flatpickr-day.selected {
            background: #667eea !important;
            border-color: #667eea !important;
        }

       
        @media (max-width: 768px) {
            .container {
                padding: 30px 20px;
            }

            h2 {
                font-size: 26px;
            }

            .refresh-btn {
                position: static;
                margin: 0 auto 20px;
                display: flex;
            }

            .date-range-container {
                flex-direction: column;
            }

            .small-btn {
                width: 100%;
            }
        }

        
        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.7;
            }
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 16px 24px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            font-weight: 600;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            z-index: 10000;
            opacity: 0;
            transform: translateX(400px);
            transition: all 0.3s ease;
        }

        .notification.show {
            opacity: 1;
            transform: translateX(0);
        }

        .notification.success {
            background: rgba(76, 175, 80, 0.3);
            border-color: rgba(76, 175, 80, 0.5);
        }

        .notification.error {
            background: rgba(244, 67, 54, 0.3);
            border-color: rgba(244, 67, 54, 0.5);
        }

        .notification.info {
            background: rgba(33, 150, 243, 0.3);
            border-color: rgba(33, 150, 243, 0.5);
        }


      
        .app-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.45);
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 99999;
            animation: fadeInOverlay 0.3s ease-out forwards;
        }

       
        .app-modal {
            width: 90%;
            max-width: 420px;
            padding: 22px;
            border-radius: 18px;

            
            background: rgba(255, 70, 70, 0.18);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);

            
            border: 1px solid rgba(255, 90, 90, 0.5);
            box-shadow: 0 8px 32px rgba(255, 40, 40, 0.45);

            color: #fff;
            animation: popUp 0.25s ease-out;
        }

       
        .app-modal-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 10px;
            color: #ffcccc;
            text-shadow: 0 0 8px rgba(255, 40, 40, 0.7);
        }

       
        .app-modal-body {
            font-size: 15px;
            line-height: 1.5;
            margin-bottom: 14px;
            color: #ffeaea;
        }

      
        .app-btn {
            background: linear-gradient(135deg, rgba(255, 80, 80, 0.6), rgba(255, 40, 40, 0.7));
            padding: 10px 16px;
            border-radius: 8px;
            color: #fff;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: 0.25s ease;
            box-shadow: 0 3px 15px rgba(255, 40, 40, 0.5);
        }

        .app-btn:hover {
            background: rgba(255, 40, 40, 0.9);
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(255, 0, 0, 0.6);
        }

        
        @keyframes fadeInOverlay {
            from { opacity: 0; }
            to   { opacity: 1; }
        }

        @keyframes popUp {
            0% { transform: scale(0.6); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .app-footer {
            text-align: center;
            padding: 20px;
            margin-top: 30px;
            color: rgba(255, 255, 255, 0.85);
            font-size: 14px;
            font-weight: 500;
            letter-spacing: 0.5px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(12px);
            border-top: 1px solid rgba(255, 255, 255, 0.25);
            box-shadow: 0 -4px 18px rgba(0, 0, 0, 0.15);
        }

        .app-footer p {
            margin: 5px 0;
        }

        .app-footer strong {
            color: #ffffff;
            text-shadow: 0 0 5px rgba(255,255,255,0.5);
        }
        
        #lstSelectedDates::-webkit-scrollbar {
            width: 10px;
        }

        #lstSelectedDates::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 10px;
        }

        #lstSelectedDates::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.35);
            border-radius: 10px;
            border: 2px solid rgba(255, 255, 255, 0.15);
        }

        #lstSelectedDates::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.55);
        }
        .custom-select-wrapper {
            position: relative;
        }

       
        .custom-select-original {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

     
        .custom-select-display {
            width: 100%;
            padding: 14px 18px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            color: #ffffff;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .custom-select-display::after {
            content: "▼";
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 12px;
            pointer-events: none;
        }

      
        .custom-select-options {
            position: absolute;
            top: calc(100% + 6px);
            left: 0;
            right: 0;
            max-height: 220px;
            overflow-y: auto;
            border-radius: 12px;
            background: rgba(102, 126, 234, 0.96);
            backdrop-filter: blur(14px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.35);
            border: 1px solid rgba(255, 255, 255, 0.3);
            display: none;
            z-index: 9999;
        }

       
        .custom-select-options::-webkit-scrollbar {
            width: 8px;
        }
        .custom-select-options::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
        }
        .custom-select-options::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.4);
            border-radius: 10px;
        }

      
        .custom-option {
            padding: 10px 16px;
            color: #ffffff;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.2s ease, transform 0.1s ease;
        }

        .custom-option:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-1px);
        }

        .custom-option.selected {
            background: rgba(255, 255, 255, 0.28);
        }


        .custom-select-options.open {
            display: block;
        }

   </style>



</head>
<body>
    <form id="form1" class="form" runat="server">
        <button id="btnRefresh" class="refresh-btn" runat="server" onserverclick="btnRefresh_Click">
            <i class="fa fa-refresh"></i> Refresh
        </button>
        
        <div class="container">

            <div class="header-section">
             <h2>⚕️ Physiotherapy Billing Form</h2>
                <p class="subtitle">Fee Management System</p>
            </div>
            <div class="two-column">
            <div class="form-group">
                <label for="txtPatientName">Patient Name<span>*</span></label>
                <asp:TextBox CssClass="input" ID="txtPatientName" runat="server" 
                    placeholder="Enter patient's full name" 
                    onkeyup="validatePatientName(this)"></asp:TextBox>
                <asp:RegularExpressionValidator ID="revPatientName" runat="server" 
                    ControlToValidate="txtPatientName"
                    ValidationExpression="^[A-Za-z\. ]+$"
                    ErrorMessage="Only alphabets and spaces allowed."
                    CssClass="error-message"
                    Display="Dynamic">
                </asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label for="txtAddress">Patient Address<span>*</span></label>
                <asp:TextBox CssClass="input" ID="txtAddress" runat="server" 
                    placeholder="Enter complete address"></asp:TextBox>
                <asp:RegularExpressionValidator ID="revAddress" runat="server"
                    ControlToValidate="txtAddress"
                    ValidationExpression="^[a-zA-Z0-9\s,./\-]+$"
                    ErrorMessage="Only letters, numbers, spaces, /, -, and , are allowed."
                    CssClass="error-message"
                    Display="Dynamic">
                </asp:RegularExpressionValidator>
            </div>
            </div>
            <div class="two-column">
            <div class="form-group">
                <label for="txtBillingDate">Billing Date<span>*</span></label>
                <asp:TextBox CssClass="input" ID="txtBillingDate" runat="server" 
                    placeholder="Select billing date"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtAmount">Charges (per day)<span>*</span></label>
                <asp:TextBox CssClass="input" ID="txtAmount" runat="server" 
                    placeholder="Enter daily charges amount" 
                    onkeyup="validateAmount(this)"></asp:TextBox>
                <asp:RegularExpressionValidator ID="revAmount" runat="server"
                    ControlToValidate="txtAmount"
                    ValidationExpression="^\d+$"
                    ErrorMessage="Only numeric values are allowed."
                    CssClass="error-message"
                    Display="Dynamic">
                </asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label for="ddlCharges">Physiotherapy Type<span>*</span></label>
                <div class="custom-select-wrapper">
                
                <asp:DropDownList ID="ddlCharges" runat="server" CssClass="custom-select-original">
                    <asp:ListItem Value="TKR">TKR REHAB EXERCISES</asp:ListItem>
                    <asp:ListItem Value="THR">THR REHAB EXERCISES</asp:ListItem>
                    <asp:ListItem Value="KNEE">KNEE EXERCISES & GAIT TRAINING</asp:ListItem>
                </asp:DropDownList>

                
                <div class="custom-select-display" id="ddlChargesDisplay"></div>
                <div class="custom-select-options" id="ddlChargesOptions"></div>
            </div>
            </div>
            </div>

            <div class="form-group">
                <label>Select Treatment Date Ranges<span>*</span></label>
                <asp:HiddenField ID="hfSelectedDates" runat="server" />
                <div class="date-range-container">
                    <div class="date-input-wrapper">
                        <input type="text" id="dateRangePicker" class="input-box" 
                            placeholder="Pick date range"/>
                    </div>
                    <asp:Button ID="btnAddDateRange" runat="server" Text="Add Dates" CssClass="small-btn"
                        OnClientClick="addSelectedDates(); return false;" />
                </div>

                <asp:ListBox ID="lstSelectedDates" runat="server" SelectionMode="Multiple"></asp:ListBox>
                
                <div class="btn-group">
                    <asp:Button ID="btnRemoveDate" runat="server" Text="Remove Selected" CssClass="small-btn"
                        OnClientClick="removeSelectedDates(); return false;" />
                </div>
            </div>

            <asp:Button ID="btnGeneratePDF" runat="server" Text="Generate PDF Bill" CssClass="large-btn"
                OnClick="btnGeneratePDF_Click" />
        </div>
    </form>
    <footer class="app-footer">
        <p>Designed & Developed by <a href="https://www.linkedin.com/in/ayan-7564911b2" target="_blank" class="footer-link">
            Ayan Kumar Samanta
        </a></p>
        <p>© <span id="currentYear"></span> Physiotherapy Billing System — All Rights Reserved</p>
    </footer>

    <div id="appModalOverlay" class="app-modal-overlay" role="dialog" aria-modal="true" aria-labelledby="appModalTitle">
      <div class="app-modal" role="document">
        <div id="appModalTitle" class="app-modal-title">Error</div>
        <div id="appModalBody" class="app-modal-body"></div>
        <div class="app-modal-actions">
          <button id="appModalClose" type="button" class="app-btn">OK</button>
        </div>
      </div>
    </div>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            

           
            var selectEl = document.getElementById('<%= ddlCharges.ClientID %>');
            var display = document.getElementById('ddlChargesDisplay');
            var optionsContainer = document.getElementById('ddlChargesOptions');

            if (selectEl && display && optionsContainer) {
               
                display.textContent = selectEl.options[selectEl.selectedIndex].text;

               
                for (var i = 0; i < selectEl.options.length; i++) {
                    var opt = selectEl.options[i];
                    var div = document.createElement('div');
                    div.className = 'custom-option';
                    div.textContent = opt.text;
                    div.dataset.value = opt.value;

                    if (opt.selected) {
                        div.classList.add('selected');
                    }

                    div.addEventListener('click', function () {
                        
                        selectEl.value = this.dataset.value;

                       
                        display.textContent = this.textContent;

                       
                        var all = optionsContainer.querySelectorAll('.custom-option');
                        all.forEach(function (o) { o.classList.remove('selected'); });
                        this.classList.add('selected');

          
                        optionsContainer.classList.remove('open');
                    });

                    optionsContainer.appendChild(div);
                }


                display.addEventListener('click', function (e) {
                    e.stopPropagation();
                    optionsContainer.classList.toggle('open');
                });

                document.addEventListener('click', function (e) {
                    if (!optionsContainer.contains(e.target)) {
                        optionsContainer.classList.remove('open');
                    }
                });
            }
        });

        document.getElementById("currentYear").textContent = new Date().getFullYear();

        (function () {
            var overlay = document.getElementById('appModalOverlay');
            var body = document.getElementById('appModalBody');
            var closeBtn = document.getElementById('appModalClose');

            function showErrorModal(message) {
                if (!overlay) return;
                body.textContent = message || 'An unexpected error occurred.';
                overlay.style.display = 'flex';

                closeBtn.focus();
                document.addEventListener('keydown', onKeyDown);
            }

            function hideErrorModal() {
                if (!overlay) return;
                overlay.style.display = 'none';
                document.removeEventListener('keydown', onKeyDown);
            }

            function onKeyDown(e) {
                if (e.key === 'Escape' || e.key === 'Esc') hideErrorModal();
            }

            closeBtn.addEventListener('click', hideErrorModal);

            window.showErrorModal = showErrorModal;
        })();
    </script>

    <script>
        function validatePatientName(input) {
            input.value = input.value.replace(/[^a-zA-Z\s.]/g, '');
        }

        function validateAmount(input) {
            input.value = input.value.replace(/[^0-9]/g, '');
        }

        document.addEventListener("DOMContentLoaded", function () {
            flatpickr("#dateRangePicker", {
                mode: "range",
                dateFormat: "d/m/Y",
                theme: "light"
            });

            flatpickr("#txtBillingDate", {
                dateFormat: "d/m/Y",
                theme: "light"
            });
        });

        function addSelectedDates() {
            var dateInput = document.getElementById("dateRangePicker").value;
            if (dateInput.trim() === "") {
                showNotification("Please select valid dates.", "error");
                return;
            }

            var listBox = document.getElementById('<%= lstSelectedDates.ClientID %>');
            var hiddenField = document.getElementById('<%= hfSelectedDates.ClientID %>');
            var dateArray = expandDateRange(dateInput);
            var selectedDates = hiddenField.value ? hiddenField.value.split(",") : [];

            var addedCount = 0;
            dateArray.forEach(date => {
                if (!isDateInList(listBox, date)) {
                    var option = document.createElement("option");
                    option.text = date;
                    option.value = date;
                    listBox.appendChild(option);
                    selectedDates.push(date);
                    addedCount++;
                }
            });

            hiddenField.value = selectedDates.join(",");
            if (addedCount > 0) {
                showNotification(`${addedCount} date(s) added successfully!`, "success");
            } else {
                showNotification("All dates already added.", "info");
            }
        }

        function expandDateRange(dateRange) {
            var dates = dateRange.split(" to ");
            if (dates.length === 1) return [dates[0]];

            var start = parseDate(dates[0]);
            var end = parseDate(dates[1]);
            var dateList = [];

            while (start <= end) {
                dateList.push(formatDate(start));
                start.setDate(start.getDate() + 1);
            }
            return dateList;
        }

        function parseDate(dateStr) {
            var parts = dateStr.split("/");
            return new Date(parts[2], parts[1] - 1, parts[0]);
        }

        function formatDate(date) {
            return date.getDate().toString().padStart(2, "0") + "/" +
                (date.getMonth() + 1).toString().padStart(2, "0") + "/" +
                date.getFullYear();
        }

        function isDateInList(listBox, date) {
            for (var i = 0; i < listBox.options.length; i++) {
                if (listBox.options[i].value === date) {
                    return true;
                }
            }
            return false;
        }

        function removeSelectedDates() {
            var listBox = document.getElementById('<%= lstSelectedDates.ClientID %>');
            var hiddenField = document.getElementById('<%= hfSelectedDates.ClientID %>');

            if (listBox.selectedIndex !== -1) {
                var selectedDates = hiddenField.value ? hiddenField.value.split(",") : [];
                var selectedValue = listBox.options[listBox.selectedIndex].value;
                selectedDates = selectedDates.filter(date => date !== selectedValue);
                hiddenField.value = selectedDates.join(",");
                listBox.remove(listBox.selectedIndex);
                showNotification("Date removed successfully!", "success");
            } else {
                showNotification("Please select a date to remove.", "error");
            }
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;
            notification.textContent = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                notification.classList.add('show');
            }, 10);

            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => {
                    document.body.removeChild(notification);
                }, 300);
            }, 3000);
        }
    </script>
</body>
</html>
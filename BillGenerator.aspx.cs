using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.draw;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ListItem = System.Web.UI.WebControls.ListItem;

namespace BillingApplication
{
    public partial class BillGenerator : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                InitializeForm();
            }
        }

        private void InitializeForm()
        {
            
            txtBillingDate.Text = DateTime.Now.ToString("dd/MM/yyyy");

           
            lstSelectedDates.Items.Clear();
            hfSelectedDates.Value = string.Empty;
        }

       
        protected void btnGeneratePDF_Click(object sender, EventArgs e)
        {
            try
            {
               
                if (!ValidateInputs())
                {
                    return;
                }

                
                RestoreDatesToListBox();

               
                string patientName = txtPatientName.Text.Trim();
                string address = txtAddress.Text.Trim();
                int chargeAmount = int.Parse(txtAmount.Text.Trim());
                string selectedCharge = ddlCharges.SelectedItem.Text;
                DateTime billingDate = ParseDate(txtBillingDate.Text.Trim());

                
                byte[] pdfBytes = GeneratePDFDocument(patientName, address, chargeAmount,
                                                       selectedCharge, billingDate);

                
                SendPDFToClient(pdfBytes, patientName);

             
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while generating the PDF: " + ex.Message);
                LogError(ex);
            }
        }


        private bool ValidateInputs()
        {
            
            if (string.IsNullOrWhiteSpace(txtPatientName.Text))
            {
                ShowError("Please enter patient name.");
                return false;
            }

            if (!System.Text.RegularExpressions.Regex.IsMatch(txtPatientName.Text.Trim(), @"^[a-zA-Z\s.]+$"))
            {
                ShowError("Only alphabets and spaces allowed for patient name.");
                return false;
            }

            
            if (string.IsNullOrWhiteSpace(txtAddress.Text))
            {
                ShowError("Please enter patient address.");
                return false;
            }

            if (!System.Text.RegularExpressions.Regex.IsMatch(txtAddress.Text.Trim(), @"^[a-zA-Z0-9\s,./-]+$"))
            {
                ShowError("Only letters, numbers, spaces, comma (,), slash (/), hyphen (-), and dot (.) are allowed for the patient's address.");
                return false;
            }

           
            if (string.IsNullOrWhiteSpace(txtBillingDate.Text))
            {
                ShowError("Please choose one date for bill date.");
                return false;
            }

           
            if (string.IsNullOrWhiteSpace(txtAmount.Text))
            {
                ShowError("Please enter charges that you have taken each day.");
                return false;
            }

            int amount;
            if (!int.TryParse(txtAmount.Text.Trim(), out amount) || amount <= 0)
            {
                ShowError("Please enter a valid positive amount.");
                return false;
            }

            
            if (ddlCharges.SelectedIndex == -1)
            {
                ShowError("Please select one charge from the dropdown.");
                return false;
            }

            
            if (string.IsNullOrWhiteSpace(hfSelectedDates.Value) && lstSelectedDates.Items.Count == 0)
            {
                ShowError("Please select at least one date for billing.");
                return false;
            }

            return true;
        }

  
        private void RestoreDatesToListBox()
        {
            if (lstSelectedDates.Items.Count == 0 && !string.IsNullOrWhiteSpace(hfSelectedDates.Value))
            {
                string[] dates = hfSelectedDates.Value.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string date in dates)
                {
                    if (!string.IsNullOrWhiteSpace(date))
                    {
                        lstSelectedDates.Items.Add(new ListItem(date.Trim()));
                    }
                }
            }
        }


        private DateTime ParseDate(string dateStr)
        {
            DateTime date;
            if (DateTime.TryParseExact(dateStr, "dd/MM/yyyy",
                System.Globalization.CultureInfo.InvariantCulture,
                System.Globalization.DateTimeStyles.None, out date))
            {
                return date;
            }

      
            if (DateTime.TryParse(dateStr, out date))
            {
                return date;
            }

            throw new FormatException("Invalid date format. Please use dd/MM/yyyy format.");
        }

  
        private byte[] GeneratePDFDocument(string patientName, string address, int chargeAmount,
                                           string selectedCharge, DateTime billingDate)
        {
            using (MemoryStream memoryStream = new MemoryStream())
            {
               
                Document doc = new Document(PageSize.A4, 40, 40, 40, 40);
                PdfWriter writer = PdfWriter.GetInstance(doc, memoryStream);
                doc.Open();

               
                AddHeader(doc, billingDate);

                
                doc.Add(new Paragraph("\n"));

                
                AddReceiptTitle(doc);

                
                AddPatientInfo(doc, patientName, address);

                
                AddBillingTable(doc, chargeAmount, selectedCharge);

                
                AddFooter(doc);

                doc.Close();
                writer.Close();

                return memoryStream.ToArray();
            }
        }


        private void AddHeader(Document doc, DateTime billingDate)
        {
            PdfPTable headerTable = new PdfPTable(2);
            headerTable.WidthPercentage = 100;
            headerTable.SetWidths(new float[] { 70f, 30f });

            Font boldFont = FontFactory.GetFont("Arial", 12, Font.BOLD);
            Font normalFont = FontFactory.GetFont("Arial", 10, Font.NORMAL);


            Phrase phrase = new Phrase();
            phrase.Add(new Chunk("Mr. SAYAN KUMAR SAMANTA\n\n", boldFont));
            phrase.Add(new Chunk("B.P.T (WBUHS), KOLKATA\n", normalFont));
            phrase.Add(new Chunk("CONSULTANT PHYSIOTHERAPIST\n", normalFont));
            phrase.Add(new Chunk("MOB: 7688056270\n", normalFont));

            PdfPCell leftCell = new PdfPCell(phrase)
            {
                Border = Rectangle.NO_BORDER,
                HorizontalAlignment = Element.ALIGN_LEFT,
                PaddingBottom = 10
            };


            PdfPCell rightCell = new PdfPCell(new Phrase("Date: " + billingDate.ToString("dd/MM/yyyy"),
                FontFactory.GetFont("Arial", 11, Font.NORMAL)))
            {
                Border = Rectangle.NO_BORDER,
                HorizontalAlignment = Element.ALIGN_RIGHT,
                VerticalAlignment = Element.ALIGN_TOP
            };

            headerTable.AddCell(leftCell);
            headerTable.AddCell(rightCell);

            doc.Add(headerTable);


            LineSeparator line = new LineSeparator(1f, 100f, BaseColor.BLACK, Element.ALIGN_CENTER, -2);
            doc.Add(new Chunk(line));
        }


        private void AddReceiptTitle(Document doc)
        {
            Paragraph receiptTitle = new Paragraph("RECEIPT\n\n",
                FontFactory.GetFont("Arial", 16, Font.BOLD))
            {
                Alignment = Element.ALIGN_CENTER
            };
            doc.Add(receiptTitle);
        }

        private void AddPatientInfo(Document doc, string patientName, string address)
        {
            Font normalFont = FontFactory.GetFont("Arial", 11, Font.NORMAL);
            Font boldFont = FontFactory.GetFont("Arial", 11, Font.BOLD);

            Paragraph patientInfo = new Paragraph();
            patientInfo.Add(new Chunk("Received with thanks from ", normalFont));
            patientInfo.Add(new Chunk(patientName, boldFont));
            patientInfo.Add(new Chunk(" of ", normalFont));
            doc.Add(patientInfo);

            doc.Add(new Paragraph(address + "\n", normalFont));
            doc.Add(new Paragraph("The following amount towards my Professional fees as detailed below:\n\n",
                normalFont));
        }


        private void AddBillingTable(Document doc, int chargeAmount, string selectedCharge)
        {
            PdfPTable table = new PdfPTable(4);
            table.WidthPercentage = 100;
            table.SetWidths(new float[] { 10f, 25f, 40f, 25f });

            // Add headers
            table.AddCell(CreateCell("S.NO.", true, true));
            table.AddCell(CreateCell("DATE", true, true));
            table.AddCell(CreateCell("PHYSIOTHERAPY CHARGES", true, true));
            table.AddCell(CreateCell("AMOUNT", true, true));


            int serialNo = 1;
            int totalAmount = 0;

            foreach (ListItem dateItem in lstSelectedDates.Items)
            {
                table.AddCell(CreateCell(serialNo.ToString(), false, false));
                table.AddCell(CreateCell(dateItem.Text, false, false));
                table.AddCell(CreateCell(selectedCharge, false, false));
                table.AddCell(CreateCell(chargeAmount.ToString(), false, false));

                totalAmount += chargeAmount;
                serialNo++;
            }

            PdfPCell totalLabelCell = new PdfPCell(new Phrase("TOTAL",
                FontFactory.GetFont("Arial", 12, Font.BOLD)))
            {
                Colspan = 3,
                HorizontalAlignment = Element.ALIGN_CENTER,
                BorderWidthTop = 2f,
                BorderWidthBottom = 2f,
                BackgroundColor = new BaseColor(240, 240, 240),
                Padding = 8
            };
            table.AddCell(totalLabelCell);

            PdfPCell totalAmountCell = CreateCell(totalAmount.ToString(), true, true);
            totalAmountCell.BorderWidthTop = 2f;
            totalAmountCell.BorderWidthBottom = 2f;
            totalAmountCell.BackgroundColor = new BaseColor(240, 240, 240);
            table.AddCell(totalAmountCell);

            doc.Add(table);
        }


        private void AddFooter(Document doc)
        {
            doc.Add(new Paragraph("\n\n"));

            Paragraph footer = new Paragraph("Thank you for your payment!",
                FontFactory.GetFont("Arial", 10, Font.ITALIC))
            {
                Alignment = Element.ALIGN_CENTER
            };
            doc.Add(footer);

            Paragraph signature = new Paragraph("\n\n\n_____________________\nAuthorized Signature",
                FontFactory.GetFont("Arial", 10, Font.NORMAL))
            {
                Alignment = Element.ALIGN_RIGHT
            };
            doc.Add(signature);
        }


        private PdfPCell CreateCell(string text, bool isBold, bool isHeader)
        {
            Font font = isBold ?
                FontFactory.GetFont("Arial", 11, Font.BOLD) :
                FontFactory.GetFont("Arial", 10, Font.NORMAL);

            PdfPCell cell = new PdfPCell(new Phrase(text, font))
            {
                HorizontalAlignment = Element.ALIGN_CENTER,
                VerticalAlignment = Element.ALIGN_MIDDLE,
                Padding = isHeader ? 8 : 6,
                BackgroundColor = isHeader ? new BaseColor(230, 230, 230) : BaseColor.WHITE
            };

            return cell;
        }


        private void SendPDFToClient(byte[] pdfBytes, string patientName)
        {
            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AppendHeader("Content-Disposition",
                "attachment; filename=" + SanitizeFileName(patientName) + "_Physiotherapy_Bill.pdf");
            Response.BinaryWrite(pdfBytes);
            Response.Flush();
            Response.End();
        }

        private string SanitizeFileName(string fileName)
        {
            string invalid = new string(Path.GetInvalidFileNameChars());
            foreach (char c in invalid)
            {
                fileName = fileName.Replace(c.ToString(), "");
            }
            return fileName.Replace(" ", "_");
        }

        //private void ShowError(string message)
        //{
        //    Page.ClientScript.RegisterStartupScript(this.GetType(), "Alert",
        //        $"alert('{message.Replace("'", "\\'")}');", true);
        //}
        private void ShowError(string message)
        {
            string safeMessage = HttpUtility.JavaScriptStringEncode(message ?? "");
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "errModal",
                $"setTimeout(function(){{ showErrorModal('{safeMessage}'); }}, 50);",
                true
            );
        }


        private void ClearForm()
        {
            txtPatientName.Text = string.Empty;
            txtAddress.Text = string.Empty;
            txtAmount.Text = string.Empty;
            txtBillingDate.Text = DateTime.Now.ToString("dd/MM/yyyy");
            ddlCharges.SelectedIndex = 0;
            lstSelectedDates.Items.Clear();
            hfSelectedDates.Value = string.Empty;
        }

       
        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            
            ClearForm();
            InitializeForm();
            Response.Redirect(Request.RawUrl);
        }

        private void LogError(Exception ex)
        {
           
            System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
            System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");

            
            try
            {
                string logPath = Server.MapPath("~/Logs/");
                if (!Directory.Exists(logPath))
                {
                    Directory.CreateDirectory(logPath);
                }

                string logFile = Path.Combine(logPath, $"ErrorLog_{DateTime.Now:yyyyMMdd}.txt");
                string logMessage = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {ex.Message}\n{ex.StackTrace}\n\n";

                File.AppendAllText(logFile, logMessage);
            }
            catch
            {
               
            }
        }
    }
}
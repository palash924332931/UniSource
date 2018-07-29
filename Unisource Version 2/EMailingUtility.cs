using System;
using System.Collections.Generic;
using System.Web;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.IO;

namespace UniSourceV2
{
    public class EMailingUtility
    {
        public static void SendMailMessage(string @from, string recepient, string bcc, string cc, string subject, string body)
        {
            try
            {
                MailMessage mMailMessage = new MailMessage(@from, recepient);

                mMailMessage.Headers.Add("Reply-To", "chuckd@unimancorp.com");


                if ((bcc != null) & bcc != string.Empty)
                {
                    mMailMessage.Bcc.Add(new MailAddress(bcc));
                }


                if ((cc != null) & cc != string.Empty)
                {
                    mMailMessage.CC.Add(new MailAddress(cc));
                }

                mMailMessage.Subject = subject;

                mMailMessage.Body = body;
                mMailMessage.IsBodyHtml = false;

                mMailMessage.Priority = MailPriority.Normal;

                SmtpClient mSmtpClient = new SmtpClient();
                mSmtpClient.EnableSsl = true;
                mSmtpClient.Port = 587;
                mSmtpClient.Host = "smtp.gmail.com";
                mSmtpClient.Credentials = new System.Net.NetworkCredential("support@unimancorp.com", "drwMIKE2004uni");

                mSmtpClient.Send(mMailMessage);

                
            }
            catch
            {
                throw;
            }

        }
        private static bool isEmail(string inputEmail)
        {
            var mails = inputEmail.Split(new Char[] { ',', ';' });

            //inputEmail = NulltoString(inputEmail);
            string strRegex = @"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}" +
                  @"\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\" +
                  @".)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$";
            Regex re = new Regex(strRegex);

            Boolean isValidMail = false;

            foreach (var mail in mails)
            {
                if (!String.IsNullOrEmpty(mail))
                {
                    if (re.IsMatch(mail))
                    {
                        isValidMail = true;
                    }
                    else
                    {
                        isValidMail = false;
                        break;
                    }
                }
            }

            return isValidMail;
        }

        public static void SendMailforWorkOrder(string mailTo, string woNo, string ctgName, string pMangrName, string woDtls, string DNECost, string pId, string[] file)
        {
            decimal dneCost;
            if (decimal.TryParse(DNECost, out dneCost))
            {
                DNECost = "$" + dneCost.ToString("0.00");
            }

            string url = "<a href=https://safe.unimancorpaps.com/DataEntry/WorkOrder?category=edit&propertyID=" + pId + "&specificID=" + woNo + ">Unisource Portal</a>";

            string subject = "New Work Order Submitted – " + woNo + " for " + ctgName;
            string body = "Dear " + pMangrName + ",<br /><br />";
            body += "A new work order has been submitted to Unisource. See below for details.<br /><br />";
            body += "Work Order#: <b>" + woNo + "</b><br /><br />";
            body += "Work Requested:<br /><br />";
            body += woDtls + "<br /><br />";
            body += "Do Not Exceed Cost: <b>" + DNECost + "</b><br /><br />";
            body += "To view more details, please click the following link: " + url + "<br/><br/>";
            body += "If you have any questions please contact the Unisource Operations Center at (802) 985-9075.<br /><br /><br />";
            body += "Thank you, <br />";
            body += "Unisource Operations Team";

            //mailTo = "basha@appsynapsis.com;rafay@appsynapsis.com";
            //mailTo = "riaz@appsynapsis.com";
            string bcc = "chuckd@unimancorp.com;nmacedonci@unimancorp.com;dfloyd@unimancorp.com";
            //string bcc = "";
            //SendMailMessage(mailTo, bcc, subject, body);
            SendMailMessage(mailTo, bcc, subject, body, file);
        }
        public static void SendMailforServiceLog(string mailTo, string woNo, string ctgName, string woDtls, string DNECost, string pId, List<prServiceLogInfo_Result> servLog)
        {
            decimal dneCost;
            string[] file = null;
            if (decimal.TryParse(DNECost, out dneCost))
            {
                DNECost = "$" + dneCost.ToString("0.00");
            }

            string url = "<a href=https://safe.unimancorpaps.com/DataEntry/WorkOrder?category=edit&propertyID=" + pId + "&specificID=" + woNo + ">here</a>";

            string subject = "Service Log Updated – Work Order " + woNo + " for " + ctgName;
            string body = "The service log for work order " + woNo + " for " + ctgName + " has been updated with the message(s) below: <br /><br />";
            body += "Work Requested:" + woDtls + "<br /><br />";
            body += "Do Not Exceed Cost: <b>" + DNECost + "</b><br /><br />";
            body += "Service Log: <br/><br/>";
            foreach (prServiceLogInfo_Result srv in servLog)
            {
                body += "" + srv.Serviselog + " by " + srv.UserName + " at " + srv.LogDate + " <br/>";
            }


            body += "<br/><br/>Click " + url + " to view this work order in your browser.<br/><br/>";

            body += "If you have any questions please contact the Unisource Operations Center at (802) 985-9075.<br /><br /><br />";
            body += "Thank you, <br />";
            body += "Unisource Operations Team";

            //mailTo = "basha@appsynapsis.com;rafay@appsynapsis.com";
            //mailTo = "riaz@appsynapsis.com";
            string bcc = "chuckd@unimancorp.com;nmacedonci@unimancorp.com;dfloyd@unimancorp.com";
            //string bcc = "";
            //SendMailMessage(mailTo, bcc, subject, body);
            SendMailMessage(mailTo, bcc, subject, body, file);
        }
        public static void SendMailforInspection(string mailTo, string date, string pName, string pId, string bId)
        {
            string[] file = null;

            string url = "<a href=https://safe.unimancorpaps.com/DataEntry/InspectionReport?category=edit&propertyID=" + pId + "&specificID=" + bId + "/>Unisource Portal</a>";

            string subject = "Property Inspection posted for " + pName;
            string body = "A property inspection has been submitted for your review.<br /><br />";
            body += "Date: <b>" + date + "</b><br /><br />";
            body += "Property:= " + pName + "<br /><br />";

            body += "<br/><br/>Click " + url + " to view this work order in your browser.<br/><br/>";

            body += "If you have any questions please contact the Unisource Operations Center at (802) 985-9075.<br /><br /><br />";
            body += "Thank you, <br />";
            body += "Unisource Operations Team";

            //mailTo = "basha@appsynapsis.com;rafay@appsynapsis.com";
            //mailTo = "riaz@appsynapsis.com";
            string bcc = "chuckd@unimancorp.com;nmacedonci@unimancorp.com;dfloyd@unimancorp.com";
            //string bcc = "";
            //SendMailMessage(mailTo, bcc, subject, body);
            SendMailMessage(mailTo, bcc, subject, body, file);
        }
        public static void SendMailforWorkRequst(string mailTo, string date, string pName, string estCost, string pId, string bNo, string[] file)
        {
            string url = "<a href=https://safe.unimancorpaps.com/DataEntry/WorkRequest?category=edit&propertyID=" + pId + "&specificID=" + bNo + ">Unisource Portal</a>";


            string subject = "Work request posted for " + pName;
            string body = "A work request has been submitted for your review.<br /><br />";
            body += "Date: <b>" + date + "</b><br /><br />";
            body += "Property: " + pName + "<br /><br />";

            body += "Estimated Cost: <b>" + estCost + "</b><br /><br />";

            body += "<br/><br/>Click " + url + " to view this work order in your browser.<br/><br/>";

            body += "If you have any questions please contact the Unisource Operations Center at (802) 985-9075.<br /><br /><br />";
            body += "Thank you, <br />";
            body += "Unisource Operations Team";

            //mailTo = "basha@appsynapsis.com;rafay@appsynapsis.com";
            //mailTo = "riaz@appsynapsis.com";
            string bcc = "chuckd@unimancorp.com;nmacedonci@unimancorp.com;dfloyd@unimancorp.com";
            //string bcc = "";
            //SendMailMessage(mailTo, bcc, subject, body);
            SendMailMessage(mailTo, bcc, subject, body, file);
        }
        public static void SendMailforSnowReport(string mailTo, string date, string pName, string pId, string bId)
        {
           // string[] file = null;

            string url = "<a href=https://safe.unimancorpaps.com/DataEntry/InspectionReport?category=edit&propertyID=" + pId + "&specificID=" + bId + "/>Unisource Portal</a>";

            string subject = "Property Inspection posted for " + pName;
            string body = "A property inspection has been submitted for your review.<br /><br />";
            body += "Date: <b>" + date + "</b><br /><br />";
            body += "Property:= " + pName + "<br /><br />";

            body += "<br/><br/>Click " + url + " to view this work order in your browser.<br/><br/>";

            body += "If you have any questions please contact the Unisource Operations Center at (802) 985-9075.<br /><br /><br />";
            body += "Thank you, <br />";
            body += "Unisource Operations Team";

            //mailTo = "basha@appsynapsis.com;rafay@appsynapsis.com";
            //mailTo = "riaz@appsynapsis.com";
           // string bcc = "chuckd@unimancorp.com;nmacedonci@unimancorp.com;dfloyd@unimancorp.com";
            //string bcc = "";
            //SendMailMessage(mailTo, bcc, subject, body);
            //SendMailMessage(mailTo, bcc, subject, body, file);
        }
        private static void SendMailMessage(string mailTo, string bcc, string subject, string body, string[] file)
        {
            //string zipFile = @"C:/WEBSITES/WebPortal/Pictures/Images.zip";
            MailMessage mMailMessage = new MailMessage();
            try
            {
                mMailMessage.From = new MailAddress("Unisource Property Management <support@unimancorp.com>");
                mMailMessage.Headers.Add("Reply-To", "chuckd@unimancorp.com");

                if ((mailTo != null) & mailTo != string.Empty)
                {
                    var mails = mailTo.Split(new Char[] { ',', ';' });
                    foreach (var mail in mails)
                    {
                        if (isEmail(mail))
                            mMailMessage.To.Add(new MailAddress(mail));
                    }
                }

                if ((bcc != null) & bcc != string.Empty)
                {
                    var mails = bcc.Split(new Char[] { ',', ';' });
                    foreach (var mail in mails)
                    {
                        if (isEmail(mail))
                            mMailMessage.Bcc.Add(new MailAddress(mail));
                    }
                }

                if (file != null)
                {
                    int name = 1;
                    foreach (string address in file)
                    {
                        if (!string.IsNullOrEmpty(address))
                        {
                            MemoryStream ms = new MemoryStream(File.ReadAllBytes(address));
                            mMailMessage.Attachments.Add(new Attachment(ms, name + ".png"));
                            ms.Position = 0;
                        }
                        name++;
                    }
                }


                mMailMessage.Subject = subject;

                mMailMessage.Body = body;
                mMailMessage.IsBodyHtml = true;

                mMailMessage.Priority = MailPriority.Normal;

                SmtpClient mSmtpClient = new SmtpClient();
                mSmtpClient.EnableSsl = true;
                mSmtpClient.Port = 587;
                mSmtpClient.Host = "smtp.gmail.com";
                mSmtpClient.Credentials = new System.Net.NetworkCredential("support@unimancorp.com", "drwMIKE2004uni");

                mSmtpClient.Send(mMailMessage);


            }
            catch
            {
                throw;
            }
            finally
            {
                mMailMessage.Dispose();
                //File.Delete(zipFile);
            }
        }
    }
}

//mailTo = "riaz.mazumder@gmail.com;rafay.fx@gmail.com";
//string bcc = "chuckd@unimancorp.com,nmacedonci@unimancorp.com,jfitzcharles@unimancorp.com,jsharkey@unimancorp.com,bprim@unimancorp.com";
//string bcc = "basha@appsynapsis.com;rafay@appsynapsis.com";
//SendMailMessage(mailTo, bcc, subject, body);

//body += "If you have any questions please contact the Unisource Operations Center at (802) 985-9075.<br /><br /><br />";
//           body += "Thank you, <br />";
//           body += "Unisource Operations Team";
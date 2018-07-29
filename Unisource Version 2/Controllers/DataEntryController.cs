using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UniSourceV2.Models;

namespace UniSourceV2.Controllers
{
    public class DataEntryController : Controller
    {
        //
        // GET: /DataEntry/
        pIworkRequestInfo_Result pi = new pIworkRequestInfo_Result();

        public ActionResult Index()
        {
            return View();
        }
        public ActionResult WorkRequest()
        {
            return View();
        }
        [HttpPost]
        public ActionResult WorkRequest(pIworkRequestInfo_Result dataset, string Action, string notes, string TempDeletedImage, string SendMail)
        {
            var PropertyID = dataset.propertyid.ToString();
            var reportHeader = dataset.reportheader.ToString();
            var currentDate = DateTime.Now.ToString("yyyy-MM-dd");
            var currentTime = DateTime.Now.ToString("t", CultureInfo.CreateSpecificCulture("en-us"));
            //string curYearTwoDigit = DateTime.Now.Year.ToString().Substring(2, 2).ToString();
            string GuiID = Guid.NewGuid().ToString();
            var UserID = Session["UserID"];
            //var status = false;
            var WPID = "";// "WP" + curYearTwoDigit + "" + GuiID.Split('-')[1].ToUpper();
            string pic1 = "", pic2 = "", pic3 = "", pic4 = "", pic5 = "";

            if (Action == "New")
            {
                Session["category"] = "Created";
                using (DBEntities dc = new DBEntities())
                {
                    //delete temp images
                    DeleteTemImage(TempDeletedImage);


                    DirectoryInfo directoryInfo = new DirectoryInfo(Server.MapPath("~/Content/Temp/" + UserID + "/"));
                    if (directoryInfo.Exists)
                    {
                        string rootFolder = "~/DailyReports/" + PropertyID + "/" + GuiID;
                        var counter = 0;
                        string internalExtension = string.Concat("*.", "*");
                        FileInfo[] fileInfo = directoryInfo.GetFiles(internalExtension, SearchOption.AllDirectories);
                        ResizeImages(fileInfo);
                        if (!Directory.Exists(Server.MapPath(rootFolder)))
                        {
                            Directory.CreateDirectory(Server.MapPath(rootFolder));
                        }
                        foreach (FileInfo fileInfoTemp in fileInfo)
                        {
                            counter = counter + 1;
                            var fileDic = fileInfoTemp.Directory;
                            var fileDicName = fileInfoTemp.DirectoryName;
                            fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s1.png"));
                            ResizeImage(fileInfoTemp, 100, 75);
                            fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s2.png"));

                            //Bitmap objBitmap = new Bitmap("~/DailyReports/", new Size(227, 171));
                            string extension = fileInfoTemp.Extension;
                        }

                    }
                    try
                    {
                        //to insert in daily report table.
                        dc.pIdailyReports(WPID, dataset.propertyid, currentDate, currentTime, currentDate, currentTime, GuiID, dataset.approvalstatus.ToString(), dataset.reportheader, dataset.reporttext, dataset.hazard.ToString(), dataset.maintenance.ToString(), pic1, pic2, pic3, pic4, pic5, dataset.costestimate, dataset.costtotal, dataset.taxrate, UserID.ToString());

                    }
                    catch { throw; }

                    var message = "/Details/ProductDetails?category=Work%20Request&property=" + dataset.propertyid.ToString();
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            else if (Action == "Update")
            {
                using (DBEntities dc = new DBEntities())
                {
                    //delete temp images
                    DeleteTemImage(TempDeletedImage);
                    string rootFolder = "";
                    //for image upload
                    DirectoryInfo directoryInfo = new DirectoryInfo(Server.MapPath("~/Content/Temp/" + UserID + "/"));
                    if (directoryInfo.Exists)
                    {
                        rootFolder = "~/DailyReports/" + PropertyID + "/" + dataset.batchnumber + "/";
                        // "~/DailyReports/" + PropertyID + "/" + GuiID;
                        var counter = 0;
                        //check root directory is exists                        
                        string internalExtension = string.Concat("*.", "*");
                        FileInfo[] fileInfo = directoryInfo.GetFiles(internalExtension, SearchOption.AllDirectories);
                        ResizeImages(fileInfo);
                        if (Directory.Exists(Server.MapPath(rootFolder)))
                        {

                            foreach (FileInfo fileInfoTemp in fileInfo)
                            {
                                counter = CountExistImage(rootFolder);
                                var fileDic = fileInfoTemp.Directory;
                                var fileDicName = fileInfoTemp.DirectoryName;
                                fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "Photo_" + counter + ".s1.png"));
                                ResizeImage(fileInfoTemp, 100, 75);
                                fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "Photo_" + counter + ".s2.png"));

                                string extension = fileInfoTemp.Extension;
                            }
                        }
                        else
                        {
                            Directory.CreateDirectory(Server.MapPath(rootFolder));
                            foreach (FileInfo fileInfoTemp in fileInfo)
                            {
                                counter = counter + 1;
                                var fileDic = fileInfoTemp.Directory;
                                var fileDicName = fileInfoTemp.DirectoryName;
                                fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "Photo_" + counter + ".s1.png"));
                                ResizeImage(fileInfoTemp, 100, 75);
                                fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "Photo_" + counter + ".s2.png"));
                                string extension = fileInfoTemp.Extension;
                            }
                        }
                    }

                    //end of image upload code

                    // dc.pUDailyReports(dataset.propertyid.ToString(), dataset.batchnumber.ToString(), dataset.reportheader.ToString(), dataset.reporttext.ToString(), dataset.hazard.ToString(), dataset.maintenance.ToString(), dataset.costestimate.ToString(), dataset.taxrate.ToString(), dataset.costtotal.ToString(), dataset.approvalstatus.ToString(), notes, UserID.ToString());
                    dc.pUDailyReports(dataset.propertyid, dataset.batchnumber.ToString(), dataset.reportheader.ToString(), dataset.reporttext.ToString(), dataset.hazard.ToString(), dataset.maintenance.ToString(), dataset.costestimate, dataset.taxrate.ToString(), dataset.costtotal.ToString(), dataset.approvalstatus.ToString(), notes.ToString(), UserID.ToString());
                    //dc.pUDailyReports(dataset.propertyid,);


                    if (SendMail == "true")
                    {
                        string[] array = GetImages(rootFolder);
                        var result = dc.prAllPropertiesUserWise(Session["UserID"].ToString()).Where(x => x.propertyid == PropertyID).FirstOrDefault();
                        EMailingUtility.SendMailforWorkRequst(result.emailalerts, currentDate, result.displayname, dataset.costestimate, dataset.propertyid, dataset.batchnumber.ToString(), array);

                    }
                    var message = "/Details/ProductDetails?category=Work%20Request&property=" + dataset.propertyid.ToString();
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            return View();
        }
        public ActionResult WorkOrder()
        {
            return View();
        }
        [HttpPost]
        public ActionResult WorkOrder(string wonumber, string propertyid, string approvalstatus, string worktobedone, string request_name, string request_email, string request_phone, string workcompleted, string business_unit, string company_unit, string estimatedCompletionDate, string markupCost, string completionDate, string dNEcost, string uNIcost, string uNIcontractor_cost, string taxCost, string dailyreport_batchnumber, string TempDeletedImage, string ServiseLog, string ClosedDate, string VendorId, string POID, string Action)
        {
            var currentDate = DateTime.Now.ToString("yyyy-MM-dd");
            var currentTime = DateTime.Now.ToString("t", CultureInfo.CreateSpecificCulture("en-us"));
            string curYearTwoDigit = DateTime.Now.Year.ToString().Substring(2, 2).ToString();
            string GuiID = Guid.NewGuid().ToString();
            var UserID = Session["UserID"];
            var WONumber = "";// "U" + curYearTwoDigit + "" + GuiID.Split('-')[1].ToUpper();
           // string batchnumber = " ";
            //string pic1 = "", pic2 = "", pic3 = "", pic4 = "", pic5 = "";

            // dc.pIWorkOrder(WONumber, propertyid, currentDate, currentTime, currentDate, currentTime, approvalstatus, worktobedone, request_name, request_email, request_phone, workcompleted, business_unit, company_unit, dNEcost, uNIcost, uNIcontractor_cost, batchnumber, UserID.ToString());

            if (Action == "New")
            {
                using (DBEntities dc = new DBEntities())
                {
                    //delete temp images
                    DeleteTemImage(TempDeletedImage);
                    string rootFolder = "";
                    Session["category"] = "Created";
                    WONumber = dc.prGetRecordID("Work Order", "U").ToList().SingleOrDefault();
                    //   var rootFolder = "~/Content/Temp/WorkOrder/" + Session["UserID"];
                    DirectoryInfo directoryInfo = new DirectoryInfo(Server.MapPath("~/Content/Temp/WorkOrder/" + UserID + "/"));
                    if (directoryInfo.Exists)
                    {
                        rootFolder = "~/Pictures/WorkOrder/" + WONumber;
                        var counter = 0;
                        string internalExtension = string.Concat("*.", "*");
                        FileInfo[] fileInfo = directoryInfo.GetFiles(internalExtension, SearchOption.AllDirectories);
                        ResizeImages(fileInfo);
                        if (Directory.Exists(Server.MapPath(rootFolder)))
                        {
                            foreach (FileInfo fileInfoTemp in fileInfo)
                            {
                                counter = counter + 1;
                                var fileDic = fileInfoTemp.Directory;
                                var fileDicName = fileInfoTemp.DirectoryName;
                                fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s1.png"));
                                ResizeImage(fileInfoTemp, 100, 75);
                                fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s2.png"));

                                //Bitmap objBitmap = new Bitmap("~/DailyReports/", new Size(227, 171));
                                string extension = fileInfoTemp.Extension;
                            }
                        }
                        else
                        {
                            Directory.CreateDirectory(Server.MapPath(rootFolder));
                            foreach (FileInfo fileInfoTemp in fileInfo)
                            {
                                counter = counter + 1;
                                var fileDic = fileInfoTemp.Directory;
                                var fileDicName = fileInfoTemp.DirectoryName;
                                fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s1.png"));
                                ResizeImage(fileInfoTemp, 100, 75);
                                fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s2.png"));
                                string extension = fileInfoTemp.Extension;
                            }
                        }
                    }
                    try
                    {
                        //to insert in work order table.
                        dc.pIWorkOrder(WONumber, propertyid, currentDate, currentTime, currentDate, currentTime, approvalstatus, worktobedone, request_name, request_email, request_phone, workcompleted, business_unit, company_unit, dNEcost, uNIcost, uNIcontractor_cost, GuiID, UserID.ToString());

                        //mail send     
                        if (Session["UserID"].ToString() != "brixwo")
                        {
                            string[] array = GetImages(rootFolder);
                            var result = dc.prAllPropertiesUserWise(Session["UserID"].ToString()).Where(x => x.propertyid == propertyid).FirstOrDefault();
                            EMailingUtility.SendMailforWorkOrder(result.emailalerts, WONumber, result.displayname, Session["UserFullName"].ToString(), worktobedone, dNEcost, propertyid, array);
                        }
                    }
                    catch { throw; }

                    //var message = "/Details/ProductDetails?category=Work Order&property=" + propertyid;
                    var message = "/DataEntry/WorkOrder?category=edit&propertyID=" + propertyid + "&specificID=" + WONumber;
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            if (Action == "R-New")
            {
                using (DBEntities dc = new DBEntities())
                {
                    //delete temp images
                    DeleteTemImage(TempDeletedImage);
                    string rootFolder = "";
                    Session["category"] = "Created";
                    WONumber = dc.prGetRecordID("Work Order", "U").ToList().SingleOrDefault();
                    //   var rootFolder = "~/Content/Temp/WorkOrder/" + Session["UserID"];
                    DirectoryInfo directoryInfo = new DirectoryInfo(Server.MapPath("~/Content/Temp/WorkOrder/" + UserID + "/"));
                    if (directoryInfo.Exists)
                    {
                        rootFolder = "~/Pictures/WorkOrder/" + WONumber;
                        var counter = 0;
                        string internalExtension = string.Concat("*.", "*");
                        FileInfo[] fileInfo = directoryInfo.GetFiles(internalExtension, SearchOption.AllDirectories);
                        ResizeImages(fileInfo);
                        if (Directory.Exists(Server.MapPath(rootFolder)))
                        {
                            foreach (FileInfo fileInfoTemp in fileInfo)
                            {
                                counter = counter + 1;
                                var fileDic = fileInfoTemp.Directory;
                                var fileDicName = fileInfoTemp.DirectoryName;
                                fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s1.png"));
                                ResizeImage(fileInfoTemp, 100, 75);
                                fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s2.png"));

                                //Bitmap objBitmap = new Bitmap("~/DailyReports/", new Size(227, 171));
                                string extension = fileInfoTemp.Extension;
                            }
                        }
                        else
                        {
                            Directory.CreateDirectory(Server.MapPath(rootFolder));
                            foreach (FileInfo fileInfoTemp in fileInfo)
                            {
                                counter = counter + 1;
                                var fileDic = fileInfoTemp.Directory;
                                var fileDicName = fileInfoTemp.DirectoryName;
                                fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s1.png"));
                                ResizeImage(fileInfoTemp, 100, 75);
                                fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s2.png"));
                                string extension = fileInfoTemp.Extension;
                            }
                        }
                    }
                    try
                    {
                        //to insert in work order table.
                        dc.pIWorkOrderForRaymour(WONumber, propertyid, currentDate, currentTime, currentDate, currentTime, approvalstatus, worktobedone, request_name, request_email, request_phone, workcompleted, business_unit, company_unit, dNEcost, uNIcost, uNIcontractor_cost, GuiID, POID, UserID.ToString());

                        //mail send     
                        if (Session["UserID"].ToString() != "brixwo")
                        {
                            string[] array = GetImages(rootFolder);
                            var result = dc.prAllPropertiesUserWise(Session["UserID"].ToString()).Where(x => x.propertyid == propertyid).FirstOrDefault();
                            EMailingUtility.SendMailforWorkOrder(result.emailalerts, WONumber, result.displayname, Session["UserFullName"].ToString(), worktobedone, dNEcost, propertyid, array);
                        }
                    }
                    catch { throw; }

                    //var message = "/Details/ProductDetails?category=Work Order&property=" + propertyid;
                    var message = "/DataEntry/WorkOrder?category=edit&propertyID=" + propertyid + "&specificID=" + WONumber;
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            else if (Action == "SoureceWorkProposal")
            {
                if (string.IsNullOrWhiteSpace(POID) == true)
                {
                    POID = "";
                }
                using (DBEntities dc = new DBEntities())
                {
                    Session["category"] = "Created";
                    WONumber = dc.prGetRecordID("Work Order", "U").ToList().SingleOrDefault();
                    string rootFolder = "~/Pictures/WorkOrder/" + WONumber + "/";
                    string workProposalRootPath = "~/DailyReports/" + propertyid + "/" + dailyreport_batchnumber + "/";

                    DirectoryInfo directoryInfoTemp = new DirectoryInfo(Server.MapPath("~/Content/Temp/WorkOrder/" + UserID + "/"));
                    DirectoryInfo directoryInfoRoot = new DirectoryInfo(Server.MapPath(rootFolder));
                    DirectoryInfo directoryInfoWP = new DirectoryInfo(Server.MapPath(workProposalRootPath));
                    //destination root check
                    if (!directoryInfoRoot.Exists)
                    {
                        Directory.CreateDirectory(Server.MapPath(rootFolder));
                    }

                    //rootPath = "~/DailyReports/" + propertyID + "/" + batchID + "/";
                    var counter = 0;
                    string internalExtension = string.Concat("*.", "*");

                    /*****************copy image form work proposal folder*******************/
                    if (directoryInfoWP.Exists)
                    {
                        FileInfo[] fileInfoWP = directoryInfoWP.GetFiles().Where(x => x.Name.Contains("s1")).ToArray();
                        
                        foreach (FileInfo fileInfoWorkProp in fileInfoWP)
                        {
                            counter = counter + 1;
                            var fileDic = fileInfoWorkProp.Directory;
                            var fileDicName = fileInfoWorkProp.DirectoryName;
                            fileInfoWorkProp.CopyTo(Server.MapPath(rootFolder + "Photo_" + counter + ".s1.png"));                           
                            fileInfoWorkProp.CopyTo(Server.MapPath(rootFolder + "Photo_" + counter + ".s2.png"));

                            string extension = fileInfoWorkProp.Extension;

                        }
                    }
                    /***************************to check temp folder **********************************************/
                    if (directoryInfoTemp.Exists)
                    {
                        FileInfo[] fileInfo = directoryInfoTemp.GetFiles(internalExtension, SearchOption.AllDirectories);
                        ResizeImages(fileInfo);
                        foreach (FileInfo fileInfoTemp in fileInfo)
                        {
                            counter = counter + 1;
                            var fileDic = fileInfoTemp.Directory;
                            var fileDicName = fileInfoTemp.DirectoryName;
                            fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s1.png"));
                            ResizeImage(fileInfoTemp, 100, 75);
                            fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s2.png"));

                            //Bitmap objBitmap = new Bitmap("~/DailyReports/", new Size(227, 171));
                            string extension = fileInfoTemp.Extension;
                        }
                    }

                    try
                    {
                        //to insert in work order table.
                        dc.pIWorkOrderFromWorkProposal(WONumber, propertyid, currentDate, currentTime, currentDate, currentTime, approvalstatus, worktobedone, request_name, request_email, request_phone, workcompleted, business_unit, company_unit, dNEcost, uNIcost, uNIcontractor_cost, dailyreport_batchnumber, GuiID, POID, UserID.ToString());

                        if (Session["UserID"].ToString() != "brixwo")
                        {
                            string[] array = GetImages(rootFolder);
                            var result = dc.prAllPropertiesUserWise(Session["UserID"].ToString()).Where(x => x.propertyid == propertyid).FirstOrDefault();
                            EMailingUtility.SendMailforWorkOrder(result.emailalerts, WONumber, result.displayname, Session["UserFullName"].ToString(), worktobedone, dNEcost, null, array);
                        }
                    }
                    catch { throw; }
                    //var message = "/Details/ProductDetails?category=Work Order&property=" + propertyid;
                    var message = "/DataEntry/WorkOrder?category=edit&propertyID=" + propertyid + "&specificID=" + WONumber;
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            else if (Action == "Update")
            {
                DateTime LogDate = DateTime.Now;
                using (DBEntities dc = new DBEntities())
                {
                    //delete temp images
                    DeleteTemImage(TempDeletedImage);

                    DirectoryInfo directoryInfo = new DirectoryInfo(Server.MapPath("~/Content/Temp/WorkOrder/" + UserID + "/"));
                    if (directoryInfo.Exists)
                    {
                        string rootFolder = "~/Pictures/WorkOrder/" + wonumber + "/";
                        var counter = 0;
                        //check root directory is exists                        
                        string internalExtension = string.Concat("*.", "*");
                        FileInfo[] fileInfo = directoryInfo.GetFiles(internalExtension, SearchOption.AllDirectories);
                        ResizeImages(fileInfo);
                        if (!Directory.Exists(Server.MapPath(rootFolder)))
                        {
                            Directory.CreateDirectory(Server.MapPath(rootFolder));
                        }
                        //DirectoryInfo rootDirectoryInfo = new DirectoryInfo(Server.MapPath(rootFolder));
                        //counter = rootDirectoryInfo.GetFiles().Count(x => x.Name.Contains("s1"));
                        foreach (FileInfo fileInfoTemp in fileInfo)
                        {
                            counter = CountExistImage(rootFolder);
                            var fileDic = fileInfoTemp.Directory;
                            var fileDicName = fileInfoTemp.DirectoryName;
                            fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "Photo_" + counter + ".s1.png"));
                            ResizeImage(fileInfoTemp, 100, 75);
                            fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "Photo_" + counter + ".s2.png"));

                            string extension = fileInfoTemp.Extension;
                        }
                    }

                    //to update work order
                    try
                    {
                        dc.pUWorkOrder(wonumber, propertyid, approvalstatus, worktobedone, request_name, request_email, request_phone, workcompleted, dNEcost, uNIcost, uNIcontractor_cost, "", estimatedCompletionDate, completionDate, markupCost, taxCost, ServiseLog, LogDate, ClosedDate, UserID.ToString(), VendorId, POID);


                        if (!string.IsNullOrEmpty(ServiseLog) && workcompleted == "true")
                        {
                            var srvsLog = dc.prServiceLogInfo(wonumber, Session["UserID"].ToString()).ToList();
                            var result = dc.prAllPropertiesUserWise(Session["UserID"].ToString()).Where(x => x.propertyid == propertyid).FirstOrDefault();
                            EMailingUtility.SendMailforServiceLog(result.emailalerts, wonumber, result.displayname, worktobedone, dNEcost, propertyid, srvsLog);
                        }
                    }
                    catch { throw; }
                    //var message = "/Details/ProductDetails?category=Work Order&property=" + propertyid;
                    var message = "/DataEntry/WorkOrder?category=edit&propertyID=" + propertyid + "&specificID=" + wonumber;
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            return View();
        }

        //private void SendMail(string ServiseLog, DateTime LogDate)
        //{
        //    string body = ServiseLog + " by " + Session["UserFullName"].ToString() + " at " + LogDate + "<br /><br />";
        //    body += "Thank you, <br />";
        //    body += "Unisource Operations Team";
        //    EMailingUtility.SendMailMessage(body);
        //}
        public ActionResult PropertyInspection()
        {
            return View();
        }
        [HttpPost]
        public ActionResult PropertyInspection(string PropertyID, string ApprovalStatus, string ValuesArray, string Action, string ItemCategory, string BatchID, string TempDeletedImage, string SendMail)
        {
            if (Action == "New")
            {
                //delete temp images
                DeleteTemImage(TempDeletedImage);

                Session["category"] = "Created";
                var currentDate = DateTime.Now.ToString("yyyy-MM-dd");
                var currentTime = DateTime.Now.ToString("t", CultureInfo.CreateSpecificCulture("en-us"));
                string curYearTwoDigit = DateTime.Now.Year.ToString().Substring(2, 2).ToString();
                string GuiID = Guid.NewGuid().ToString();
                var UserID = Session["UserID"];
                var InsID = "WP" + curYearTwoDigit + "" + GuiID.Split('-')[1].ToUpper();
                //string pic1 = "", pic2 = "", pic3 = "", pic4 = "", pic5 = "";
                //string ApprovalStatus = "1";
                string[] ValuesArrary = ValuesArray.Split('|');
                //to save image from temp.

                MoveFolderActualLocation("Move", "Inspection", "PropertyInspections", "PreviousName", "", PropertyID, GuiID);


                using (DBEntities dc = new DBEntities())
                {
                    try
                    {
                        dc.PIPropertyInspection(Action, PropertyID, currentDate, currentDate, currentTime, UserID.ToString(), ApprovalStatus, GuiID, ValuesArrary[0], ValuesArrary[1], ValuesArrary[2], ValuesArrary[3], ValuesArrary[4], ValuesArrary[5], ValuesArrary[6], ValuesArrary[7], ValuesArrary[8], ValuesArrary[9], ValuesArrary[10], ValuesArrary[11], ValuesArrary[12], ValuesArrary[13], ValuesArrary[14], ValuesArrary[15], ValuesArrary[16], ValuesArrary[17], ValuesArrary[18], ValuesArrary[19], ValuesArrary[20], ValuesArrary[21], ValuesArrary[22], ValuesArrary[23], ValuesArrary[24], ValuesArrary[25], ValuesArrary[26], ValuesArrary[27], ValuesArrary[28], ValuesArrary[29], ValuesArrary[30], ValuesArrary[31], ValuesArrary[32], ValuesArrary[33], ValuesArrary[34], ValuesArrary[35], ValuesArrary[36], ValuesArrary[37], ValuesArrary[38], ValuesArrary[39], ValuesArrary[40], ValuesArrary[41], ValuesArrary[42], ValuesArrary[43], ValuesArrary[44], ValuesArrary[45], ValuesArrary[46], ValuesArrary[47], ValuesArrary[48], ValuesArrary[49], ValuesArrary[50], ValuesArrary[51], ValuesArrary[52], ValuesArrary[53], ValuesArrary[54], ValuesArrary[55], ValuesArrary[56], ValuesArrary[57], ValuesArrary[58], ValuesArrary[59], ValuesArrary[60], ValuesArrary[61], ValuesArrary[62], ValuesArrary[63], ValuesArrary[64], ValuesArrary[65], ValuesArrary[66], ValuesArrary[67], ValuesArrary[68], ValuesArrary[69], ValuesArrary[70], ValuesArrary[71], ValuesArrary[72], ValuesArrary[73], ValuesArrary[74], ValuesArrary[75], ValuesArrary[76], ValuesArrary[77], ValuesArrary[78], ValuesArrary[79], ValuesArrary[80], ValuesArrary[81], ValuesArrary[82], ValuesArrary[83], ValuesArrary[84], ValuesArrary[85], ValuesArrary[86], ValuesArrary[87], ValuesArrary[88], ValuesArrary[89], ValuesArrary[90], ValuesArrary[91], ValuesArrary[92], ValuesArrary[93], ValuesArrary[94], ValuesArrary[95], ValuesArrary[96], ValuesArrary[97], ValuesArrary[98], ValuesArrary[99], ValuesArrary[100], ValuesArrary[101], ValuesArrary[102], ValuesArrary[103], ValuesArrary[104], ValuesArrary[105]);

                    }
                    catch { throw; }

                    var message = "/Details/ProductDetails?category=Property Inspections&property=" + PropertyID.ToString();
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            else if (Action == "Update")
            {
                //delete temp images
                DeleteTemImage(TempDeletedImage);

                Session["category"] = "Created";
                var currentDate = DateTime.Now.ToString("yyyy-MM-dd");
                var currentTime = DateTime.Now.ToString("t", CultureInfo.CreateSpecificCulture("en-us"));
                string curYearTwoDigit = DateTime.Now.Year.ToString().Substring(2, 2).ToString();
                string GuiID = Guid.NewGuid().ToString();
                var UserID = Session["UserID"];
                var InsID = "WP" + curYearTwoDigit + "" + GuiID.Split('-')[1].ToUpper();
                //string pic1 = "", pic2 = "", pic3 = "", pic4 = "", pic5 = "";
                //string ApprovalStatus = "1";
                string[] ValuesArrary = ValuesArray.Split('|');

                MoveFolderActualLocation("Move", "Inspection", "PropertyInspections", "PreviousName", "", PropertyID, BatchID);

                using (DBEntities dc = new DBEntities())
                {
                    dc.PIPropertyInspection(Action, PropertyID, currentDate, currentDate, currentTime, UserID.ToString(), ApprovalStatus, BatchID, ValuesArrary[0], ValuesArrary[1], ValuesArrary[2], ValuesArrary[3], ValuesArrary[4], ValuesArrary[5], ValuesArrary[6], ValuesArrary[7], ValuesArrary[8], ValuesArrary[9], ValuesArrary[10], ValuesArrary[11], ValuesArrary[12], ValuesArrary[13], ValuesArrary[14], ValuesArrary[15], ValuesArrary[16], ValuesArrary[17], ValuesArrary[18], ValuesArrary[19], ValuesArrary[20], ValuesArrary[21], ValuesArrary[22], ValuesArrary[23], ValuesArrary[24], ValuesArrary[25], ValuesArrary[26], ValuesArrary[27], ValuesArrary[28], ValuesArrary[29], ValuesArrary[30], ValuesArrary[31], ValuesArrary[32], ValuesArrary[33], ValuesArrary[34], ValuesArrary[35], ValuesArrary[36], ValuesArrary[37], ValuesArrary[38], ValuesArrary[39], ValuesArrary[40], ValuesArrary[41], ValuesArrary[42], ValuesArrary[43], ValuesArrary[44], ValuesArrary[45], ValuesArrary[46], ValuesArrary[47], ValuesArrary[48], ValuesArrary[49], ValuesArrary[50], ValuesArrary[51], ValuesArrary[52], ValuesArrary[53], ValuesArrary[54], ValuesArrary[55], ValuesArrary[56], ValuesArrary[57], ValuesArrary[58], ValuesArrary[59], ValuesArrary[60], ValuesArrary[61], ValuesArrary[62], ValuesArrary[63], ValuesArrary[64], ValuesArrary[65], ValuesArrary[66], ValuesArrary[67], ValuesArrary[68], ValuesArrary[69], ValuesArrary[70], ValuesArrary[71], ValuesArrary[72], ValuesArrary[73], ValuesArrary[74], ValuesArrary[75], ValuesArrary[76], ValuesArrary[77], ValuesArrary[78], ValuesArrary[79], ValuesArrary[80], ValuesArrary[81], ValuesArrary[82], ValuesArrary[83], ValuesArrary[84], ValuesArrary[85], ValuesArrary[86], ValuesArrary[87], ValuesArrary[88], ValuesArrary[89], ValuesArrary[90], ValuesArrary[91], ValuesArrary[92], ValuesArrary[93], ValuesArrary[94], ValuesArrary[95], ValuesArrary[96], ValuesArrary[97], ValuesArrary[98], ValuesArrary[99], ValuesArrary[100], ValuesArrary[101], ValuesArrary[102], ValuesArrary[103], ValuesArrary[104], ValuesArrary[105]);
                    if (SendMail == "true")
                    {
                        var result = dc.prAllPropertiesUserWise(Session["UserID"].ToString()).Where(x => x.propertyid == PropertyID).FirstOrDefault();
                        EMailingUtility.SendMailforInspection(result.emailalerts, currentDate, result.displayname, PropertyID, BatchID);
                    }
                    var message = "/Details/ProductDetails?category=Property Inspections&property=" + PropertyID.ToString();
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            else if (Action == "GetInfo")
            {
                using (DBEntities dc = new DBEntities())
                {
                    if (Session["UserID"] != null)
                    {
                        var result = dc.prGetPropertyInspection(PropertyID, BatchID, Session["UserID"].ToString()).ToList();
                        return Json(result, JsonRequestBehavior.AllowGet);
                    }
                }
            }

            return View();
        }
        public ActionResult InspectionReport()
        {
            return View();
        }
        public ActionResult SnowRemoval()
        {
            return View();
        }
        public ActionResult SnowReport()
        {
            return View();
        }
        [HttpPost]

        public ActionResult SnowRemopval(string Action, string PropertyID, string BatchID, string ValesArray, string ApprovalStatus, string VendorName, string ArrivalTime, string DepartureTime, string DatePerformed)
        {


            if (Action == "New Item")
            {

                var currentDate = DateTime.Now.ToString("yyyy-MM-dd");
                var currentTime = DateTime.Now.ToString("t", CultureInfo.CreateSpecificCulture("en-us"));
                string curYearTwoDigit = DateTime.Now.Year.ToString().Substring(2, 2).ToString();
                string GuiID = Guid.NewGuid().ToString();
                var UserID = Session["UserID"];
                string pic1 = "", pic2 = "", pic3 = "", pic4 = "", pic5 = "";
                string[] ValuesArrary = ValesArray.Split('|');
                if (DatePerformed == " ")
                {
                    DatePerformed = currentDate;
                }
                //to save image from temp.
                using (DBEntities dc = new DBEntities())
                {
                    dc.prSnowRemoval(Action, PropertyID, DatePerformed, currentDate, currentTime, UserID.ToString(), ApprovalStatus, GuiID, ValuesArrary[0], ValuesArrary[1], ValuesArrary[2], ValuesArrary[3], ValuesArrary[4], ValuesArrary[5], ValuesArrary[6], ValuesArrary[7], ValuesArrary[8], ValuesArrary[9], ValuesArrary[10], ValuesArrary[11], ValuesArrary[12], ValuesArrary[13], ValuesArrary[14], ValuesArrary[15], ValuesArrary[16], ValuesArrary[17], ValuesArrary[18], ValuesArrary[19], ValuesArrary[20], ValuesArrary[21], ValuesArrary[22], ValuesArrary[23], ValuesArrary[24], ValuesArrary[25], ValuesArrary[26], ValuesArrary[27], ValuesArrary[28], ValuesArrary[29], ValuesArrary[30], ValuesArrary[31], ValuesArrary[32], ValuesArrary[33], ValuesArrary[34], ValuesArrary[35], ValuesArrary[36], ValuesArrary[37], ValuesArrary[38], ValuesArrary[39], ValuesArrary[40], ValuesArrary[41], ValuesArrary[42], ValuesArrary[43], ValuesArrary[44], ValuesArrary[45], ValuesArrary[46], ValuesArrary[47], ValuesArrary[48], ValuesArrary[49], ValuesArrary[50], ValuesArrary[51], ValuesArrary[52], ValuesArrary[53], ValuesArrary[54], ValuesArrary[55], ValuesArrary[56], ValuesArrary[57], ValuesArrary[58], ValuesArrary[59], ValuesArrary[60], ValuesArrary[61], ValuesArrary[62], ValuesArrary[63], ValuesArrary[64], ValuesArrary[65], ValuesArrary[66], ValuesArrary[67], ValuesArrary[68], ValuesArrary[69], ValuesArrary[70], ValuesArrary[71], ValuesArrary[72], ValuesArrary[73], ValuesArrary[74], ValuesArrary[75], ValuesArrary[76], ValuesArrary[77], ValuesArrary[78], ValuesArrary[79], ValuesArrary[80], ValuesArrary[81], ValuesArrary[82], ValuesArrary[83], ValuesArrary[84], ValuesArrary[85], ValuesArrary[86], ValuesArrary[87], ValuesArrary[88], ValuesArrary[89], ValuesArrary[90], ValuesArrary[91], ValuesArrary[92], VendorName, ArrivalTime, DepartureTime, pic1, pic2, pic3, pic4, pic5);
                    var message = "/Details/ProductDetails?category=Snow Removal&property=" + PropertyID.ToString();
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            else if (Action == "Update")
            {
                var currentDate = DateTime.Now.ToString("yyyy-MM-dd");
                var currentTime = DateTime.Now.ToString("t", CultureInfo.CreateSpecificCulture("en-us"));
                string curYearTwoDigit = DateTime.Now.Year.ToString().Substring(2, 2).ToString();
                string GuiID = Guid.NewGuid().ToString();
                var UserID = Session["UserID"];
                string pic1 = "", pic2 = "", pic3 = "", pic4 = "", pic5 = "";
                string[] ValuesArrary = ValesArray.Split('|');

                using (DBEntities dc = new DBEntities())
                {
                    dc.prSnowRemoval(Action, PropertyID, DatePerformed, currentDate, currentTime, UserID.ToString(), ApprovalStatus, BatchID, ValuesArrary[0], ValuesArrary[1], ValuesArrary[2], ValuesArrary[3], ValuesArrary[4], ValuesArrary[5], ValuesArrary[6], ValuesArrary[7], ValuesArrary[8], ValuesArrary[9], ValuesArrary[10], ValuesArrary[11], ValuesArrary[12], ValuesArrary[13], ValuesArrary[14], ValuesArrary[15], ValuesArrary[16], ValuesArrary[17], ValuesArrary[18], ValuesArrary[19], ValuesArrary[20], ValuesArrary[21], ValuesArrary[22], ValuesArrary[23], ValuesArrary[24], ValuesArrary[25], ValuesArrary[26], ValuesArrary[27], ValuesArrary[28], ValuesArrary[29], ValuesArrary[30], ValuesArrary[31], ValuesArrary[32], ValuesArrary[33], ValuesArrary[34], ValuesArrary[35], ValuesArrary[36], ValuesArrary[37], ValuesArrary[38], ValuesArrary[39], ValuesArrary[40], ValuesArrary[41], ValuesArrary[42], ValuesArrary[43], ValuesArrary[44], ValuesArrary[45], ValuesArrary[46], ValuesArrary[47], ValuesArrary[48], ValuesArrary[49], ValuesArrary[50], ValuesArrary[51], ValuesArrary[52], ValuesArrary[53], ValuesArrary[54], ValuesArrary[55], ValuesArrary[56], ValuesArrary[57], ValuesArrary[58], ValuesArrary[59], ValuesArrary[60], ValuesArrary[61], ValuesArrary[62], ValuesArrary[63], ValuesArrary[64], ValuesArrary[65], ValuesArrary[66], ValuesArrary[67], ValuesArrary[68], ValuesArrary[69], ValuesArrary[70], ValuesArrary[71], ValuesArrary[72], ValuesArrary[73], ValuesArrary[74], ValuesArrary[75], ValuesArrary[76], ValuesArrary[77], ValuesArrary[78], ValuesArrary[79], ValuesArrary[80], ValuesArrary[81], ValuesArrary[82], ValuesArrary[83], ValuesArrary[84], ValuesArrary[85], ValuesArrary[86], ValuesArrary[87], ValuesArrary[88], ValuesArrary[89], ValuesArrary[90], ValuesArrary[91], ValuesArrary[92], VendorName, ArrivalTime, DepartureTime, pic1, pic2, pic3, pic4, pic5);
                    var message = "/Details/ProductDetails?category=Snow Removal&property=" + PropertyID.ToString();
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            else if (Action == "GetInfo")
            {
                using (DBEntities dc = new DBEntities())
                {
                    if (Session["UserID"] != null)
                    {
                        var result = dc.prGetSnowRemovalInfo(PropertyID, BatchID, Session["UserID"].ToString()).ToList();
                        return Json(result, JsonRequestBehavior.AllowGet);
                    }
                }
            }

            return View();
        }
        public JsonResult GetAllPropertyList()
        {
            using (DBEntities dc = new DBEntities())
            {
                // var result = Session["UserID"];
                if (Session["UserID"] != null)
                {
                    var result = dc.prAllPropertiesUserWise(Session["UserID"].ToString()).ToList();
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return null;

                }

            }
        }
        public JsonResult GetAllVendorList()
        {
            using (DBEntities dc = new DBEntities())
            {
                var result = dc.prAllVendorList().ToList();
                return Json(result, JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult GetUserInformation(string Action)
        {
            using (DBEntities dc = new DBEntities())
            {
                if (Session["UserID"] != null)
                {
                    var result = dc.prGetUserInformation(Session["UserID"].ToString(), Action).ToList();
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return null;

                }

            }
        }
        [HttpPost]
        public JsonResult GetAllDailyReportInfo(string BatchNumber)
        {
            using (DBEntities dc = new DBEntities())
            {
                // var result = Session["UserID"];
                if (Session["UserID"] != null)
                {
                    var result = dc.prGetDailyReportInfo(BatchNumber, Session["UserID"].ToString()).ToList();
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return null;

                }

            }
        }
        [HttpPost]
        public JsonResult GetAllInfoCategoryWise(string BatchNumber, string ItemCategory)
        {
            using (DBEntities dc = new DBEntities())
            {
                // var result = Session["UserID"];
                if (Session["UserID"] != null)
                {
                    if (ItemCategory == "Work Order")
                    {
                        var result = dc.prGetWorkOrderInfo(BatchNumber).ToList();
                        return Json(result, JsonRequestBehavior.AllowGet);
                    }
                    else if (ItemCategory == "Property Inspection")
                    {
                        return null;
                    }

                    return null;
                }
                else
                {
                    return null;

                }

            }
        }

        [HttpPost]
        public JsonResult GetAllInfoServiceLog(string BatchNumber, string ItemCategory)
        {
            using (DBEntities dc = new DBEntities())
            {
                // var result = Session["UserID"];
                if (Session["UserID"] != null)
                {
                    if (ItemCategory == "Work Order")
                    {
                        var result = dc.prServiceLogInfo(BatchNumber, Session["UserID"].ToString()).ToList();
                        return Json(result, JsonRequestBehavior.AllowGet);
                    }
                    else if (ItemCategory == "Property Inspection")
                    {
                        return null;
                    }

                    return null;
                }
                else
                {
                    return null;

                }

            }
        }

        [HttpPost]
        public JsonResult GetAllServices(string propertyid, string Action)
        {
            using (DBEntities dc = new DBEntities())
            {
                // var result = Session["UserID"];
                if (Session["UserID"] != null)
                {
                    var result = dc.prGetAllServices(propertyid, Session["UserID"].ToString()).ToList();
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return null;

                }

            }
        }
        [HttpPost]
        public virtual ActionResult UploadFile()
        {
            if (Session["UserID"] != null)
            {
                HttpPostedFileBase myFile = Request.Files["MyFile"];
                var fileName = myFile.FileName;
                bool isUploaded = false;
                string message = "File upload failed";
                var rootFolder = "~/Content/Temp/" + Session["UserID"];
                string returnURL = "../Content/Temp/" + Session["UserID"];
                var fileExtension = myFile.ContentType;
                var contentTypeOfFile = ("image/jpeg|image/gif|image/png").Split('|');
                string fileID = DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Year.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + DateTime.Now.Millisecond.ToString();
                for (var i = 0; i < contentTypeOfFile.Length; i++)
                {
                    if (fileExtension == contentTypeOfFile[i])
                    {
                        isUploaded = true;
                        message = "";
                        break;
                    }
                }

                if (myFile != null && myFile.ContentLength != 0 && isUploaded == true)
                {
                    if (Directory.Exists(Server.MapPath(rootFolder)))
                    {
                        myFile.SaveAs(Server.MapPath(rootFolder + "/" + fileID + ".jpg"));
                        isUploaded = true;
                    }
                    else
                    {
                        Directory.CreateDirectory(Server.MapPath(rootFolder));
                        myFile.SaveAs(Server.MapPath(rootFolder + "/" + fileID + ".jpg"));
                        isUploaded = true;
                    }
                }
                else
                {
                    isUploaded = false;
                    message = "Your file extension does not support by system.";
                }
                return Json(new { isUploaded = isUploaded, message = message, fileID = fileID, imageURL = returnURL + "/" + fileID + ".jpg" }, "text/html");

            }
            else
            {
                return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
            }

        }

        public virtual ActionResult UploadFileWorkOrder()
        {
            if (Session["UserID"] != null)
            {
                HttpPostedFileBase myFile = Request.Files["MyFile"];
                var fileName = myFile.FileName;
                bool isUploaded = false;
                string message = "File upload failed";
                var rootFolder = "~/Content/Temp/WorkOrder/" + Session["UserID"];
                string returnURL = "../Content/Temp/WorkOrder/" + Session["UserID"];
                var fileExtension = myFile.ContentType;
                var contentTypeOfFile = ("image/jpeg|image/gif|image/png").Split('|');
                string fileID = DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Year.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + DateTime.Now.Millisecond.ToString();
                for (var i = 0; i < contentTypeOfFile.Length; i++)
                {
                    if (fileExtension == contentTypeOfFile[i])
                    {
                        isUploaded = true;
                        message = "";
                        break;
                    }
                }

                if (myFile != null && myFile.ContentLength != 0 && isUploaded == true)
                {
                    // string rootFolder = Server.MapPath("~/Uploads");

                    if (Directory.Exists(Server.MapPath(rootFolder)))
                    {
                        myFile.SaveAs(Server.MapPath(rootFolder + "/" + fileID + ".jpg"));
                        isUploaded = true;
                    }
                    else
                    {
                        Directory.CreateDirectory(Server.MapPath(rootFolder));
                        myFile.SaveAs(Server.MapPath(rootFolder + "/" + fileID + ".jpg"));
                        isUploaded = true;
                    }
                }
                else
                {
                    isUploaded = false;
                    message = "Your file extension does not support by system.";
                }
                return Json(new { isUploaded = isUploaded, message = message, fileID = fileID, imageURL = returnURL + "/" + fileID + ".jpg" }, "text/html");
            }
            else
            {
                return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
            }

        }

        [HttpPost]
        public JsonResult UploadImage(string folderType, string ImageName)
        {
            try
            {
                //folderName='/Content/Temp/';
                bool isUploaded = false;
                string message = "File upload failed";
                var rootFolder = "";
                var returnURL = "";
                if (folderType == "WorkOrder")
                {
                    rootFolder = "~/Content/Temp/WorkOrder/" + Session["UserID"];
                    returnURL = "../Content/Temp/WorkOrder/" + Session["UserID"];
                }
                else if (folderType == "Inspection")
                {
                    rootFolder = "~/Content/Temp/Inspection/" + Session["UserID"];
                    returnURL = "../Content/Temp/Inspection/" + Session["UserID"];
                }
                else
                {
                    rootFolder = "~/Content/Temp/" + Session["UserID"];
                    returnURL = "../Content/Temp/" + Session["UserID"];
                }
                var contentTypeOfFile = ("image/jpeg|image/gif|image/png").Split('|');
                string fileID = DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Year.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + DateTime.Now.Millisecond.ToString();
                if (string.IsNullOrEmpty(ImageName) != true)
                {
                    fileID = ImageName + "-" + fileID;
                }

                foreach (string file in Request.Files)
                {
                    var fileContent = Request.Files[file];
                    var fileExtension = fileContent.ContentType;
                    for (var i = 0; i < contentTypeOfFile.Length; i++)
                    {
                        if (fileExtension == contentTypeOfFile[i])
                        {
                            isUploaded = true;
                            message = "";
                            break;
                        }
                    }
                    if (fileContent != null && fileContent.ContentLength > 0 && isUploaded == true)
                    {

                        // get a stream
                        var stream = fileContent.InputStream;
                        // and optionally write the file to disk
                        var fileName = Path.GetFileName(file);
                        if (Directory.Exists(Server.MapPath(rootFolder)))
                        {
                            fileContent.SaveAs(Server.MapPath(rootFolder + "/" + fileID + ".jpg"));
                            isUploaded = true;
                        }
                        else
                        {
                            Directory.CreateDirectory(Server.MapPath(rootFolder));
                            fileContent.SaveAs(Server.MapPath(rootFolder + "/" + fileID + ".jpg"));
                            isUploaded = true;
                        }
                    }
                    else
                    {
                        isUploaded = false;
                        message = "Your file extension does not support by system.";
                    }
                }
                //return Json(new { isUploaded = isUploaded, message = message, fileID = fileID, imageURL = returnURL + "/" + fileID + ".jpg" }, "text/html");
                var returnString = isUploaded + "|" + message + "|" + fileID + "|" + returnURL + "/" + fileID + ".jpg";
                return Json(returnString, JsonRequestBehavior.AllowGet);

            }
            catch (Exception)
            {
                // Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return Json("Upload failed");
            }

            //return Json("File uploaded successfully");
        }

        [HttpPost]
        public JsonResult ActivityOnFile(string Action, string filePath, string optional)
        {
            var rootPath = filePath;
            if (optional == "TemFolderDelete")
            {
                filePath = filePath + "/" + Session["UserID"].ToString();
                if (Directory.Exists(Server.MapPath(filePath)))
                {
                    //DirectoryInfo dir = new DirectoryInfo(Server.MapPath(filePath));
                    //dir.Delete(true);

                    DirectoryInfo dir = new DirectoryInfo(Server.MapPath(filePath));

                    foreach (FileInfo fi in dir.GetFiles())
                    {
                        fi.Delete();
                    }
                }
            }
            else
            {
                //image file delete
                if (rootPath.Contains("/Content/Temp"))
                {
                    System.IO.File.Delete(Server.MapPath(rootPath));
                }
                else
                {
                    System.IO.File.Delete(Server.MapPath(rootPath));
                    rootPath = rootPath.Replace(".s1", ".s2");
                    System.IO.File.Delete(Server.MapPath(rootPath));
                }
            }

            return null;
        }

        [HttpPost]
        public JsonResult MoveFolderActualLocation(string Action, string SourceFolder, string DestinationFolder, string Nameing, string Optinal, string PropertyID, string BatchID)
        {
            var UserID = Session["UserID"];
            var isUploaded = false;
            var message = "";
            var returnString = "";
            //   var rootFolder = "~/Content/Temp/WorkOrder/" + Session["UserID"];

            if (Action == "Move")
            {
                DirectoryInfo directoryInfo = new DirectoryInfo(Server.MapPath("~/Content/Temp/" + SourceFolder + "/" + UserID + "/"));
                if (directoryInfo.Exists)
                {
                    string rootFolder = "~/" + DestinationFolder + "/" + PropertyID + "/" + BatchID;
                    string returnURL = "../" + DestinationFolder + "/" + PropertyID + "/" + BatchID;
                    string returnURLofImage = "";

                    var counter = 0;
                    string internalExtension = string.Concat("*.", "*");
                    FileInfo[] fileInfo = directoryInfo.GetFiles(internalExtension, SearchOption.AllDirectories);
                    ResizeImages(fileInfo);
                    if (!Directory.Exists(Server.MapPath(rootFolder)))
                    {
                        Directory.CreateDirectory(Server.MapPath(rootFolder));
                    }

                    foreach (FileInfo fileInfoTemp in fileInfo)
                    {
                        counter = counter + 1;
                        string fileID = DateTime.Now.ToString("yyyyMMddhhmmssffffff") + counter;
                        var fileDic = fileInfoTemp.Directory;
                        var fileDicName = fileInfoTemp.DirectoryName;
                        var name = fileInfoTemp.Name;
                        //fileInfoTemp.CopyTo(Server.MapPath(rootFolder + "/Photo_" + counter + ".s2.png"));
                        if (Nameing == "PreviousName")
                        {
                            fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "/" + name + ".png"));
                        }
                        else
                        {
                            fileInfoTemp.MoveTo(Server.MapPath(rootFolder + "/" + Nameing + "-" + fileID + ".png"));
                        }
                        string extension = fileInfoTemp.Extension;
                        isUploaded = true;
                        returnURLofImage = returnURLofImage + fileID + "*" + returnURL + "/" + Nameing + "-" + fileID + ".png*" + Nameing + "-" + fileID + "~";
                    }
                    returnString = isUploaded + "|" + message + "|" + returnURLofImage;
                }
            }
            return Json(returnString, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GetAllFiles(string Category, string Action, string PropertyID, string SourceFolder, string BatchID)
        {
            var rootPath = "";
            var rootPathForHTML = "";
            var returnString = "";
            var counter = 0;
            if (Action == "TempFolder")
            {
                rootPath = "~/Content/Temp/Inspection/" + Session["UserID"];
                rootPathForHTML = "../Content/Temp/Inspection/" + Session["UserID"] + "/";
            }
            string propertyID = Request.QueryString["propertyID"];
            string guiID = Request.QueryString["specificID"];

            //if (propertyID != null && guiID != null)
            //{
            DirectoryInfo directoryInfoOverlay = new DirectoryInfo(Server.MapPath(rootPath));
            if (directoryInfoOverlay.Exists)
            {

                string internalExtension = string.Concat("*.", "*");
                FileInfo[] fileInfo = directoryInfoOverlay.GetFiles(internalExtension, SearchOption.AllDirectories);
                ResizeImages(fileInfo);
                foreach (FileInfo fileInfoTemp in fileInfo)
                {
                    counter = counter + 1;
                    string fileID = DateTime.Now.ToString("yyyyMMddhhmmssffffff") + counter;

                    returnString = returnString + fileInfoTemp.Name + "|" + fileID + "|" + rootPathForHTML + fileInfoTemp.Name + "~";
                }
            }
            // }

            return Json(returnString, JsonRequestBehavior.AllowGet);
        }

        public void DeleteTemImage(string TempDeletedImage)
        {
            string[] TempDeletedImageArray = TempDeletedImage.Split('|');
            foreach (string FilePath in TempDeletedImageArray)
            {
                if (FilePath.Length > 0)
                {
                    ActivityOnFile("Delete", FilePath, null);
                }
            }
        }
        [HttpPost]
        public JsonResult DeleteRecord(string PropertyID, string UniqueID, string Category)
        {
            using (DBEntities dc = new DBEntities())
            {
                // var result = Session["UserID"];
                if (Session["UserID"] != null)
                {
                    // EmptyTemImage(PropertyID, UniqueID, Category);
                    var result = dc.DeleteRecord(PropertyID, UniqueID, Category).ToList();
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return null;

                }

            }
        }

        public int CountExistImage(string rootFolder)
        {
            DirectoryInfo rootDirectoryInfo = new DirectoryInfo(Server.MapPath(rootFolder));
            IEnumerable<FileInfo> existimages = rootDirectoryInfo.GetFiles().Where(x => x.Name.Contains("s1"));
            int loop = 1;

            foreach (FileInfo file in existimages)
            {
                string name = "Photo_" + loop + ".s1.png";
                if (file.Name == name)
                {
                    loop = loop + 1;
                }
                else
                    break;
            }
            return loop;
        }

        private void ResizeImage(FileInfo file, int width, int height)
        {

            Image img = Image.FromFile(file.FullName);
            var newImage = ScaleImage(img, width, height);
            img.Dispose();
            newImage.Save(file.FullName);

        }

        private void ResizeImages(FileInfo[] files)
        {
            foreach (FileInfo file in files)
            {
                Image img = Image.FromFile(file.FullName);
                var newImage = ScaleImage(img, 480, 640);
                img.Dispose();
                newImage.Save(file.FullName);
            }
        }
        public static Image ScaleImage(Image image, int maxWidth, int maxHeight)
        {
            var ratioX = (double)maxWidth / image.Width;
            var ratioY = (double)maxHeight / image.Height;
            var ratio = Math.Min(ratioX, ratioY);

            var newWidth = (int)(image.Width * ratio);
            var newHeight = (int)(image.Height * ratio);

            var newImage = new Bitmap(newWidth, newHeight);
            Graphics.FromImage(newImage).DrawImage(image, 0, 0, newWidth, newHeight);
            return newImage;
        }

        public string[] GetImages(string rootpath)
        {
            string[] array = null;
            if (Directory.Exists(Server.MapPath(rootpath)))
            {
                array = Directory.GetFiles(Server.MapPath(rootpath)).Where(x => x.Contains(".s1.")).ToArray();
            }
            return array;
        }
        public void EmptyTemImage(string PropertyID, string UniqueID, string Category)
        {
            string rootPath = "";
            if (Category == "Work Order")
            {
                rootPath = "~/Pictures/WorkOrder/" + UniqueID + "/";
            }
            else if (Category == "Property Inspection")
            {
                rootPath = "~/PropertyInspections/" + PropertyID + "/" + UniqueID + "/";
            }
            if (Directory.Exists(Server.MapPath(rootPath)))
            {
                DirectoryInfo dir = new DirectoryInfo(Server.MapPath(rootPath));

                foreach (FileInfo fi in dir.GetFiles())
                {
                    fi.Delete();
                }
            }
        }
        public ActionResult RWorkOrder()
        {
            return View();
        }
    }

    //string rootPathInspection = "~/Content/Temp/Inspection/" + userID;
    //                EmptyTemImage(rootPathInspection);
}

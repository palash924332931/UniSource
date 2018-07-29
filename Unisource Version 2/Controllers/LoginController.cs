
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UniSourceV2.Controllers
{
    public class LoginController : Controller
    {

        // GET: Login
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Loginpage()
        {
            return View();
        }
        public ActionResult HomeLogin()
        {
            if (Session["UserID"] != null)
            {
                return RedirectToAction("Index", "Home", new { area = "Admin", id = "" });
            }
            else
            {
                return View();
            }

        }
        [HttpPost]
        public ActionResult AuthoLogin(user user)
        {
            using (DBEntities dc = new DBEntities())
            {
                string message = "";
                string userID = user.username.ToString();
                string password = user.password.ToString();
                //int checkResult = System.Convert.ToInt32(dc.prUserLogin(userID, password).FirstOrDefault().ToString());
                var result = dc.prUserLoginV2(userID, password).ToList();
                if (result.Count > 0)
                {
                    foreach (prUserLoginV2_Result results in result)
                    {
                        Session["category"] = "Yes";
                        Session["executeStatus"] = "false";
                        Session["FromDate"] = "false";
                        Session["ToDate"] = "false";
                        Session["PropertyDataSet"] = null;
                        Session["ApplicationStatusCustomSearch"] = "false";


                        Session["Allowviewvendors"] = results.allowviewvendors == 1 ? "Yes" : "No";

                        Session["uniadmin"] = results.uniadmin == 1 ? "Yes" : "No";
                        Session["allowdailyreportuploads"] = results.allowdailyreportuploads == 1 ? "Yes" : "No";
                        Session["allowreportstatuschange"] = results.allowreportstatuschange == 1 ? "Yes" : "No";
                        Session["allowenterworkorder"] = results.allowenterworkorder == 1 ? "Yes" : "No";
                        Session["alloweditworkorder"] = results.alloweditworkorder == 1 ? "Yes" : "No";
                        Session["allowsubmitform1"] = results.allowsubmitform1 == 1 ? "Yes" : "No";
                        Session["allowsubmitform2"] = results.allowsubmitform2 == 1 ? "Yes" : "No";

                        Session["UserID"] = results.username.ToString();
                        Session["UserFullName"] = results.fullname.ToString();
                        Session["WPComments"] = " ";

                    }
                    //to delete temporary file
                    string rootPath = "~/Content/Temp/" + userID;
                    EmptyTemImage(rootPath);
                    //to delete work request temp folder
                    string rootPathWR = "~/Content/Temp/WorkOrder/" + userID;
                    EmptyTemImage(rootPathWR);
                    //to delete work Inspection temp folder
                    string rootPathInspection = "~/Content/Temp/Inspection/" + userID;
                    EmptyTemImage(rootPathInspection);


                    message = "Login Success||../../Home/Unisource?category=Total%20Work%20Request&property=All";
                }
                else
                {
                    Session["UserID"] = null;
                    message = "Invalid UserID and Password. Please Try again.||../../Login/HomeLogin?Admin";
                }
                return Json(message, JsonRequestBehavior.AllowGet);
            }



        }
        public ActionResult Logout()
        {
            Session["UserID"] = null;
            return RedirectToAction("HomeLogin", "Login", new { area = "", id = "" });

        }
        public void EmptyTemImage(string filePath)
        {
            if (Directory.Exists(Server.MapPath(filePath)))
            {
                DirectoryInfo dir = new DirectoryInfo(Server.MapPath(filePath));

                foreach (FileInfo fi in dir.GetFiles())
                {
                    fi.Delete();
                }
            }
        }
    }
}
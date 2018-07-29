using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UniSourceV2.Models;
using UniSourceV2.Controllers;
namespace UniSourceV2.Controllers
{
    public class HomeController : Controller
    {

        public static List<prCategoryWiseMasterInfoForUnisource_Result> _data;
        private const int TOTAL_ROWS = 20000;
        public static string PreviousCategory;

        public ActionResult Index()
        {
            // Session["executeStatus"] = "false"; 
            // Session["UserID"] = "admin";

            //if (Session["UserID"] != null)
            //{
            //    using (DBEntities dc = new DBEntities())
            //    {
            //        var result = dc.prUserWiseMasterInfo(Session["UserID"].ToString()).ToList();
            //        return View(result);
            //    }
            //}
            //else {
            //    return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
            //}
            return View();
        }
        [HttpPost]
        public ActionResult Index(string UserID)
        {
            // Session["UserID"] = "admin";

            if (Session["UserID"] != null)
            {
                using (DBEntities dc = new DBEntities())
                {
                    var result = dc.prUserWiseMasterInfo(Session["UserID"].ToString()).ToList();
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
            }
        }
        public ActionResult Unisource(string category, string property)
        {
            //string category = "Total Work Order";
            //string property = "All";
            if (Session["UserID"] != null && category != null)
            {
                //using (DBEntities dc = new DBEntities())
                //{
                //    ViewBag.Category = category.ToString();
                //    var result = dc.prCategoryWiseMasterInfoForUnisource(category.ToString(), property.ToString(), Session["UserID"].ToString()).ToList();
                //    return View(result);
                //}
                return View("");
            }
            else
            {
                return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
            }
        }

        public ActionResult PropertyInformationAjaxCall(int draw, int start, int length, string PropertyId, string Category, string FromDate, string ToDate, string ApplicationStatus, string ExecuteStatus, string SearchInfo, string OnlySearchExc)
        {
            if (Session["UserID"] == null)
            {
                return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
            }
            //string search = Request.QueryString["search[value]"];
            string search = SearchInfo;
            string UserID = Session["UserID"].ToString();
            int sortColumn = -1;
            string sortDirection = "asc";
            if (length == -1)
            {
                length = TOTAL_ROWS;
            }

            if (FromDate == null || FromDate == "")
            {
                FromDate = "1990-01-01";
            }
            if (ToDate == null || ToDate == "")
            {
                ToDate = "2050-07-31";
            }
            if (ApplicationStatus == null || ApplicationStatus == "")
            {
                ApplicationStatus = "%";
            }

            if (OnlySearchExc != "true")
            {
                if ((ExecuteStatus == "true" && Session["executeStatus"].ToString() != ExecuteStatus) || _data == null || Category != Session["category"].ToString() || Session["FromDate"].ToString() != FromDate || Session["ToDate"].ToString() != ToDate || Session["ApplicationStatusCustomSearch"].ToString() != ApplicationStatus)
                {
                    //if ((ExecuteStatus == "true" || Session["executeStatus"].ToString() != ExecuteStatus) || _data == null || Category != Session["category"].ToString() || Session["FromDate"].ToString() != FromDate || Session["ToDate"].ToString() != ToDate || Session["ApplicationStatusCustomSearch"].ToString() != ApplicationStatus) {
                    using (DBEntities dc = new DBEntities())
                    {
                        _data = dc.prCategoryWiseMasterInfoForUnisource(Category, PropertyId, FromDate, ToDate, ApplicationStatus, UserID).ToList();
                        start = 0;

                    }
                }
                else
                {
                    if (Request.QueryString["order[0][column]"] != null)
                    {
                        sortColumn = int.Parse(Request.QueryString["order[0][column]"]);
                    }
                    if (Request.QueryString["order[0][dir]"] != null)
                    {
                        sortDirection = Request.QueryString["order[0][dir]"];
                    }
                }
            }
            else
            {
                //start = 0;
                if (Request.QueryString["order[0][column]"] != null)
                {
                    sortColumn = int.Parse(Request.QueryString["order[0][column]"]);
                }
                if (Request.QueryString["order[0][dir]"] != null)
                {
                    sortDirection = Request.QueryString["order[0][dir]"];
                }
            }

            Session["category"] = Category;
            //to set execute status in session
            if (ExecuteStatus == null)
            {
                Session["executeStatus"] = "false";
            }
            else
            {
                Session["executeStatus"] = ExecuteStatus;
            }
            //to set FromDate in sessoin
            if (FromDate == null || FromDate == "")
            {
                Session["FromDate"] = "1990-01-01";
            }
            else
            {
                Session["FromDate"] = FromDate;
            }
            //to set toDate in session
            if (ToDate == null || ToDate == "")
            {
                Session["ToDate"] = "1990-01-01";
            }
            else
            {
                Session["ToDate"] = ToDate;
            }
            //to set application status in session            
            if (ApplicationStatus == null || ApplicationStatus == "")
            {
                Session["ApplicationStatusCustomSearch"] = "%";
            }
            else
            {
                Session["ApplicationStatusCustomSearch"] = ApplicationStatus;
            }

            DataTableData dataTableData = new DataTableData();
            dataTableData.draw = draw;
            dataTableData.recordsTotal = _data.Count;// TOTAL_ROWS;
            int recordsFiltered = 0;
            dataTableData.data = FilterData(ref recordsFiltered, start, length, search, sortColumn, sortDirection);
            dataTableData.recordsFiltered = recordsFiltered;

            return Json(dataTableData, JsonRequestBehavior.AllowGet);
        }
        private static List<prCategoryWiseMasterInfoForUnisource_Result> CreateData1()
        {
            using (DBEntities dc = new DBEntities())
            {
                var result = dc.prCategoryWiseMasterInfoForUnisource("Total Work Request", "All", "%", "%", "%", "Admin").ToList();
                return result;
            }
        }
        private List<prCategoryWiseMasterInfoForUnisource_Result> FilterData(ref int recordFiltered, int start, int length, string search, int sortColumn, string sortDirection)
        {
            List<prCategoryWiseMasterInfoForUnisource_Result> list = new List<prCategoryWiseMasterInfoForUnisource_Result>();
            if (search == null || search == "")
            {
                list = _data;
            }
            else
            {
                // simulate search
                foreach (prCategoryWiseMasterInfoForUnisource_Result dataItem in _data)
                {
                    if (dataItem.ID.ToUpper().Contains(search.ToUpper()) ||
                        dataItem.SubmittedDate.ToString().Contains(search.ToUpper()) ||
                        dataItem.PerformedDate.ToString().Contains(search.ToUpper()) ||
                        dataItem.PropertyName.ToUpper().Contains(search.ToUpper()) ||
                        dataItem.ApprovalStatus.ToUpper().Contains(search.ToUpper()) ||
                        dataItem.Comments.ToUpper().Contains(search.ToUpper()))
                    {
                        list.Add(dataItem);
                    }
                }
                search = null;
            }

            // simulate sort
            if (sortColumn == 0)
            {// sort ID
                list.Sort((x, y) => SortString(x.ID, y.ID, sortDirection));
            }
            else if (sortColumn == 1)
            {
                //list.Sort((x, y) => SortInteger(x.Age, y.Age, sortDirection));               
                list.Sort((x, y) => SortString(x.SubmittedDate, y.SubmittedDate, sortDirection));
            }
            else if (sortColumn == 2)
            {   // sort DoB
                //list.Sort((x, y) => SortDateTime(x.DoB, y.DoB, sortDirection));
                if (Session["category"].ToString() == "Total Work Request" || Session["category"].ToString() == "Work Request" || Session["category"].ToString() == "total Work Order" || Session["category"].ToString() == "Work Order")
                {
                    list.Sort((x, y) => SortString(x.PropertyName, y.PropertyName, sortDirection));
                }
                else
                {
                    list.Sort((x, y) => SortString(x.PerformedDate, y.PerformedDate, sortDirection));
                }

            }
            else if (sortColumn == 3)
            {   // sort DoB
                //list.Sort((x, y) => SortDateTime(x.DoB, y.DoB, sortDirection));
                if (Session["category"].ToString() == "total Work Order" || Session["category"].ToString() == "Work Order")
                {
                    list.Sort((x, y) => SortString(x.ApprovalStatus, y.ApprovalStatus, sortDirection));
                }
                else
                {
                    list.Sort((x, y) => SortString(x.PropertyName, y.PropertyName, sortDirection));
                }
            }
            else if (sortColumn == 4)
            {   // sort DoB
                //list.Sort((x, y) => SortDateTime(x.DoB, y.DoB, sortDirection));
                list.Sort((x, y) => SortString(x.ApprovalStatus, y.ApprovalStatus, sortDirection));
            }

            recordFiltered = list.Count;

            // get just one page of data
            if (list.Count < start)
            {
                start = 0;
            }
            list = list.GetRange(start, Math.Min(length, list.Count - start));


            return list;
        }
        public class DataTableData
        {
            public int draw { get; set; }
            public int recordsTotal { get; set; }
            public int recordsFiltered { get; set; }
            public List<prCategoryWiseMasterInfoForUnisource_Result> data { get; set; }
        }
        private int SortString(string s1, string s2, string sortDirection)
        {
            return sortDirection == "asc" ? s1.CompareTo(s2) : s2.CompareTo(s1);
        }

        private int SortInteger(string s1, string s2, string sortDirection)
        {
            int i1 = int.Parse(s1);
            int i2 = int.Parse(s2);
            return sortDirection == "asc" ? i1.CompareTo(i2) : i2.CompareTo(i1);
        }

        private int SortDateTime(string s1, string s2, string sortDirection)
        {
            DateTime d1 = DateTime.Parse(s1);
            DateTime d2 = DateTime.Parse(s2);
            return sortDirection == "asc" ? d1.CompareTo(d2) : d2.CompareTo(d1);
        }


        //end of ajax activity

        public ActionResult Login()
        {
            return View("Login");
        }
        public JsonResult GetTotalNumberOfCatetory()
        {
            using (DBEntities dc = new DBEntities())
            {
                // var result = Session["UserID"];
                if (Session["UserID"] != null)
                {
                    var result = dc.prTotalItemsUserWise(Session["UserID"].ToString()).ToList();
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return null;

                }

            }
        }
        public JsonResult IndividualPropertyDetails(UniSourceV2.prIndividualPropertyInfoV2_Result pro)
        {
            using (DBEntities dc = new DBEntities())
            {
                // var result = Session["UserID"];
                string PropertyID = pro.propertyid.ToString();
                if (Session["UserID"] != null)
                {
                    var result = dc.prIndividualPropertyInfoV2(PropertyID, Session["UserID"].ToString()).ToList();
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return null;

                }

            }
        }

    }
}
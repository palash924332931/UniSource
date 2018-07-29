using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UniSourceV2.Controllers
{
    public class ReportController : Controller
    {
        //
        // GET: /Report/

        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Reports()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Reports(string Action, string Optinal,string RedirecPage)
        {
            string GuiID = Guid.NewGuid().ToString();
            var UserID = Session["UserID"];
            using (DBEntities dc = new DBEntities())
            {
                dc.PIXREF(GuiID, UserID.ToString()," ", RedirecPage);
            }
            var URLLink = "http://rd.unimancorpaps.com/redirect.aspx?&uid="+ GuiID;
            return Json(URLLink, JsonRequestBehavior.AllowGet);
        }
    }
}

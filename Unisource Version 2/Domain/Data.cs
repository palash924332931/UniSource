using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UniSourceV2.Models;

namespace UniSourceV2.Domain
{
    public class Data
    {
        public IEnumerable<Navbar> navbarItems()
        {
            var menu = new List<Navbar>();
            menu.Add(new Navbar { Id = 1, nameOption = "My Unisource", controller = "Home", action = "Unisource", imageClass = "fa fa-dashboard fa-fw", status = true, isParent = false, parentId = 0 });
            menu.Add(new Navbar { Id = 2, nameOption = "Property Dashboard", controller = "Home", action = "Index", imageClass = "uni-icon icon-dashbord1 small", status = true, isParent = false, parentId = 0 });
            menu.Add(new Navbar { Id = 3, nameOption = "Reports", controller = "Report", action = "Reports", imageClass = "uni-icon icon-report small", status = true, isParent = false, parentId = 0 });
            menu.Add(new Navbar { Id = 6, nameOption = "Admin Function", controller = "Admin", action = "AdminFunction", imageClass = "uni-icon icon-admin small", status = true, isParent = false, parentId = 0 });
            menu.Add(new Navbar { Id = 7, nameOption = "Create Work Order", controller = "DataEntry", action = "WorkOrder", imageClass = "uni-icon icon-inspec1 small", status = true, isParent = false, parentId = 0 });
            //menu.Add(new Navbar { Id = 4, nameOption = "Payment Approval", controller = "Admin", action = "PaymentApproval", imageClass = "uni-icon icon-payment small", status = true, isParent = false, parentId = 0 });

            return menu.ToList();
        }
    }
}
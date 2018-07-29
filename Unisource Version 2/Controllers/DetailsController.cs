using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UniSourceV2.Models;

namespace UniSourceV2.Controllers
{
    public class DetailsController : Controller
    {
        //
        // GET: /Details/

        public ActionResult ProductDetails(string category, string property)
        {
            //to query of product details
            if (Session["UserID"] != null && property!=null)
            {
                if (property != "all Property")
                {
                    Session["category"] = "Search";
                    using (DBEntities dc = new DBEntities())
                    {
                        var productData = dc.prIndividualPropertyInfoV2(property.ToString(), Session["UserID"].ToString()).ToList();
                        if (productData.Count > 0)
                        {
                            foreach (prIndividualPropertyInfoV2_Result results in productData)
                            {
                                ViewBag.PropertyName = results.displayname.ToString();

                                if (category == "Work Request")
                                {
                                    ViewBag.TitleTable = "Work Proposals for " + results.displayname.ToString();
                                }
                                else {
                                    ViewBag.TitleTable = category + " Details of " + results.displayname.ToString();
                                }
                            }
                        }
                    }
                }
                else {
                    ViewBag.TitleTable = category + " Details of All Property";
                }
            }
            else {
                return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
            }



            //for all property information
            if (Session["UserID"] != null)
            {
                using (DBEntities dc = new DBEntities())
                {
                    var result = dc.prCategoryWiseMasterInfoV2(category.ToString(), property.ToString(), Session["UserID"].ToString()).ToList();
                    return View(result);
                }
            }
            else {
                return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
            }

        }
        public ActionResult PropertyDetails(string propertyID)
        {
            if (Session["UserID"] != null && propertyID != null)
            {
                using (DBEntities dc = new DBEntities())
                {
                    var result = dc.prIndividualPropertyInfoV2(propertyID.ToString(), Session["UserID"].ToString()).ToList();
                    return View(result);
                }
            }
            else {
                return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
            }
        }

        public FileResult Download(string ImagePath, string fileName)
        {
            // return File("~/Content/Documents/022LYN/allSQL.txt", System.Net.Mime.MediaTypeNames.Application.Octet);
            return File(ImagePath, System.Net.Mime.MediaTypeNames.Application.Octet, fileName.ToString());
            //return File(ImagePath, "multipart/form-data", "apc.");

        }
        public JsonResult GetPropertyDetailsFromPropertySheet(string PropertyID)
        {
            using (DBEntities dc = new DBEntities())
            {
                // var result = Session["UserID"];x
                if (Session["UserID"] != null)
                {
                    var result = dc.prPropertyDataPropertyWise(PropertyID, Session["UserID"].ToString()).ToList();
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                else {
                    return null;

                }

            }
        }

        public ActionResult MapDetails()
        {
            return View();
        }
        public ActionResult PropertyMap()
        {
            return View();
        }

        public ActionResult GetDocument(HttpPostedFileBase file, string folderName)
        {
            if (Session["UserID"] != null)
            {
                // Verify that the user selecsted a file
                if (file != null && file.ContentLength > 0)
                {
                    // Get file info
                    var fileName = Path.GetFileName(file.FileName);
                    var rootFolder = "~/Docs/" + folderName;
                    var contentLength = file.ContentLength;
                    var contentType = file.ContentType;
                    if (Directory.Exists(Server.MapPath(rootFolder)))
                    {
                        file.SaveAs(Server.MapPath(rootFolder + "/" + fileName));
                    }
                    else {
                        Directory.CreateDirectory(Server.MapPath(rootFolder));
                        file.SaveAs(Server.MapPath(rootFolder + "/" + fileName));
                    }
                    return RedirectToAction("PropertyDetails", "Details", new { propertyID = folderName });
                }
                else {
                    return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
                }
            }
            else
            {
                // Show error ...
                return View("Foo");
            }
        }
        [HttpPost]
        public virtual ActionResult UpdatePropertyDataSheet(PropertyDataSheet DataSet)
        {
            int result;
            using (DBEntities dc = new DBEntities())
            {
                // var result = DataSet.propertyid.ToString();
                if (Session["UserID"] != null)
                {
                    result = dc.pUPropertiesDataSheet(DataSet.propertyid.ToString(), DataSet.property_type.ToString(), DataSet.date_property_acquired.ToString(), DataSet.current_owner.ToString(), DataSet.original_architect.ToString(), DataSet.original_developer.ToString(), DataSet.original_engineers.ToString(), DataSet.year_built.ToString(), DataSet.original_gla.ToString(), DataSet.renovation_expansion.ToString(), DataSet.current_gla.ToString(), DataSet.acres_building.ToString(), DataSet.acres_parkinglot.ToString(), DataSet.acres_project_total.ToString(), DataSet.outparcel_tenants.ToString(), DataSet.acres_maintained.ToString(), DataSet.percent_acres_bedding_plants.ToString(), DataSet.number_dormant_months_year.ToString(), DataSet.parkinglot_number_of_poles.ToString(), DataSet.parkinglot_number_of_fixtures.ToString(), DataSet.parkinglot_type_of_fixture.ToString(), DataSet.parkinglot_location_of_controls.ToString(), DataSet.parkinglot_other.ToString(), DataSet.parkinglot_other_lighting.ToString(), DataSet.parkinglot_other_lighting_controls.ToString(), DataSet.roof.ToString(), DataSet.parking_spaces.ToString(), DataSet.parking_spaces_handicapped.ToString(), DataSet.parking_ratio.ToString(), DataSet.parking_sealcoat_overlay.ToString(), DataSet.building_fire_sprinkler.ToString(), DataSet.building_hvac.ToString(), DataSet.building_construction.ToString(), DataSet.building_key_notes.ToString(), DataSet.lockbox_location_01.ToString(), DataSet.lockbox_code_01.ToString(), DataSet.lockbox_location_02.ToString(), DataSet.lockbox_code_02.ToString(), DataSet.lockbox_location_03.ToString(), DataSet.lockbox_code_03.ToString(), DataSet.marketing_fund.ToString(), DataSet.marketing_contracted_to.ToString(), DataSet.utility_electric_text.ToString(), DataSet.utility_electric_provider.ToString(), DataSet.utility_electric_phone.ToString(), DataSet.utility_gas_text.ToString(), DataSet.utility_gas_provider.ToString(), DataSet.utility_gas_phone.ToString(), DataSet.utility_water_sewer_text.ToString(), DataSet.utility_water_sewer_provider.ToString(), DataSet.utility_water_sewer_phone.ToString(), DataSet.utility_telephone_text.ToString(), DataSet.utility_telephone_provider.ToString(), DataSet.utility_telephone_phone.ToString(), DataSet.municipal_police_text.ToString(), DataSet.municipal_police_provider.ToString(), DataSet.municipal_police_phone.ToString(), DataSet.municipal_fire_text.ToString(), DataSet.municipal_fire_provider.ToString(), DataSet.municipal_fire_phone.ToString(), DataSet.municipal_buildingdept_text.ToString(), DataSet.municipal_buildingdept_provider.ToString(), DataSet.municipal_buildingdept_phone.ToString(), DataSet.municipal_publicworks_text.ToString(), DataSet.municipal_publicworks_provider.ToString(), DataSet.municipal_publicworks_phone.ToString(), DataSet.municipal_highwaydept_text.ToString(), DataSet.municipal_highwaydept_provider.ToString(), DataSet.municipal_highwaydept_phone.ToString(), DataSet.vendor_cardaccess_provider.ToString(), DataSet.vendor_cardaccess_contact.ToString(), DataSet.vendor_cardaccess_notes.ToString(), DataSet.vendor_door_repair_provider.ToString(), DataSet.vendor_door_repair_contact.ToString(), DataSet.vendor_door_repair_notes.ToString(), DataSet.vendor_eifs_provider.ToString(), DataSet.vendor_eifs_contact.ToString(), DataSet.vendor_eifs_notes.ToString(), DataSet.vendor_electrical_provider.ToString(), DataSet.vendor_electrical_contact.ToString(), DataSet.vendor_electrical_notes.ToString(), DataSet.vendor_elevator_provider.ToString(), DataSet.vendor_elevator_contact.ToString(), DataSet.vendor_elevator_notes.ToString(), DataSet.vendor_enviro_cleanup_provider.ToString(), DataSet.vendor_enviro_cleanup_contact.ToString(), DataSet.vendor_enviro_cleanup_notes.ToString(), DataSet.vendor_exterminator_provider.ToString(), DataSet.vendor_exterminator_contact.ToString(), DataSet.vendor_exterminator_notes.ToString(), DataSet.vendor_facade_provider.ToString(), DataSet.vendor_facade_contact.ToString(), DataSet.vendor_facade_notes.ToString(), DataSet.vendor_fire_alarm_monitor_provider.ToString(), DataSet.vendor_fire_alarm_monitor_contact.ToString(), DataSet.vendor_fire_alarm_monitor_notes.ToString(), DataSet.vendor_fire_alarm_repair_provider.ToString(), DataSet.vendor_fire_alarm_repair_contact.ToString(), DataSet.vendor_fire_alarm_repair_notes.ToString(), DataSet.vendor_generator_provider.ToString(), DataSet.vendor_generator_contact.ToString(), DataSet.vendor_generator_notes.ToString(), DataSet.vendor_glass_boardup_provider.ToString(), DataSet.vendor_glass_boardup_contact.ToString(), DataSet.vendor_glass_boardup_notes.ToString(), DataSet.vendor_graffitti_vandal_provider.ToString(), DataSet.vendor_graffitti_vandal_contact.ToString(), DataSet.vendor_graffitti_vandal_notes.ToString(), DataSet.vendor_hvac_repair_provider.ToString(), DataSet.vendor_hvac_repair_contact.ToString(), DataSet.vendor_hvac_repair_notes.ToString(), DataSet.vendor_handrail_provider.ToString(), DataSet.vendor_handrail_contact.ToString(), DataSet.vendor_handrail_notes.ToString(), DataSet.vendor_irrigation_provider.ToString(), DataSet.vendor_irrigation_contact.ToString(), DataSet.vendor_irrigation_notes.ToString(), DataSet.vendor_janitorial_provider.ToString(), DataSet.vendor_janitorial_contact.ToString(), DataSet.vendor_janitorial_notes.ToString(), DataSet.vendor_landscaping_provider.ToString(), DataSet.vendor_landscaping_contact.ToString(), DataSet.vendor_landscaping_notes.ToString(), DataSet.vendor_locksmith_provider.ToString(), DataSet.vendor_locksmith_contact.ToString(), DataSet.vendor_locksmith_notes.ToString(), DataSet.vendor_masonry_provider.ToString(), DataSet.vendor_masonry_contact.ToString(), DataSet.vendor_masonry_notes.ToString(), DataSet.vendor_oil_supply_provider.ToString(), DataSet.vendor_oil_supply_contact.ToString(), DataSet.vendor_oil_supply_notes.ToString(), DataSet.vendor_plot_light_repair_provider.ToString(), DataSet.vendor_plot_light_repair_contact.ToString(), DataSet.vendor_plot_light_repair_notes.ToString(), DataSet.vendor_plot_sweeping_provider.ToString(), DataSet.vendor_plot_sweeping_contact.ToString(), DataSet.vendor_plot_sweeping_notes.ToString(), DataSet.vendor_painting_provider.ToString(), DataSet.vendor_painting_contact.ToString(), DataSet.vendor_painting_notes.ToString(), DataSet.vendor_payphone_provider.ToString(), DataSet.vendor_payphone_contact.ToString(), DataSet.vendor_payphone_notes.ToString(), DataSet.vendor_plumbing_provider.ToString(), DataSet.vendor_plumbing_contact.ToString(), DataSet.vendor_plumbing_notes.ToString(), DataSet.vendor_retentionpond_provider.ToString(), DataSet.vendor_retentionpond_contact.ToString(), DataSet.vendor_retentionpond_notes.ToString(), DataSet.vendor_roof_repair_provider.ToString(), DataSet.vendor_roof_repair_contact.ToString(), DataSet.vendor_roof_repair_notes.ToString(), DataSet.vendor_security_provider.ToString(), DataSet.vendor_security_contact.ToString(), DataSet.vendor_security_notes.ToString(), DataSet.vendor_sewer_septic_drain_clearing_provider.ToString(), DataSet.vendor_sewer_septic_drain_clearing_contact.ToString(), DataSet.vendor_sewer_septic_drain_clearing_notes.ToString(), DataSet.vendor_sewer_septic_plumbing_provider.ToString(), DataSet.vendor_sewer_septic_plumbing_contact.ToString(), DataSet.vendor_sewer_septic_plumbing_notes.ToString(), DataSet.vendor_sidewalk_provider.ToString(), DataSet.vendor_sidewalk_contact.ToString(), DataSet.vendor_sidewalk_notes.ToString(), DataSet.vendor_signage_provider.ToString(), DataSet.vendor_signage_contact.ToString(), DataSet.vendor_signage_notes.ToString(), DataSet.vendor_smoke_water_restore_provider.ToString(), DataSet.vendor_smoke_water_restore_contact.ToString(), DataSet.vendor_smoke_water_restore_notes.ToString(), DataSet.vendor_snow_removal_provider.ToString(), DataSet.vendor_snow_removal_contact.ToString(), DataSet.vendor_snow_removal_notes.ToString(), DataSet.vendor_towing_provider.ToString(), DataSet.vendor_towing_contact.ToString(), DataSet.vendor_towing_notes.ToString(), DataSet.vendor_trashremoval_provider.ToString(), DataSet.vendor_trashremoval_contact.ToString(), DataSet.vendor_trashremoval_notes.ToString(), DataSet.vendor_flooring_provider.ToString(), DataSet.vendor_flooring_contact.ToString(), DataSet.vendor_flooring_notes.ToString(), DataSet.vendor_comments.ToString());
                    //result=dc.pUPropertiesDataSheet(, DataSet.original_gla.ToString(), DataSet.renovation_expansion.ToString(), DataSet.current_gla.ToString(), DataSet.acres_building.ToString(), DataSet.acres_parkinglot.ToString(), DataSet.acres_project_total.ToString(), DataSet.outparcel_tenants.ToString(), DataSet.acres_maintained.ToString(), DataSet.percent_acres_bedding_plants.ToString(), DataSet.number_dormant_months_year.ToString(), DataSet.parkinglot_number_of_poles.ToString(), DataSet.parkinglot_number_of_fixtures.ToString(), DataSet.parkinglot_type_of_fixture.ToString(), DataSet.parkinglot_location_of_controls.ToString(), DataSet.parkinglot_other.ToString(), DataSet.parkinglot_other_lighting.ToString(), DataSet.parkinglot_other_lighting_controls.ToString(), DataSet.roof.ToString(), DataSet.parking_spaces.ToString(), DataSet.parking_spaces_handicapped.ToString(), DataSet.parking_ratio.ToString(), DataSet.parking_sealcoat_overlay.ToString(), DataSet.building_fire_sprinkler.ToString(), DataSet.building_hvac.ToString(), DataSet.building_construction.ToString(), DataSet.building_key_notes.ToString(), DataSet.lockbox_location_01.ToString(), DataSet.lockbox_code_01.ToString(), DataSet.lockbox_location_02.ToString(), DataSet.lockbox_code_02.ToString(), DataSet.lockbox_location_03.ToString(), DataSet.lockbox_code_03.ToString(), DataSet.marketing_fund.ToString(), DataSet.marketing_contracted_to.ToString(), DataSet.utility_electric_text.ToString(), DataSet.utility_electric_provider.ToString(), DataSet.utility_electric_phone.ToString(), DataSet.utility_gas_text.ToString(), DataSet.utility_gas_provider.ToString(), DataSet.utility_gas_phone.ToString(), DataSet.utility_water_sewer_text.ToString(), DataSet.utility_water_sewer_provider.ToString(), DataSet.utility_water_sewer_phone.ToString(), DataSet.utility_telephone_text.ToString(), DataSet.utility_telephone_provider.ToString(), DataSet.utility_telephone_phone.ToString(), DataSet.municipal_police_text.ToString(), DataSet.municipal_police_provider.ToString(), DataSet.municipal_police_phone.ToString(), DataSet.municipal_fire_text.ToString(), DataSet.municipal_fire_provider.ToString(), DataSet.municipal_fire_phone.ToString(), DataSet.municipal_buildingdept_text.ToString(), DataSet.municipal_buildingdept_provider.ToString(), DataSet.municipal_buildingdept_phone.ToString(), DataSet.municipal_publicworks_text.ToString(), DataSet.municipal_publicworks_provider.ToString(), DataSet.municipal_publicworks_phone.ToString(), DataSet.municipal_highwaydept_text.ToString(), DataSet.municipal_highwaydept_provider.ToString(), DataSet.municipal_highwaydept_phone.ToString(), DataSet.vendor_cardaccess_provider.ToString(), DataSet.vendor_cardaccess_contact.ToString(), DataSet.vendor_cardaccess_notes.ToString(), DataSet.vendor_door_repair_provider.ToString(), DataSet.vendor_door_repair_contact.ToString(), DataSet.vendor_door_repair_notes.ToString(), DataSet.vendor_eifs_provider.ToString(), DataSet.vendor_eifs_contact.ToString(), DataSet.vendor_eifs_notes.ToString(), DataSet.vendor_electrical_provider.ToString(), DataSet.vendor_electrical_contact.ToString(), DataSet.vendor_electrical_notes.ToString(), DataSet.vendor_elevator_provider.ToString(), DataSet.vendor_elevator_contact.ToString(), DataSet.vendor_elevator_notes.ToString(), DataSet.vendor_enviro_cleanup_provider.ToString(), DataSet.vendor_enviro_cleanup_contact.ToString(), DataSet.vendor_enviro_cleanup_notes.ToString(), DataSet.vendor_exterminator_provider.ToString(), DataSet.vendor_exterminator_contact.ToString(), DataSet.vendor_exterminator_notes.ToString(), DataSet.vendor_facade_provider.ToString(), DataSet.vendor_facade_contact.ToString(), DataSet.vendor_facade_notes.ToString(), DataSet.vendor_fire_alarm_monitor_provider.ToString(), DataSet.vendor_fire_alarm_monitor_contact.ToString(), DataSet.vendor_fire_alarm_monitor_notes.ToString(), DataSet.vendor_fire_alarm_repair_provider.ToString(), DataSet.vendor_fire_alarm_repair_contact.ToString(), DataSet.vendor_fire_alarm_repair_notes.ToString(), DataSet.vendor_generator_provider.ToString(), DataSet.vendor_generator_contact.ToString(), DataSet.vendor_generator_notes.ToString(), DataSet.vendor_glass_boardup_provider.ToString(), DataSet.vendor_glass_boardup_contact.ToString(), DataSet.vendor_glass_boardup_notes.ToString(), DataSet.vendor_graffitti_vandal_provider.ToString(), DataSet.vendor_graffitti_vandal_contact.ToString(), DataSet.vendor_graffitti_vandal_notes.ToString(), DataSet.vendor_hvac_repair_provider.ToString(), DataSet.vendor_hvac_repair_contact.ToString(), DataSet.vendor_hvac_repair_notes.ToString(), DataSet.vendor_handrail_provider.ToString(), DataSet.vendor_handrail_contact.ToString(), DataSet.vendor_handrail_notes.ToString(), DataSet.vendor_irrigation_provider.ToString(), DataSet.vendor_irrigation_contact.ToString(), DataSet.vendor_irrigation_notes.ToString(), DataSet.vendor_janitorial_provider.ToString(), DataSet.vendor_janitorial_contact.ToString(), DataSet.vendor_janitorial_notes.ToString(), DataSet.vendor_landscaping_provider.ToString(), DataSet.vendor_landscaping_contact.ToString(), DataSet.vendor_landscaping_notes.ToString(), DataSet.vendor_locksmith_provider.ToString(), DataSet.vendor_locksmith_contact.ToString(), DataSet.vendor_locksmith_notes.ToString(), DataSet.vendor_masonry_provider.ToString(), DataSet.vendor_masonry_contact.ToString(), DataSet.vendor_masonry_notes.ToString(), DataSet.vendor_oil_supply_provider.ToString(), DataSet.vendor_oil_supply_contact.ToString(), DataSet.vendor_oil_supply_notes.ToString(), DataSet.vendor_plot_light_repair_provider.ToString(), DataSet.vendor_plot_light_repair_contact.ToString(), DataSet.vendor_plot_light_repair_notes.ToString(), DataSet.vendor_plot_sweeping_provider.ToString(), DataSet.vendor_plot_sweeping_contact.ToString(), DataSet.vendor_plot_sweeping_notes.ToString(), DataSet.vendor_painting_provider.ToString(), DataSet.vendor_painting_contact.ToString(), DataSet.vendor_painting_notes.ToString(), DataSet.vendor_payphone_provider.ToString(), DataSet.vendor_payphone_contact.ToString(), DataSet.vendor_payphone_notes.ToString(), DataSet.vendor_plumbing_provider.ToString(), DataSet.vendor_plumbing_contact.ToString(), DataSet.vendor_plumbing_notes.ToString(), DataSet.vendor_retentionpond_provider.ToString(), DataSet.vendor_retentionpond_contact.ToString(), DataSet.vendor_retentionpond_notes.ToString(), DataSet.vendor_roof_repair_provider.ToString(), DataSet.vendor_roof_repair_contact.ToString(), DataSet.vendor_roof_repair_notes.ToString(), DataSet.vendor_security_provider.ToString(), DataSet.vendor_security_contact.ToString(), DataSet.vendor_security_notes.ToString(), DataSet.vendor_sewer_septic_drain_clearing_provider.ToString(), DataSet.vendor_sewer_septic_drain_clearing_contact.ToString(), DataSet.vendor_sewer_septic_drain_clearing_notes.ToString(), DataSet.vendor_sewer_septic_plumbing_provider.ToString(), DataSet.vendor_sewer_septic_plumbing_contact.ToString(), DataSet.vendor_sewer_septic_plumbing_notes.ToString(), DataSet.vendor_sidewalk_provider.ToString(), DataSet.vendor_sidewalk_contact.ToString(), DataSet.vendor_sidewalk_notes.ToString(), DataSet.vendor_signage_provider.ToString(), DataSet.vendor_signage_contact.ToString(), DataSet.vendor_signage_notes.ToString(), DataSet.vendor_smoke_water_restore_provider.ToString(), DataSet.vendor_smoke_water_restore_contact.ToString(), DataSet.vendor_smoke_water_restore_notes.ToString(), DataSet.vendor_snow_removal_provider.ToString(), DataSet.vendor_snow_removal_contact.ToString(), DataSet.vendor_snow_removal_notes.ToString(), DataSet.vendor_towing_provider.ToString(), DataSet.vendor_towing_contact.ToString(), DataSet.vendor_towing_notes.ToString(), DataSet.vendor_trashremoval_provider.ToString(), DataSet.vendor_trashremoval_contact.ToString(), DataSet.vendor_trashremoval_notes.ToString(), DataSet.vendor_flooring_provider.ToString(), DataSet.vendor_flooring_contact.ToString(), DataSet.vendor_flooring_notes.ToString());
                    //return Json(result, JsonRequestBehavior.AllowGet);
                    return null;
                }
                else {
                    return null;

                }

            }
        }
        public ActionResult GetDocumentOverlays(HttpPostedFileBase file, string folderName)
        {
            if (Session["UserID"] != null)
            {
                // Verify that the user selecsted a file
                if (file != null && file.ContentLength > 0)
                {
                    // Get file info
                    var fileName = Path.GetFileName(file.FileName);
                    var rootFolder = "~/Overlays/" + folderName;
                    var contentLength = file.ContentLength;
                    var contentType = file.ContentType;
                    if (Directory.Exists(Server.MapPath(rootFolder)))
                    {
                        file.SaveAs(Server.MapPath(rootFolder + "/" + fileName));
                    }
                    else {
                        Directory.CreateDirectory(Server.MapPath(rootFolder));
                        file.SaveAs(Server.MapPath(rootFolder + "/" + fileName));
                    }
                    return RedirectToAction("PropertyDetails", "Details", new { propertyID = folderName });
                }
                else {
                    return RedirectToAction("HomeLogin", "Login", new { area = "Admin", id = "" });
                }
            }
            else
            {
                // Show error ...
                return View("Foo");
            }
        }
        [HttpPost]
        public JsonResult UploadFile(string FileType, string ImageName, string Category, string folderName)
        {
            try
            {
                bool isUploaded = false;
                string message = "File upload failed";
                var rootFolder = "";
                var returnURL = "";
                var fileName = "";
                string[] contentTypeOfFileSupported = ("application/vnd.openxmlformats-officedocument.wordprocessingml.document|application/vnd.openxmlformats-officedocument.presentationml.presentation|application/vnd.openxmlformats-officedocument.wordprocessingml.document|application/vnd.openxmlformats-officedocument.presentationml.presentation|application/vnd.openxmlformats-officedocument.spreadsheetml.sheet|application/pdf|text/plain").Split('|');
                if (Category == "Site Document")
                {
                    rootFolder = "~/Docs/" + folderName;
                    returnURL = "/Docs/" + folderName;
                    contentTypeOfFileSupported = ("application/vnd.openxmlformats-officedocument.wordprocessingml.document|application/vnd.openxmlformats-officedocument.presentationml.presentation|application/vnd.openxmlformats-officedocument.wordprocessingml.document|application/vnd.openxmlformats-officedocument.presentationml.presentation|application/vnd.openxmlformats-officedocument.spreadsheetml.sheet|application/pdf|text/plain").Split('|');
                }
                else if (Category == "Site Overlay")
                {
                    rootFolder = "~/Overlays/" + folderName;
                    returnURL = "/Overlays/" + folderName;
                    contentTypeOfFileSupported = ("application/vnd.openxmlformats-officedocument.wordprocessingml.document|application/vnd.openxmlformats-officedocument.presentationml.presentation|application/vnd.openxmlformats-officedocument.wordprocessingml.document|application/vnd.openxmlformats-officedocument.presentationml.presentation|application/vnd.openxmlformats-officedocument.spreadsheetml.sheet|application/pdf|text/plain").Split('|');
                }
                else if (Category == "Raymour Document")
                {
                    rootFolder = "~/POPDF/" + folderName;
                    returnURL = "/POPDF/" + folderName;
                    contentTypeOfFileSupported = ("pdf/application|application/pdf").Split('|');
                   // contentTypeOfFileSupported = ("application/pdf|text/plain|pdf/application|application/vnd.ms-xpsdocument").Split('|');
                }


                //var contentTypeOfFile = ("image/jpeg|image/gif|image/png|application/vnd.openxmlformats-officedocument.spreadsheetml.sheet|application/pdf|text/plain").Split('|');
                string fileID = DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Year.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + DateTime.Now.Millisecond.ToString();
                if (string.IsNullOrEmpty(ImageName) != true)
                {
                    fileID = ImageName + "-" + fileID;
                }

                foreach (string file in Request.Files)
                {
                    var fileContent = Request.Files[file];
                    var fileExtension = fileContent.ContentType;
                    for (var i = 0; i < contentTypeOfFileSupported.Length; i++)
                    {
                        if (fileExtension == contentTypeOfFileSupported[i])
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
                        //fileName = Path.GetFileName(file);
                        fileName = fileContent.FileName;


                        if (Directory.Exists(Server.MapPath(rootFolder)))
                        {
                            if (Category == "Raymour Document") {
                                EmptyTemImage(folderName, "", "Raymour Document");
                            }
                            fileContent.SaveAs(Server.MapPath(rootFolder + "/" + fileName));
                            isUploaded = true;
                        }
                        else {
                            Directory.CreateDirectory(Server.MapPath(rootFolder));
                            fileContent.SaveAs(Server.MapPath(rootFolder + "/" + fileName));
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
                var returnString = isUploaded + "|" + message + "|" + fileName + "|" + returnURL + "/" + fileName;
                return Json(returnString, JsonRequestBehavior.AllowGet);

            }
            catch (Exception)
            {
                // Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return Json("Upload failed");
            }

            //return Json("File uploaded successfully");
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
            else if (Category == "Raymour Document")
            {
                rootPath = "~/POPDF/" + PropertyID +"/";
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
    }
}

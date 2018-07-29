/*****************start of google maps ***************************/
    //for datatable
$(document).ready(function () {
    ////user role section
    //var UniAdmin = @Session["uniadmin"];
    //alert(UniAdmin);
    //if('@Session["uniadmin"]'!=null){
    //    if("@Session['uniadmin'].ToString()"!="Yes"){
    //        $(".UniAdminPermission").css("display","none");
    //    }
    //}else{
    //    window.location = "/Login/HomeLogin?area=admin";
    //}
    ////end of user role section

    $('#propertyImage').error(function () {
        $("#propertyImage").attr("src", "../Content/imgs/noimages.png");
    });
    $(".number").keyup(function () {
        var value = fnRemoveCommas(this.value);
        if ($.isNumeric(value) === false) {
            this.value = numberWithCommas(this.value.slice(0, -1));
        } else {
            //this.value = numberWithCommas(value);
        }

    });
    $(".number-float").change(function () {
        this.value = numberWithCommas(Number(fnRemoveCommas(this.value)).toFixed(2));
    });
    //for datetime
    $('.datetime input').datepicker({
        dateFormat: 'mm-dd-yy'
    });

    //for set datetime
    $('.date-picker input').datepicker({
        dateFormat: 'yy-mm-dd'
    });

    //for time
    $('.timepicker input').timepicker();

    //for percentage
    $(".percetage").keyup(function () {
        var value = fnRemoveCommas(this.value);
        if ($.isNumeric(value) === false || value>99) {
            //alert("Please enter numeric value.");
            this.value = this.value.slice(0, -1);
        } else {
            this.value = value;
        }
    });

    //to search in propertyDataTable
    $('#propertyDataTableSearch').keyup(function () {
       // $("#propertyDataTable").DataTable().search($(this).val()).draw();
    });
    
    //to show processing image
    $(".startProcessing").click(function () {
        fnProgress(true);
    });

    //to stop processing image
    $(".stopProcessing").click(function () {
        fnProgress(false);
    });

    $('a[href="table_datatables.html"]').addClass('active').parent().parent().addClass('in');

    //fixed drop-down box width
    $.extend($.ui.autocomplete.prototype.options, {
        open: function (event, ui) {
            //alert($(this).width());
            $(this).autocomplete("widget").css({
                "width": ($(this).width() + 55 + "px")

            });
        }
    });
});

var classUniSource = {
    propertyID: "",
    fnImageUploadOnChange: function (e, category, imageTableID) {
        fnProgress(true);
        //var files = e.target.files;
        var imageName = checkIsNull($(e).attr("name"),"");
        var files = document.getElementById('fu-my-auto-upload').files;
        if (files.length > 0) {
            if (window.FormData !== undefined) {
                var data = new FormData();
                for (var x = 0; x < files.length; x++) {
                    data.append("file" + x, files[x]);
                }
                //url: '/DataEntry/UploadImage?Action="Inspection"',
                //Url.Action("PropertyInspection", "DataEntry")

                $.ajax({
                    url: '/DataEntry/UploadImage?folderType=Inspection&ImageName='+imageName,
                    type: "POST",
                    contentType: false,
                    processData: false,
                    data: data,
                    success: function (data) {
                        var dataArry = data.split("|");
                        // console.log(dataArry[0]);
                        if (dataArry[0] == "True" || dataArry[0] == true) {
                            $("#errorImageUpload").html("");
                            $('#'+imageTableID+ ' tr').append('<td class="tdImageUpload" id="' + dataArry[2] + '" name="' + dataArry[3] + '" onClick="classInspection.removeImageFromServer1(this)" title="Click to view."><img src="' + dataArry[3] + '" class="uploadedImage img-thumbnail"/></td>');

                            //to color plus button for comments and image
                            if (imageName!="") {
                                $("#id-Comments-" + imageName).addClass("commentsAlready hasImage");
                            }
                            fnProgress(false);
                        }
                        else {
                            $("#errorImageUpload").html("<span class='alert-danger'>" + dataArry[1] + "</span>");
                            fnProgress(false);
                        }
                    },
                    error: function (xhr, status, p3, p4) {
                        fnProgress(false);
                        var err = "Error " + " " + status + " " + p3 + " " + p4;
                        if (xhr.responseText && xhr.responseText[0] == "{")
                            err = JSON.parse(xhr.responseText).Message;
                        console.log(err);
                    }
                });
            } else {
                alertify.alert("This browser doesn't support HTML5 file uploads!");
            }
        }
    },
    fnGetTotlaNumberofItemsOfFourBlock: function () {
        $.ajax({
           // url: "@Url.Action('GetTotalNumberOfCatetory', 'Home')",
            url: "/Home/GetTotalNumberOfCatetory",
            data: "",
        type: "GET",
        dataType: "json",
        success: function (data) {
            $.each(data, function (i, record) {
                // alert("success" + record.TotalWOrkOrder + " 2" + record.TotalWorkRequest);
                $("#totalWorkRequest").text(numberWithCommas(record.TotalWorkRequest));
                $("#totalPropertyInspections").text(numberWithCommas(record.TotalPropertyInspection));
                $("#totalSnowRemoval").text(numberWithCommas(record.TotalSnowReport));
                $("#totalWorkOrder").text(numberWithCommas(record.TotalWOrkOrder));
            });

            //loadData(data);
        },
        error: function () {
            $.fn.dataTable.ext.errMode = 'throw';
        }
        });
    },
    fnSiteSubMenuShow: function (propertyID,propertyName,selectedID) {
        if (propertyID != "" && propertyName != "") {
            $("#liPropertyName").html(propertyName);
            $("#liPropertyName").attr("href", "/Details/PropertyDetails?propertyID=" + propertyID);
            $("#liWorkRequest").attr("href", "/Details/ProductDetails?category=Work Request&property=" + propertyID);
            $("#liWorkOrder").attr("href", "/Details/ProductDetails?category=Work Order&property=" + propertyID);
            $("#liPropertyInspection").attr("href", "/Details/ProductDetails?category=Property Inspections&property=" + propertyID);
            $("#liSnowRemoval").attr("href", "/Details/ProductDetails?category=Snow Removal&property=" + propertyID);
            $(".expand-menu").addClass("collapse in");
            $(".expand-menu").attr("aria-expanded", "true");
            $(".expand-menu").css("display", "block");
            if (selectedID!="") {
                 $("a").removeClass("active");
                 $("#"+selectedID).addClass("active");
            }
        }
    },
    escapeHTML: function (s) {
        //return s.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        return s.replace(/\r?\n/g, '<br />', ' ');
    }
};

  
    function loadMaps(divID,addrers) {
        var address1 = addrers;
        var address2 = 'New York, US';

        //var map = new google.maps.Map(document.getElementById('map-canvas'), {
        //    zoom: 4,
        //    center: new google.maps.LatLng(35.00, -25.00)
        //});

        var gc = new google.maps.Geocoder();

        gc.geocode({ 'address': address1 }, function (res1, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                var map = new google.maps.Map(document.getElementById(divID), {
                            zoom: 12,
                            position: res1[0].geometry.location,
                            center: res1[0].geometry.location
                        });
                        new google.maps.Marker({
                            position: res1[0].geometry.location,
                            map: map
                        });

            }
        });


    }

    function fnGetParameterByName(name) {
        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
        var regexS = "[\\?&]" + name + "=([^&#]*)";
        var regex = new RegExp(regexS);
        var results = regex.exec(window.location.href);
        if (results == null)
            return "";
        else
            return decodeURIComponent(results[1].replace(/\+/g, ""));
    }
function checkIsNull(itemValue, isNullValue) {
    var isNullReturn = "";
    if (itemValue == 'NaN' || itemValue == 'undefined' || itemValue == null || itemValue == "") {
        isNullReturn = isNullValue;
    }
    else {
        isNullReturn = itemValue;
    }
    return isNullReturn;
}

function numberWithCommas(x) {
    if ($.isNumeric(x) == true) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    } else {
        return x;
    }

}
function fnRemoveCommas(Number) {
    //return currentValue.replace(/\,/g, '');
    var ReturnNumber = "";
    var ActualNumber = Number;
    if ($.isNumeric(ActualNumber) == true) {
        return ActualNumber;
    }
    else {
        var SplitNumberAry = ActualNumber.split(",");
        for (i = 0; i < SplitNumberAry.length; i++) {
            ReturnNumber = ReturnNumber.concat(SplitNumberAry[i]);
        }
        return ReturnNumber;
    }
}
function fnProgress(status) {
    if (status == true) {
        $("#divLoading").css("display", "block");//to show waiting signal
        setTimeout(function () {
        }, 2000);
       
    } else {
        $("#divLoading").css("display", "none");//to show waiting signal
    }
    
}
function fnConvertDate(currDate, currentFormat,returnFormat) {
    if (checkIsNull(currDate, "") != "" && (currDate.indexOf('-') != -1 || currDate.indexOf('/') != -1)) {
        var month = "|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec";
        month = month.split('|');
        var currDate = currDate.split(' ')[0];
        if (currDate.indexOf('/') != -1) {
            var currFormatDate = currDate.split('/');
            /*if (currFormatDate[1][0] == '0') {
                currFormatDate[1] = currFormatDate[1][1];
            }
            if (currFormatDate[2][0] == '0') {
                currFormatDate[2] = currFormatDate[2][1];
            }
            if (currFormatDate[0][0] == '0') {
                currFormatDate[0] = currFormatDate[0][1];
            }
            var actualMOnth = month[currFormatDate[0]];
            var actualDate = currFormatDate[1] + "-" + actualMOnth + "-" + currFormatDate[2];*/
            if (currentFormat == "mm/dd/yyyy") {
                if (returnFormat == "yyyy-mm-dd") {
                    actualDate = currFormatDate[2] + "-" + currFormatDate[0] + "-" + currFormatDate[1];
                } else if (returnFormat == "dd-mm-yyyy") {
                    actualDate = currFormatDate[1] + "-" + currFormatDate[0] + "-" + currFormatDate[2];
                }
            } else if (currentFormat == "yyyy/mm/dd") {
                if (returnFormat == "mm-dd-yyyy") {
                    actualDate = currFormatDate[1] + "-" + currFormatDate[2] + "-" + currFormatDate[0];
                } else if (returnFormat == "dd-mm-yyyy") {
                    actualDate = currFormatDate[2] + "-" + currFormatDate[1] + "-" + currFormatDate[0];
                }
            }
        } else if (currDate.indexOf('-') != -1) {
            var currFormatDate = currDate.split('-');
            if (currentFormat == "mm-dd-yyyy") {
                if (returnFormat == "yyyy-mm-dd") {
                    actualDate = currFormatDate[2] + "-" + currFormatDate[0] + "-" + currFormatDate[1];
                } else if (returnFormat == "dd-mm-yyyy") {
                    actualDate = currFormatDate[1] + "-" + currFormatDate[0] + "-" + currFormatDate[2];
                }
            } else if (currentFormat == "yyyy-mm-dd") {
                if (returnFormat == "mm-dd-yyyy") {
                    actualDate = currFormatDate[1] + "-" + currFormatDate[2] + "-" + currFormatDate[0];
                } else if (returnFormat == "dd-mm-yyyy") {
                    actualDate = currFormatDate[2] + "-" + currFormatDate[1] + "-" + currFormatDate[0];
                }
            }
           
        } else {
            return currDate;
        }
        return actualDate;
    } else {
        return currDate;
    }
}


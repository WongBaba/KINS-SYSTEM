using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.IO;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Web.Script.Services;

namespace KINS_SYSTEM.Pages.OrderManagement
{
    public partial class OrderManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Redirect("~/Pages/Login.aspx");
                }
                if (Session["permissions"].ToString().IndexOf("#O01") < 0)
                {
                    Response.Redirect("~/Pages/NoPermission.aspx?permissionId=#O01");
                }
            }
        }
    }
}  

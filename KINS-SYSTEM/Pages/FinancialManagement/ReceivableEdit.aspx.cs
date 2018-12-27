using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KINS_SYSTEM.Pages.FinancialManagement
{
    public partial class ReceivableEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Redirect("~/Pages/Login.aspx");
                }
                if (Session["permissions"].ToString().IndexOf("#F12") < 0)
                {
                    Response.Redirect("~/Pages/NoPermission.aspx?permissionId=#F12");
                }
            }
        }
    }
}
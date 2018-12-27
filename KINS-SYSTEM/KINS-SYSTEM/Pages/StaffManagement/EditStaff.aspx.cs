using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KINS_SYSTEM.Pages.StaffManagement
{
    public partial class EditStaff : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Redirect("~/Pages/Login.aspx");
                }
                if (Session["permissions"].ToString().IndexOf("#S03") < 0)
                {
                    Response.Redirect("~/Pages/NoPermission.aspx?permissionId=#S03");
                }
            }
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KINS_SYSTEM.Pages.CustomerManagement
{
    public partial class GetCustomerInfo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["yhm"] == null)
            {
                Response.Redirect("~/Pages/Login.aspx");
            }
            //该功能还未设置权限，有时间再设置
            //if (Session["permissions"].ToString().IndexOf("#S01") < 0)
            //{
            //    Response.Redirect("~/Pages/NoPermission.aspx?permissionId=#S01");
            //}
        }
    }
}
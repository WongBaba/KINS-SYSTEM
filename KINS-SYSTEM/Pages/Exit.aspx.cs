using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KINS_SYSTEM.Pages
{
    public partial class Exit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Write("<script language='javascript' type='text/javascript'>  window.parent.location.href = 'Login.aspx'; </script>");
                }
            }
            Session["yhm"] = null;
            ClearClientPageCache();
            Response.Redirect("~/Pages/Login.aspx");
        }

        public void ClearClientPageCache()
        {
            //清除浏览器缓存
            Response.Buffer = true;
            Response.ExpiresAbsolute = DateTime.Now.AddDays(-1);
            Response.Cache.SetExpires(DateTime.Now.AddDays(-1));
            Response.Expires = 0;
            Response.CacheControl = "no-cache";
            Response.Cache.SetNoStore();

        }
    }
}
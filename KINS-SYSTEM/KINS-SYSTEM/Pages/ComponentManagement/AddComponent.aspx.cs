using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Data;

namespace KINS_SYSTEM.Pages.ProductManagement
{
    public partial class AddComponent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Redirect("~/Pages/Login.aspx");
                }
                if (Session["permissions"].ToString().IndexOf("#C02") < 0)
                {
                    Response.Redirect("~/Pages/NoPermission.aspx?permissionId=#C02");
                }
            }
            //setSession();
        }
        //private void setSession()
        //{
        //    string sqlStr = "select Tp_id,Tp_name from k_ProductType where Tp_type='成品' order by Tp_name";
        //    DbSql ds = new DbSql();
        //    DataTable da = new DataTable();
        //    da = ds.FillDt(sqlStr);
        //    string useType = "";
        //    for (int i = 0; i < da.Rows.Count; i++)
        //        useType += ";" + da.Rows[i][1]+";" + da.Rows[i][1];
        //    if (useType != "")
        //        useType = useType.Substring(1);
        //    Session["useType"] = useType;
        //}
    }
}
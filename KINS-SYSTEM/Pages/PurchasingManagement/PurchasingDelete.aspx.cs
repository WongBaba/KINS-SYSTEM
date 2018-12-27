using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;

namespace KINS_SYSTEM.Pages.PurchasingManagement
{
    public partial class PurchasingDelete : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void yes_Click(object sender, EventArgs e)
        {
            string sqlStr = "UPDATE K_Purchasing SET Pc_isValid='0'  WHERE ";
            string[] sArray = Request.QueryString["Pc_id"].ToString().Split(',');

            foreach (string i in sArray)
            {
                sqlStr += " Pc_id='" + i + "'  or";
            }
            sqlStr = sqlStr.Substring(0, sqlStr.Length - 3);
            DbSql ds = new DbSql();
            if (!ds.ExecSql(sqlStr))
                Response.Write("<script language='javascript' type='text/javascript'>  alert('操作失败，请重试或者检查网络联系管理员')</script>");
            workOut();
        }

        protected void no_Click(object sender, EventArgs e)
        {
            workOut();
        }

        private void workOut()
        {
            Response.Write("<script language='javascript' type='text/javascript'>  window.parent.hideBlackScreen();window.parent.getPageData();</script>");
        }
    }
}
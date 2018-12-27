using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;

namespace KINS_SYSTEM.Pages.ProductManagement
{
    public partial class delComponentType : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Redirect("~/Pages/Login.aspx");
                }
                if (Session["permissions"].ToString().IndexOf("#C07") < 0)
                {
                    Response.Redirect("~/Pages/NoPermission.aspx?permissionId=#C07");
                }
            }
        }

        protected void yes_Click(object sender, EventArgs e)
        {
            string sqlStr = "DELETE FROM k_ProductType  WHERE ";
            string[] sArray = Request.QueryString["delData"].ToString().Split(',');

            foreach (string i in sArray)
            {
                sqlStr += " Tp_id='" + i + "'  or";
            }
            sqlStr = sqlStr.Substring(0, sqlStr.Length - 3);
            DbSql ds = new DbSql();
            if (!ds.ExecSql(sqlStr))
                Response.Write("<script language='javascript' type='text/javascript'>  alert('删除失败，请重试或者检查网络联系管理员')</script>");
            workOut();
        }

        protected void no_Click(object sender, EventArgs e)
        {
            workOut();
        }

        //操作处理完毕，恢复父页面
        private void workOut()
        {
            Response.Write("<script language='javascript' type='text/javascript'>  window.parent.hideBlackScreen();window.parent.initPageData();</script>");
        }
    }
}
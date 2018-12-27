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
    public partial class AddComponentType : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Redirect("~/Pages/Login.aspx");
                }
                if (Session["permissions"].ToString().IndexOf("#C03") < 0)
                {
                    Response.Redirect("~/Pages/NoPermission.aspx?permissionId=#C03");
                }
            }
        }

        protected void yes_Click(object sender, EventArgs e)
        {
            string sqlStr = "SELECT * FROM k_ProductType WHERE Tp_company='"+Session["company"]+"' and Tp_name='" + ComTp.Text + "'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (da.Rows.Count > 0)
            {
                Response.Write("<script language='javascript' type='text/javascript'>  alert('添加失败，该类型已存在')</script>");
                return;
            }

            sqlStr = "INSERT INTO k_ProductType (Tp_name, Tp_type,Tp_company) VALUES ('"+ComTp.Text+"', '零件','"+Session["company"]+"')";
            if (!ds.ExecSql(sqlStr))
                Response.Write("<script language='javascript' type='text/javascript'>  alert('添加失败，请重试或者检查网络联系管理员')</script>");
            workOut();
        }

        protected void no_Click(object sender, EventArgs e)
        {
            workOut();
        }

        //操作处理完毕，恢复并更新父页面数据
        private void workOut()
        {
            Response.Write("<script language='javascript' type='text/javascript'>  window.parent.hideBlackScreen();window.parent.initPageData();</script>");
        }
    }
}
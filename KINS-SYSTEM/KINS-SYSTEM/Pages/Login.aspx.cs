using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Data;

namespace KINS_SYSTEM.Pages
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load1(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    //Response.Write("<script language='javascript' type='text/javascript'>  window.parent.location.href = 'Login.aspx'; </script>");
                }
            }
        }

        protected void submit_Click(object sender, EventArgs e)
        {
            loginSystem("Index.aspx");
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            loginSystem("AttendanceManagement/CheckIn.aspx");
        }
        private void loginSystem(string url) {
            string sqlStr = "select * from K_Employee where Emp_account='" + yhm.Text + "' and Emp_password='" + mm.Text + "'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (da.Rows.Count > 0)
            {
                Response.Write(da.Rows.Count.ToString());
                Session["yhm"] = yhm.Text;
                Session["company"] = da.Rows[0]["Emp_company"].ToString();
                Session["xm"] = da.Rows[0]["Emp_name"].ToString();
                Session["indexUrl"] = da.Rows[0]["Emp_indexUrl"].ToString();
                Session["permissions"] = da.Rows[0]["Emp_permissions"].ToString();
                Session["Emp_id"] = da.Rows[0]["Emp_id"].ToString();
                Response.Redirect(url);
            }
            else
            {
                Response.Write("<script language='javascript' type='text/javascript'>  alert('密码错误或用户名不存在')</script>");
            }
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Data;

namespace KINS_SYSTEM.Pages.StaffManagement
{
    public partial class EditPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void yes_Click(object sender, EventArgs e)
        {
            if (new_ps.Text != again_ps.Text)
            {
                Response.Write("<script language='javascript' type='text/javascript'>  alert('修改失败，两次输入新密码不一致，请重新输入')</script>");
                return;
            }
            string sqlStr = "select * from K_Employee where Emp_account='" + Session["yhm"] + "' and Emp_password='" + old_ps.Text + "' and Emp_company='"+Session["company"]+"'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (da.Rows.Count > 0)
            {
                sqlStr = "update K_Employee set Emp_password='" + new_ps.Text + "' where Emp_id='" + Session["Emp_id"] + "'";
                if (ds.ExecSql(sqlStr))
                {
                    Session["yhm"] = null;
                    Response.Write("<script language='javascript' type='text/javascript'>  alert('修改成功，请重新登录页面');window.parent.location.href='../Login.aspx';</script>");
                }
                else {
                    Response.Write("<script language='javascript' type='text/javascript'>  alert('修改失败，请重试或联系系统管理员')</script>");
                }
                
            }
            else
            {
                Response.Write("<script language='javascript' type='text/javascript'>  alert('密码错误或用户名不存在')</script>");
            }
        }

        protected void no_Click(object sender, EventArgs e)
        {
            workOut();
        }
        //调用父页面的JS方法，隐藏当前页面
        private void workOut()
        {
            Response.Write("<script language='javascript' type='text/javascript'>  window.parent.hideBlackScreen();window.parent.initPageData();</script>");
        }

        protected void TextBox2_TextChanged(object sender, EventArgs e)
        {

        }

        protected void again_ps_TextChanged(object sender, EventArgs e)
        {

        }

        protected void old_ps_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;

namespace KINS_SYSTEM.Pages.ProductManagement
{
    public partial class DelProductSku : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Redirect("~/Pages/Login.aspx");
                }
                if (Session["permissions"].ToString().IndexOf("#P05") < 0)
                {
                    Response.Redirect("~/Pages/NoPermission.aspx?permissionId=#P05");
                }
            }
        }

        protected void yes_Click(object sender, EventArgs e)
        {
            string sqlStr = "DELETE FROM K_ProductSku  WHERE ";
            string[] sArray = Request.QueryString["delData"].ToString().Split(',');

            foreach (string i in sArray)
            {
                sqlStr += " SKU_id='" + i + "'  or";
            }
            sqlStr = sqlStr.Substring(0, sqlStr.Length - 3);
            DbSql ds = new DbSql();
            if (!ds.ExecSql(sqlStr))
                Response.Write("<script language='javascript' type='text/javascript'>  alert('删除失败，请重试或者检查网络联系管理员')</script>");
            updateProduct(Request.QueryString["skuId"].ToString());
            workOut();
        }

        protected void no_Click(object sender, EventArgs e)
        {
            workOut();
        }

        private void updateProduct(string id)
        {
            string sqlStr = "UPDATE K_Product SET Pd_inventory=(SELECT SUM(SKU_inventory) FROM K_ProductSku WHERE SKU_pdId='" + id + "') WHERE Pd_id='" + id + "';";
            sqlStr += "UPDATE K_Product SET Pd_SKU =(SELECT COUNT(*) FROM K_ProductSku WHERE SKU_pdId='" + id + "') WHERE Pd_id='" + id + "'";
            sqlStr += "UPDATE K_Product SET Pd_price =(SELECT (SELECT convert(nvarchar(20),MIN(SKU_price )) FROM K_ProductSku  WHERE SKU_pdId='" + id + "')+'-'+convert(nvarchar(20),MAX(SKU_price)) FROM K_ProductSku  WHERE SKU_pdId='" + id + "') WHERE Pd_id='" + id + "'";
            DbSql ds = new DbSql();
            ds.ExecSql(sqlStr);
        }

        private void workOut()
        {
            Response.Write("<script language='javascript' type='text/javascript'>  window.parent.hideBlackScreen();window.parent.getSkuData();window.parent.getProduct();</script>");
        }
    }
}
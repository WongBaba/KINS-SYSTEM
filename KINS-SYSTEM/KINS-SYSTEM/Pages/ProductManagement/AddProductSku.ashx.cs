using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Web.SessionState;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;

namespace KINS_SYSTEM.Pages.ProductManagement
{
    /// <summary>
    /// AddProductSku 的摘要说明
    /// </summary>
    public class AddProductSku : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            context.Response.Write(addComponent(data));
        }

        private int addComponent(Data data)
        {
            //返回1代表该SKU已存在，返回2代表添加成功，返回0代表数据库添加失败
            string sqlStr = "SELECT * FROM K_ProductSku WHERE SKU_id='" + data.SKU_id + "'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            if (da.Rows.Count > 0)
                return 1;

            sqlStr = "INSERT INTO K_ProductSku (SKU_inventory, SKU_pdId, SKU_parameter, SKU_name, SKU_id, SKU_remarks, SKU_price) VALUES ('" +
                data.SKU_inventory + "', '" + data.SKU_pdId + "', '" + data.SKU_parameter + "', '" + data.SKU_name + "', '" + data.SKU_id + "', '" + data.SKU_remarks + "', '" + data.SKU_price + "')";
            if (!ds.ExecSql(sqlStr))
                return 0;
            updateProduct(data.SKU_pdId);
            return 2;
        }

        private void updateProduct(string id)
        {
            string sqlStr = "UPDATE K_Product SET Pd_inventory=(SELECT SUM(SKU_inventory) FROM K_ProductSku WHERE SKU_pdId='" + id + "') WHERE Pd_id='" + id + "';";
            sqlStr += "UPDATE K_Product SET Pd_SKU =(SELECT COUNT(*) FROM K_ProductSku WHERE SKU_pdId='" + id + "') WHERE Pd_id='" + id + "'";
            sqlStr += "UPDATE K_Product SET Pd_price =(SELECT (SELECT convert(nvarchar(20),MIN(SKU_price )) FROM K_ProductSku  WHERE SKU_pdId='" + id + "')+'-'+convert(nvarchar(20),MAX(SKU_price)) FROM K_ProductSku  WHERE SKU_pdId='" + id + "') WHERE Pd_id='" + id + "'";
            DbSql ds = new DbSql();
            ds.ExecSql(sqlStr);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public class Data
        {
            public string SKU_inventory, SKU_pdId, SKU_parameter, SKU_name, SKU_id, SKU_remarks, SKU_price;
        }
    }
}
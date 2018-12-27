using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace KINS_SYSTEM.Pages.ProductManagement
{
    /// <summary>
    /// GetSkuData 的摘要说明
    /// </summary>
    public class GetSkuData : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain"; 
            JavaScriptSerializer jss = new JavaScriptSerializer();
            String data = jss.Deserialize<String>(context.Request["data"].ToString());; 
            context.Response.Write(getSkuData(data));
        }

        private string getSkuData(string  data) {
            string sqlStr = "select * from K_ProductSku where SKU_pdId='" + data + "' order by SKU_id";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            return JsonConvert.SerializeObject(da, new DataTableConverter());
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
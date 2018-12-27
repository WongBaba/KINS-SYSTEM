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
    /// Init_Component 的摘要说明
    /// </summary>
    public class Init_Component : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.company = context.Session["company"].ToString();
            context.Response.Write(getComData(data));
        }

        private string getComData(Data data) {
            string dataSum = "select count(*) from K_Component where Cp_isValid='1' and Cp_company='"+data.company+"'";
            string sqlStr = "select top 200 * from K_Component ,k_ProductType ,K_info_Company where K_Component.Cp_typeId=k_ProductType.Tp_id and K_Component.Cp_manufacturerId=K_info_Company.Co_id";
            sqlStr += " and Cp_isValid='1' and K_Component.Cp_company='" + data.company + "' and k_ProductType.Tp_company='" + data.company + "' and K_info_Company.Co_company='" + data.company + "'";
            //order=1 以类型进行筛选，order=2 以制造商进行筛选
            if (data.order == "1")
            {
                dataSum += "and Cp_typeId='" + data.require + "'";
                sqlStr += " and Cp_typeId='" + data.require + "'  and Cp_id not in (" + "select top " + (data.starCom - 1).ToString() + " Cp_id from K_Component where  Cp_isValid='1' and  Cp_company='" + data.company + "' and Cp_typeId='" + data.require + "' order by Cp_manufacturerId ) order by Cp_manufacturerId ";
            }
            else if (data.order == "2")
            {
                dataSum += "and Cp_manufacturerId='" + data.require + "'";
                sqlStr += " and Cp_manufacturerId='" + data.require + "'  and Cp_id not in (" + "select top " + (data.starCom - 1).ToString() + " Cp_id from K_Component where Cp_company='" + data.company + "' and  Cp_manufacturerId='" + data.require + "' order by Cp_typeId ) order by Cp_typeId ";
            }
            else sqlStr += " and Cp_id not in (" + "select top " + (data.starCom - 1).ToString() + " Cp_id from K_Component where Cp_company='"+data.company+"'  order by  Cp_typeId ) order by  Cp_typeId ";

            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);

            dataSum = ds.FillDt(dataSum).Rows[0][0].ToString();
            DataRow dr = da.NewRow();
            dr["Cp_parameter"] = dataSum;//
            da.Rows.Add(dr);                //将这一行记录加这个表中

            return (JsonConvert.SerializeObject(da, new DataTableConverter()));
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
            public string order = "";
            public string require = "",company="";
            public int starCom;
        }
    }
}
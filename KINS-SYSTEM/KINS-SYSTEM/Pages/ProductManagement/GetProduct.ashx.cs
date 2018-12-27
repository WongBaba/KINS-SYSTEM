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
    /// GetProduct 的摘要说明
    /// </summary>
    public class GetProduct : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.company = context.Session["company"].ToString();
            context.Response.Write(getComData(data));
        }

        private string getComData(Data data)
        {
            //select top 10 * from 表名 where id not in (select top 10 id from 表名 order by id asc) order by ID  
            string dataSum = "select count(*) from K_Product where Pd_company='"+data.company+"'";
            string sqlStr = "select top 200 * from K_Product ,k_ProductType ,K_info_Company where K_Product.Pd_typeId=k_ProductType.Tp_id and K_Product.Pd_manufacturerId=K_info_Company.Co_id";
            sqlStr += " and K_Product.Pd_company='" + data.company + "' and K_info_Company.Co_company='" + data.company + "' and k_ProductType.Tp_company='" + data.company + "' ";
            //order=1 以类型进行筛选，order=2 以制造商进行筛选
            if (data.order == "1")
            {
                dataSum += "and Pd_typeId='" + data.require + "'";
                sqlStr += " and Pd_typeId='" + data.require + "'  and Pd_id not in (" + "select top " + (data.starCom - 1).ToString() + " Pd_id from K_Product where Pd_company='"+data.company+"' and Pd_typeId='" + data.require + "' order by Pd_manufacturerId ) order by Pd_manufacturerId ";
            }
            else if (data.order == "2")
            {
                dataSum += "and Pd_manufacturerId='" + data.require + "'";
                sqlStr += " and Pd_manufacturerId='" + data.require + "'  and Pd_id not in (" + "select top " + (data.starCom - 1).ToString() + " Pd_id from K_Product where Pd_company='" + data.company + "' and  Pd_manufacturerId='" + data.require + "' order by Pd_typeId ) order by Pd_typeId ";
            }
            else sqlStr += " and Pd_id not in (" + "select top " + (data.starCom - 1).ToString() + " Pd_id from K_Product  order by  Pd_typeId ) order by  Pd_typeId,Pd_name ";

            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);

            dataSum = ds.FillDt(dataSum).Rows[0][0].ToString();
            DataRow dr = da.NewRow();
            dr["Pd_name"] = dataSum;//
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
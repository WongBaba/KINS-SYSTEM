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

namespace KINS_SYSTEM.Pages.PurchasingManagement
{
    /// <summary>
    /// PurchasingManagementGetData 的摘要说明
    /// </summary>
    public class PurchasingManagementGetData : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.Pc_company = context.Session["company"].ToString();
            context.Response.Write(getData(data));
        }

        private string getData(Data data)
        {
            string sqlStr = " select top 200 * from K_Purchasing ,k_ProductType ,K_info_Company where K_Purchasing.Pc_typeId=k_ProductType.Tp_id and K_Purchasing.Pc_manufacturerId=K_info_Company.Co_id";
            sqlStr += " and K_Purchasing.Pc_isValid='1' and  K_Purchasing.Pc_company='" + data.Pc_company + "' and k_ProductType.Tp_company='" + data.Pc_company + "' and K_info_Company.Co_company='" + data.Pc_company + "' ";
            sqlStr += getSqlStr(data);
            sqlStr += " and Pc_id not in ( select top " + (data.starCom - 1) + " Pc_id from  K_Purchasing where Pc_isValid='1' and Pc_company='" + data.Pc_company + "' " + getSqlStr(data) + " order  by Pc_date desc,Pc_editDate desc)";
            sqlStr += "  order  by Pc_date desc,Pc_editDate desc";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            da.Rows.Add(da);                //将这一行记录加这个表中
            sqlStr = "select count (*) from K_Purchasing where Pc_isValid='1' and Pc_company='" + data.Pc_company + "' " + getSqlStr(data);
            string temp = ds.FillDt(sqlStr).Rows[0][0].ToString();
            DataRow row = da.NewRow();
            row["Pc_id"] = temp;
            da.Rows.Add(row);
            return (JsonConvert.SerializeObject(da, new DataTableConverter()));
        }

        private string getSqlStr(Data data)
        {
            string sqlStr = "";
            if (data.Pc_date != "")
                sqlStr += " and Pc_date = '" + data.Pc_date + "'";
            if (data.Pc_manufacturer != "")
                sqlStr += " and Pc_manufacturerId like '%" + data.Pc_manufacturer + "%'";
            if (data.Pc_type != "")
                sqlStr += " and Pc_typeId = '" + data.Pc_type + "'";
            if (data.Pc_parameter != "")
                sqlStr += " and Pc_parameter like '%" + data.Pc_parameter + "%'";
            if (data.Pc_purpose != "")
                sqlStr += " and Pc_purpose like '%" + data.Pc_purpose + "%'";
            if (data.Pc_remarks != "")
                sqlStr += " and Pc_remarks like '%" + data.Pc_remarks + "%'";
            return sqlStr;
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
            public string Pc_date = "", Pc_type = "", Pc_manufacturer = "", Pc_parameter = "", Pc_purpose = "", Pc_remarks = "", Pc_company = "";
            public int starCom;
        }
    }
}
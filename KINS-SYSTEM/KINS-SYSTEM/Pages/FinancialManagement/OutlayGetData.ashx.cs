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

namespace KINS_SYSTEM.Pages.FinancialManagement
{
    /// <summary>
    /// OutlayGetData 的摘要说明
    /// </summary>
    public class OutlayGetData : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.Ol_company = context.Session["company"].ToString();
            context.Response.Write(getData(data));
        }

        private string getData(Data data)
        {
            string sqlStr = " select top 200 * from K_Outlay where Ol_isValid='1' and  Ol_company='" + data.Ol_company + "' and Ol_state='"+data.Ol_state+"' ";
            sqlStr += getSqlStr(data);
            sqlStr += " and Ol_id not in ( select top " + (data.starCom - 1) + " Ol_id from  K_Outlay where Ol_isValid='1' and Ol_company='" + data.Ol_company + "'  and Ol_state='" + data.Ol_state + "' " + getSqlStr(data) + " order  by Ol_payDate,Ol_editDate desc)";
            sqlStr += "  order  by Ol_payDate desc,Ol_editDate desc";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            da.Rows.Add(da);                //将这一行记录加这个表中
            sqlStr = "select count (*) from K_Outlay where Ol_isValid='1' and Ol_company='" + data.Ol_company + "'  and Ol_state='" + data.Ol_state + "' " + getSqlStr(data);
            string temp = ds.FillDt(sqlStr).Rows[0][0].ToString();
            DataRow row = da.NewRow();
            row["Ol_id"] = temp;
            da.Rows.Add(row);
            return (JsonConvert.SerializeObject(da, new DataTableConverter()));
        }

        private string getSqlStr(Data data)
        {
            string sqlStr = "";
            if (data.Ol_payDate != "")
                sqlStr += " and Ol_payDate = '" + data.Ol_payDate + "'";
            if (data.Ol_payee != "")
                sqlStr += " and Ol_payee like '%" + data.Ol_payee + "%'";
            if (data.Ol_payMethod != "")
                sqlStr += " and Ol_payMethod = '" + data.Ol_payMethod + "'";
            if (data.Ol_content != "")
                sqlStr += " and Ol_content like '%" + data.Ol_content + "%'";
            if (data.Ol_operator != "")
                sqlStr += " and Ol_operator like '%" + data.Ol_operator + "%'";
            if (data.Ol_remarks != "")
                sqlStr += " and Ol_remarks like '%" + data.Ol_remarks + "%'";
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
            public string Ol_payDate = "", Ol_payee = "", Ol_payMethod = "", Ol_content = "", Ol_operator = "", Ol_remarks = "", Ol_company = "",Ol_state="";
            public int starCom;
        }
    }
}
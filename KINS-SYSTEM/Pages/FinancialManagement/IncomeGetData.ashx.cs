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
    /// IncomeGetData 的摘要说明
    /// </summary>
    public class IncomeGetData : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.Ic_company = context.Session["company"].ToString();
            context.Response.Write(getData(data));
        }

        private string getData(Data data)
        {
            string sqlStr = " select top 200 * from K_Income where Ic_isValid='1' and  Ic_company='" + data.Ic_company + "' and Ic_state='"+data.Ic_state+"' ";
            sqlStr += getSqlStr(data);
            sqlStr += " and Ic_id not in ( select top " + (data.starCom - 1) + " Ic_id from  K_Income where Ic_isValid='1' and Ic_company='" + data.Ic_company + "' and Ic_state='" + data.Ic_state + "'  " + getSqlStr(data) + " order  by Ic_payDate desc)";
            sqlStr += "  order  by Ic_payDate desc,Ic_editDate desc";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            da.Rows.Add(da);                //将这一行记录加这个表中
            sqlStr = "select count (*) from K_Income where Ic_isValid='1' and Ic_company='" + data.Ic_company + "'  and Ic_state='" + data.Ic_state + "' " + getSqlStr(data);
            string temp = ds.FillDt(sqlStr).Rows[0][0].ToString();
            DataRow row = da.NewRow();
            row["Ic_id"] = temp;
            da.Rows.Add(row);
            return (JsonConvert.SerializeObject(da, new DataTableConverter()));
        }

        private string getSqlStr(Data data)
        {
            string sqlStr = "";
            if (data.Ic_payDate != "")
                sqlStr += " and Ic_payDate = '" + data.Ic_payDate + "'";
            if (data.Ic_payer != "")
                sqlStr += " and Ic_payer like '%" + data.Ic_payer + "%'";
            if (data.Ic_payMethod != "")
                sqlStr += " and Ic_payMethod = '" + data.Ic_payMethod + "'";
            if (data.Ic_content != "")
                sqlStr += " and Ic_content like '%" + data.Ic_content + "%'";
            if (data.Ic_operator != "")
                sqlStr += " and Ic_operator like '%" + data.Ic_operator + "%'";
            if (data.Ic_remarks != "")
                sqlStr += " and Ic_remarks like '%" + data.Ic_remarks + "%'";
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
            public string Ic_payDate = "", Ic_payer = "", Ic_payMethod = "", Ic_content = "", Ic_operator = "", Ic_remarks = "", Ic_company = "", Ic_state = "";
            public int starCom;
        }
    }
}
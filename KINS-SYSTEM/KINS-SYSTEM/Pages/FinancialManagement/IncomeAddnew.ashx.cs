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
    /// IncomeAddnew1 的摘要说明
    /// </summary>
    public class IncomeAddnew1 : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.Ic_company = context.Session["company"].ToString();
            data.Ic_editDate = DateTime.Now.ToString("yyyy-MM-dd ") + DateTime.Now.ToLongTimeString().ToString();
            context.Response.Write(addNew(data));
        }

        private string addNew(Data data)
        {
            string sqlStr = " insert into K_Income (Ic_payDate,Ic_payer,Ic_payMethod,Ic_money,Ic_content,Ic_operator,Ic_remarks,Ic_company,Ic_editDate,Ic_state) values ('" +
                data.Ic_payDate + "','" + data.Ic_payer + "','" + data.Ic_payMethod + "','" + data.Ic_money + "','" + data.Ic_content + "','" + data.Ic_operator + "','" + data.Ic_remarks + "','" + data.Ic_company + "','" + data.Ic_editDate + "','" + data.Ic_state + "')";
            DbSql ds = new DbSql();
            if (ds.ExecSql(sqlStr))
                return "2";//成功
            return "0";//失败
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
            public string
                Ic_payDate = "",
                Ic_payer = "",
                Ic_payMethod = "",
                Ic_money = "",
                Ic_content = "",
                Ic_operator = "",
                Ic_remarks = "",
                Ic_editDate="",
                Ic_company="",
                Ic_state="";
        }
    }
}
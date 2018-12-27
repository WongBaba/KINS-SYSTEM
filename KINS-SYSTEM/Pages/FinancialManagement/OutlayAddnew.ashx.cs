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
    /// OutlayAddnew1 的摘要说明
    /// </summary>
    public class OutlayAddnew1 : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.Ol_company = context.Session["company"].ToString();
            data.Ol_editDate = DateTime.Now.ToString("yyyy-MM-dd ") + DateTime.Now.ToLongTimeString().ToString();
            context.Response.Write(addNew(data));
        }

        private string addNew(Data data)
        {
            string sqlStr = " insert into K_Outlay (Ol_payDate,Ol_payee,Ol_payMethod,Ol_money,Ol_content,Ol_operator,Ol_remarks,Ol_company,Ol_editDate,Ol_state) values ('" +
                data.Ol_payDate + "','" + data.Ol_payee + "','" + data.Ol_payMethod + "','" + data.Ol_money + "','" + data.Ol_content + "','" + data.Ol_operator + "','" + data.Ol_remarks + "','" + data.Ol_company + "','" + data.Ol_editDate + "','" + data.Ol_state + "')";
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
                Ol_payDate = "",
                Ol_payee = "",
                Ol_payMethod = "",
                Ol_money = "",
                Ol_content = "",
                Ol_operator = "",
                Ol_remarks = "",
                Ol_editDate = "",
                Ol_state="",
                Ol_company = "";
        }
    }
}
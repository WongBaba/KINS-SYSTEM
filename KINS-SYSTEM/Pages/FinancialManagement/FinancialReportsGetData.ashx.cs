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
    /// GetFinancialReportsData 的摘要说明
    /// </summary>
    public class GetFinancialReportsData : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.company = context.Session["company"].ToString();
            context.Response.Write(getData(data));
        }

        private string getData(Data data)
        {
            //获取期间每天的进账金额
            string sqlStr = "select Ic_payDate as frDate,sum(Ic_money) as money from K_Income where Ic_isValid='1' and Ic_state='进账' and Ic_payDate<='" + data.endDate +
                "' and Ic_payDate>='"+data.startDate+"' and Ic_company='" + data.company + "' group by Ic_payDate order by Ic_payDate  ";
            //获取期间每天的出账金额
            sqlStr += "select Ol_payDate as frDate,sum(Ol_money) as money from K_Outlay where Ol_isValid='1' and Ol_state='出账' and Ol_payDate<='" + data.endDate +
                "' and Ol_payDate>='" + data.startDate + "' and Ol_company='" + data.company + "' group by Ol_payDate order by Ol_payDate  ";
            sqlStr += "select sum(Ic_money) as money from K_Income where Ic_isValid='1' and Ic_state='待进账' and Ic_company='" + data.company + "' ";
            sqlStr += "select sum(Ol_money) as money from K_Outlay where Ol_isValid='1' and Ol_state='待出账' and Ol_company='" + data.company + "' ";
            sqlStr += "select SUM(Cp_inventory*Cp_price) as money from K_Component WHERE Cp_isValid='1' and Cp_company='"+data.company+"'";
            DbSql ds = new DbSql();
            DataSet dset = new DataSet();
            dset = ds.FillDs(sqlStr);
            return (JsonConvert.SerializeObject(dset, new DataSetConverter()));
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
            public string company = "",startDate="",endDate="";
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Runtime.Serialization;
using Newtonsoft.Json;

namespace KINS_SYSTEM.Pages.ProductManagement
{
    /// <summary>
    /// InitCo_PdType 的摘要说明
    /// </summary>
    public class InitCo_PdType : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            pageData dataInfo = new pageData();
            context.Response.Write(JsonConvert.SerializeObject(initPageData(context)));
        }

        private pageData initPageData(HttpContext context)
        {
            pageData dataInfo = new pageData();
            dataInfo.company = context.Session["company"].ToString();
            string sqlStr = "select Co_id,Co_abbreviation from K_info_Company where Co_company='"+dataInfo.company+"' order by Co_abbreviation";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            for (int i = 0; i < da.Rows.Count; i++)
            {
                dataInfo.co += "<li><input type='checkbox'  data-Co_id='" + da.Rows[i][0].ToString() + "'/>" + da.Rows[i][1].ToString() + "</li>";
            }

            sqlStr = "select Tp_id,Tp_name from k_ProductType where Tp_company='"+dataInfo.company+"' and Tp_type='成品' order by Tp_name";
            da = ds.FillDt(sqlStr);
            for (int i = 0; i < da.Rows.Count; i++)
            {
                dataInfo.pd += "<li><input type='checkbox' data-Tp_id='" + da.Rows[i][0].ToString() + "'/>" + da.Rows[i][1].ToString() + "</li>";
            }
            return dataInfo;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public class pageData
        {
            public string pd = "";
            public string co = "";
            public string company = "";
        }
    }
}
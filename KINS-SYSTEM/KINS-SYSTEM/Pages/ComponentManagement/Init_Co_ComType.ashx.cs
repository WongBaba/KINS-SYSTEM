using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace KINS_SYSTEM.Pages.ProductManagement
{
    /// <summary>
    /// Init_AddNewCom 的摘要说明
    /// </summary>
    public class Init_AddNewCom : IHttpHandler, System.Web.SessionState.IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            pageData dataInfo = new pageData();
            string company = context.Session["company"].ToString();
            context.Response.Write(initPageData(company));
        }

        private string initPageData(string company)
        {
            pageData dataInfo = new pageData();
            string sqlStr = "select * from K_info_Company where Co_company='" + company + "' order by Co_abbreviation  select Tp_id,Tp_name from k_ProductType where Tp_company='" + company + "' and Tp_type='零件' order by Tp_name";
            DbSql ds = new DbSql();
            DataSet dset = new DataSet();
            dset = ds.FillDs(sqlStr);
            return JsonConvert.SerializeObject(dset, new DataSetConverter());
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
            public string com="";
            public string co = "";
        }
    }
}
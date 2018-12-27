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

namespace KINS_SYSTEM.Pages
{
    /// <summary>
    /// lockIndex 的摘要说明
    /// </summary>
    public class lockIndex : IHttpHandler,System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            String data = jss.Deserialize<String>(context.Request["data"].ToString()); ;
            context.Response.Write(setUrl(data,context.Session["yhm"].ToString()));
            context.Session["indexUrl"] = data;
        }

        private string setUrl(string data,string id)
        {
            string sqlStr = "Update K_Employee set Emp_indexUrl='"+data+"' where Emp_id='"+id+"'";
            DbSql ds = new DbSql();
            DataTable da = new DataTable();
            if (ds.ExecSql(sqlStr))
                return "1";
            return "0";
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}